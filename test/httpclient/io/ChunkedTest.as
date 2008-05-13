package httpclient.io {
  
  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  
  import org.httpclient.io.*;

  import flash.utils.ByteArray;
  
  public class ChunkedTest extends TestCase {
    
    public function ChunkedTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new ChunkedTest("testReadChunks"));
      return ts;
    }
    
    public function testReadChunks():void {
      var buffer:HttpBuffer = new HttpBuffer();
      
      var data:String = "1a; ignore-stuff-here\r\nabcdefghijklmnopqrstuvwxyz\r\n10\r\n1234567890abcdef\r\n0\r\nsome-footer: some-value\r\nanother-footer: another-value\r\n\r\n";
      
      var bytes:ByteArray = new ByteArray();
      bytes.writeUTFBytes(data);
      
      buffer.write(bytes);
            
      var count:int = 0;
      
      var onData:Function = function(data:ByteArray):void {
        if (count == 0) assertEquals("abcdefghijklmnopqrstuvwxyz", data);
        else if (count == 1) assertEquals("1234567890abcdef", data);
        else fail("Too much data");
        count++;
      };
      
      buffer.readChunks(onData);
    }
    
  }
  
}