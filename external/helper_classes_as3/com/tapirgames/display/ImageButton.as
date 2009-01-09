package com.tapirgames.display {
   
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.SimpleButton;
   import flash.display.Shape;
   
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   import flash.events.MouseEvent;

   

   
   public class ImageButton extends SimpleButton 
   {
      private var mBitmap:Bitmap;
      private var mOnClikFunc:Function;
      private var mUserData:Object;
      
      public function ImageButton (onClick:Function, bitmapData:BitmapData, userData:Object = null)
      {
         addEventListener( MouseEvent.CLICK, OnButtonClick );
         
         SetClickEventHandler (onClick);
         
         SetBitmapData (bitmapData);
         
         SetUserData (userData);
      }
      
      public function SetClickEventHandler (onClick:Function):void
      {
         mOnClikFunc = onClick;
         
         useHandCursor = (mOnClikFunc != null);
      }
      
      public function SetBitmapData (bitmapData:BitmapData):void
      {
         mBitmap = new Bitmap (bitmapData);
         
         upState = mBitmap;
         hitTestState = mBitmap;
         overState = mBitmap;
         downState = mBitmap;
         
      }
      
      private function OnButtonClick( event:MouseEvent ):void 
      {
         if (mOnClikFunc != null)
            mOnClikFunc (mUserData);
      }
      
      public function SetUserData (userData:Object):void
      {
         mUserData = userData;
      }
      
      public function GetUserData ():Object
      {
         return mUserData;
      }
   }
   
}
   