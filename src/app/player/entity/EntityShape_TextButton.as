
package player.entity {
   
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.display.SimpleButton;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import player.world.World;
   
   import common.Define;
   
   public class EntityShape_TextButton extends EntityShape_Text
   {
      public function EntityShape_TextButton (world:World)
      {
         super (world);
         
         SetWordWrap (false);
         SetAdaptiveBackgroundSize (true);
         SetFontSize (12);
         
         SetDrawBorder (true);
         SetDrawBackground (true);
         
         SetFilledColor (Define.ColorTextButtonBackground);
         SetBorderColor (Define.ColorTextButtonBorder);
         SetBorderThickness (2);
         SetTextColor (Define.ColorTextButtonText);
         SetTextAlign (TextUtil.TextAlign_Center | TextUtil.TextAlign_Middle);
         
         mAppearanceObjectsContainer.removeChild (mBackgroundShape); // added in rect
         mAppearanceObjectsContainer.removeChild (mBorderShape); // added in rect
         //mAppearanceObjectsContainer.removeChild (mTextBitmap); // added in text
         mAppearanceObjectsContainer.addChild (mSimpleButton);
         
         mNormalSprite.addChild (mBackgroundShape);
         mNormalSprite.addChild (mBorderShape);
         mNormalSprite.addChild (mTextBitmap);
         
         mMouseOverSprite.addChild (mBackgroundShape_MouseOver);
         mMouseOverSprite.addChild (mBorderShape_MouseOver);
         mMouseOverSprite.addChild (mTextBitmap_MouseOver);
         
         mMouseDownSprite.addChild (mBackgroundShape_MouseDown);
         mMouseDownSprite.addChild (mBorderShape_MouseDown);
         mMouseDownSprite.addChild (mTextBitmap_MouseDown);
         
         mSimpleButton.upState = mNormalSprite;
         mSimpleButton.hitTestState = mNormalSprite;
         mSimpleButton.overState = mMouseOverSprite;
         mSimpleButton.downState = mMouseDownSprite;
         
         mSimpleButton.enabled = IsEnabled ();
         mSimpleButton.useHandCursor = true;
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object, extraInfos:Object):void
      {
         super.Create (createStageId, entityDefine, extraInfos);
         
         if (createStageId == 0)
         {
            SetTextColor_MouseOver (GetTextColor ());
            SetFontSize_MouseOver (GetFontSize ());
            
            if (entityDefine.mUsingHandCursor != undefined)
               SetUsingHandCursor (entityDefine.mUsingHandCursor);
            
            if (entityDefine.mDrawBorder_MouseOver != undefined)
               mDrawBorder_MouseOver = entityDefine.mDrawBorder_MouseOver;
            if (entityDefine.mDrawBackground_MouseOver != undefined)
               mDrawBackground_MouseOver = entityDefine.mDrawBackground_MouseOver;
            if (entityDefine.mBorderColor_MouseOver != undefined)
               mBorderColor_MouseOver = entityDefine.mBorderColor_MouseOver;
            if (entityDefine.mBorderThickness_MouseOver != undefined)
               mBorderThickness_MouseOver = mWorld.GetCoordinateSystem ().D2P_Length (entityDefine.mBorderThickness_MouseOver);
            if (entityDefine.mBackgroundColor_MouseOver != undefined)
               mBackgroundColor_MouseOver = entityDefine.mBackgroundColor_MouseOver;
            if (entityDefine.mBackgroundTransparency_MouseOver != undefined)
               mTransparency_MouseOver = entityDefine.mBackgroundTransparency_MouseOver;
            if (entityDefine.mBorderTransparency_MouseOver != undefined)
               mBorderTransparency_MouseOver = entityDefine.mBorderTransparency_MouseOver;
            
            // not set in editor, set in Clone API
            if (entityDefine.mTextColor_MouseOver != undefined)
               SetTextColor_MouseOver (entityDefine.mTextColor_MouseOver);
            if (entityDefine.mFontSize_MouseOver != undefined)
               SetFontSize_MouseOver (entityDefine.mFontSize_MouseOver);

         }
      }
      
     override public function ToEntityDefine (entityDefine:Object):Object
     {
         super.ToEntityDefine (entityDefine);
         
         entityDefine.mTextColor_MouseOver = GetTextColor_MouseOver ();
         entityDefine.mFontSize_MouseOver = GetFontSize_MouseOver ();
         
         entityDefine.mUsingHandCursor = UsingHandCursor ();
         entityDefine.mDrawBorder_MouseOver = mDrawBorder_MouseOver;
         entityDefine.mDrawBackground_MouseOver = mDrawBackground_MouseOver;
         entityDefine.mBorderColor_MouseOver = mBorderColor_MouseOver;
         entityDefine.mBorderThickness_MouseOver = mWorld.GetCoordinateSystem ().P2D_Length (mBorderThickness_MouseOver);
         entityDefine.mBackgroundColor_MouseOver = mBackgroundColor_MouseOver;
         entityDefine.mBackgroundTransparency_MouseOver = mTransparency_MouseOver;
         entityDefine.mBorderTransparency_MouseOver = mBorderTransparency_MouseOver;
         
         entityDefine.mEntityType = Define.EntityType_ShapeTextButton;
         
         return entityDefine;
     }
      
//=============================================================
//   initialize
//=============================================================
      
      override protected function InitializeInternal ():void
      {
         super.InitializeInternal ();
         
         mAppearanceObjectsContainer.mouseChildren = true; // !!! important
      }
      
//=============================================================
//   
//=============================================================
      
      override public function SetEnabled (enabled:Boolean):void
      {
         super.SetEnabled (enabled);
         
         mSimpleButton.enabled = IsEnabled ();
      }
      
      private var mUsingHandCurcor:Boolean = true;
      
      public function UsingHandCursor ():Boolean
      {
         return mUsingHandCurcor;
      }
      
      public function SetUsingHandCursor (usingHandCursor:Boolean):void
      {
         mUsingHandCurcor = usingHandCursor;
         
         mSimpleButton.useHandCursor = mUsingHandCurcor;
      }
      
//=============================================================
//   
//=============================================================
      
      private var mDrawBorder_MouseOver:Boolean = true;
      private var mDrawBackground_MouseOver:Boolean =true;
      private var mBorderColor_MouseOver:uint = 0x0;
      private var mBorderThickness_MouseOver:Number = 2;
      private var mBackgroundColor_MouseOver:uint = Define.ColorTextButtonBackground_MouseOver;
      private var mTransparency_MouseOver:uint = 100;
      private var mBorderTransparency_MouseOver:uint = 100;
      
      // these are not defined in editor, they are changed by API
      private var mTextColor_MouseOver:uint = 0x000000;
      private var mFontSize_MouseOver:uint = 10;
      
      public function GetTextColor_MouseOver ():uint
      {
         return mTextColor_MouseOver;
      }
      
      public function SetTextColor_MouseOver (color:uint):void
      {
         mTextColor_MouseOver = color;
         
         mNeedRebuildTextSprite = true;
         // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
         DelayUpdateAppearance ();
      }
      
      public function GetFontSize_MouseOver ():uint
      {
         return mFontSize_MouseOver;
      }
      
      public function SetFontSize_MouseOver (size:uint):void
      {
         mFontSize_MouseOver = size;
         
         mNeedRebuildTextSprite = true;
         // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
         DelayUpdateAppearance ();
      }
      
//=============================================================
//   appearance
//=============================================================
      
      protected var mSimpleButton:SimpleButton = new SimpleButton ();
      
      protected var mNormalSprite:Sprite = new Sprite ();
      
      protected var mMouseOverSprite:Sprite = new Sprite ();
      protected var mTextBitmap_MouseOver:Bitmap = new Bitmap ();
      protected var mBackgroundShape_MouseOver:Shape = new Shape ();
      protected var mBorderShape_MouseOver    :Shape = new Shape ();
      
      protected var mMouseDownSprite:Sprite = new Sprite ();
      protected var mTextBitmap_MouseDown:Bitmap = new Bitmap ();
      protected var mBackgroundShape_MouseDown:Shape = new Shape ();
      protected var mBorderShape_MouseDown    :Shape = new Shape ();
      
      override protected function PreUpdateTextAppearance ():void
      {
      }
      
      override protected function PostUpdateTextAppearance ():void
      {
         //
         var hAlign:int = mTextAlign & 0x0F;
         var vAlign:int = mTextAlign & 0xF0;
         var displayHalfWidth:Number = mWorld.GetCoordinateSystem ().P2D_Length (mHalfWidth);
         var displayHalfHeight:Number = mWorld.GetCoordinateSystem ().P2D_Length (mHalfHeight);
         var halfDisplayBorderThickness:Number = 0.5 * mWorld.GetCoordinateSystem ().P2D_Length (mBorderThickness);
         
         AlignTextSprite (mTextBitmap, hAlign, vAlign, displayHalfWidth, displayHalfHeight, halfDisplayBorderThickness);
         AlignTextSprite (mTextBitmap_MouseOver, hAlign, vAlign, displayHalfWidth, displayHalfHeight, halfDisplayBorderThickness);
         AlignTextSprite (mTextBitmap_MouseDown, hAlign, vAlign, displayHalfWidth, displayHalfHeight, halfDisplayBorderThickness);
         mTextBitmap_MouseDown.y += 1;
      }
      
      // why override it?
      //override protected function AdjustBackgroundSize ():void
      //{
      //   if (IsAdaptiveBackgroundSize ())
      //   {
      //      SetHalfWidth  (mWorld.GetCoordinateSystem ().D2P_Length (0.5 * mTextBitmap.width + 15));
      //      SetHalfHeight (mWorld.GetCoordinateSystem ().D2P_Length (0.5 * mTextBitmap.height + 3));
      //      
      //      mNeedRebuildAppearanceObjects = true;
      //   }
      //}
      
      override protected function RebuildTextAppearance ():void
      {
         // create the over bitmap, some tricky here.
         var textColor_Backup:uint = mTextColor;
         var fontSize_Backup:uint = mFontSize;
         try
         {
            mTextColor = mTextColor_MouseOver;
            mFontSize = mFontSize_MouseOver;
            
            super.RebuildTextAppearance ();
            
            mTextBitmap_MouseOver.bitmapData = mTextBitmap.bitmapData;
            //mTextBitmap_MouseOver.x = - 0.5 * mTextBitmap_MouseOver.width;
            //mTextBitmap_MouseOver.y = - 0.5 * mTextBitmap_MouseOver.height;
            
            mTextBitmap_MouseDown.bitmapData = mTextBitmap.bitmapData;
            //mTextBitmap_MouseDown.x = - 0.5 * mTextBitmap_MouseOver.width;
            //mTextBitmap_MouseDown.y = - 0.5 * mTextBitmap_MouseOver.height + 1;
         }
         catch (error:Error)
         {
         }
         
         // create the up bitmap
         mTextColor = textColor_Backup;
         mFontSize = fontSize_Backup;
         super.RebuildTextAppearance ();
      }
      
      override protected function RebuildBackgroundAndBorder (displayHalfWidth:Number, displayHalfHeight:Number, displayBorderThickness:Number):void
      {
         super.RebuildBackgroundAndBorder (displayHalfWidth, displayHalfHeight, displayBorderThickness);
         
         var displayWidth :Number = displayHalfWidth +  displayHalfWidth;
         var displayHeight:Number = displayHalfHeight +  displayHalfHeight;
         var displayBorderThickness_MouseOver:Number = mWorld.GetCoordinateSystem ().P2D_Length (mBorderThickness_MouseOver);
         
         GraphicsUtil.ClearAndDrawRect (
                  mBackgroundShape_MouseOver,
                  - displayHalfWidth,
                  - displayHalfHeight,
                  displayWidth,
                  displayHeight,
                  mBorderColor_MouseOver,
                  -1, // not draw border
                  true, // draw background
                  mBackgroundColor_MouseOver
               );
         
         GraphicsUtil.ClearAndDrawRect (
                  mBorderShape_MouseOver,
                  - displayHalfWidth,
                  - displayHalfHeight,
                  displayWidth,
                  displayHeight,
                  mBorderColor_MouseOver,
                  displayBorderThickness_MouseOver, // draw border
                  false, // not draw background
                  0x0, // invald bg color
                  mIsRoundJoint // mIsRoundCornors
               );
         
         GraphicsUtil.ClearAndDrawRect (
                  mBackgroundShape_MouseDown,
                  - displayHalfWidth,
                  - displayHalfHeight,
                  displayWidth,
                  displayHeight,
                  mBorderColor_MouseOver,
                  -1, // not draw border
                  true, // draw background
                  mBackgroundColor_MouseOver
               );
         
         GraphicsUtil.ClearAndDrawRect (
                  mBorderShape_MouseDown,
                  - displayHalfWidth,
                  - displayHalfHeight,
                  displayWidth,
                  displayHeight,
                  mBorderColor_MouseOver,
                  displayBorderThickness_MouseOver, // draw border
                  false, // not draw background
                  0x0, // invald bg color
                  mIsRoundJoint // mIsRoundCornors
               );
         
         mBackgroundShape_MouseOver.visible = mBackgroundShape_MouseDown.visible = mDrawBackground_MouseOver;
         mBackgroundShape_MouseOver.alpha = mBackgroundShape_MouseDown.alpha = mTransparency_MouseOver * 0.01;
         
         mBorderShape_MouseOver.visible = mBorderShape_MouseDown.visible = mDrawBorder_MouseOver;
         mBorderShape_MouseOver.alpha = mBorderShape_MouseDown.alpha = mBorderTransparency_MouseOver * 0.01;
      }
   }
   
}
