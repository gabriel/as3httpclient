package org.httpclient.ui {
  
  import mx.core.Application;
  import mx.controls.TextInput;
  import mx.controls.TextArea;
  import mx.controls.Label;
  import mx.controls.ComboBox;
  import mx.containers.TabNavigator;
  import flash.events.Event;
  import mx.events.MenuEvent;
  import flash.utils.ByteArray;
  import mx.collections.ArrayCollection;
  
  import org.httpclient.HttpClient;
  import org.httpclient.http.Delete;
  import org.httpclient.events.HttpListener;
  import org.httpclient.events.HttpDataEvent;
  import org.httpclient.events.HttpStatusEvent;
  import org.httpclient.events.HttpErrorEvent;
  import com.adobe.net.URI;

  public class HttpClientAppImpl extends Application {
    
    [Bindable]
    public var verbs:ArrayCollection = new ArrayCollection([ { label:"GET" }, { label:"HEAD" }, { label:"DELETE" }, { label:"PUT" }, { label:"POST" } ]);
    
    public var uriInput:TextInput;
    public var verbCombo:ComboBox;
    public var statusLabel:Label;
    public var requestBodyArea:TextArea;
    
    public var responseStatusLabel:Label;
    public var responseHeaderArea:TextArea;
    public var responseBodyArea:TextArea;    
    
    public var tabNavigator:TabNavigator;

    public function onRequest(event:Event):void {
      
      var verb:String = verbCombo.selectedItem.label;
      
      responseBodyArea.text = "";
      responseStatusLabel.text = "";
      responseHeaderArea.text = "";
      
      var listeners:Object = { 
        onData: function(e:HttpDataEvent):void {           
          statusLabel.text = "Received " + e.bytes.length + " bytes";
          responseBodyArea.text += e.readUTFBytes();
        },
        onStatus: function(e:HttpStatusEvent):void {
          statusLabel.text = "Got response header";
          responseStatusLabel.text = e.code + " " + e.response.message;
          responseHeaderArea.text = e.header.toString();
        },
        onClose: function():void {
          statusLabel.text = "Closed";
          tabNavigator.selectedIndex = 1;
        },
        onComplete: function():void {          
          statusLabel.text = "Completed";
        },
        onConnect: function():void {
          statusLabel.text = "Connected";
        },
        onError: function(event:HttpErrorEvent):void {
          statusLabel.text = "Error: " + event.text;
        }
      };
      
      statusLabel.text = "Connecting";
      
      var client:HttpClient = new HttpClient();
      client.timeout = 5000;
      client.listener = new HttpListener(listeners);
      
      var requestURI:URI = new URI(uriInput.text);
      
      var data:ByteArray = new ByteArray();
      data.writeUTFBytes(requestBodyArea.text);
      data.position = 0;      
            
      if (verb == "GET") {
        client.get(requestURI);
      } else if (verb == "HEAD") {
        client.head(requestURI);
      } else if (verb == "DELETE") {
        client.request(requestURI, new Delete());
      } else if (verb == "PUT") {
        client.put(requestURI, data);
      } else if (verb == "POST") {
        client.post(requestURI, data);
      }
      else throw new ArgumentError("Invalid verb: " + verb);
    }
    
  }

}