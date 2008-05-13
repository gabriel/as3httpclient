package httpclient.http {
  
  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  
  import org.httpclient.*;
  import org.httpclient.http.*;
  import org.httpclient.events.*;
  
  import com.hurlant.crypto.tls.TLSSocket;  
  import com.adobe.net.*;
  
  import flash.utils.ByteArray;
  import flash.events.Event;
  import flash.events.ProgressEvent;
  
  public class TLSTest extends TestCase {
    
    public function TLSTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new TLSTest("testCertMatch"));
      ts.addTest(new TLSTest("testRegexEscape"));
            
      // Redundant, this is tested in HttpsTest      
      //ts.addTest(new HttpsTest("testHost"));
      //ts.addTest(new HttpsTest("testHostBytes"));
      return ts;
    }
    
    // Regexp.escape('\\*?{}.')   #=> \\\\\*\?\{\}\.
		private function regexEscape(s:String):String {
      return s.replace(/([\\*?{}.])/g, "\\$1");
		}
    
    // Test patch for "Invalid common name: *.s3.amazonaws.com, expected http-test.s3.amazonaws.com"
    public function testCertMatch():void {
      var commonName:String = "*.s3.amazonaws.com";
      var otherIdentity:String = "http-test.s3.amazonaws.com";
            
      var escaped:String = regexEscape(commonName);
		  var reg:String = escaped.replace(/\\\*/g, "[^.]+")
		  assertTrue(new RegExp(reg).exec(otherIdentity));		  
    }

    /**
     * Test regex escape.
     */
    public function testRegexEscape():void {
      var s:String = '\\\\*?{}.';
		  var escaped:String = s.replace(/([\\*?{}.])/g, "\\$1");
  		//Log.debug("Escaped: " + escaped);
  		assertEquals('\\\\\\\\\\*\\?\\{\\}\\.', escaped);
    }
    
    /**
     * Test TLS connecting to S3.
     */
    public function testHost():void {
      
      var host:String = "http-test.s3.amazonaws.com";
      
      var t:TLSSocket = new TLSSocket;
      t.connect(host, 443); 
      t.writeUTFBytes("GET / HTTP/1.1\r\nHost: "+host+"\r\nConnection: close\r\n\r\n");
      t.addEventListener(Event.CLOSE, addAsync(function(e:*):void {
          var s:String = t.readUTFBytes(t.bytesAvailable);
          trace("Response from " + host + ": " + s.length + " characters");
          trace("Data: " + s);
      }, 20 * 1000));
    }    
    
    /**
     * Test TLS connecting to S3, getting binary data.
     */
    public function testHostBytes():void {
      
      var host:String = "http-test.s3.amazonaws.com";
      
      var t:TLSSocket = new TLSSocket;
      t.connect(host, 443); 
      t.writeUTFBytes("GET /test.png HTTP/1.0\r\nHost: "+host+"\r\n\r\n");
      t.flush();
      
      var bytes:ByteArray = new ByteArray();
      
      t.addEventListener(ProgressEvent.SOCKET_DATA, function(e:*):void {
        Log.debug("[" + t.bytesAvailable + "]");
        t.readBytes(bytes);
      });
      
      t.addEventListener(Event.CLOSE, addAsync(function(e:*):void {      
        Log.debug("Close, #bytes: " + bytes.length);
        //writeFile(new File(File.userDirectory.nativePath + "/Temp/test_get_with_tls.png"), bytes);
      }, 20 * 1000));
    }
    
  }
  
}