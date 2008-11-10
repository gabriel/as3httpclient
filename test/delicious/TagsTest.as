package delicious {
  
  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  
  import org.httpclient.*;
  import org.httpclient.http.*;
  import org.httpclient.events.*;
  import org.httpclient.http.multipart.*;
  
  import com.adobe.net.*;
  import com.hurlant.util.Base64;
  
  import flash.utils.ByteArray;
  import flash.events.Event;
  import flash.filesystem.File;
  
  public class TagsTest extends TestCase {
    
    public function TagsTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new TagsTest("testGetTags"));
      return ts;
    }
    
    /**
     * Test get tags from del.icio.us.
     */
    public function testGetTags():void {
      
      var uri:URI = new URI('https://api.del.icio.us/v1/tags/get'); 
      var client:HttpClient = new HttpClient(); 
      var request:HttpRequest = new Get(); 
      
      var auth:String = Base64.encode("username:password");
      
      request.addHeader("Authorization", "Basic " + auth); 
      
      client.listener.onComplete = addAsync(function(event:HttpResponseEvent):void {
        assertNotNull(event.response);
        Log.debug("Response: " + event.response);
      }, 20 * 1000);
      
      client.listener.onStatus = function(event:HttpResponseEvent):void {
        assertTrue(event.response.isSuccess);
      };
      
      client.listener.onError = function(error:ErrorEvent):void {
        fail(error.message);
      };
      
      client.request(uri, request);      
    }    
    
  }
  
}