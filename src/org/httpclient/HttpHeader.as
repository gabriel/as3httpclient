/**
 * Copyright (c) 2007 Gabriel Handford
 * See LICENSE.txt for full license information.
 */
package org.httpclient {
  
  import com.adobe.utils.StringUtil;
  
  public class HttpHeader {
    
    private var _headers:Array;
    
    /**
     * Create header.
     * Initialize with headers, [ { name: "Name", value: "Value" }, ... ]
     */
    public function HttpHeader(headers:Array = null) {
      _headers = headers;
      if (!_headers) _headers = [];
    }
    
    /**
     * Add a header.
     * @param name
     * @param value
     */
    public function add(name:String, value:String):void {
      _headers.push({ name: name, value: value });
    }
    
    /**
     * Number of header (name, value) pairs.
     */
    public function get length():Number {
      return _headers.length;
    }
        
    /**
     * Check if we have any headers.
     */
    public function get isEmpty():Boolean { return _headers.length == 0; }
    
    /**
     * Get header value for name.
     * @param name
     * @return Value
     */
    public function getValue(name:String):String {
      var prop:Object = find(name);
      if (prop) return prop["value"];
      return null;
    }
    
    /**
     * Replace header, if set. (otherwise add)
     */
    public function replace(name:String, value:String):void {
      var prop:Object = find(name);
      if (prop) prop["value"] = value;
      else add(name, value);
    }
    
    /**
     * Find header property. (Case insensitive)
     * @param name
     * @return Header property
     */
    public function find(name:String):Object {
      for each(var prop:Object in _headers) {
        if (prop["name"].toLowerCase() == name.toLowerCase()) return prop;
      }
      return null;
    }
    
    /**
     * Check if we have the name, value pair.
     * Case insensitive and trimmed.
     *  
     * @param name
     * @param value
     * @return True if the name with value pair exists
     */
    public function contains(name:String, value:String):Boolean {
      var prop:Object = find(name);
      if (!prop) return false;
      return StringUtil.trim(prop["value"].toLowerCase()) == value.toLowerCase();
    }
    
    /**
     * Get the header content for HTTP request.
     */
    public function get content():String {
      var data:String = "";
      
      for each(var prop:Object in _headers) 
        data += prop["name"] + ": " + prop["value"] + "\r\n";
      
      return data;
    }
    
    /**
     * To string.
     */
    public function toString():String {
      var arr:Array = [];
      for each(var prop:Object in _headers) 
        arr.push(prop["name"] + ": " + prop["value"]);
        
      return arr.join("\n");
    }
  }
}