package s3 {
  
  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  
  import org.httpclient.*;
  import org.httpclient.http.*;
  import org.httpclient.events.*;
  
  import com.adobe.net.*;
  
  import flash.utils.ByteArray;
  import flash.events.Event;
  import flash.events.ErrorEvent;
  
  public class S3HeadTest extends TestCase {
    
    public function S3HeadTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new S3HeadTest("testHead"));
      return ts;
    }
        
    /**
     * Test head.
     */
    public function testHead():void {
      var client:HttpClient = new HttpClient();
            
      var uri:URI = new URI("http://http-test.s3.amazonaws.com/test.png");
      
      client.listener.onComplete = addAsync(function(event:HttpResponseEvent):void {
        assertNotNull(event.response);  
        assertNotNull(event.response.header);
        assertTrue(event.response.header.length > 0);
        
        assertNotNull(event.response.header.getValue("x-amz-request-id"));
        // Test case insensitivity
        assertNotNull(event.response.header.getValue("X-amz-reQuest-Id"));
         
      }, 20 * 1000);
      
      client.listener.onStatus = function(event:HttpStatusEvent):void {
        assertTrue(event.response.isSuccess);
      };
      
      client.listener.onError = function(event:ErrorEvent):void {
        fail(event.text);
      };
      
      client.head(uri);
      
    }
    
  }
  
}