
package player.entity {

   import flash.display.DisplayObject;
   import flash.display.Bitmap;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFieldAutoSize;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import player.world.World;
   
   import common.Define;
   
   public class EntityShape_Text extends EntityShapeRectangle
   {
      public function EntityShape_Text (world:World)
      {
         super (world);
         
         mAiTypeChangeable = false;
         
         //mAppearanceObjectsContainer.addChild (mTextBitmap);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object, extraInfos:Object):void
      {
         super.Create (createStageId, entityDefine, extraInfos);
         
         if (createStageId == 0)
         {
            if (entityDefine.mText != undefined)
               SetText (entityDefine.mText);
            if (entityDefine.mFlags1 != undefined)
               SetFlags1 (entityDefine.mFlags1);
               //if (entityDefine.mWordWrap != undefined)
               //   SetWordWrap (entityDefine.mWordWrap);
            if (entityDefine.mFlags2 != undefined)
               SetFlags2 (entityDefine.mFlags2);
               //if (entityDefine.mAdaptiveBackgroundSize != undefined)
               //   SetAdaptiveBackgroundSize (entityDefine.mAdaptiveBackgroundSize);
            if (entityDefine.mEditable != undefined)
               SetEditable (entityDefine.mEditable);
            if (entityDefine.mSelectable != undefined)
               SetSelectable (entityDefine.mSelectable);
            if (entityDefine.mIsHtmlText != undefined)
               SetIsHtmlText (entityDefine.mIsHtmlText);
            if (entityDefine.mTextColor != undefined)
               SetTextColor (entityDefine.mTextColor);
            if (entityDefine.mFontSize != undefined)
               SetFontSize (entityDefine.mFontSize);
            if (entityDefine.mIsBold != undefined)
               SetBold (entityDefine.mIsBold);
            if (entityDefine.mIsItalic != undefined)
               SetItalic (entityDefine.mIsItalic);
            if (entityDefine.mTextAlign != undefined)
               SetTextAlign (entityDefine.mTextAlign);
            if (entityDefine.mIsUnderlined != undefined)
               SetUnderlined (entityDefine.mIsUnderlined);
            
            // commected off from r128. ? why force 50?!
            // force 50
            //SetTransparency (50);
         }
      }
       
      override public function ToEntityDefine (entityDefine:Object):Object
      {
         super.ToEntityDefine (entityDefine);
         
         entityDefine.mText = GetText ();
         entityDefine.mFlags1 = mFlags1;
            //entityDefine.mWordWrap = mWordWrap;
            //entityDefine.mEditable = mEditable;
            //entityDefine.mSelectable = mSelectable;
            //entityDefine.mIsHtmlText = mIsHtmlText;
         entityDefine.mFlags2 = mFlags2;
            //entityDefine.mAdaptiveBackgroundSize = IsAdaptiveBackgroundSize ();
         entityDefine.mTextColor = GetTextColor ();
         entityDefine.mFontSize = GetFontSize ();
         entityDefine.mIsBold = IsBold ();
         entityDefine.mIsItalic = IsItalic ();
         entityDefine.mTextAlign = GetTextAlign ();
         entityDefine.mIsUnderlined = IsUnderlined ();
         
         entityDefine.mEntityType = Define.EntityType_ShapeText;
         
         return entityDefine;
      }
      
//=============================================================
//   
//=============================================================
      
      private var mText:String = "";
      
      private var mFlags1:int = TextUtil.TextFlag_WordWrap; // from v2.04
      
        // private var mWordWrap:Boolean = true;
        // 
        // // from v2.04
        // private var mEditable:Boolean = false;
        // private var mSelectable:Boolean = false;
        // private var mIsHtmlText:Boolean = false;
      
      private var mFlags2:int = 0; // from v2.04
         
         //private var mAdaptiveBackgroundSize:Boolean = false;
         //
         // // from v2.04
         // private var mClipText:Boolean = false;
      
      private var mTextColor:uint = 0x000000;
      private var mFontSize:uint = 10;
      private var mIsBold:Boolean = false;
      private var mIsItalic:Boolean = false;
      private var mIsUnderlined:Boolean = false;
      protected var mTextAlign:int = TextUtil.TextAlign_Left | TextUtil.TextAlign_Middle;
      
      public function GetText ():String
      {
         return mText == null ? "" : mText;
      }
      
      public function SetText (text:String):void
      {
         if (text == null)
            text = "";
         
         if (mText != text)
         {
            mText = text;
            
            mNeedRebuildTextSprite = true;
            DelayUpdateAppearance ();
         }
      }
      
      public function GetFlags1 ():int
      {
         return mFlags1;
      }
      
      public function SetFlags1 (flags1:int):void
      {
         mFlags1 = flags1;
         
         // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
         DelayUpdateAppearance ();
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
               
               // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
               DelayUpdateAppearance ();
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
               
               // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
               DelayUpdateAppearance ();
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
               
               // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
               DelayUpdateAppearance ();
            }
            
            public function IsHtmlText ():Boolean
            {
               //return mIsHtmlText;
               return (mFlags1 & TextUtil.TextFlag_IsHtmlText) == TextUtil.TextFlag_IsHtmlText;
            }
            
            public function SetIsHtmlText (isHtmlText:Boolean):void
            {
               //mIsHtmlText = isHtmlText;
               if (isHtmlText)
                  mFlags1 |= TextUtil.TextFlag_IsHtmlText;
               else
                  mFlags1 &= ~TextUtil.TextFlag_IsHtmlText;
               
               // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
               DelayUpdateAppearance ();
            }
      
      public function GetFlags2 ():int
      {
         return mFlags2;
      }
      
      public function SetFlags2 (flags2:int):void
      {
         mFlags2 = flags2;
         
         // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
         DelayUpdateAppearance ();
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
               
               mNeedRebuildTextSprite = true;
               // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
               DelayUpdateAppearance ();
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
               
               mNeedRebuildTextSprite = true;
               // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
               DelayUpdateAppearance ();
            }
      
      public function GetTextColor ():uint
      {
         return mTextColor;
      }
      
      public function SetTextColor (color:uint):void
      {
         mTextColor = color;
         
         mNeedRebuildTextSprite = true;
         // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
         DelayUpdateAppearance ();
      }
      
      public function GetFontSize ():uint
      {
         return mFontSize;
      }
      
      public function SetFontSize (size:uint):void
      {
         mFontSize = size;
         
         mNeedRebuildTextSprite = true;
         // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
         DelayUpdateAppearance ();
      }
      
      public function IsBold ():Boolean
      {
         return mIsBold;
      }
      
      public function SetBold (bold:Boolean):void
      {
         mIsBold = bold;
         
         mNeedRebuildTextSprite = true;
         // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
         DelayUpdateAppearance ();
      }
      
      public function IsItalic ():Boolean
      {
         return mIsItalic;
      }
      
      public function SetItalic (italic:Boolean):void
      {
         mIsItalic = italic;
         
         mNeedRebuildTextSprite = true;
         // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
         DelayUpdateAppearance ();
      }
      
      public function IsUnderlined ():Boolean
      {
         return mIsUnderlined;
      }
      
      public function SetUnderlined (underlined:Boolean):void
      {
         mIsUnderlined = underlined;
         
         mNeedRebuildTextSprite = true;
         // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
         DelayUpdateAppearance ();
      }
      
      public function GetTextAlign ():int
      {
         return mTextAlign;
      }
      
      public function SetTextAlign (align:int):void
      {
         mTextAlign = align;
         
         mNeedRebuildTextSprite = true;
         // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
         DelayUpdateAppearance ();
      }
      
//=============================================================
//   update
//=============================================================
      
      override protected function UpdateInternal (dt:Number):void
      {
      }
      
//=============================================================
//   appearance
//=============================================================

      // one and only one of the two will be shown      
      protected var mTextField:TextField;
      protected var mTextBitmap:Bitmap = new Bitmap ();
      
      protected var mNeedRebuildTextSprite:Boolean = false;
      
      override public function UpdateAppearance ():void
      {
         PreUpdateTextAppearance ();
         
         if (mNeedRebuildTextSprite)
         {
            mNeedRebuildTextSprite = false;
            
            RebuildTextBitmap ();
         }
         
         
         var oldHalfWidth:Number = GetHalfWidth ();
         var oldHalfHeight:Number = GetHalfHeight ();
         
         // 
         AdjustBackgroundSize ();
         
         // no need for text button 
         mNeedRebuildAppearanceObjects = mNeedRebuildAppearanceObjects || oldHalfWidth != GetHalfWidth () || oldHalfHeight != GetHalfHeight ();
         super.UpdateAppearance ();
         
         PostUpdateTextAppearance ();
      }
      
      protected function PreUpdateTextAppearance ():void
      {
         //
         if (mTextBitmap != null && mTextBitmap.parent == mAppearanceObjectsContainer)
            mAppearanceObjectsContainer.removeChild (mTextBitmap);
         if (mTextField != null && mTextField.parent == mAppearanceObjectsContainer)
            mAppearanceObjectsContainer.removeChild (mTextField);
      }
      
      protected function ShouldUseBitmap ():Boolean
      {
         return (! IsEditable ()) && (! IsSelectable ());
      }
      
      protected function PostUpdateTextAppearance ():void
      {  
         var showBitmap:Boolean = ShouldUseBitmap ();

         //
         AlignTextSprite (mTextField,
                    mTextAlign & 0x0F, 
                    mTextAlign & 0xF0,
                    mWorld.GetCoordinateSystem ().P2D_Length (mHalfWidth),
                    mWorld.GetCoordinateSystem ().P2D_Length (mHalfHeight),
                    0.5 * mWorld.GetCoordinateSystem ().P2D_Length (mBorderThickness)
                   );
         mTextField.visible = ! showBitmap; 
         if (mTextField.visible)
         {
            mAppearanceObjectsContainer.mouseChildren = true;
            mAppearanceObjectsContainer.addChild (mTextField);
         }
         
         if (mTextBitmap != null)
         {
            AlignTextSprite (mTextBitmap,
                       mTextAlign & 0x0F, 
                       mTextAlign & 0xF0,
                       mWorld.GetCoordinateSystem ().P2D_Length (mHalfWidth),
                       mWorld.GetCoordinateSystem ().P2D_Length (mHalfHeight),
                       0.5 * mWorld.GetCoordinateSystem ().P2D_Length (mBorderThickness)
                      );
            mTextBitmap.visible = showBitmap;
            if (mTextBitmap.visible)
            {
               mAppearanceObjectsContainer.mouseChildren = true;
               mAppearanceObjectsContainer.addChild (mTextBitmap);
            }
         }
      }
      
      protected function AlignTextSprite (textSprite:DisplayObject, hAlign:int, vAlign:int, displayHalfWidth:Number, displayHalfHeight:Number, halfDisplayBorderThickness:Number):void
      {
         // ...
         
         if (hAlign == TextUtil.TextAlign_Left || hAlign == TextUtil.TextAlign_Right)
         {
            if (hAlign == TextUtil.TextAlign_Left)
               textSprite.x = - displayHalfWidth + TextUtil.TextPadding + halfDisplayBorderThickness;
            else
               textSprite.x = displayHalfWidth - TextUtil.TextPadding - halfDisplayBorderThickness - textSprite.width;
         }
         else
         {
            textSprite.x = - 0.5 * textSprite.width;
         }
         
         if (vAlign == TextUtil.TextAlign_Top || vAlign == TextUtil.TextAlign_Bottom)
         {
            if (vAlign == TextUtil.TextAlign_Top)
               textSprite.y = - displayHalfHeight + TextUtil.TextPadding + halfDisplayBorderThickness;
            else
               textSprite.y = displayHalfHeight - TextUtil.TextPadding - halfDisplayBorderThickness - textSprite.height;
         }
         else
         {
            textSprite.y = - 0.5 * textSprite.height;
         }
      }
      
      protected function ShouldCacheTextAsBitmap ():Boolean
      {
         return false;
      }
      
      protected function AdjustBackgroundSize ():void
      {
         if (IsAdaptiveBackgroundSize ())
         {
            var halfDisplayBorderThickness:Number = 0.5 * mWorld.GetCoordinateSystem ().P2D_Length (mBorderThickness);

            if (! IsWordWrap ())
               SetHalfWidth (mWorld.GetCoordinateSystem ().D2P_Length (0.5 * mTextBitmap.width + TextUtil.TextPadding + halfDisplayBorderThickness));
            
            SetHalfHeight (mWorld.GetCoordinateSystem ().D2P_Length (0.5 * mTextBitmap.height + TextUtil.TextPadding + halfDisplayBorderThickness));
            
            mNeedRebuildAppearanceObjects = true;
         }
      }
      
      //protected function RebuildTextBitmap ():void
      //{
      //   var displayHalfWidth :Number = mWorld.GetCoordinateSystem ().P2D_Length (mHalfWidth);
      //   //var displayHalfHeight:Number = mWorld.GetCoordinateSystem ().P2D_Length (mHalfHeight);
      //   var displayBorderThickness:Number = mWorld.GetCoordinateSystem ().P2D_Length (mBorderThickness);
      //   
      //   var infoText:String = TextUtil.GetHtmlWikiText (GetText (), TextUtil.GetTextAlignText (mTextAlign & 0x0F), mFontSize, TextUtil.Uint2ColorString (mTextColor), null, mIsBold, mIsItalic, mIsUnderlined);
      //   
      //   if (infoText == null)
      //   {
      //      mTextBitmap.bitmapData = null;
      //   }
      //   else
      //   {
      //      var textField:TextFieldEx;
      //      if (mWordWrap && (! mAdaptiveBackgroundSize))
      //         textField = TextFieldEx.CreateTextField (infoText, false, 0xFFFFFF, mTextColor, true, displayHalfWidth * 2 - 10 - displayBorderThickness);
      //      else
      //         textField = TextFieldEx.CreateTextField (infoText, false, 0xFFFFFF, mTextColor);
      //      
      //      DisplayObjectUtil.CreateCacheDisplayObjectInBitmap (textField, mTextBitmap);
      //   }
      //   
      //   mTextBitmap.x = - 0.5 * mTextBitmap.width;
      //   mTextBitmap.y = - 0.5 * mTextBitmap.height;
      //}
      
      protected function RebuildTextBitmap ():void
      {
         var displayHalfWidth :Number = mWorld.GetCoordinateSystem ().P2D_Length (mHalfWidth);
         var displayHalfHeight:Number = mWorld.GetCoordinateSystem ().P2D_Length (mHalfHeight);
         var displayBorderThickness:Number = mWorld.GetCoordinateSystem ().P2D_Length (mBorderThickness);
         
         var infoText:String = TextUtil.GetHtmlWikiText (GetText (), IsHtmlText (), TextUtil.GetTextAlignText (mTextAlign & 0x0F), mFontSize, TextUtil.Uint2ColorString (mTextColor), null, mIsBold, mIsItalic, mIsUnderlined);
         
         if (infoText == null)
         {
            infoText = "";
         }
         
         var fixedWidth:Number = displayHalfWidth * 2  - displayBorderThickness - TextUtil.TextPadding * 2;
         var fixedHeight:Number = displayHalfHeight * 2  - displayBorderThickness - TextUtil.TextPadding * 2;
         
         var textField:TextFieldEx;
         if (IsWordWrap ())
            textField = TextFieldEx.CreateTextField (infoText, false, 0xFFFFFF, mTextColor, true, fixedWidth);
         else
            textField = TextFieldEx.CreateTextField (infoText, false, 0xFFFFFF, mTextColor);
         
         mTextField = textField;
         mTextField.selectable = IsSelectable ();
         mTextField.type = IsEditable () ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
         if (IsClipText ())
         {
            mTextField.autoSize = TextFieldAutoSize.NONE;
            mTextField.width  = fixedWidth;
            mTextField.height = fixedHeight;
         }
         
         if (ShouldUseBitmap ())
         {
            try
            {
               DisplayObjectUtil.CreateCacheDisplayObjectInBitmap (textField, mTextBitmap);
            }
            catch (error:Error)
            {
            }
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
   }
   
}
