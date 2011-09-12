
package editor.core {
   
   public class ReferPair
   {
      internal var mReferer:EditorObject;
      internal var mRefering:EditorObject;
      
      internal var mPrevReferPairForReferer:ReferPair;
      internal var mNextReferPairForReferer:ReferPair;
      
      internal var mPrevReferPairForRefering:ReferPair;
      internal var mNextReferPairForRefering:ReferPair;
      
      internal var mIsActive:Boolean;
    
      public function ReferPair (referer:EditorObject, refering:EditorObject)
      {
         mReferer = referer;
         mRefering = refering;
         
         mReferer.AddReferPairAsReferer (this);
         mRefering.AddReferPairAsRefering (this);
         
         mIsActive = true;
      }
      
      public function Break ():void
      {
         mIsActive = false;

         mReferer.RemoveReferPairAsReferer (this);
         mRefering.RemoveReferPairAsRefering (this);
         
         mReferer = null;
         mRefering = null;
      }
      
      public function IsActive ():Boolean
      {
         return mIsActive;
      }
   }
}
