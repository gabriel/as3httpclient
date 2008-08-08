package s3 {

  import com.adobe.serialization.json.JSON;
  import com.hurlant.util.Base64;
  import com.hurlant.crypto.hash.SHA1;
	import com.hurlant.crypto.hash.HMAC;
	import flash.utils.ByteArray;
	import flash.net.URLVariables;
  
  public class S3PostOptions {
    
    private var bucketName:String;
    private var objectName:String;
    private var accessKey:String;
    private var contentType:String;
    private var acl:String;
    private var isFlash:Boolean;
    
    private static var hmac:HMAC;
    
    public function S3PostOptions(bucketName:String, objectName:String, accessKey:String, options:Object = null) {
      this.bucketName = bucketName;
      this.objectName = objectName;
      this.accessKey = accessKey;
      this.contentType = options.contentType;
      this.acl = options.acl;
      this.isFlash = options.isFlash;
      
      if (!hmac) hmac = new HMAC(new SHA1());
    }
    
    public function getURLVariables(secretAccessKey:String):URLVariables {
      var postVariables:URLVariables = new URLVariables();
      postVariables.key = objectName;
      postVariables.AWSAccessKeyId = accessKey;
      if (contentType) postVariables["Content-Type"] = contentType;
      if (acl) postVariables.acl = acl;
			postVariables.policy = getPolicy(); 
      postVariables.signature = getSignature(secretAccessKey, postVariables.policy);
      return postVariables;
    }
    
    public function getExpiration():String {
      var year:Number = new Date().getFullYear() + 1;      
      return year + "-01-01T12:00:00.000Z"
    }
  
    /**
     * Get policy, in JSON format encoded as Base64.
     * @param encode If true, will return Base64 encoded.
     * @return Policy string
     */
    public function getPolicy(encode:Boolean = true):String {
      var policyOptions:Object = {};
      policyOptions.expiration = getExpiration();
      var conditions:Array = [];
      conditions.push({ bucket: bucketName });
      conditions.push({ key: objectName });
      conditions.push({ "Content-Type": contentType });
      
      if (isFlash) conditions.push([ "starts-with", "$Filename", "" ]);
      
      policyOptions.conditions = conditions;
      var policy:String = JSON.encode(policyOptions);            
      //Log.debug("policy=" + policy);
      if (encode) policy = Base64.encode(policy);
      return policy;
    }
    
    public function getSignature(secretAccessKey:String, policyEncoded:String):String {
      var policyEncodedBytes:ByteArray = new ByteArray();
			policyEncodedBytes.writeUTFBytes(policyEncoded);
			
			var secretAccessKeyBytes:ByteArray = new ByteArray();
			secretAccessKeyBytes.writeUTFBytes(secretAccessKey);
			
      var signatureBytes:ByteArray = hmac.compute(secretAccessKeyBytes, policyEncodedBytes);
      return Base64.encodeByteArray(signatureBytes);
    }
  }
  
}