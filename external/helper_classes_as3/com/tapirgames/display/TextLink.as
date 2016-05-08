
package com.tapirgames.display {
   
   import flash.display.DisplayObject;
   import flash.display.SimpleButton;
   
   import flash.display.Sprite;
   
   import flash.events.MouseEvent;
   
   import com.tapirgames.util.TextUtil;
   
   // !!! use TextUtil.CreatHtmlText_Link instead
   
   public class TextLink extends SimpleButton 
   {
      private var mText:String;
      private var mOnClikFunc:Function;
      private var mIslink:Boolean;
      
      private var mTextColor:String;
      
      public function TextLink (text:String = "", onClick:Function = null, textColor:String="#FFFF00")
      {
         useHandCursor = false;
         
         mText = text;
         mOnClikFunc = onClick;
         
         mTextColor = textColor
         
         Build ();
         
         if (OnButtonClick != null)
         {
            addEventListener( MouseEvent.CLICK, OnButtonClick );
            
            useHandCursor = true;
         }
      }
      
      private function OnButtonClick( event:MouseEvent ):void 
      {
         if (mOnClikFunc != null)
            mOnClikFunc ();
      }
      
      private function Build ():void
      {
         upState = //TextFieldEx.CreateTextField ( TextUtil.CreateHtmlText (mText, 12, mTextColor, "Times New Roman", false, false, false) );
         overState = TextFieldEx.CreateTextField ( TextUtil.CreateHtmlText (mText, 12, mTextColor, "Times New Roman", false, false, true) );
         
         hitTestState = upState;
         downState = overState;
      }
   }
}