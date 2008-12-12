
package com.tapirgames.display {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   import flash.events.Event;
   
   public class Dialog extends Sprite 
   {
      private var mInfoObject:DisplayObject;
      
      private var mShowCloseButton:Boolean;
      private var mShowConfirmButton:Boolean;
      
      private var mOnCloseFunc : Function;
      private var mOnConfirmFunc : Function;
      
      public function Dialog (infoObject:DisplayObject, showClose:Boolean = true, showConfirm:Boolean = false, onClose:Function = null, onConfirm:Function = null)
      {
         mInfoObject = infoObject;
         
         mShowCloseButton = showClose;
         mShowConfirmButton = showConfirm;
         
         mOnCloseFunc = onClose == null ? OnCloseDefault : onClose;
         mOnConfirmFunc = onConfirm;
      }
      
      protected var mBorderMarginX:Number = 30;
      protected var mBorderMarginY:Number = 10;
      private var mButtonMarginX:Number = 10;
      private var mButtonMarginY:Number = 10;
      
      /*
      // border
      private var mBorderVisible:Boolean = true;
      private var mBorderColor:int = 0x0;
      private var mBorderThickness:int = 1;
      
      public function get border ():Boolean {
         return mBorderVisible;
      }
      
      public function set border (b:Boolean):void {
         mBorderVisible = b;
      }
      
      public function get borderColor ():int {
         return mBorderColor;
      }
      
      public function set borderColor (c:int):void {
         mBorderColor = c;
      }
      
      public function get borderThickness ():int {
         return mBorderThickness;
      }
      
      public function set borderThickness (t:int):void {
         mBorderThickness = t;
      }
      */
      
      private var mCloseButton:TextButton;
      private var mConfirmButton:TextButton;
      
      public function Rebuild ():void
      {
         var maxBottonHeight:Number = 0;
         var numButtons:uint = 0;
         var sumBottonWidth:Number = 0;
         
         if (mShowConfirmButton && mConfirmButton == null)
         {
            mConfirmButton = new TextButton ("Ok", mOnConfirmFunc);
            maxBottonHeight = mConfirmButton.height > maxBottonHeight ? mConfirmButton.height : maxBottonHeight;
            sumBottonWidth += mConfirmButton.width;
            ++ numButtons;
         }
         
         if (mShowCloseButton && mCloseButton == null)
         {
            mCloseButton = new TextButton ("Close", mOnCloseFunc);
            maxBottonHeight = mCloseButton.height > maxBottonHeight ? mCloseButton.height : maxBottonHeight;
            sumBottonWidth += mCloseButton.width;
            ++ numButtons;
         }
         
         var dialogWidth:Number = mBorderMarginX + mBorderMarginX;
         if (numButtons > 0)
         {
            var minButtonRowWidth:Number = sumBottonWidth + (numButtons + 1) * mButtonMarginX;
            if (mInfoObject != null && mInfoObject.width > minButtonRowWidth)
               dialogWidth += mInfoObject.width;
            else
               dialogWidth += minButtonRowWidth;
         }
         else if (mInfoObject != null)
            dialogWidth += mInfoObject.width;
         
         var dialogHeight:Number = mBorderMarginY + mBorderMarginY;
         if (numButtons > 0)
         {
            if (mInfoObject != null)
               dialogHeight += maxBottonHeight + mInfoObject.height + mButtonMarginY;
            else
               dialogHeight += maxBottonHeight;
         }
         else if (mInfoObject != null)
            dialogHeight += mInfoObject.height;
            
         // background
         graphics.clear ();
         graphics.beginFill(0x808000);
         graphics.lineStyle(1, 0x0);
         graphics.drawRoundRect(0, 0, dialogWidth, dialogHeight, 8);
         graphics.endFill();
         
         // 
         if (mInfoObject != null)
         {
            addChild (mInfoObject);
            
            mInfoObject.x = (dialogWidth - mInfoObject.width) / 2;
            mInfoObject.y = mButtonMarginY;
         }
         
         //
         if (numButtons > 0)
         {
            var buttonMarginX:Number = (dialogWidth - sumBottonWidth - mBorderMarginX - mBorderMarginX) / (numButtons + 1);
            
            var buttonX:Number = mBorderMarginX + buttonMarginX;
            var buttonY:Number = dialogHeight - mBorderMarginY - maxBottonHeight / 2;
            
            if (mShowConfirmButton)
            {
               addChild (mConfirmButton);
               
               mConfirmButton.y = buttonY - mConfirmButton.height / 2;
               mConfirmButton.x = buttonX;
               buttonX += mConfirmButton.width + buttonMarginX;
            }
            
            if (mShowCloseButton)
            {
               addChild (mCloseButton);
               
               mCloseButton.y = buttonY - mCloseButton.height / 2;
               mCloseButton.x = buttonX;
               buttonX += mCloseButton.width + buttonMarginX;
            }
         }
         
      }
      
      
      
      private function OnCloseDefault ():void
      {
         visible = false;
      }
   }
}
