/**
 * Copyright (c) 2007 Gabriel Handford
 * See LICENSE.txt for full license information.
 */
package org.httpclient {
  
  import com.adobe.net.URI;
  
  import flash.events.EventDispatcher;
  import flash.events.Event;
  import flash.errors.IllegalOperationError;
  
  import org.httpclient.http.Put;
  import org.httpclient.http.Post;
  import org.httpclient.http.Get;
  import org.httpclient.http.Head;
  import org.httpclient.http.Delete;
  import org.httpclient.events.HttpListener;
  
  import org.httpclient.http.multipart.Multipart;
  //import org.httpclient.http.multipart.FilePart;
    
  [Event(name=Event.CLOSE, type="flash.events.Event")]  
  
  [Event(name=HttpRequestEvent.CONNECT, type="org.httpclient.events.HttpRequestEvent")]
  [Event(name=HttpResponseEvent.COMPLETE, type="org.httpclient.events.HttpResponseEvent")]
  
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
    private var _proxy:URI;
    
    /**
     * Create HTTP client.
     * @param proxy URI
     */
    public function HttpClient(proxy:URI = null) {
      _timeout = -1;
      _proxy = proxy;
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
      _socket = new HttpSocket(this, timeout, _proxy);
      _socket.request(uri, request);
    }
    
    /**
     * Upload file to URI. In the Flash/AIR VM, there is no way to determine when packets leave the computer, since
     * the Socket#flush call is not blocking and there is no output progress events to monitor.
     *  
     *  var client:HttpClient = new HttpClient();
     *  
     *  client.listener.onComplete = function(e:HttpResponseEvent):void { ... };
     *  client.listener.onStatus = function(e:HttpStatusEvent):void { ... };
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
            
      //httpRequest.setMultipart(new Multipart([ new FilePart(file) ]));    
      throw new IllegalOperationError("Not supported, comment out the line above");
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
     *   client.postFormData(new URI("http://foo.com/"), variables);
     *  
     * @param uri
     * @param variables
     */
    public function postFormData(uri:URI, variables:Array):void {
      request(uri, new Post(variables));
    }
    
    /**
     * Post with multipart.
     *  
     * @param uri
     * @param multipart
     */
    public function postMultipart(uri:URI, multipart:Multipart):void {
      var post:Post = new Post();
      post.setMultipart(multipart);
      request(uri, post);
    }
    
    /**
     * Post with raw data.
     *  
     * @param uri
     * @param body
     * @param contentType
     *  
     * The request body can be anything but should respond to:
     *  - readBytes(bytes:ByteArray, offset:uint, length:uint)
     *  - length
     *  - bytesAvailable
     *  - close
     */
    public function post(uri:URI, body:*, contentType:String = null):void {
      var post:Post = new Post();
      post.body = body;
      post.contentType = contentType;
      request(uri, post);
    }
    
    /**
     * Put with raw data.
     *  
     * @param uri
     * @param body
     * @param contentType
     *  
     * The request body can be anything but should respond to:
     *  - readBytes(bytes:ByteArray, offset:uint, length:uint)
     *  - length
     *  - bytesAvailable
     *  - close
     */ 
    public function put(uri:URI, body:*, contentType:String = null):void {
      var put:Put = new Put();
      put.body = body;
      put.contentType = contentType;
      request(uri, put);
    }
    
    /**
     * Put with form data.
     *  
     *   var variables:Array = [ 
     *    { name: "fname", value: "FirstName1" }, 
     *    { name: "lname", value: "LastName1" } 
     *   ];
     *  
     *   client.putFormData(new URI("http://foo.com/"), variables);
     *  
     * @param uri
     * @param variables
     */
    public function putFormData(uri:URI, variables:Array):void {
      var put:Put = new Put();
      put.setFormData(variables);
      request(uri, put);
    }
    
    /**
     * Head.
     * @param uri
     */    
    public function head(uri:URI):void {
      request(uri, new Head());
    }
    
    /**
     * Delete.
     * (Delete is a keyword; which is why this method signature is inconsistent)
     * @param uri
     */
    public function del(uri:URI):void {
      request(uri, new Delete());
    }
  }

}