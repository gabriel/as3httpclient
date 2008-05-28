package s3 {
  
  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  
  import org.httpclient.*;
  import org.httpclient.http.*;
  import org.httpclient.events.*;
  
  import com.adobe.net.*;
  import com.hurlant.crypto.tls.TLSSocket;
  
  import flash.utils.ByteArray;
  import flash.events.Event;
  import flash.events.ProgressEvent;
  
  public class HttpsTest extends TestCase {
    
    public function HttpsTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new HttpsTest("testGet"));            
      ts.addTest(new HttpsTest("testPut"));      
      return ts;
    }
        
    /**
     * Test get with https.
     */
    public function testGet():void {
      var client:HttpClient = new HttpClient();
            
      var uri:URI = new URI("https://http-test.s3.amazonaws.com/test.png");
      
      var request:HttpRequest = new Get();
      var response:HttpResponse = null;
      var testData:ByteArray = new ByteArray();
      
      client.listener.onComplete = addAsync(function():void {
        assertNotNull(response);
        assertEquals(12258, testData.length);
      }, 20 * 1000);
      
      client.listener.onStatus = function(event:HttpStatusEvent):void {
        response = event.response;
        assertTrue(response.isSuccess);
      };
      
      client.listener.onData = function(event:HttpDataEvent):void {
        Log.debug("[" + event.bytes.bytesAvailable + "]");
        testData.writeBytes(event.bytes);
      };
      
      client.listener.onError = function(event:ErrorEvent):void {
        fail(event.text);
      };
      
      client.request(uri, request);      
    }
    
    /**
     * Test put with multipart form data.
     */
    public function testPut():void {
      var client:HttpClient = new HttpClient();
            
      var uri:URI = new URI("https://http-test.s3.amazonaws.com/test_https_put.txt");
      
      //var testFile:File = new File("app:/test/assets/test.png");
      
      var response:HttpResponse = null;
            
      client.listener.onComplete = addAsync(function():void {
        assertNotNull(response);
      }, 20 * 1000);
      
      client.listener.onStatus = function(event:HttpStatusEvent):void {
        response = event.response;
        assertTrue(response.isSuccess);
      };
      
      client.listener.onError = function(event:ErrorEvent):void {
        fail(event.text);
      };
      
      var data:ByteArray = new ByteArray();
      data.writeUTFBytes("This is a test");
      data.position = 0;
      
      client.put(uri, data);      
    }
    
  }
  
}