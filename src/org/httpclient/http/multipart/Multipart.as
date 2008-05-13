/**
 * Copyright (c) 2007 Gabriel Handford
 * See LICENSE.txt for full license information.
 */
package org.httpclient.http.multipart {
  
  import flash.utils.ByteArray;
  
  public class Multipart {
    
    public static const BOUNDARY:String = "----------------314159265358979323846";
    
    private var _parts:Array = [];
    
    private var _partIndex:int = 0; // Index to current part
    private var _bytesSent:uint = 0; // Bytes sent for current part
        
    /**
     * Create multipart.
     * 
     * @param parts
     */
    public function Multipart(parts:Array) { 
      _parts = parts;
    }
    
    /**
     * Get content length.
     */
    public function get length():uint {
      var length:uint = 0;
      for each(var part:Part in _parts) {
        length += part.length;
      }
      return length;
    }
    
    /**
     * Read available data from multipart.
     * @return Data, or null if no more
     *  
     */
    public function readBytes(bytes:ByteArray, offset:uint, length:uint):void {      
      if (!hasMoreParts) return;
      
      currentPart.readBytes(bytes, offset, length);
      
      _bytesSent += bytes.length;
        
      // If no more payload, go to next part    
      if (_bytesSent >= currentPart.length) {                
        currentPart.close();
        _partIndex += 1;
        _bytesSent = 0;
      }
    }
    
    public function get bytesAvailable():uint {
      if (!hasMoreParts) throw new Error("No parts left to read");
      
      return currentPart.bytesAvailable;
    }
    
    /**
     * Get current part for reading.
     */
    public function get currentPart():Part {
      return Part(_parts[_partIndex]);
    }
    
    /**
     * Check if have more parts for reading.
     */        
    protected function get hasMoreParts():Boolean {
      return _partIndex < _parts.length;
    }
        
    
    //
    // From apache httpclient, not using random boundary.
    //
    
    private static const BOUNDARY_CHARS:String = "-_1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";    
    
    /**
     * Generate random boundary (see java httpclient MultipartRequestEntity).
     */
    private static function generateBoundary():String {      
      var length:Number = Math.round(Math.random() * 10) * 30;
      var boundary:String = "";
      for(var i:Number = 0; i < length; i++) {
        var index:Number = Math.round(Math.random() * (BOUNDARY_CHARS.length - 1));
        boundary += BOUNDARY_CHARS.charAt(index);
      }
      return boundary;
    }
    
  }
}