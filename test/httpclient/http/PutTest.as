package httpclient.http {
  
  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  
  import org.httpclient.*;
  import org.httpclient.http.*;
  import org.httpclient.events.*;
  
  import com.adobe.net.*;
  
  import flash.utils.ByteArray;
  import flash.events.Event;
  
  public class PutTest extends TestCase {
    
    public function PutTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new PutTest("testPutFormData"));
      return ts;
    }
    
    /**
     * Test put with form data.
     */
    public function testPutFormData():void {
      
      var client:HttpClient = new HttpClient();
            
      var uri:URI = new URI("http://www.snee.com/xml/crud/posttest.cgi");
      
      client.listener.onComplete = addAsync(function(event:HttpResponseEvent):void {
        assertNotNull(event.response);        
      }, 20 * 1000);
      
      client.listener.onStatus = function(event:HttpStatusEvent):void {
        assertTrue(event.response.isSuccess);
      };
      
      var params:Array = [ { name: "fname", value: "FirstName1" }, { name: "lname", value: "LastName1" } ];
      client.putFormData(uri, params);
      
    }
    
  }
  
}