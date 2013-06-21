import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import haxe.io.BytesData;
import haxe.remoting.ExternalConnection;
import kcs.Decoder;

class App {
	
	var inputs : Array<AudioSource>;
	var input : AudioSource;
	var vumeters : {
		mono : VuMeter,
		left : VuMeter,
		right : VuMeter
	};

	var decoder : Decoder;

	var root : MovieClip;

	var outp : TextField;

	var dump : BytesData;

	var ext : Null<ExternalConnection>;

	var currentSignal : hxs.Signal1<BytesData>;

	var inputVolume : Float = 1.0;
	var outputVolume : Float = 0.0;

	var output : AudioOutput;

	function new( mc ){
		
		root = mc;

		decoder = new Decoder();

		inputs = Mic.all();
		output = new AudioOutput();

		//inputs = [new AudioFile("test_kawenga.mp3")];
		
		vumeters = {
			mono : new VuMeter(),
			left : new VuMeter(),
			right : new VuMeter()
		}

		root.addChild(vumeters.mono);
		
		outp = new TextField();
		outp.wordWrap = true;

		root.addChild(outp);

		if( root.stage != null ) init();
		else root.addEventListener( Event.ADDED_TO_STAGE , init );

		#if !openfl
		ext = if( flash.external.ExternalInterface.available ){
			var ctx = new haxe.remoting.Context();
			ctx.addObject( "SwfDecoder" , this );
			ExternalConnection.jsConnect("decoder",ctx);
		}else{
			null;
		}
		#end

		getInputs();
		
	}

	function getInputs(){
		if( ext != null ){
			ext.JsDecoder.onInputs.call([Mic.names]);
		}else{
			attachInput();
		}
	}

	function attachInput( id = 0 , name = "mono" ){
		var input = inputs[id];
		input.volume = inputVolume;

		var signals = input.signals;
		var signal = Reflect.field( signals , name );

		if( currentSignal != null ){
			currentSignal.removeAll();
		}

		vumeters.mono.signal = signal;
		output.signal = signal;
		signal.add( decode );

		currentSignal = signal;
	}

	function decode( b ){
		var bytes = decoder.decode(b); 
		var str = bytes.toString();
		if( ext != null && str.length > 0 ){
			ext.JsDecoder.onData.call( [str] );
		}else if( str.length > 0 ){
			trace(str);
		}
	}

	function setInputVolume( v : Float ){
		inputVolume = v;
	}

	function setOutputVolume( v : Float ){
		outputVolume = v;
	}

	function init(?_=null){
		root.stage.removeEventListener( Event.ADDED_TO_STAGE , init );

		root.stage.align = StageAlign.TOP_LEFT;
		root.stage.scaleMode = StageScaleMode.NO_SCALE;

		root.stage.addEventListener( Event.RESIZE , resize );
		resize();
	}

	function resize(?_){
		outp.width = root.stage.stageWidth;
		outp.height = root.stage.stageHeight;
	}

	static function main(){
		new App( flash.Lib.current );
	}

}