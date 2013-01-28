/**
 * Copyright (c) 2007 Gabriel Handford
 * See LICENSE.txt for full license information.
 */
package org.httpclient.http {
  
  import org.httpclient.HttpRequest;
  
  public class Patch extends HttpRequest {
    
    public function Patch() {      
      super("PATCH");
    }
    
    override public function get hasRequestBody():Boolean {
      return true;
    }
    
    override public function get hasResponseBody():Boolean {
      return true;
    }
            
  }
  
}