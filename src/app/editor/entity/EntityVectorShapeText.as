
package editor.entity {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.image.AssetImageBitmapModule;
   
   import common.Define;
   
   public class EntityVectorShapeText extends EntityVectorShapeRectangle 
   {
      private var mText:String;
      private var mWordWrap:Boolean = true;
      
      // from v1.07
      private var mTextColor:uint = 0x000000;
      private var mFontSize:uint = 10;
      private var mIsBold:Boolean = false;
      private var mIsItalic:Boolean = false;
      
      // from v1.09
      private var mIsUnderlined:Boolean = false;
      private var mTextAlign:int = TextUtil.TextAlign_Left | TextUtil.TextAlign_Middle;
      
      private var mAdaptiveBackgroundSize:Boolean = false;
      
      //
      protected var mTextLayer:Sprite = new Sprite ();
      protected var mTextSprite:DisplayObject = null;
      
      public function EntityVectorShapeText (container:Scene)
      {
         super (container);
         
         SetHalfWidth (50);
         SetHalfHeight (15);
         SetText ("(not set yet)");
         SetDrawBorder (false);
         SetDrawBackground (false);
         SetFilledColor (0xFFFFFF);
         
         addChild (mTextLayer);
      }
      
      override public function IsBasicVectorShapeEntity ():Boolean
      {
         return false;
      }

      override public function IsPhysicsCapableShapeEntity ():Boolean
      {
         return false;
      }
      
      override public function GetTypeName ():String
      {
         return "Text";
      }
      
      override public function GetPhysicsShapesCount ():uint
      {
         return 0;
      }
      
      override public function AreControlPointsEnabled ():Boolean
      {
         return ! IsAdaptiveBackgroundSize () || IsWordWrap ();
      }
      
      override public function SetBodyTextureModule (bitmapModule:AssetImageBitmapModule):Boolean
      {
         return super.SetBodyTextureModule (null);
      }
      
      override public function UpdateAppearance ():void
      {
         if (mTextSprite != null)
            mTextLayer.removeChild (mTextSprite);
         
         RebuildTextSprite ();
         
         AdjustBackgroundSize ();
         
         super.UpdateAppearance ();
         
         addChild (mTextLayer);
         
         // ...
         
         var halfWidth :Number = GetHalfWidth  ();
         var halfHeight:Number = GetHalfHeight ();
         var halfBorderThickness:Number = 0.5 * GetBorderThickness ();
         
         var hAlign:int = mTextAlign & 0x0F;
         if (hAlign == TextUtil.TextAlign_Left || hAlign == TextUtil.TextAlign_Right)
         {  
            if (hAlign == TextUtil.TextAlign_Left)
               mTextSprite.x = - halfWidth + 5 + halfBorderThickness;
            else
               mTextSprite.x = halfWidth - 5 - halfBorderThickness - mTextSprite.width;
         }
         else
         {
            mTextSprite.x = - 0.5 * mTextSprite.width;
         }
         
         var vAlign:int = mTextAlign & 0xF0;
         if (vAlign == TextUtil.TextAlign_Top || vAlign == TextUtil.TextAlign_Bottom)
         {
            if (vAlign == TextUtil.TextAlign_Top)
               mTextSprite.y = - halfHeight + 5 + halfBorderThickness;
            else
               mTextSprite.y = halfHeight - 5 - halfBorderThickness - mTextSprite.height;
         }
         else
         {
            mTextSprite.y = - 0.5 * mTextSprite.height;
         }
         
         // ...
         
         mTextLayer.addChild (mTextSprite);
      }
      
      protected function AdjustBackgroundSize ():void
      {
         if (IsAdaptiveBackgroundSize ())
         {
            if (! IsWordWrap ())
               SetHalfWidth  (0.5 * mTextSprite.width + 5);
            
            SetHalfHeight (0.5 * mTextSprite.height + 5);
         }
      }
      
      // use TextUtil.GetHtmlWikiText now
      //protected function GetDisplayText ():String
      //{
      //   var infoText:String = mText;
      //   
      //   if (infoText == null)
      //      return "";
      //   
      //   infoText = TextUtil.GetHtmlEscapedText (infoText);
      //   infoText = TextUtil.ParseWikiString (infoText);
      //   
      //   if (mIsBold)
      //      infoText = "<b>" + infoText + "</b>";
      //   if (mIsItalic)
      //      infoText = "<i>" + infoText + "</i>";
      //   if (mIsUnderlined)
      //      infoText = "<u>" + infoText + "</u>";
      //   
      //   return "<p align='" + Define.GetTextAlignText (mTextAlign & 0x0F) + "'><font face='Verdana' size='" + mFontSize + "'>" + infoText + "</font></p>";
      //}
      
      //protected function RebuildTextSprite ():void
      //{
      //   var displayText:String = TextUtil.GetHtmlWikiText (GetText (), TextUtil.GetTextAlignText (mTextAlign & 0x0F), mFontSize, TextUtil.Uint2ColorString (mTextColor), null, mIsBold, mIsItalic, mIsUnderlined);
      //   
      //   var textField:TextFieldEx;
      //   
      //   if (mWordWrap && (! mAdaptiveBackgroundSize))
      //      textField = TextFieldEx.CreateTextField (displayText, false, 0xFFFFFF, mTextColor, true, GetHalfWidth () * 2 - 10 - GetBorderThickness ());
      //   else
      //      textField = TextFieldEx.CreateTextField (displayText, false, 0xFFFFFF, mTextColor);
      //      
      //   if (GetRotation () == 0)
      //      mTextSprite = textField;
      //   else
      //   {
      //      var textBitmap:Bitmap = DisplayObjectUtil.CreateCacheDisplayObject (textField);
      //      mTextSprite = textBitmap;
      //   }
      //   
      //   mTextSprite.x = - mTextSprite.width * 0.5;
      //   mTextSprite.y = - mTextSprite.height * 0.5;
      //}
      
      protected function RebuildTextSprite ():void
      {
         var displayText:String = TextUtil.GetHtmlWikiText (GetText (), TextUtil.GetTextAlignText (mTextAlign & 0x0F), mFontSize, TextUtil.Uint2ColorString (mTextColor), null, mIsBold, mIsItalic, mIsUnderlined);
         
         var textField:TextFieldEx;
         
         if (mWordWrap)
            textField = TextFieldEx.CreateTextField (displayText, false, 0xFFFFFF, mTextColor, true, GetHalfWidth () * 2 - 10 - GetBorderThickness ());
         else
            textField = TextFieldEx.CreateTextField (displayText, false, 0xFFFFFF, mTextColor);
            
         if (GetRotation () == 0)
            mTextSprite = textField;
         else
         {
            var textBitmap:Bitmap = DisplayObjectUtil.CreateCacheDisplayObject (textField);
            mTextSprite = textBitmap;
         }
         
         mTextSprite.x = - mTextSprite.width * 0.5;
         mTextSprite.y = - mTextSprite.height * 0.5;
      }
      
      public function GetText ():String
      {
         return mText == null ? "" : mText;
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
         
         if (mAdaptiveBackgroundSize)
         {
            if (IsSelected ())
            {
               SetControlPointsVisible (true);
            }
         }
         else
         {
            SetControlPointsVisible (false);
         }
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityVectorShapeText (mEntityContainer);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var text:EntityVectorShapeText = entity as EntityVectorShapeText;
         text.SetText ( GetText () );
         text.SetWordWrap (IsWordWrap ());
         text.SetTextColor (GetTextColor ());
         text.SetFontSize (GetFontSize ());
         text.SetBold (IsBold ());
         text.SetItalic (IsItalic ());
         text.SetAdaptiveBackgroundSize (IsAdaptiveBackgroundSize ());
         text.SetTextAlign (GetTextAlign ());
         text.SetUnderlined (IsUnderlined ());
      }
      
   }
}
