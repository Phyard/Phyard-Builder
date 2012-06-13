
package editor.core {
   
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   
   import common.DataFormat3;
   
   public class EditorObject extends Sprite
   {
      public function EditorObject ()
      {
      }
  
//=============================================================
//   uuid
//=============================================================
      
      private var mKey:String = "";
      
      public function GetKey ():String
      {
         return mKey;
      }
      
      public function SetKey (key:String):void
      {
         mKey = key;
      }
      
      public static const kMaxAccId:int = 0xFFFFFF;
      
      private static const kTime20090101:Number = new Date (2009, 0, 1, 0, 0, 0, 0).getTime (); // 2009.01.01 00:00:00
      private static const kShift24bits:int = 1 << 24;
      
      public static function BuildKey (spaceName:String, accId:int):String
      {
         var time:Number = new Date ().getTime () - kTime20090101;
         var time1:int = int (time / kShift24bits) & (kShift24bits - 1);
         var time2:int = time & (kShift24bits - 1);
         
         var random:int = Math.floor (Math.random () * kShift24bits);
         
         var bytes:ByteArray = new ByteArray ();
         bytes.length = 12;
         FillByteArrayWith24bits (bytes, 0, random);
         FillByteArrayWith24bits (bytes, 3, accId & kMaxAccId);
         FillByteArrayWith24bits (bytes, 6, time1);
         FillByteArrayWith24bits (bytes, 9, time2);
         var base64String:String = DataFormat3.EncodeByteArray2String (bytes);
         
         var key:String = (spaceName == null ? base64String : spaceName + "/" + base64String);
         
         return key;
      }
      
      private static function FillByteArrayWith24bits (bytes:ByteArray, fromIndex:int, value:int):void
      {
         bytes [fromIndex ++] = (value >> 16) & 0xFF;
         bytes [fromIndex ++] = (value >>  8) & 0xFF;
         bytes [fromIndex ++] = (value >>  0) & 0xFF;
      }
  
//=============================================================
//   time modified 
//=============================================================
  
      private var mTimeModified:Number = 0;
      
      public function GetTimeModified ():Number
      {
         return mTimeModified;
      }
      
      public function SetTimeModified (time:Number):void
      {
         if (isNaN (Number (time)))
            time = 0;
         
         mTimeModified = time;
      }
      
      public function UpdateTimeModified ():void
      {
         mTimeModified = new Date ().getTime () - kTime20090101;
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
