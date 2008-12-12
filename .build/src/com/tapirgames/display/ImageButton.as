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
      
      public function ImageButton (bitmapData:BitmapData, onClick:Function = null)
      {
         mOnClikFunc = onClick;
         
         mBitmap = new Bitmap (bitmapData);
         
         upState = mBitmap;
         hitTestState = mBitmap;
         overState = mBitmap;
         downState = mBitmap;
         
         addEventListener( MouseEvent.CLICK, OnButtonClick );            
      }
      
      private function OnButtonClick( event:MouseEvent ):void 
      {
         if (mOnClikFunc != null)
            mOnClikFunc ();
      }
   }
   
}
   