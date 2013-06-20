import flash.events.SampleDataEvent;
import flash.media.Microphone;

class Mic extends AudioSource {

	public var mic (default,null) : Microphone;

	public static var names : Array<Dynamic>;

	function new(i){

		super();

		mic = Microphone.getMicrophone(i);
		mic.rate = 44;
		mic.setSilenceLevel(0);
		mic.setUseEchoSuppression( false );
		
		mic.addEventListener( SampleDataEvent.SAMPLE_DATA , dispatch );
		
	}

	public static function get(?i=-1){
		return new Mic(i);
	}
	public static function all() : Array<AudioSource>{
		var mics : Array<AudioSource> = [];
		names = Microphone.names;
		for( i in 0...names.length ){
			mics[i] = new Mic(i);
		}
		return mics;
	}

}