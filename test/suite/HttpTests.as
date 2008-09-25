package suite {
  
  import flexunit.framework.TestSuite;  
  
  import httpclient.http.*;
  import httpclient.io.*;
  
  // For examples, see: http://code.google.com/p/as3flexunitlib/wiki/Resources
  public class HttpTests extends TestSuite {
    
    public function HttpTests() {
      super();
      addTest(ChunkedTest.suite());
      addTest(ReadLineTest.suite());
      addTest(TLSTest.suite());
      addTest(GetTest.suite());
      addTest(PostTest.suite());
      addTest(UriEscapeTest.suite());
      addTest(HttpsChunkedTest.suite());
      addTest(PutTest.suite());
      
      // Uncomment when have upload supported
      //addTest(UploadTest.suite());
    }
    
  }
  
}