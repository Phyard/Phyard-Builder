package common.shape
{
   import com.tapirgames.util.TextUtil;

   import common.Define;

   public class VectorShapeText extends VectorShapeRectangle
   {
      protected var mText:String = "(not set yet)";
      private var mFlags1:int = TextUtil.TextFlag_WordWrap; // from v2.04
      
        // private var mWordWrap:Boolean = true;
        // 
        // // from v2.04
        // private var mEditable:Boolean = false;
        // private var mSelectable:Boolean = false;
        // private var mTextFormat:int = TextUtil.TextFormat_Plain;
      
      private var mFlags2:int = 0; // from v2.04
         
         //private var mAdaptiveBackgroundSize:Boolean = false;
         //
         // // from v2.04
         // private var mClipText:Boolean = false;

      // from v1.07
      protected var mTextColor:uint = 0x000000;
      protected var mFontSize:uint = 10;
      protected var mIsBold:Boolean = false;
      protected var mIsItalic:Boolean = false;

      // from v1.09
      protected var mIsUnderlined:Boolean = false;
      protected var mTextAlign:int = TextUtil.TextAlign_Left | TextUtil.TextAlign_Middle;

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
      
      public function GetFlags1 ():int
      {
         return mFlags1;
      }
      
      public function SetFlags1 (flags1:int):void
      {
         mFlags1 = flags1;
      }
      
            public function IsWordWrap ():Boolean
            {
               //return mWordWrap;
               return (mFlags1 & TextUtil.TextFlag_WordWrap) == TextUtil.TextFlag_WordWrap;
            }
            
            public function SetWordWrap (wrap:Boolean):void
            {
               //mWordWrap = wrap;
               if (wrap)
                  mFlags1 |= TextUtil.TextFlag_WordWrap;
               else
                  mFlags1 &= ~TextUtil.TextFlag_WordWrap;
            }
            
            public function IsEditable ():Boolean
            {
               //return mEditable;
               return (mFlags1 & TextUtil.TextFlag_Editable) == TextUtil.TextFlag_Editable;
            }
            
            public function SetEditable (editable:Boolean):void
            {
               //mEditable = editable;
               if (editable)
                  mFlags1 |= TextUtil.TextFlag_Editable;
               else
                  mFlags1 &= ~TextUtil.TextFlag_Editable;
            }
            
            public function IsSelectable ():Boolean
            {
               //return mSelectable;
               return (mFlags1 & TextUtil.TextFlag_Selectable) == TextUtil.TextFlag_Selectable;
            }
            
            public function SetSelectable (selectable:Boolean):void
            {
               //mSelectable = selectable;
               if (selectable)
                  mFlags1 |= TextUtil.TextFlag_Selectable;
               else
                  mFlags1 &= ~TextUtil.TextFlag_Selectable;
            }
            
            public function IsDontAllowCreatedAsBitmap ():Boolean
            {
               //return mSelectable;
               return (mFlags1 & TextUtil.TextFlag_DontAllowCreatedAsBitmap) == TextUtil.TextFlag_DontAllowCreatedAsBitmap;
            }
            
            public function SetDontAllowCreatedAsBitmap (dontAllow:Boolean):void
            {
               if (dontAllow)
                  mFlags1 |= TextUtil.TextFlag_DontAllowCreatedAsBitmap;
               else
                  mFlags1 &= ~TextUtil.TextFlag_DontAllowCreatedAsBitmap;
            }
            
            public function GetTextFormat ():int
            {
               return (mFlags1 & TextUtil.Mask_TextFormat) >> TextUtil.Shift_TextFormat;
            }
            
            public function SetTextFormat (format:int):void
            {
               mFlags1 = (mFlags1 & ~TextUtil.Mask_TextFormat) | ((format << TextUtil.Shift_TextFormat) & TextUtil.Mask_TextFormat);
            }
      
      public function GetFlags2 ():int
      {
         return mFlags2;
      }
      
      public function SetFlags2 (flags2:int):void
      {
         mFlags2 = flags2;
      }
      
            public function IsAdaptiveBackgroundSize ():Boolean
            {
               //return mAdaptiveBackgroundSize;
               return (mFlags2 & TextUtil.TextFlag_AdaptiveBackgroundSize) == TextUtil.TextFlag_AdaptiveBackgroundSize;
            }
            
            public function SetAdaptiveBackgroundSize (adapt:Boolean):void
            {
               //mAdaptiveBackgroundSize = adapt;
               if (adapt)
                  mFlags2 |= TextUtil.TextFlag_AdaptiveBackgroundSize;
               else
                  mFlags2 &= ~TextUtil.TextFlag_AdaptiveBackgroundSize;
            }
      
            public function IsClipText ():Boolean
            {
               return (mFlags2 & TextUtil.TextFlag_ClipText) == TextUtil.TextFlag_ClipText;
            }
            
            public function SetClipText (clip:Boolean):void
            {
               if (clip)
                  mFlags2 |= TextUtil.TextFlag_ClipText;
               else
                  mFlags2 &= ~TextUtil.TextFlag_ClipText;
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
   }
}
