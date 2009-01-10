package com.tapirgames.display {
   
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.SimpleButton;
   import flash.display.Shape;
   
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   import flash.events.MouseEvent;

   

   
   public class IconButton extends SimpleButton 
   {
      private var mOnClikFunc:Function;
      
      private var mUserData:Object;
      
      public function IconButton (onClick:Function, icon:Bitmap, overIcon:Bitmap = null, userData:Object = null)
      {
         addEventListener( MouseEvent.CLICK, OnButtonClick );
         
         mOnClikFunc = onClick;
         
         SetIcons (icon, overIcon);
         
         SetUserData (userData);
      }
      
      public function SetIcons (icon:Bitmap, overIcon:Bitmap = null):void
      {
         upState = icon;
         hitTestState = icon;
         overState = overIcon == null ? icon : overIcon;
         downState = overIcon == null ? icon : overIcon;
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
