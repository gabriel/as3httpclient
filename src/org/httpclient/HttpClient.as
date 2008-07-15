/**
 * Copyright (c) 2007 Gabriel Handford
 * See LICENSE.txt for full license information.
 */
package org.httpclient {
  
  import com.adobe.net.URI;
  
  import flash.events.EventDispatcher;
  import flash.events.Event;
  
  import org.httpclient.http.Put;
  import org.httpclient.http.Post;
  import org.httpclient.http.Get;
  import org.httpclient.http.Head;
  import org.httpclient.http.Delete;
  import org.httpclient.events.HttpListener;
  
  import org.httpclient.http.multipart.Multipart;
  //import org.httpclient.http.multipart.FilePart;
    
  [Event(name=Event.CLOSE, type="flash.events.Event")]
  [Event(name=Event.COMPLETE, type="flash.events.Event")]
  [Event(name=Event.CONNECT, type="flash.events.Event")]	
  [Event(name=HttpDataEvent.DATA, type="org.httpclient.events.HttpDataEvent")]     
  [Event(name=HttpStatusEvent.STATUS, type="org.httpclient.events.HttpStatusEvent")]  
  [Event(name=HttpRequestEvent.COMPLETE, type="org.httpclient.events.HttpRequestEvent")]
  [Event(name=HttpErrorEvent.ERROR, type="org.httpclient.events.HttpErrorEvent")]  
  [Event(name=HttpErrorEvent.TIMEOUT_ERROR, type="org.httpclient.events.HttpErrorEvent")]    
  [Event(name=IOErrorEvent.IO_ERROR, type="flash.events.IOErrorEvent")]  
  [Event(name=SecurityErrorEvent.SECURITY_ERROR, type="flash.events.SecurityErrorEvent")]  
  
  /**
   * HTTP Client.
   */
  public class HttpClient extends EventDispatcher {

    private var _socket:HttpSocket;  
    private var _listener:*;
    private var _timeout:int;
    
    /**
     * Create HTTP client.
     */
    public function HttpClient() {
      _timeout = -1;
    }
    
    /**
     * Get listener.
     * Redirects events to callbacks.
     * You can use this listener, or use the EventDispatcher listener. Your choice.
     *  
     * @return Listener
     */
    public function get listener():HttpListener {
      if (!_listener) {
        _listener = new HttpListener();
        _listener.register(this);        
      }
      return _listener;
    }
    
    /**
     * Set the listener.
     * @para listener Listeners to callback on
     */
    public function set listener(listener:HttpListener):void {
      //_listener = new HttpListener(listeners);
      _listener = listener;
      _listener.register(this);
    }
    
    public function set timeout(timeout:int):void { _timeout = timeout; }
    public function get timeout():int { return _timeout; }

    /**
     * Load a generic request.
     *  
     * @param uri URI
     * @param request HTTP request
     * @param timeout Timeout (in millis)
     */
    public function request(uri:URI, request:HttpRequest, timeout:int = 60000):void {
      if (timeout == -1) timeout = _timeout;
      _socket = new HttpSocket(this, timeout);
      _socket.request(uri, request);
    }
    
    /**
     * Upload file to URI. In the Flash/AIR VM, there is no way to determine when packets leave the computer, since
     * the Socket#flush call is not blocking and there is no output progress events to monitor.
     *  
     *  var client:HttpClient = new HttpClient();
     *  
     *  client.listener.onComplete = function():void { ... };
     *  client.listener.onStatus = function(r:HttpResponse):void { ... };
     * 
     *  var uri:URI = new URI("http://http-test.s3.amazonaws.com/test_put.png");
     *  var testFile:File = new File("app:/test/assets/test.png");
     * 
     *  client.upload(uri, testFile);
     *  
     * @param uri
     * @param file (Should be flash.filesystem.File; Not typed for compatibility with Flash)
     * @param method PUT or POST
     * @param 
     */
    public function upload(uri:URI, file:*, method:String = "PUT"):void {
      var httpRequest:HttpRequest = null;
      if (method == "PUT") httpRequest = new Put();
      else if (method == "POST") httpRequest = new Post();
      else throw new ArgumentError("Method must be PUT or POST");
            
      // Comment out to compile under flash
      //httpRequest.multipart = new Multipart([ new FilePart(file) ]);    
      throw new DefinitionError("Upload not supported; Rebuild with upload support.");
      
      request(uri, httpRequest);      
    }
    
    /**
     * Get request.
     * @param uri
     */
    public function get(uri:URI):void {
      request(uri, new Get());
    }
    
    /**
     * Post with form data.
     *  
     *   var variables:Array = [ 
     *    { name: "fname", value: "FirstName1" }, 
     *    { name: "lname", value: "LastName1" } 
     *   ];
     *  
     *   client.post(new URI("http://foo.com/"), variables);
     *  
     * @param uri
     * @param variables
     */
    public function postFormData(uri:URI, variables:Array):void {
      request(uri, new Post(variables));
    }
    
    /**
     * Post with data.
     * @param uri
     * @param body
     * @param contentType
     */
    public function post(uri:URI, body:*, contentType:String = null):void {
      var post:Post = new Post();
      post.body = body;
      post.contentType = contentType;
      request(uri, post);
    }
    
    /**
     * Put.
     * @param uri
     * @param body
     * @param contentType
     */ 
    public function put(uri:URI, body:*, contentType:String = null):void {
      var put:Put = new Put();
      put.body = body;
      put.contentType = contentType;
      request(uri, put);
    }
    
    /**
     * Head.
     * @param uri
     */    
    public function head(uri:URI):void {
      request(uri, new Head());
    }
    
  }

}