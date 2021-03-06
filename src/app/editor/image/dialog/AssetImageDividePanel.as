
package editor.image.dialog {
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.BitmapData;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.EventPhase;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import flash.net.URLRequest;
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   import mx.controls.Button;
   import mx.controls.Label;
   import mx.controls.NumericStepper;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.asset.AssetManagerPanel;
   import editor.asset.Intent;
   import editor.asset.IntentPutAsset;
   
   import editor.image.AssetImageDivision;
   import editor.image.AssetImageDivisionManager;
   
   import common.Define;
   import common.Version;
   
   public class AssetImageDividePanel extends AssetManagerPanel 
   {
      protected var mImageSprite:Sprite;
      protected var mAssetImageDivisionManager:AssetImageDivisionManager;
      
      public function AssetImageDividePanel ()
      {
      }
      
      public function SetAssetImageDivisionManager (aidm:AssetImageDivisionManager):void
      {
         super.SetAssetManager (aidm);
         
         mAssetImageDivisionManager = aidm;
         
         while (mBackgroundLayer.numChildren > 0)
            mBackgroundLayer.removeChildAt (0);
         
         if (mAssetImageDivisionManager != null)
         {
            mImageSprite = mAssetImageDivisionManager.GetAssetImageSprite ();
            mBackgroundLayer.addChild (mImageSprite);
                                    
            ScaleManagerAroundFixedPoint (1.0, 0.5 * GetPanelWidth (), 0.5 * GetPanelHeight ());
            
            MoveManager (0.5 * (GetPanelWidth () - (mImageSprite.width == 0 ? GetPanelWidth () : mImageSprite.width)) - mAssetImageDivisionManager.x, 
                         0.5 * (GetPanelHeight () - (mImageSprite.height == 0 ? GetPanelHeight () : mImageSprite.height)) - mAssetImageDivisionManager.y
                        );
            
            UpdateInterface ();
         }
      }
      
//============================================================================
//   
//============================================================================
      
      override protected function OnResize (event:Event):void 
      {
         var lastParentWidth:Number  = GetPanelWidth (); 
         var lastParentHeight:Number = GetPanelHeight (); 
         
         super.OnResize (event);
         
         MoveManager (0.5 * (GetPanelWidth () - lastParentWidth), 0.5 * (GetPanelHeight () - lastParentHeight));
      }
      
      override public function MoveManager (dx:Number, dy:Number):void
      {
         super.MoveManager (dx, dy);
         
         if (mImageSprite != null)
         {
            mImageSprite.x = mAssetImageDivisionManager.x;
            mImageSprite.y = mAssetImageDivisionManager.y;
         }
      }
      
      override public function ScaleManagerAroundFixedPoint (scale:Number, fixedPanelPointX:Number, fixedPanelPointY:Number):void
      {
         super.ScaleManagerAroundFixedPoint (scale, fixedPanelPointX, fixedPanelPointY);
         
         if (mImageSprite != null)
         {
            mImageSprite.x = mAssetImageDivisionManager.x;
            mImageSprite.y = mAssetImageDivisionManager.y;
            mImageSprite.scaleX = mAssetImageDivisionManager.scaleX;
            mImageSprite.scaleY = mAssetImageDivisionManager.scaleY;
         }
      }

//============================================================================
//   
//============================================================================
      
      public function OnCreateImageDivisionClicked ():void
      {
         if (mAssetImageDivisionManager == null)
            return;
         
         if (mCurrentIntent is IntentDragDivision)
         {
            mCurrentIntent.Terminate ();
         }
         else
         {
            mAssetImageDivisionManager.CancelAllAssetSelections ();
            
            SetCurrentIntent (new IntentDragDivision (this));
         }
      }
      
      public function DeleteImageDivisions ():void
      {
         if (mAssetImageDivisionManager == null)
            return;
         
         mAssetImageDivisionManager.DeleteSelectedAssets ();
      }
      
//============================================================================
//   
//============================================================================

      public function CreateImageDivision (left:Number, top:Number, right:Number, bottom:Number):void
      {
         mAssetImageDivisionManager.CreateImageDivision (null, left, top, right, bottom, true);
         
         OnAssetSelectionsChanged ();
         mButtonCreateImageDivision.selected = false;
      }

//============================================================================
//   
//============================================================================
      
      public var mButtonCreateImageDivision:Button;
      public var mButtonDeleteImageDivision:Button;
      public var mNumericStepperLeft:NumericStepper;
      public var mNumericStepperTop:NumericStepper;
      public var mNumericStepperRight:NumericStepper;
      public var mNumericStepperBottom:NumericStepper;
      
      override public function UpdateInterface ():void
      {
         if (mAssetImageDivisionManager == null)
            return;
         
         var numSelecteds:int = mAssetImageDivisionManager.GetNumSelectedAssets ();
         
         mButtonDeleteImageDivision.enabled = numSelecteds > 0;
         if (numSelecteds == 1)
         {
            var division:AssetImageDivision = mAssetImageDivisionManager.GetSelectedAssets ()[0] as AssetImageDivision;

            mNumericStepperLeft.enabled   = true; mNumericStepperLeft.value   = division.GetLeft ();
            mNumericStepperTop.enabled    = true; mNumericStepperTop.value    = division.GetTop ();
            mNumericStepperRight.enabled  = true; mNumericStepperRight.value  = division.GetRight ();
            mNumericStepperBottom.enabled = true; mNumericStepperBottom.value = division.GetBottom ();
         }
         else
         {
            mNumericStepperLeft.enabled   = false; mNumericStepperLeft.value   = 0;
            mNumericStepperTop.enabled    = false; mNumericStepperTop.value    = 0;
            mNumericStepperRight.enabled  = false; mNumericStepperRight.value  = 0;
            mNumericStepperBottom.enabled = false; mNumericStepperBottom.value = 0;
         }
      }
      
      public function SychronizeCurrentDivisionPropertiesFromUI ():void
      {
         if (mAssetImageDivisionManager.GetNumSelectedAssets () == 1)
         {
            var division:AssetImageDivision = mAssetImageDivisionManager.GetSelectedAssets ()[0] as AssetImageDivision;
            
            division.SetRegion (mNumericStepperLeft.value, mNumericStepperTop.value, mNumericStepperRight.value, mNumericStepperBottom.value);
            division.UpdateTimeModified ();
            division.UpdateAppearance ();
            division.UpdateSelectionProxy ();
            
            UpdateInterface ();
         }
      }

   }
}
