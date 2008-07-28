package httpclient.http {
  
  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  
  import org.httpclient.*;
  import org.httpclient.http.*;
  import org.httpclient.events.*;
  
  import com.adobe.net.URI;
  import flash.utils.ByteArray;
  import flash.events.*;
    
  public class HttpsChunkedTest extends TestCase {
    
    public function HttpsChunkedTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new HttpsChunkedTest("testHttpsChunked"));
      return ts;
    }
    
    /**
     */
    public function testHttpsChunked():void {
      var client:HttpClient = new HttpClient();
            
      var uri:URI = new URI("https://www.amazon.com");
      
      var request:HttpRequest = new Get();
      var response:HttpResponse = null;
      var testData:ByteArray = new ByteArray();
      
      client.listener.onStatus = function(event:HttpStatusEvent):void {
        response = event.response;
        assertTrue(response.isSuccess);
      };
      
      client.listener.onComplete = addAsync(function():void {
        assertNotNull(response);
      }, 20 * 1000);
      
      client.listener.onError = function(event:ErrorEvent):void {
        fail(event.text);
      };
      
      client.request(uri, request);
    }
    

    
  }
  
}