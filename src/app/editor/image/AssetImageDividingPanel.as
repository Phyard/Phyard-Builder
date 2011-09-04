
package editor.image {
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Bitmap;
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
   
   import editor.runtime.Runtime;
   
   import common.Define;
   import common.Version;
   
   public class AssetImageDividingPanel extends AssetManagerPanel 
   {
      protected var mBitamp:Bitmap;
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
            var bitmapData:BitmapData = mAssetImageDivisionManager.GetAssetImage ().GetBitmapData ();
            if (bitmapData != null)
            {
               mBitamp = new Bitmap (bitmapData);
               
               mBackgroundLayer.addChild (mBitamp);
            }
            
            MoveManager (0.5 * (mParentWidth - (mBitamp == null ? 0 : mBitamp.width)) - mAssetImageDivisionManager.x, 
                                     0.5 * (mParentHeight - (mBitamp == null ? 0 : mBitamp.height)) - mAssetImageDivisionManager.y
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
         if (mAssetImageDivisionManager != null)
         {
            var intDx:int = int (dx);
            var intDy:int = int (dy);
            
            mAssetImageDivisionManager.x += intDx;
            mAssetImageDivisionManager.y += intDy;
         
            if (mBitamp != null)
            {
               mBitamp.x = mAssetImageDivisionManager.x;
               mBitamp.y = mAssetImageDivisionManager.y;
            }
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
      
      public function DeleteImageDivision ():void
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
         mAssetImageDivisionManager.CreateImageDivision (left, top, right, bottom, true);
      }      

   }
}
