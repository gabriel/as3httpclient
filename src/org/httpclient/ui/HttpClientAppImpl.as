package org.httpclient.ui {
  
  import mx.core.Application;
  import mx.controls.TextInput;
  import mx.controls.TextArea;
  import flash.events.Event;
  
  import org.httpclient.HttpClient;
  import org.httpclient.events.HttpDataEvent;
  import com.adobe.net.URI;

  public class HttpClientAppImpl extends Application {
    
    public var uri:TextInput;
    public var response:TextArea;

    public function onGo(event:Event):void {
      
      var listeners:Object = { 
        onData: function(e:HttpDataEvent):void { 
          response.text += e.readUTFBytes();
        } 
      }
      
      HttpClient.get(new URI(uri.text), listeners);
      
    }
    
  }

}