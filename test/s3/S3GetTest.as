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
  
  public class S3GetTest extends TestCase {
    
    public function S3GetTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new S3GetTest("testGet"));
      ts.addTest(new S3GetTest("testGetUrlEncoding"));
      ts.addTest(new S3GetTest("testGetChunked"));
      return ts;
    }
    
    /**
     * Test get png.
     */
    public function testGet():void {
      var client:HttpClient = new HttpClient();
            
      var uri:URI = new URI("http://http-test.s3.amazonaws.com/test.png");
      
      var request:HttpRequest = new Get();
      var testData:ByteArray = new ByteArray();
      
      client.listener.onStatus = function(event:HttpStatusEvent):void {
        assertTrue(event.response.isSuccess);
      };
      
      client.listener.onData = function(event:HttpDataEvent):void {
        Log.debug("[" + event.bytes.bytesAvailable + "]");
        testData.writeBytes(event.bytes);
      };
      
      client.listener.onError = function(event:ErrorEvent):void {
        fail(event.text);
      };      
      
      client.listener.onComplete = addAsync(function(event:HttpResponseEvent):void {
        assertNotNull(event.response);
        assertEquals(12258, testData.length)
        
      }, 20 * 1000);
      
      
      client.request(uri, request);
    }
    
    /**
     * Test get png (with space in path).
     */
    public function testGetUrlEncoding():void {
      var client:HttpClient = new HttpClient();
            
      var uri:URI = new URI("http://http-test.s3.amazonaws.com/test space.png");
      
      var request:HttpRequest = new Get();
      var testData:ByteArray = new ByteArray();
      
      client.listener.onStatus = function(event:HttpStatusEvent):void {
        assertTrue(event.response.isSuccess);
      };
      
      client.listener.onData = function(event:HttpDataEvent):void {
        Log.debug("[" + event.bytes.bytesAvailable + "]");
        testData.writeBytes(event.bytes);
      };
      
      client.listener.onError = function(event:ErrorEvent):void {
        fail(event.text);
      };
      
      client.listener.onComplete = addAsync(function(event:HttpResponseEvent):void {
        assertNotNull(event.response);
        assertEquals(12258, testData.length)
        
      }, 20 * 1000);
      
      client.request(uri, request);      
    }
    
    /**
     * Test get chunked.
     */
    public function testGetChunked():void {
      var client:HttpClient = new HttpClient();
      var response:HttpResponse = null;
            
      var uri:URI = new URI("http://http-test.s3.amazonaws.com/");
      
      var request:HttpRequest = new Get();
      var testData:ByteArray = new ByteArray();
      
      client.listener.onStatus = function(event:HttpStatusEvent):void {
        assertTrue(event.response.isSuccess);
      };
      
      client.listener.onData = function(event:HttpDataEvent):void {
        Log.debug("[" + event.bytes.bytesAvailable + "]");
        testData.writeBytes(event.bytes);
      };
      
      client.listener.onError = function(event:ErrorEvent):void {
        fail(event.text);
      };
      
      client.listener.onComplete = addAsync(function(event:HttpResponseEvent):void {
        assertNotNull(event.response);

        testData.position = 0;
        var data:String = testData.readUTFBytes(testData.bytesAvailable);
        
        var expected:String = "^<\\?xml version=\"1.0\" encoding=\"UTF-8\"\\?>.*";
        var regex:RegExp = new RegExp(expected);        
        assertNotNull(data.match(regex));
        
      }, 20 * 1000);
      
      client.request(uri, request);      
    }
    
  }
  
}