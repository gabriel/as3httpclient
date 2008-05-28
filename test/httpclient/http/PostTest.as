package httpclient.http {
  
  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  
  import org.httpclient.*;
  import org.httpclient.http.*;
  import org.httpclient.events.*;
  
  import com.adobe.net.*;
  
  import flash.utils.ByteArray;
  import flash.events.Event;
  
  public class PostTest extends TestCase {
    
    public function PostTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new PostTest("testPost"));
      return ts;
    }
    
    /**
     * Test post using rails resource.
     */
    public function testPost():void {
      
      var client:HttpClient = new HttpClient();
            
      var uri:URI = new URI("http://www.snee.com/xml/crud/posttest.cgi");
      
      var request:HttpRequest = new Post([ { name: "fname", value: "FirstName1" }, { name: "lname", value: "LastName1" } ]);
      var response:HttpResponse = null;
      var testData:ByteArray = new ByteArray();
      
      client.listener.onComplete = addAsync(function():void {
        assertNotNull(response);
        
        //Log.debug("Response: " + response);
        testData.position = 0;
        var responseBody:String = testData.readUTFBytes(testData.bytesAvailable);
        
        var length:uint = uint(response.header.getValue("Content-Length"));
        assertEquals(length, responseBody.length);
        
      }, 20 * 1000);
      
      client.listener.onStatus = function(event:HttpStatusEvent):void {
        response = event.response;
        assertTrue(response.isSuccess);
      };
      
      client.listener.onData = function(event:HttpDataEvent):void {
        testData.writeBytes(event.bytes);
      };
      
      client.request(uri, request);
      
    }
    
  }
  
}