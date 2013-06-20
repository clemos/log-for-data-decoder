import flash.display.Sprite;
import flash.events.Event;
import flash.events.SampleDataEvent;
import flash.media.Microphone;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.BytesData;
import hxs.Signal1;


class VuMeter extends Sprite {
	
	public var signal (default,set_signal) : Signal1<BytesData>;
	static inline var WIDTH = 320;
	static inline var HEIGHT = 200;

	var background : Sprite;
	var canvas : Sprite;

	var bytes : BytesData;

	public function new(){
		super();
		background = new Sprite();

		var g = background.graphics;
		g.clear();
		g.beginFill(0xeeeeff);
		g.lineStyle(1, 0xcccccc);

		g.drawRect( 0 , 0 , WIDTH , HEIGHT );
		g.moveTo( 0 , HEIGHT / 2 );
		g.lineTo( WIDTH , HEIGHT / 2 );

		addChild(background);

		canvas = new Sprite();
		addChild(canvas);

		addEventListener(Event.ENTER_FRAME,draw);

	}

	function set_signal( s : Signal1<BytesData> ){
		
		if( signal != null ){
			signal.remove( drawBytes );
		}

		signal = s;

		signal.add( drawBytes );

		return signal;
	}

	function drawBytes( b : BytesData ){
		bytes = b;		
	}

	function draw( ?_=null){
		if( bytes == null ) return;

		bytes.position = 0;

		var g = canvas.graphics;
		
		g.clear();
		g.lineStyle(1,0x660000);
		g.moveTo( 0 , HEIGHT / 2 );

		var i = 0;
		while( i <= WIDTH ){
			try{
				var f = bytes.readFloat();
				g.lineTo( i , HEIGHT / 2 + f * (HEIGHT / 2) );
				i++;
			}catch( e : Dynamic ){
				break;
			}
		}

		bytes.position = 0;
	}

}