package httpclient.http {
  
  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  
  import org.httpclient.*;
  import org.httpclient.http.*;
  import org.httpclient.events.*;
  
  import com.adobe.net.*;
  
  import flash.utils.ByteArray;
  import flash.events.Event;
  import flash.events.ErrorEvent;
  import flash.events.IOErrorEvent;
  
  public class GetTest extends TestCase {
    
    public function GetTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new GetTest("testGet"));
      ts.addTest(new GetTest("testGetOnClose"));
      ts.addTest(new GetTest("testGetWithDataListener"));
      ts.addTest(new GetTest("testCancel"));
      ts.addTest(new GetTest("testClearListeners"));
      ts.addTest(new GetTest("testMultipleGet"));
      ts.addTest(new GetTest("testClose"));
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
      
      client.listener.onClose = function(event:Event):void {
        Log.debug("On Close");
      };

      var uri:URI = new URI("http://www.google.com/search?q=rel-me");
      client.get(uri);
      
    }
    
    public function testGetOnClose():void {
      var client:HttpClient = new HttpClient();
      
      client.listener.onClose = addAsync(function(event:Event):void {
        Log.debug("On Close");
      }, 20 * 1000);

      var uri:URI = new URI("http://www.google.com/search?q=rel-me");
      client.get(uri);
    
    }
    
    public function testGetError():void {
      var client:HttpClient = new HttpClient();

      client.listener.onError = addAsync(function(errorEvent:ErrorEvent):void {
        Log.debug("Error: " + errorEvent);
        assertEquals(errorEvent.type, IOErrorEvent.IO_ERROR);
      }, 20 * 1000);
      
      client.listener.onClose = function(event:Event):void {
        Log.debug("On Close");
      };
      
      client.listener.onComplete = function(event:Event):void {
        Log.debug("On Complete");
      };

      var uri:URI = new URI("http://www.invalid.domain/");
      client.get(uri);
    }
    
    public function testCancel():void {
      var client:HttpClient = new HttpClient();
      var uri:URI = new URI("http://www.amazon.com/");
      client.get(uri);
      client.cancel();
      // TODO(gabe): Assert canceled
      
      client.listener.onClose = addAsync(function(event:Event):void {
        Log.debug("On Close");
      }, 20 * 1000);
    }
    
    public function testClose():void {
      var client:HttpClient = new HttpClient();
      var uri:URI = new URI("http://www.amazon.com/");
      
      client.listener.onClose = addAsync(function(event:Event):void {
        Log.debug("On Close");
      }, 5 * 1000);
      
      client.listener.onComplete = function(event:Event):void {
        Log.debug("On Complete");
      };
      
      client.get(uri);
      client.close();
      
    }
    
    public function testClearListeners():void {
      var client:HttpClient = new HttpClient();
      
      var failListener:Boolean = false;
      
      client.listener.onComplete = function(event:Event):void {
        Log.debug("On Complete");
        if (failListener) fail("Should be canceled");
      };
      
      var uri:URI = new URI("http://www.google.com/");
      client.get(uri);
      
      failListener = true;
      client.listener = null;
      client.get(uri);
    }
    
    public function testMultipleGet():void {
      var client1:HttpClient = new HttpClient();
      var client2:HttpClient = new HttpClient();
     
      client1.listener.onComplete = addAsync(function(event:Event):void {
        Log.debug("On Complete #1");
      }, 10 * 1000); 
      
      client2.listener.onComplete = addAsync(function(event:Event):void {
        Log.debug("On Complete #2");
      }, 10 * 1000);
      
      client1.get(new URI("http://www.google.com/"));
      client2.get(new URI("http://www.yahoo.com/"));
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