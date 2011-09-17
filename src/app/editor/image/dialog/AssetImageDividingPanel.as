
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
   import mx.controls.CheckBox;
   import mx.controls.Label;
   import mx.controls.TextInput;
   import mx.controls.RadioButton;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.asset.AssetManagerPanel;
   import editor.asset.Intent;
   import editor.asset.IntentPutAsset;
   
   import editor.image.AssetImageDivisionManager;
   
   import editor.runtime.Runtime;
   
   import common.Define;
   import common.Version;
   
   public class AssetImageDividingPanel extends AssetManagerPanel 
   {
      protected var mImageSprite:Sprite;
      protected var mAssetImageDivisionManager:AssetImageDivisionManager;
      
      public function AssetImageDividingPanel ()
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
                                    
            ScaleManager (1.0);
            
            MoveManager (0.5 * (mParentWidth - (mImageSprite == null ? 0 : mImageSprite.width)) - mAssetImageDivisionManager.x, 
                                     0.5 * (mParentHeight - (mImageSprite == null ? 0 : mImageSprite.height)) - mAssetImageDivisionManager.y
                                    );
         }
      }
      
//============================================================================
//   
//============================================================================
      
      override protected function OnResize (event:Event):void 
      {
         var lastParentWidth:Number  = mParentWidth; 
         var lastParentHeight:Number = mParentHeight; 
         
         super.OnResize (event);
         
         MoveManager (0.5 * (mParentWidth - lastParentWidth), 0.5 * (mParentHeight - lastParentHeight));
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
      
      override public function ScaleManager (scale:Number):void
      {
         super.ScaleManager (scale);
         
         if (mImageSprite != null)
         {
            mImageSprite.scaleX = mAssetImageDivisionManager.scaleX;
            mImageSprite.scaleY = mAssetImageDivisionManager.scaleY;
         }
      }

//============================================================================
//   
//============================================================================
      
      public function StartCreateImageDivision ():void
      {
         if (mAssetImageDivisionManager == null)
            return;
         
         mAssetImageDivisionManager.ClearSelectedAssets ();
         
         SetCurrentIntent (new IntentDragDivision (this));
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
      
      override protected function OnMouseMoveInternal (managerX:Number, managerY:Number, isHold:Boolean, mIsCtrlDownOnMouseDown:Boolean, mIsShiftDownOnMouseDown:Boolean):void
      {
         
      }

//============================================================================
//   
//============================================================================

      public function CreateImageDivision (left:Number, top:Number, right:Number, bottom:Number):void
      {
         mAssetImageDivisionManager.CreateImageDivision (left, top, right, bottom, true);
      }      

   }
}
