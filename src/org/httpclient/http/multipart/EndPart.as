/**
 * Copyright (c) 2007 Gabriel Handford
 * See LICENSE.txt for full license information.
 */
package org.httpclient.http.multipart {
  
  import flash.utils.ByteArray;
  
  public class EndPart extends Part {
        
    /**
     * Create part section.
     *  
     * @param none
     */
    public function EndPart() {
      super(new ByteArray());
    }

    /**
     * Build header.
     * @return Header as byte array
     */
    override protected function header():ByteArray {
      var bytes:ByteArray = new ByteArray();

      // Boundary
      bytes.writeUTFBytes("--" + Multipart.BOUNDARY + "--\r\n");
      bytes.position = 0;
      return bytes;
    }

    override protected function footer():ByteArray {
      return new ByteArray();
    }
  }
}
