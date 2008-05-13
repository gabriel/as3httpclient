package httpclient.http {
  
  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  
  import org.httpclient.*;
  import org.httpclient.http.*;
  import org.httpclient.events.*;
  
  import com.adobe.net.*;
  
  import flash.filesystem.File;
  import flash.utils.ByteArray;
  import flash.events.Event;
  
  public class UploadTest extends TestCase {
    
    public function UploadTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new UploadTest("testUpload"));
      return ts;
    }
    
    /**
     * Test upload client method.
     */
    public function testUpload():void {
      
      var client:HttpClient = new HttpClient();

      var response:HttpResponse = null;
            
      client.listener.onComplete = addAsync(function():void {
        assertNotNull(response);        
      }, 20 * 1000);
      
      client.listener.onStatus = function(r:HttpResponse):void {
        response = r;
        assertTrue(response.isSuccess);
      };
      
      var uri:URI = new URI("http://http-test.s3.amazonaws.com/test_put.png");
      var testFile:File = new File("app:/test/assets/test.png");
      
      client.upload(uri, testFile);
      
    }
    
  }
  
}