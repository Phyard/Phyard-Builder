package common.shape
{
   import com.tapirgames.util.TextUtil;

   import common.Define;

   public class VectorShapeText extends VectorShapeRectangle
   {
      protected var mText:String = "(not set yet)";
      protected var mWordWrap:Boolean = true;

      // from v1.07
      protected var mTextColor:uint = 0x000000;
      protected var mFontSize:uint = 10;
      protected var mIsBold:Boolean = false;
      protected var mIsItalic:Boolean = false;

      // from v1.09
      protected var mIsUnderlined:Boolean = false;
      protected var mTextAlign:int = TextUtil.TextAlign_Left;

      protected var mAdaptiveBackgroundSize:Boolean = false;

      //.......

      public function VectorShapeText ()
      {
         SetHalfWidth (50);
         SetHalfHeight (25);
      }

      public function GetText ():String
      {
         return mText;
      }

      public function SetText (text:String):void
      {
         if (text == null)
            text = "";

         //if (text.length > Define.MaxTextLength)
         //   text = text.substr (0, Define.MaxTextLength);

         mText = text;
      }

      public function IsWordWrap ():Boolean
      {
         return mWordWrap;
      }

      public function SetWordWrap (auto:Boolean):void
      {
         mWordWrap = auto;
      }

      public function GetTextColor ():uint
      {
         return mTextColor;
      }

      public function SetTextColor (color:uint):void
      {
         mTextColor = color;
      }

      public function GetFontSize ():uint
      {
         return mFontSize;
      }

      public function SetFontSize (size:uint):void
      {
         mFontSize = size;
      }

      public function IsBold ():Boolean
      {
         return mIsBold;
      }

      public function SetBold (bold:Boolean):void
      {
         mIsBold = bold;
      }

      public function IsItalic ():Boolean
      {
         return mIsItalic;
      }

      public function SetItalic (italic:Boolean):void
      {
         mIsItalic = italic;
      }

      public function IsUnderlined ():Boolean
      {
         return mIsUnderlined;
      }

      public function SetUnderlined (underlined:Boolean):void
      {
         mIsUnderlined = underlined;
      }

      public function GetTextAlign ():int
      {
         return mTextAlign;
      }

      public function SetTextAlign (align:int):void
      {
         mTextAlign = align;
      }

      public function IsAdaptiveBackgroundSize ():Boolean
      {
         return mAdaptiveBackgroundSize;
      }

      public function SetAdaptiveBackgroundSize (adapt:Boolean):void
      {
         mAdaptiveBackgroundSize = adapt;
      }
   }
}
