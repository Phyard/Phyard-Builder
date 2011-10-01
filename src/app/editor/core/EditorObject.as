
package editor.core {
   
   import flash.display.Sprite;
   
   public class EditorObject extends Sprite
   {
      public function EditorObject ()
      {
      }
  
//=============================================================
//   reference
//=============================================================
      
      protected function ReferObject (refering:EditorObject):ReferPair
      {
         if (refering == null)
            return null;
         
         return new ReferPair (this, refering);
      }
      
      internal var mReferPairListHeadAsReferer:ReferPair = null;
      internal var mReferPairListHeadAsRefering:ReferPair = null;
      
      internal function AddReferPairAsReferer (referPair:ReferPair):void
      {
         if (referPair.mReferer != this)
            return;
         
         if (mReferPairListHeadAsReferer != null)
            mReferPairListHeadAsReferer.mPrevReferPairForReferer = referPair;
         
         referPair.mNextReferPairForReferer = mReferPairListHeadAsReferer;
         referPair.mPrevReferPairForReferer = null;
         
         mReferPairListHeadAsReferer = referPair;
      }
      
      internal function RemoveReferPairAsReferer (referPair:ReferPair):void
      {
         if (referPair.mReferer != this)
            return;
         
         if (referPair.mPrevReferPairForReferer != null) // == mReferPairListHeadAsReferer
            referPair.mPrevReferPairForReferer.mNextReferPairForReferer = referPair.mNextReferPairForReferer;
         else
            mReferPairListHeadAsReferer = referPair.mNextReferPairForReferer;
            
         if (referPair.mNextReferPairForReferer != null)
         {
            referPair.mNextReferPairForReferer.mPrevReferPairForReferer = referPair.mPrevReferPairForReferer;
         }
      }
      
      internal function AddReferPairAsRefering (referPair:ReferPair):void
      {
         if (referPair.mRefering != this)
            return;
         
         if (mReferPairListHeadAsRefering != null)
            mReferPairListHeadAsRefering.mPrevReferPairForRefering = referPair;
         
         referPair.mNextReferPairForRefering = mReferPairListHeadAsRefering;
         referPair.mPrevReferPairForRefering = null;
         
         mReferPairListHeadAsRefering = referPair;
      }
      
      internal function RemoveReferPairAsRefering (referPair:ReferPair):void
      {
         if (referPair.mRefering != this)
            return;
         
         if (referPair.mPrevReferPairForRefering != null) // == mReferPairListHeadAsRefering
            referPair.mPrevReferPairForRefering.mNextReferPairForRefering = referPair.mNextReferPairForRefering;
         else
            mReferPairListHeadAsRefering = referPair.mNextReferPairForRefering;
            
         if (referPair.mNextReferPairForRefering != null)
         {
            referPair.mNextReferPairForRefering.mPrevReferPairForRefering = referPair.mPrevReferPairForRefering;
         }
      }
      
      private function BuildReferPairListAsReferingForIterating ():ReferPairListElement
      {
         var iter:ReferPairListElement = null;
         
         var referPair:ReferPair = mReferPairListHeadAsRefering;
         while (referPair != null)
         {
            iter = new ReferPairListElement (referPair, iter);
            referPair = referPair.mNextReferPairForRefering;
         }
         
         return iter;
      }
      
      public function NotifyModifiedForReferers (info:Object = null):void
      {
         var iter:ReferPairListElement = BuildReferPairListAsReferingForIterating ();
         while (iter != null)
         {
            if (iter.mReferPair.IsActive ())
            {
               iter.mReferPair.mReferer.OnReferingModified (iter.mReferPair, info);
            }
            
            iter = iter.mNextElement;
         }
      }
      
      protected function NotifyDestroyedForReferers ():void
      {
         var iter:ReferPairListElement = BuildReferPairListAsReferingForIterating ();
         while (iter != null)
         {
            if (iter.mReferPair.IsActive ())
            {
               iter.mReferPair.mReferer.OnReferingDestroyed (iter.mReferPair);
            }
            
            iter = iter.mNextElement;
         }
      }
      
      protected function UnreferAllReferings ():void
      {
         var referPair:ReferPair = mReferPairListHeadAsReferer;
         while (referPair != null)
         {
            referPair.Break ();
            referPair = referPair.mNextReferPairForReferer;
         }
      }
      
      protected function FinalAssertReferPairs ():void
      {
         if (mReferPairListHeadAsReferer != null)
            throw new Error ("mReferPairListHeadAsReferer != null ! " + this);
         if (mReferPairListHeadAsRefering != null)
            throw new Error ("mReferPairListHeadAsRefering != null ! " + this);
      }
      
      public function OnReferingModified (referPair:ReferPair, info:Object = null):void
      {
         // to override
      }
      
      public function OnReferingDestroyed (referPair:ReferPair):void
      {
         // to override
      }
   }
}
