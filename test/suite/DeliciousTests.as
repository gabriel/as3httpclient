package suite {
  
  import flexunit.framework.TestSuite;  
  
  import httpclient.http.*;
  import httpclient.io.*;
  
  import delicious.*;
  
  // For examples, see: http://code.google.com/p/as3flexunitlib/wiki/Resources
  public class DeliciousTests extends TestSuite {
    
    public function DeliciousTests() {
      super();
      addTest(TagsTest.suite());
    }
    
  }
  
}