
package editor.core {
   
   // this class is for intertion usage
   
   internal class ReferPairListElement
   {
      internal var mReferPair:ReferPair;
      
      internal var mNextElement:ReferPairListElement;
      
      public function ReferPairListElement (referPair:ReferPair, nextElement:ReferPairListElement)
      {
         mReferPair = referPair;
         mNextElement = nextElement;
      }
   }
}
