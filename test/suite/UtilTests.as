package suite {
  
  import flexunit.framework.TestSuite;  
  
  import utils.*;
  import s3.*;
  
  // For examples, see: http://code.google.com/p/as3flexunitlib/wiki/Resources
  public class UtilTests extends TestSuite {
    
    public function UtilTests() {
      super();      
      addTest(UtilTest.suite());      
    }
    
  }
  
}