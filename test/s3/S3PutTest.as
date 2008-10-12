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
  import flash.events.ErrorEvent;
  
  public class S3PutTest extends TestCase {
    
    public function S3PutTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new S3PutTest("testPut"));
      return ts;
    }
    
    /**
     * Test put with multipart form data.
     */
    public function testPut():void {
      var client:HttpClient = new HttpClient();
            
      var uri:URI = new URI("http://http-test-put.s3.amazonaws.com/test.txt");
      
      client.listener.onComplete = addAsync(function(event:HttpResponseEvent):void {
        assertNotNull(event.response);
      }, 20 * 1000);
      
      client.listener.onStatus = function(event:HttpStatusEvent):void {
        Log.debug("Response: " + event.response);
        assertTrue(event.response.isSuccess);
      };
      
      client.listener.onError = function(event:ErrorEvent):void {
        fail(event.text);
      };
      
      var data:ByteArray = new ByteArray();
      data.writeUTFBytes("This is a test");
      data.position = 0;
      
      client.put(uri, data)
    }    
    
  }
  
}