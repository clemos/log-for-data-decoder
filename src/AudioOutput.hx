package ; 

import flash.media.Sound;
import hxs.Signal1;
import haxe.io.BytesData;
import flash.events.SampleDataEvent;

class AudioOutput {

	public var volume : Float = 1.0;
	public var signal (default,set_signal) : Signal1<BytesData>;
	var bytes : BytesData;
	var sound : Sound;
	
	public function new(){
		sound = new Sound();
		sound.addEventListener( SampleDataEvent.SAMPLE_DATA , readSample );
		sound.play();
		bytes = new BytesData();
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
		var pos = b.position;
		var pos2 = bytes.position;
		while(b.bytesAvailable>0){
			var f = b.readFloat();
			bytes.writeFloat( f );
		}
		b.position = pos;
		bytes.position = pos2;
		//bytes = b;
	}

	function readSample( e : SampleDataEvent ){
		//trace("read sample");
		if( bytes == null || bytes.bytesAvailable == 0 ){
			//trace("filling with blank...");
			for( i in 0...8192 ){
				e.data.writeFloat( 0.0 );
			}
			return;
		}

		bytes.position = 0;
		var p = 0;
		var f = 0.0;

		//trace("reading "+bytes.bytesAvailable);
		while( bytes.bytesAvailable > 0 && p < 8192 ){
			f = bytes.readFloat();
			e.data.writeFloat( f * volume );
			e.data.writeFloat( f * volume );
			p+=2;
		}

		if( p < 8192 ){
			for( i in p...8192 ){
				e.data.writeFloat( 0.0 );
			}
		}

		//trace("done");
		//trace("wrote "+p+" samples");
		bytes.position = 0;
	}

}