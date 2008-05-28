package s3 {
  
  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  
  import org.httpclient.*;
  import org.httpclient.http.*;
  import org.httpclient.events.*;
  import org.httpclient.http.multipart.*;
  
  import com.adobe.net.*;
  
  import flash.utils.ByteArray;
  import flash.events.Event;
  import flash.filesystem.File;
  
  public class S3DeleteTest extends TestCase {
    
    public function S3DeleteTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new S3DeleteTest("testDelete"));
      return ts;
    }
    
    /**
     * Test put with multipart form data.
     */
    public function testDelete():void {
      var client:HttpClient = new HttpClient();
            
      var uri:URI = new URI("http://http-test.s3.amazonaws.com/test_put.png");
      
      var request:HttpRequest = new Delete();
      var response:HttpResponse = null;
            
      client.listener.onComplete = addAsync(function():void {
        assertNotNull(response);
        Log.debug("Response: " + response);
      }, 20 * 1000);
      
      client.listener.onStatus = function(event:HttpStatusEvent):void {
        response = event.response;
        assertTrue(response.isSuccess);
      };
      
      client.listener.onError = function(event:HttpErrorEvent):void {
        fail(event.text);
      };
      
      client.request(uri, request);      
    }    
    
  }
  
}