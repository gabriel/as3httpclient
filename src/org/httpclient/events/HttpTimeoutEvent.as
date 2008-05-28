package org.httpclient.events {
  
  public class HttpTimeoutEvent extends HttpErrorEvent {
    
    public static const ERROR:String = "httpTimeout";
    
    public function HttpTimeoutEvent(type:String = "error", bubbles:Boolean = false, 
      cancelable:Boolean = false, text:String = "", id:int = 0):void {
        
      super(type, bubbles, cancelable, text);
    }
        
  }
}