package utils {
  
  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  
  import org.httpclient.*;
  import org.httpclient.http.*;
  import org.httpclient.events.*;  
  
  import com.adobe.net.*;
  
  import flash.utils.ByteArray;
  import flash.events.Event;
  
  public class UtilTest extends TestCase {
    
    public function UtilTest(methodName:String):void {
      super(methodName);
    }
    
    public static function suite():TestSuite {      
      var ts:TestSuite = new TestSuite();
      ts.addTest(new UtilTest("testReduce"));
      return ts;
    }
    
    public function reduce(array:Array, f:Function, index:int = 0):* {
      if (index == array.length - 1) return array[index];
      return f(array[index], reduce(array, f, index + 1));
    }
    
    public function sum(p1:Number, p2:Number):Number {
      return p1 + p2;
    }
    
    /**
     * Test.
     */
    public function testReduce():void {
      var array:Array = [ 1, 2, 3 ];

      var result:Number = reduce(array, sum);
      assertEquals(6, result);
    }
    
  }
  
}