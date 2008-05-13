/**
 * Copyright (c) 2007 Gabriel Handford
 * See LICENSE.txt for full license information.
 */
package org.httpclient.io {
  
  import com.adobe.utils.StringUtil;
  import flash.utils.ByteArray;
  
  import org.httpclient.HttpResponse;
  import org.httpclient.HttpHeader;
  
  public class HttpResponseBuffer {
        
    // Data buffer
    private var _buffer:HttpBuffer = new HttpBuffer();
        
    // Response header data parsed from bytes
    private var _headerData:Array = [];
    
    // The response header, after we parsed it
    private var _responseHeader:HttpResponse;    
    
    // For special transfer encodings (like Chunks); Typically data is streamed directly
    private var _responseBody:HttpBuffer = new HttpBuffer();
    
    // Notified of response header: function(response:HttpResponse):void { }
    private var _onResponseHeader:Function;
    
    // Notified of response body data: function(bytes:ByteArray):void { }
    private var _onResponseData:Function;    
        
    /**
     * Create response buffer.
     * @param onPayload Notified of response body data: function(bytes:ByteArray):void { }
     */
    public function HttpResponseBuffer(onResponseHeader:Function, onResponseData:Function) { 
      super();
      _onResponseHeader = onResponseHeader;
      _onResponseData = onResponseData;
    }

    /**
     * Write bytes to the buffer.
     * Parse lines for header, or send to onPayload.
     *  
     * @param bytes Data
     */
    public function writeBytes(bytes:ByteArray):void {

      // If we don't have the full header yet
      if (!_responseHeader) {
        _buffer.write(bytes);
      
        var line:String = _buffer.readLine(true);              
        while (line != null) {          
          
          // If empty line, then we reached the end of the header
          if (line == "") {
            _responseHeader = parseHeader(_headerData);
            Log.debug("Response header:\n" + _responseHeader);
          
            // Notify
            _onResponseHeader(_responseHeader);
          
            // On information responses, get next response header            
            if (_responseHeader.isInformation) {              
              _buffer.truncate();
              _responseHeader = null;
            } else {                      
              // Pass any extra as payload
              handlePayload(_buffer.readAvailable());
              break;
            }            
          
          } else {
            _headerData.push(line);
          }
          
          line = _buffer.readLine(true);          
        }    
              
      } else {
        handlePayload(bytes);
      }
            
    }
    
    /**
     * Get header, if its been reached.
     */
    public function get header():HttpResponse { return _responseHeader; }
    
    /**
     * Notify with response data.
     * Check for transfer encodings, otherwise stream it direct.
     * @param bytes The data
     */
    private function handlePayload(bytes:ByteArray):void {    
      if (bytes.bytesAvailable <= 0) return;
      
      if (_responseHeader.isChunked) {
        _responseBody.write(bytes);
        _responseBody.readChunks(_onResponseData);
      } else {                     
        _onResponseData(bytes);
      }
    }
    
    /**
     * Parse HTTP response header.
     * @param lines Lines in header
     * @return The HTTP response (header)
     */
    protected function parseHeader(lines:Array):HttpResponse {
      var line:String = lines[0];

      // Regex courtesy of ruby 1.8 Net::HTTP
      // Example, HTTP/1.1 200 OK      
      var matches:Array = line.match(/\AHTTP(?:\/(\d+\.\d+))?\s+(\d\d\d)\s*(.*)\z/);

      if (!matches)
        throw new Error("Invalid header: " + line + ", matches: " + matches);

      var version:String = matches[1];
      var code:String = matches[2];
      var message:String = matches[3];
      var headers:Array = [];      
      
      for(var i:Number = 1; i < lines.length; i++) {
        line = lines[i];

        var index:int = line.indexOf(":");
        if (index != -1) {
          var name:String = line.substring(0, index);
          var value:String = line.substring(index + 1, line.length);
          headers.push({ name: name, value: value });
        } else {
          Log.warn("Invalid header: " + line);
        }
      }

      return new HttpResponse(version, code, message, new HttpHeader(headers));
    }

  }
  
}