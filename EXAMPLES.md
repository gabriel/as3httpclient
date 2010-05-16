# GET

	var client:HttpClient = new HttpClient();
      
	client.listener.onStatus = function(event:HttpStatusEvent):void {
	  // Notified of response (with headers but not content)
	};

	client.listener.onData = function(event:HttpDataEvent):void {
	  // For string data
	  var stringData:String = event.readUTFBytes();

	  // For data
	  var data:ByteArray = event.bytes;    
	};

	client.listener.onComplete = function(event:HttpResponseEvent):void {
	  // Notified when complete (after status and data)
	};

	client.listener.onError = function(event:ErrorEvent):void {
	  var errorMessage:String = event.text;
	};      

	var uri:URI = new URI("http://www.google.com/search?q=rel-me");
	client.get(uri);

## Custom Header

	var client:HttpClient = new HttpClient();
	var uri:URI = new URI("http://localhost:8080/shrub/test");      
	var request:HttpRequest = new Get();
	request.addHeader("X-WSSE", "UsernameToken");
	request.addHeader("Username", "tom");
	request.addHeader("PasswordDigest", "Vsr1yvZjImglo7kvcfY3gA==");
	request.addHeader("Nonce", "A11FF4575");
	request.addHeader("Created", "2008-06-04T22:45:25Z");

	client.listener.onComplete = function(event:HttpResponseEvent):void {
	  // Notified when complete (after status and data)
	};

	client.request(uri, request);

## With Request Listener

Instead of having a listener on the HTTP client, you can pass a listener when making the request.

	var client:HttpClient = new HttpClient();
	var listener:HttpListener = new HttpListener();

	listener.onData = function(event:HttpDataEvent):void {
	  // Notified with response content in event.bytes as it streams in
	};

	listener.onStatus = function(event:HttpStatusEvent):void {
	  // Notified when we get status
	};

	listener.onComplete = function(event:HttpResponseEvent):void {
	  // Notified when finished
	};

	var uri:URI = new URI("http://www.cnn.com");
	client.get(uri, listener);

To get notified of all data when the response data has been received, use the HttpDataListener? with HttpDataListener?#onDataComplete.

	 var client:HttpClient = new HttpClient();
	 var listener:HttpDataListener = new HttpDataListener();
   
	 listener.onDataComplete = function(event:HttpResponseEvent, data:ByteArray):void {
	   // Notified with response content
	 };
   
	 listener.onStatus = function(event:HttpStatusEvent):void {
	   // Notified when we get status
	 };
   
	 listener.onComplete = function(event:HttpResponseEvent):void {
	   // Notified when finished
	 };
   
	 var uri:URI = new URI("http://www.cnn.com");
	 client.get(uri, listener);
    
# POST

## Form Data (application/x-www-form-urlencoded)

	var client:HttpClient = new HttpClient();
	var uri:URI = new URI("http://www.snee.com/xml/crud/posttest.cgi");
	var variables:Array = [{name:"fname", value:"FirstName1"}, {name:"lname", value: "LastName1"}];

	client.listener.onData = function(event:HttpDataEvent):void {
	  // Notified with response content in event.bytes as it streams in
	};

	client.listener.onComplete = function(event:HttpResponseEvent):void {
	  // Notified when complete (after status and data)
	};

	client.postFormData(uri, variables);


## Custom

	var client:HttpClient = new HttpClient();
	var uri:URI = new URI("http://some.host/");

	client.listener.onData = function(event:HttpDataEvent):void {
	  // Notified with response content in event.bytes as it streams in
	};

	client.listener.onComplete = function(event:HttpResponseEvent):void {
	  // Notified when complete (after status and data)
	};

	var json:String = "{'foo':'bar'}";
	var jsonData:ByteArray = new ByteArray();
	jsonData.writeUTFBytes(json);
	jsonData.position = 0;
	var contentType:String = "application/json";

	client.post(uri, jsonData, contentType);
	
## Multipart (multipart/form-data; boundary=)

An example of multipart post to S3. Uses S3PostOptions.

Beware of large uploads. Because the API allows no way to track upload progress all the data will stream into memory. This is a limitation of the Flash API.

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

	// Create test data
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


	client.listener.onComplete = function(event:HttpResponseEvent):void {
	  // Notified when complete (after status and data)
	};

	client.postMultipart(uri, multipart);

# HEAD

	var client:HttpClient = new HttpClient();
            
	var uri:URI = new URI("http://http-test.s3.amazonaws.com/test.png");

	client.listener.onStatus = function(event:HttpStatusEvent):void {
	  var response:HttpResponse = event.response;
	  // Headers are case insensitive
	  var requestId:String = response.header.getValue("x-amz-request-id");
	};

	client.head(uri);

# DELETE

	var client:HttpClient = new HttpClient();            
	var uri:URI = new URI("http://http-test.s3.amazonaws.com/test.png");
	client.del(uri);