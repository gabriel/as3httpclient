package org.httpclient.events {
  
  import flash.events.Event;
  
  import org.httpclient.HttpResponse;
  
  public class HttpStatusEvent extends Event {
    
    public static const STATUS:String = "status";
    
    private var _response:HttpResponse;
    
    public function HttpStatusEvent(response:HttpResponse, type:String = "status", bubbles:Boolean = false, cancelable:Boolean = false):void {
      super(type, bubbles, cancelable);
      _response = response;     
    }
    
    public function get response():HttpResponse {
      return _response;
    }
    
  }
}