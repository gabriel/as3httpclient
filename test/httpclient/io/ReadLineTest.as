package httpclient.io {
  
  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  
  import org.httpclient.io.*;

  import flash.utils.ByteArray;
  
  public class ReadLineTest extends TestCase {
    
    public function ReadLineTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new ReadLineTest("testReadLine"));
      return ts;
    }
    
    public function getUTFBytes(s:String):ByteArray {
      var bytes:ByteArray = new ByteArray();
      bytes.writeUTFBytes(s);
      return bytes;
    }
    
    public function testReadLine():void {
      var buffer:HttpBuffer = new HttpBuffer();
      
      // Send half of header
      var data:String = "GET /foo HTTP/1.1\r\nHost: foo.com\r\nConnection: ";      
      buffer.write(getUTFBytes(data));
      
      // Get the first two lines, and null on the 3rd
      assertEquals("GET /foo HTTP/1.1", buffer.readLine(true));
      assertEquals("Host: foo.com", buffer.readLine(true));
      assertNull(buffer.readLine(true));
      
      // Write the end of the header
      var nextData:String = "close\r\n\r\n";
      buffer.write(getUTFBytes(nextData));
      
      // Get the 3rd line and last empty line
      assertEquals("Connection: close", buffer.readLine(true));
      assertEquals("", buffer.readLine(true));
    }
    
  }
  
}