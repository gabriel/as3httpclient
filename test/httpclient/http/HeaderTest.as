package httpclient.http {
  
  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  
  import org.httpclient.*;
  import org.httpclient.http.*;
  import org.httpclient.events.*;
  
  import com.adobe.net.*;
  
  import flash.utils.ByteArray;
  import flash.events.Event;
  
  public class HeaderTest extends TestCase {
    
    public function HeaderTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new HeaderTest("testGetWithHeader"));
      return ts;
    }
    
    /**
     * Test get with header.
     */
    public function testGetWithHeader():void {
      
      var client:HttpClient = new HttpClient();
      
      var response:HttpResponse = null;
            
      client.listener.onComplete = addAsync(function():void { assertNotNull(response); }, 20 * 1000);
      
      client.listener.onStatus = function(event:HttpStatusEvent):void {
        response = event.response;
        assertTrue(response.isSuccess);
      };      

      var uri:URI = new URI("http://localhost:8080/shrub/test");      
      var request:HttpRequest = new Get();
      request.addHeader("X-WSSE", "UsernameToken");
      request.addHeader("Username", "tom");
      request.addHeader("PasswordDigest", "Vsr1yvZjImglo7kvcfY3gA==");
      request.addHeader("Nonce", "A11FF4575");
      request.addHeader("Created", "2008-06-04T22:45:25Z");
      client.request(uri, request);
      
    }
    
  }
  
}