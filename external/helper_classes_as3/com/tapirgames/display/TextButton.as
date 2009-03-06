
package com.tapirgames.display {
   
   import flash.display.DisplayObject;
   import flash.display.SimpleButton;
   
   import flash.display.Sprite;
   
   import flash.events.MouseEvent;
   
   import com.tapirgames.util.TextUtil;   
   
   public class TextButton extends SimpleButton 
   {
      private var mText:String;
      private var mOnClikFunc:Function;
      private var mIslink:Boolean;
      
      private var mEnabled:Boolean;
      
      private var mUpState:DisplayObject;
      private var mOverState:DisplayObject;
      private var mDownState:DisplayObject;
      private var mDisableState:DisplayObject;
      
      private var mSelected:Boolean;
      
      private var mUpBgColor:uint = 0xFFFFCC;
      private var mDownBgColor:uint = 0xCCFFCC;
      
      public function TextButton (text:String = "", onClick:Function = null, upBgColor:uint = 0xFFFFCC, downBgColor:uint = 0xCCFFCC)
      {
         useHandCursor = false;
         
         mText = text;
         mOnClikFunc = onClick;
         
         mUpBgColor = upBgColor;
         mDownBgColor = downBgColor;
         
         Build ();
         
         SetEnabled (true);
      }
      
      public function SetEnabled (enabled:Boolean):void
      {
         mEnabled = enabled;
         
         if (mEnabled)
         {
            upState = mUpState;
            overState = mOverState;
            downState = mDownState;
            
            addEventListener( MouseEvent.CLICK, OnButtonClick ); 
            useHandCursor = true;
         }
         else
         {
            upState = overState = downState = mDisableState;
            
            removeEventListener( MouseEvent.CLICK, OnButtonClick );
            useHandCursor = false;
         }
         
          hitTestState = upState;
      }
      
      public function SetSelected (selected:Boolean):void
      {
         mSelected = selected;
         
         if (mSelected)
         {
            upState = overState = downState = mDownState;
         }
         else
         {
            upState = mUpState;
            overState = mOverState;
            downState = mDownState;
         }
      }
      
      private function OnButtonClick( event:MouseEvent ):void 
      {
         if (mOnClikFunc != null)
            mOnClikFunc ();
      }
      
      private function Build ():void
      {
         var upTextFieldEx:TextFieldEx = new TextFieldEx ();
         var overTextFieldEx:TextFieldEx = new TextFieldEx ();
         var downTextFieldEx:TextFieldEx = new TextFieldEx ();
         var disableTextFieldEx:TextFieldEx = new TextFieldEx ();
         disableTextFieldEx.textColor = 0xA0A0A0;
         
         upTextFieldEx.background = false; upTextFieldEx.htmlText = mText;
         overTextFieldEx.background = false; overTextFieldEx.htmlText = mText;
         downTextFieldEx.background = false; downTextFieldEx.htmlText = mText;
         disableTextFieldEx.background = false; disableTextFieldEx.htmlText = mText;
         
         var marginX:Number = 10;
         var marginY:Number = 2;
         
         var w:Number = upTextFieldEx.width + marginX + marginX;
         var h:Number = upTextFieldEx.height + marginY + marginY;
         
         mUpState = CreateStateSprite   (w, h, /*0xddddff*/ mUpBgColor, upTextFieldEx, marginX, marginY);
         mOverState = CreateStateSprite (w, h, /*0xaaaaff*/ mDownBgColor, overTextFieldEx, marginX, marginY);
         mDownState = CreateStateSprite (w, h, /*0xaaaaff*/ mDownBgColor, downTextFieldEx, marginX, marginY + 1);
         mDisableState = CreateStateSprite (w, h, /*0xddddff*/ 0xFFFFCC, disableTextFieldEx, marginX, marginY);
      }
      
      private function CreateStateSprite (w:Number, h:Number, bgColor:int, textSprite:DisplayObject, textX:Number, textY:Number):DisplayObject
      {
         var sprite:Sprite = new Sprite ();
         sprite.graphics.beginFill(bgColor);
         sprite.graphics.lineStyle(0, 0x0);
         sprite.graphics.drawRoundRect(0, 0, w, h, 0);
         sprite.graphics.endFill();
         
         sprite.addChild (textSprite);
         textSprite.x = textX;
         textSprite.y = textY;
         
         return sprite;
      }
   }
}