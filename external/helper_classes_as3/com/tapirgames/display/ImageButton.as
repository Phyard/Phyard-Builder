package com.tapirgames.display {
   
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.SimpleButton;
   import flash.display.Shape;
   
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ImageButton extends SimpleButton 
   {
      private var mBitmap:Bitmap;
      private var mOnClikFunc:Function;
      private var mUserData:Object;
      
      public function ImageButton (bitmapData:BitmapData, userData:Object = null)
      {
         SetClickEventHandler (null);
         
         SetBitmapData (bitmapData);
         
         SetUserData (userData);
         
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
      }
      
      private function OnAddedToStage (event:Event):void 
      {
         addEventListener (Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
         addEventListener( MouseEvent.CLICK, OnButtonClick );
      }
      
      private function OnRemovedFromStage (event:Event):void 
      {
         removeEventListener( MouseEvent.CLICK, OnButtonClick );
         removeEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         removeEventListener (Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
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
   