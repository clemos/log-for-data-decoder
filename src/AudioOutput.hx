package ; 

import flash.media.Sound;
import hxs.Signal1;
//import haxe.io.BytesData;
import flash.events.SampleDataEvent;

private typedef BytesData = flash.utils.ByteArray;

class AudioOutput {

	public var volume : Float = 1.0;
	public var signal (default,set_signal) : Signal1<BytesData>;
	var bytes : BytesData;
	var sound : Sound;
	
	public function new(){
		sound = new Sound();
		sound.addEventListener( SampleDataEvent.SAMPLE_DATA , readSample );
	}

	public function set_signal( s ){
		if( signal != null ){
			signal.remove( readSignal );
		}

		signal = s;
		signal.add( readSignal );

		return signal;
	}

	function readSignal( b : BytesData ){
		bytes = b;
	}

	function readSample( e : SampleDataEvent ){
		if( bytes == null ){
			return;
		}

		bytes.position = 0;
		var i = 0;
		var f = 0.0;

		while( bytes.bytesAvailable > 0 && i < 8192 ){
			f = bytes.readFloat();
			e.data.writeFloat( f * volume );
			i++;
		}

		bytes.position = 0;
	}

}