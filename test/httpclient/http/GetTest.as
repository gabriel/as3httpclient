package httpclient.http {
  
  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  
  import org.httpclient.*;
  import org.httpclient.http.*;
  import org.httpclient.events.*;
  
  import com.adobe.net.*;
  
  import flash.utils.ByteArray;
  import flash.events.Event;
  
  public class GetTest extends TestCase {
    
    public function GetTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new GetTest("testGet"));
      ts.addTest(new GetTest("testGetWithDataListener"));
      return ts;
    }
    
    /**
     * Test get.
     * This also tests chunked encoding, since google search uses that.
     */
    public function testGet():void {
      
      var client:HttpClient = new HttpClient();
      
      client.listener.onComplete = addAsync(function(event:HttpResponseEvent):void { assertNotNull(event.response); }, 20 * 1000);
      
      client.listener.onStatus = function(event:HttpStatusEvent):void {
        assertTrue(event.response.isSuccess);
      };
      
      client.listener.onData = function(event:HttpDataEvent):void {
        var data:String = event.readUTFBytes();
        //Log.debug("Response data: " + data);
      };

      var uri:URI = new URI("http://www.google.com/search?q=rel-me");
      client.get(uri);
      
    }
    
    public function testGetWithDataListener():void {
      var client:HttpClient = new HttpClient();
      
      var listener:HttpDataListener = new HttpDataListener();
      
      listener.onDataComplete = function(event:HttpResponseEvent, data:ByteArray):void {
        assertNotNull(event.response); 
        assertNotNull(data); 
        assertTrue(data.length > 0);
        Log.debug("Data: " + data);
      };
      
      listener.onStatus = function(event:HttpStatusEvent):void {
        assertTrue(event.response.isSuccess);
      };
      
      listener.onComplete = addAsync(function(event:HttpResponseEvent):void { assertNotNull(event.response); }, 20 * 1000);
      
      var uri:URI = new URI("http://www.cnn.com");
      client.get(uri, listener);
    }
    
  }
  
}