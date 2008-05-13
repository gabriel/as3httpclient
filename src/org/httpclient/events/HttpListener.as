package org.httpclient.events {
  
  import flash.events.Event;
  import flash.events.EventDispatcher;
  
  public class HttpListener {
    
    public var onClose:Function = null;
    public var onComplete:Function = null;
    public var onConnect:Function = null;
    public var onData:Function = null;
    public var onError:Function = null;
    public var onStatus:Function = null;
    
    public function HttpListener(listeners:Object = null) {
      if (listeners) {
        if (listeners["onClose"] != undefined) onClose = listeners.onClose;
        if (listeners["onComplete"] != undefined) onComplete = listeners.onComplete;
        if (listeners["onConnect"] != undefined) onConnect = listeners.onConnect;
        if (listeners["onData"] != undefined) onData = listeners.onData;
        if (listeners["onError"] != undefined) onError = listeners.onError;
        if (listeners["onStatus"] != undefined) onStatus = listeners.onStatus;
      }
    }
    
    public function register(dispatcher:EventDispatcher):void {
      dispatcher.addEventListener(Event.CLOSE, onInternalClose);
      dispatcher.addEventListener(Event.COMPLETE, onInternalComplete);
      dispatcher.addEventListener(Event.CONNECT, onInternalConnect);
      dispatcher.addEventListener(HttpDataEvent.DATA, onInternalData);
      dispatcher.addEventListener(HttpErrorEvent.ERROR, onInternalError);
      dispatcher.addEventListener(HttpStatusEvent.STATUS, onInternalStatus);      
    }
    
    public function onInternalClose(e:Event):void { 
      if (onClose != null) onClose();
    }
    
    public function onInternalComplete(e:Event):void { 
      if (onComplete != null) onComplete();
    }
    
    public function onInternalConnect(e:Event):void { 
      if (onConnect != null) onConnect();
    }
    
    public function onInternalData(e:HttpDataEvent):void { 
      if (onData != null) onData(e);
    }
    
    public function onInternalError(e:HttpErrorEvent):void { 
      if (onError != null) onError(new Error(e.text)); //, e.errorID));
    }
    
    public function onInternalStatus(e:HttpStatusEvent):void { 
      if (onStatus != null) onStatus(e.response);
    }
    
  }
}