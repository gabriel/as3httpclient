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
  
   import flash.filesystem.File;
  
  public class S3PostTest extends TestCase {
    
    public function S3PostTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new S3PostTest("testPost"));
      ts.addTest(new S3PostTest("testPostFile"));
      return ts;
    }
    
    /**
     * Test post with multipart form data.
     */
    public function testPost():void {
      var client:HttpClient = new HttpClient();
            
      var bucketName:String = "http-test-put";
      var objectName:String = "test-post.txt";
      
      var uri:URI = new URI("http://" + bucketName + ".s3.amazonaws.com/");
      var contentType:String = "text/plain";
      
      var accessKey:String = "0RXZ3R7Y034PA8VGNWR2";      
      var postOptions:S3PostOptions = new S3PostOptions(bucketName, objectName, accessKey, { contentType: contentType });      
      var policy:String = postOptions.getPolicy();
      
      // This is how I got the signature below
      /*var secretAccessKey:String = "<SECRET>";      
      var signature:String = postOptions.getSignature(secretAccessKey, policy);
      Log.debug("signature=" + signature);*/
      var signature:String = "pLlELBq/ky4o7X5arS5BHRjcPnQ="; 
      
      var data:ByteArray = new ByteArray();
      data.writeUTFBytes("This is a test");
      data.position = 0;
      
      var multipart:Multipart = new Multipart([ 
        new Part("key", objectName), 
        new Part("Content-Type", contentType),
        new Part("AWSAccessKeyId", accessKey),
        new Part("Policy", policy),
        new Part("Signature", signature),
        new Part("file", data, contentType, [ { name:"filename", value:objectName } ]),
        new Part("submit", "Upload")
      ]);
      
      client.listener.onComplete = addAsync(function(event:HttpResponseEvent):void {
        assertNotNull(event.response);
      }, 20 * 1000);
      
      client.listener.onStatus = function(event:HttpStatusEvent):void {
        Log.debug("Response: " + event.response);
        // TODO(gabe): Uncomment and fix
        //assertTrue(event.response.isSuccess);
      };
      
      client.listener.onError = function(event:ErrorEvent):void {
        fail(event.text);
      };
      
      client.listener.onData = function(event:HttpDataEvent):void {
        //Log.debug(event.readUTFBytes());
      };
      
      client.postMultipart(uri, multipart);
    }    
    
    public function testPostFile():void {
      var client:HttpClient = new HttpClient();
          
      var bucketName:String = "http-test-put";
      var objectName:String = "test-post-file.png";
    
      var uri:URI = new URI("http://" + bucketName + ".s3.amazonaws.com/");
      var contentType:String = "image/png";
    
      var accessKey:String = "0RXZ3R7Y034PA8VGNWR2";      
      var postOptions:S3PostOptions = new S3PostOptions(bucketName, objectName, accessKey, { contentType: contentType });      
      var policy:String = postOptions.getPolicy();
    
      // This is how I got the signature below
      /*var secretAccessKey:String = "<SECRET>";      
            var signature:String = postOptions.getSignature(secretAccessKey, policy);
            Log.debug("signature=" + signature);*/
      var signature:String = "J18r/1e0HvuGYrrSu5lUo0XJAMI="; 
        
      var file:File = new File("app:/test/assets/test.png");
        
      var multipart:Multipart = new Multipart([
        new Part("key", objectName), 
        new Part("Content-Type", contentType),
        new Part("AWSAccessKeyId", accessKey),
        new Part("Policy", policy),
        new Part("Signature", signature),
        new FilePart(file),
        new Part("submit", "Upload")
      ]);
    
      client.listener.onComplete = addAsync(function(event:HttpResponseEvent):void {
        assertNotNull(event.response);
      }, 20 * 1000);
    
      client.listener.onStatus = function(event:HttpStatusEvent):void {
        Log.debug("Response: " + event.response);
        // TODO(gabe): Uncomment and fix
        //assertTrue(event.response.isSuccess);
      };
    
      client.listener.onError = function(event:ErrorEvent):void {
        fail(event.text);
      };
    
      client.listener.onData = function(event:HttpDataEvent):void {
        Log.debug(event.readUTFBytes());
      };
    
      client.postMultipart(uri, multipart);
    }
  }
  
}