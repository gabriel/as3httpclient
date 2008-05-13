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
      
      var response:HttpResponse = null;
                  
      client.listener.onComplete = addAsync(function():void {
        assertNotNull(response);
        Log.debug("Response: " + response);
      }, 20 * 1000);
      
      client.listener.onStatus = function(r:HttpResponse):void {
        response = r;
        assertTrue(response.isSuccess);
      };
      
      client.listener.onError = function(error:Error):void {
        fail(error.message);
      };
      
      client.request(uri, request);      
    }    
    
  }
  
}