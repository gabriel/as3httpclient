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
      ts.addTest(new UriEscapeTest("testEscapePath"));
      ts.addTest(new UriEscapeTest("testEscapeQuery"));
      ts.addTest(new UriEscapeTest("testQueryAlreadyEscaped"));
      return ts;
    }
    
    /**
     */
    public function testEscapePath():void {
      var request:HttpRequest = new HttpRequest("GET");
      var uri:URI = new URI("https://http-test.s3.amazonaws.com/test-characters%25$%23.txt");
      var bytes:ByteArray = request.getHeader(uri);
      var s:String = bytes.readUTFBytes(bytes.length);
      assertEquals("GET /test-characters%25$%23.txt HTTP/1.1\r\nHost: http-test.s3.amazonaws.com\r\nConnection: close\r\n\r\n", s);
    }
    
    public function testEscapeQuery():void {
      var request:HttpRequest = new HttpRequest("GET");
      
      var uri:URI = new URI("https://http-test.s3.amazonaws.com/test.txt?foo=KJSDFSDF DS+/FOO");
      var bytes:ByteArray = request.getHeader(uri);
      var s:String = bytes.readUTFBytes(bytes.length);
      assertEquals("GET /test.txt?foo=KJSDFSDF%20DS%2B%2FFOO HTTP/1.1\r\nHost: http-test.s3.amazonaws.com\r\nConnection: close\r\n\r\n", s);
    }
    
    public function testQueryAlreadyEscaped():void {
      var request:HttpRequest = new HttpRequest("GET");
      
      // /bar?action=getevent&token=KD/+c=|sau=|ted=      
      var uri:URI = new URI("http://foo.com/bar?token=KD%2F%2Bc%3D%7Csau%3D%7Cted%3D");
      var bytes:ByteArray = request.getHeader(uri);
      var s:String = bytes.readUTFBytes(bytes.length);
      // TODO: URI doesn't maintain order this test is even more brittle than before :O
      assertEquals("GET /bar?token=KD%2F%2Bc%3D%7Csau%3D%7Cted%3D HTTP/1.1\r\nHost: foo.com\r\nConnection: close\r\n\r\n", s)
    }
    
  }
  
}