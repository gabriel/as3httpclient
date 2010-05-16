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
      var testData:ByteArray = new ByteArray();
      
      client.listener.onComplete = addAsync(function(event:HttpResponseEvent):void {
        assertNotNull(event.response);
        
        testData.position = 0;
        var responseBody:String = testData.readUTFBytes(testData.bytesAvailable);
        
        var contentLengthString:String = event.response.header.getValue("Content-Length");
        if (contentLengthString) {
          var length:uint = uint(contentLengthString);
          assertEquals(length, responseBody.length);
        }
        
      }, 20 * 1000);
      
      client.listener.onStatus = function(event:HttpStatusEvent):void {
        assertTrue(event.response.isSuccess);
      };
      
      client.listener.onData = function(event:HttpDataEvent):void {
        testData.writeBytes(event.bytes);
        Log.debug("Data: " + event.bytes);
      };
      
      client.request(uri, request);
      
    }
    
    public function testPostFormData():void {
    
      var client:HttpClient = new HttpClient();
      var uri:URI = new URI("http://www.snee.com/xml/crud/posttest.cgi");
      var variables:Array = [{name:"fname", value:"FirstName1"}, {name:"lname", value: "LastName1"}];

      client.listener.onData = function(event:HttpDataEvent):void {
        Log.debug("Data: " + event.bytes);
      };

      client.listener.onComplete = addAsync(function(event:HttpResponseEvent):void {
        assertTrue(event.response.isSuccess);
      }, 20 * 1000);

      client.postFormData(uri, variables);

    }
  }
  
}