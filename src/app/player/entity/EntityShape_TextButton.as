
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
         SetTextAlign (Define.TextAlign_Center);
         
         mAppearanceObjectsContainer.removeChild (mBackgroundShape); // added in rect
         mAppearanceObjectsContainer.removeChild (mBorderShape); // added in rect
         mAppearanceObjectsContainer.removeChild (mTextBitmap); // added in text
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
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
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
         }
      }
      
     override public function ToEntityDefine (entityDefine:Object):Object
     {
         super.ToEntityDefine (entityDefine);
         
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
//   
//=============================================================
      
      override public function SetEnabled (enabled:Boolean):void
      {
         super.SetEnabled (enabled);
         
         mSimpleButton.enabled = IsEnabled ();
      }
      
//=============================================================
//   
//=============================================================
      
      private var mUsingHandCurcor:Boolean = true;
      
      private var mDrawBorder_MouseOver:Boolean = true;
      private var mDrawBackground_MouseOver:Boolean =true;
      private var mBorderColor_MouseOver:uint = 0x0;
      private var mBorderThickness_MouseOver:Number = 2;
      private var mBackgroundColor_MouseOver:uint = Define.ColorTextButtonBackground_MouseOver;
      private var mTransparency_MouseOver:uint = 100;
      private var mBorderTransparency_MouseOver:uint = 100;
      
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
//   initialize
//=============================================================
      
      override protected function InitializeInternal ():void
      {
         super.InitializeInternal ();
         
         mAppearanceObjectsContainer.mouseChildren = true; // !!! important
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
      
      
      override protected function AdjustBackgroundSize ():void
      {
         if (IsAdaptiveBackgroundSize ())
         {
            SetHalfWidth  (mWorld.GetCoordinateSystem ().D2P_Length (0.5 * mTextBitmap.width + 15));
            SetHalfHeight (mWorld.GetCoordinateSystem ().D2P_Length (0.5 * mTextBitmap.height + 3));
            
            mNeedRebuildAppearanceObjects = true;
         }
      }
      
      override protected function RebuildTextBitmap ():void
      {
         super.RebuildTextBitmap ();
         
         mTextBitmap_MouseOver.bitmapData = mTextBitmap.bitmapData;
         mTextBitmap_MouseOver.x = - 0.5 * mTextBitmap_MouseOver.width;
         mTextBitmap_MouseOver.y = - 0.5 * mTextBitmap_MouseOver.height;
         
         mTextBitmap_MouseDown.bitmapData = mTextBitmap.bitmapData;
         mTextBitmap_MouseDown.x = - 0.5 * mTextBitmap_MouseOver.width;
         mTextBitmap_MouseDown.y = - 0.5 * mTextBitmap_MouseOver.height + 1;
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
                  mIsRoundCornors
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
                  mIsRoundCornors
               );
         
         mBackgroundShape_MouseOver.visible = mBackgroundShape_MouseDown.visible = mDrawBackground_MouseOver;
         mBackgroundShape_MouseOver.alpha = mBackgroundShape_MouseDown.alpha = mTransparency_MouseOver * 0.01;
         
         mBorderShape_MouseOver.visible = mBorderShape_MouseDown.visible = mDrawBorder_MouseOver;
         mBorderShape_MouseOver.alpha = mBorderShape_MouseDown.alpha = mBorderTransparency_MouseOver * 0.01;
      }
   }
   
}
