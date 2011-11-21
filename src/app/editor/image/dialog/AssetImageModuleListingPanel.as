
package editor.image.dialog {
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   
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
   
   import editor.image.AssetImageModule;
   import editor.image.AssetImageModuleManager;
   
   import editor.image.IntentPickModule;
   
   import editor.runtime.Runtime;
   
   import common.Define;
   import common.Version;
   
   public class AssetImageModuleListingPanel extends AssetManagerPanel 
   {
      protected var mAssetImageModuleManager:AssetImageModuleManager;
      
      public function SetAssetImageModuleManager (assetImageModuleManager:AssetImageModuleManager):void
      {
         super.SetAssetManager (assetImageModuleManager);
         
         if (mAssetImageModuleManager != assetImageModuleManager)
         {
            mAssetImageModuleManager = assetImageModuleManager;
            
            if (mAssetImageModuleManager != null)
            {
               mAssetImageModuleManager.RearrangeAssetPositions (true);
            }
         }
      }
      
      public function EnterPickModuleIntent (onPick:Function, onEnd:Function):void
      {
         if (mAssetImageModuleManager != null)
         {
            SetCurrentIntent (new IntentPickModule (this, onPick, onEnd));
            mAssetImageModuleManager.NotifyPickingStatusChanged (true);
         }
      }
      
      public function ExitPickModuleIntent ():void
      {
         if (mAssetImageModuleManager != null)
         {
            SetCurrentIntent (null);
            mAssetImageModuleManager.NotifyPickingStatusChanged (false);
         }
      }

//=====================================================================
// ...
//=====================================================================
      
      public function PickModuleAtPosition (managerX:Number, managerY:Number):AssetImageModule
      {
         if (mAssetImageModuleManager != null)
         {
            var assetArray:Array = mAssetImageModuleManager.GetAssetsAtPoint (managerX, managerY);
            if (assetArray != null && assetArray.length >= 1)
            {
               return assetArray [0] as AssetImageModule;
            }
         }
         
         return null; //new AssetImageNullModule ();
      }
        
      
   }
}
