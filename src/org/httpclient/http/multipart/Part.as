/**
 * Copyright (c) 2007 Gabriel Handford
 * See LICENSE.txt for full license information.
 */
package org.httpclient.http.multipart {
  
  import flash.utils.ByteArray;
  
  public class Part {
        
    private var _contentType:String;
    private var _params:Array;
    private var _boundary:String;
    
    private var _header:ByteArray;
    private var _payload:*;
    private var _footer:ByteArray;
    
    /**
     * Create multipart section.
     *  
     * @param payload
     * @param contentType
     * @param params, [ { name: "Name", value: "Value" }, ... ]
     * @param boundary Boundary or null, and a random one is generated
     */
    public function Part(payload:*, contentType:String = "application/octet-stream", params:Array = null) { 
      _payload = payload;
      _contentType = contentType;
      _params = params;
      if (!_params) _params = [];
      
      _header = header();
      _footer = footer();
    }
    
    /**
     * Get bytes.
     */
    private function get nextBytes():* {
      if (_header.bytesAvailable > 0) return _header;      
      if (_payload.bytesAvailable > 0) return _payload;      
      if (_footer.bytesAvailable > 0) return _footer;

      throw Error("Nothing left for part");
    }
    
    /**
     * Read available data from payload.
     * @return Data
     */
    public function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void {      
      if (nextBytes.bytesAvailable > 0) {
        length = Math.min(length, nextBytes.bytesAvailable);
        nextBytes.readBytes(bytes, offset, length);
      }
    }
    
    public function get bytesAvailable():uint {
      return nextBytes.bytesAvailable;
    }
    
    /**
     * Get part content length.
     */
    public function get length():uint {
      return _payload.length + _header.length + _footer.length;
    }
        
    /**
     * Close payload.
     */
    public function close():void {
      _payload.close();
    }
        
    /**
     * Build header.
     */
    protected function header():ByteArray {
      var bytes:ByteArray = new ByteArray();
      
      // Boundary
      bytes.writeUTFBytes("--" + Multipart.BOUNDARY + "\r\n");
      
      // Content disposition
      bytes.writeUTFBytes("Content-Disposition: form-data; ");
      
      // Params
      bytes.writeUTFBytes(_params.map(function(item:*, index:int, array:Array):void { item["name"] + "=\"" + item["value"] + "\""; }).join("; "));
      bytes.writeUTFBytes("\r\n");
      
      // Content type
      bytes.writeUTFBytes("Content-Type: " + _contentType + "\r\n");
      bytes.writeUTFBytes("Content-Length: " + _payload.length + "\r\n");
      
      // Empty line      
      bytes.writeUTFBytes("\r\n");
            
      bytes.position = 0;
      return bytes;
    }
    
    protected function footer():ByteArray {
      var bytes:ByteArray = new ByteArray();
      bytes.writeUTFBytes("\r\n");
      bytes.position = 0;
      return bytes;
    }
    
  }
}