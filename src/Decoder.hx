
@:expose
class Decoder {

	public static var current : Decoder;
	var cnx : haxe.remoting.ExternalConnection;

	function new(){
		var ctx = new haxe.remoting.Context();
		ctx.addObject( "JsDecoder" , this );

		cnx = haxe.remoting.ExternalConnection.flashConnect("decoder","swfDecoder",ctx);
	}

	public dynamic function onData( s : String ){
		trace("receiving data : " + s);
	}

	public function getInputs(){
		return cnx.SwfDecoder.getInputs.call([]);
	}

	public dynamic function onInputs( inputs ){
		trace("shouldn't be here");
		trace(inputs);
	}

	public function attachInput( id , name ){
		cnx.SwfDecoder.attachInput.call( [id , name] );
	}

	public function setInputVolume( v : Float ){
		cnx.SwfDecoder.setInputVolume.call( [v] );
	}

	public function setOutputVolume( v : Float ){
		cnx.SwfDecoder.setOutputVolume.call( [v] );
	}

	public static function start( url = "swf/decoder.swf" , ?cb : Decoder -> Void = null ){
		untyped swfobject.embedSWF(
            url, 
            "swfDecoder", 
            "100%", "100%", 
            "10.2", 
            null, 
            {} , 
            {allowScriptAccess:"always"} , 
            {} , 
            function(){
            	js.Browser.window.setTimeout( function(){
            		Decoder.current = new Decoder();
            		if( cb != null ){
						cb( Decoder.current );
					}
            	}, 500);
			}
        );
	}

	public static function main(){
	}

}