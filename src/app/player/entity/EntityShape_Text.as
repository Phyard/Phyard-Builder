
package player.entity {
   
   import flash.display.Bitmap;
   
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
         
         mAppearanceObjectsContainer.addChild (mTextBitmap);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mText != undefined)
               SetText (entityDefine.mText);
            if (entityDefine.mWordWrap != undefined)
               SetWordWrap (entityDefine.mWordWrap);
            if (entityDefine.mTextColor != undefined)
               SetTextColor (entityDefine.mTextColor);
            if (entityDefine.mFontSize != undefined)
               SetFontSize (entityDefine.mFontSize);
            if (entityDefine.mIsBold != undefined)
               SetBold (entityDefine.mIsBold);
            if (entityDefine.mIsItalic != undefined)
               SetItalic (entityDefine.mIsItalic);
            if (entityDefine.mAdaptiveBackgroundSize != undefined)
               SetAdaptiveBackgroundSize (entityDefine.mAdaptiveBackgroundSize);
            
            // force 50
            SetTransparency (50);
         }
      }
      
//=============================================================
//   
//=============================================================
      
      private var mText:String = "";
      private var mAdaptiveBackgroundSize:Boolean = false;
      private var mWordWrap:Boolean = true;
      private var mTextColor:uint = 0x000000;
      private var mFontSize:uint = 10;
      private var mIsBold:Boolean = false;
      private var mIsItalic:Boolean = false;
      
      public function GetText ():String
      {
         return mText;
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
      
      public function SetWordWrap (auto:Boolean):void
      {
         if (mWordWrap != auto)
         {
            mWordWrap = auto;
            
            mNeedRebuildAppearanceObjects = true;
            DelayUpdateAppearance ();
         }
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
      
      public function IsAdaptiveBackgroundSize ():Boolean
      {
         return mAdaptiveBackgroundSize;
      }
      
      public function SetAdaptiveBackgroundSize (adapt:Boolean):void
      {
         mAdaptiveBackgroundSize = adapt;
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
      
      protected var mTextBitmap:Bitmap = new Bitmap ();
      protected var mNeedRebuildTextSprite:Boolean = false;
      
      override public function UpdateAppearance ():void
      {
         if (mNeedRebuildTextSprite)
         {
            mNeedRebuildTextSprite = false;
            
            RebuildTextBitmap ();
         }
         
         AdjustBackgroundSize ();
         
         super.UpdateAppearance ();
      }
      
      protected function AdjustBackgroundSize ():void
      {
         if (IsAdaptiveBackgroundSize ())
         {
            SetHalfWidth  (mWorld.GetCoordinateSystem ().D2P_Length (0.5 * mTextBitmap.width + 5));
            SetHalfHeight (mWorld.GetCoordinateSystem ().D2P_Length (0.5 * mTextBitmap.height + 5));
            
            mNeedRebuildAppearanceObjects = true;
         }
      }
      
      protected function RebuildTextBitmap ():void
      {
         var displayHalfWidth :Number = mWorld.GetCoordinateSystem ().P2D_Length (mHalfWidth);
         //var displayHalfHeight:Number = mWorld.GetCoordinateSystem ().P2D_Length (mHalfHeight);
         var displayBorderThickness:Number = mWorld.GetCoordinateSystem ().P2D_Length (mBorderThickness);
         
         var infoText:String = GetDisplayText ();
         
         if (infoText == null)
         {
            mTextBitmap.bitmapData = null;
         }
         else
         {
            var textFiled:TextFieldEx;
            if (mWordWrap && (! mAdaptiveBackgroundSize))
               textFiled = TextFieldEx.CreateTextField (infoText, false, 0xFFFFFF, mTextColor, true, displayHalfWidth * 2 - 10 - displayBorderThickness);
            else
               textFiled = TextFieldEx.CreateTextField (infoText, false, 0xFFFFFF, mTextColor);
            
            DisplayObjectUtil.CreateCacheDisplayObjectInBitmap (textFiled, mTextBitmap);
         }
         
         mTextBitmap.x = - 0.5 * mTextBitmap.width;
         mTextBitmap.y = - 0.5 * mTextBitmap.height;
      }
      
      protected function GetDisplayText ():String
      {
         var infoText:String = mText;
         
         if (infoText == null)
            return null;
         
         infoText = TextUtil.GetHtmlEscapedText (infoText);
         infoText = TextUtil.ParseWikiString (infoText);
         
         if (mIsBold)
            infoText = "<b>" + infoText + "</b>";
         if (mIsItalic)
            infoText = "<i>" + infoText + "</i>";
         
         return "<font face='Verdana' size='" + mFontSize + "'>" + infoText + "</font>";
      }
   }
   
}
