import flash.events.Event;
import flash.media.Sound;
import flash.net.URLRequest;
import flash.events.SampleDataEvent;
import haxe.io.BytesData;

class AudioFile extends AudioSource {
	
	var file : String;
	var sound : Sound;
	var outp : Sound;

	public function new( file : String ){
		super();
		this.file = file;
		outp = new Sound();

		load();
	}

	function load(){
		var req = new URLRequest(file);
		sound = new Sound();
		sound.load(req);
		sound.play();
		sound.addEventListener( Event.COMPLETE , loaded );
	}
	function loaded(_){
		outp.addEventListener( SampleDataEvent.SAMPLE_DATA , dispatch );
		outp.play();
	}

	override function dispatch( e : {data:BytesData} ){
		var bytes:BytesData = new BytesData();
		sound.extract(bytes, 2*4096);
    	e.data.writeBytes( bytes );
    	
    	bytes.position = 0;
    	super.dispatch( { data : bytes } );
	}


}