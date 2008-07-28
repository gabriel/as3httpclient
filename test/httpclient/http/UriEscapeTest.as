package httpclient.http {
  
  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  
  import org.httpclient.*;
  import org.httpclient.http.*;
  
  import com.adobe.net.URI;
  import flash.utils.ByteArray;
    
  public class UriEscapeTest extends TestCase {
    
    public function UriEscapeTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new UriEscapeTest("testUnescape"));
      ts.addTest(new UriEscapeTest("testUnescapeQuery"));
      return ts;
    }
    
    /**
     */
    public function testUnescape():void {
      var request:HttpRequest = new HttpRequest("GET");
      var uri:URI = new URI("https://http-test.s3.amazonaws.com/test-characters%25$%23.txt");
      var bytes:ByteArray = request.getHeader(uri);
      var s:String = bytes.readUTFBytes(bytes.length);
      assertEquals("GET /test-characters%25$%23.txt HTTP/1.1\r\nHost: http-test.s3.amazonaws.com\r\nConnection: close\r\n\r\n", s);
    }
    
    public function testUnescapeQuery():void {
      var request:HttpRequest = new HttpRequest("GET");
      var uri:URI = new URI("https://http-test.s3.amazonaws.com/test.txt?foo=KJSDFSDF DS+/FOO");
      var bytes:ByteArray = request.getHeader(uri);
      var s:String = bytes.readUTFBytes(bytes.length);
      assertEquals("GET /test.txt?foo=KJSDFSDF%20DS+/FOO HTTP/1.1\r\nHost: http-test.s3.amazonaws.com\r\nConnection: close\r\n\r\n", s);
    }
    
    // URI bug?
    public function testEscape1():void {      
      var request:HttpRequest = new HttpRequest("GET");
      var uri:URI = new URI("https://http-test.s3.amazonaws.com/test-characters%$#&@.txt");
      var bytes:ByteArray = request.getHeader(uri);
      var s:String = bytes.readUTFBytes(bytes.length);
      Log.debug("S=" + s);
    }
    
    // URI bug?
    public function testEscape2():void {      
      var request:HttpRequest = new HttpRequest("GET");
      var uri:URI = new URI("https://http-test.s3.amazonaws.com/test-characters$#%.txt");
      var bytes:ByteArray = request.getHeader(uri);
      var s:String = bytes.readUTFBytes(bytes.length);
      Log.debug("S=" + s);
    }
    
  }
  
}