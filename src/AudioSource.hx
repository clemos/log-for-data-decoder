import hxs.Signal1;
import haxe.io.BytesData;
import flash.events.SampleDataEvent;

class AudioSource {

	public var signals (default, null) : {
		mono : Signal1<BytesData>,
		left : Signal1<BytesData>,
		right : Signal1<BytesData>
	};

	public var volume : Float = 1.0;
	
	function new(){
		signals = {
			mono : new Signal1(),
			left : new Signal1(),
			right : new Signal1()
		};
		
	}

	function dispatch( e : { data : BytesData } ){
		var bytes = e.data;
		var mono = new BytesData();
		var left = new BytesData();
		var right = new BytesData();

		var i = 0;
		var f = 0.0;

		while( bytes.bytesAvailable > 0 ){
			
			f = bytes.readFloat();
			mono.writeFloat( f * volume );

			if( i % 2 == 0 ){
				left.writeFloat( f * volume );
			}else{
				right.writeFloat( f * volume );
			}

			i++;

		}
		
		mono.position = left.position = right.position = 0;
		
		signals.mono.dispatch( mono );
		signals.left.dispatch( left );
		signals.right.dispatch( right );

	}

}