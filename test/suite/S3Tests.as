package suite {
  
  import flexunit.framework.TestSuite;  
  
  import s3.*;
  
  // For examples, see: http://code.google.com/p/as3flexunitlib/wiki/Resources
  public class S3Tests extends TestSuite {
    
    public function S3Tests() {
      super();
      addTest(S3GetTest.suite());
      addTest(S3HeadTest.suite());      
      addTest(S3PutTest.suite());
      addTest(S3DeleteTest.suite());
      addTest(HttpsTest.suite());      
      addTest(S3PostTest.suite());
    }
    
  }
  
}