
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
   
   import editor.asset.AssetManagerArrayLayout; 
   
   import editor.image.AssetImageModule;
   import editor.image.AssetImageModuleManager;
   
   import common.Define;
   import common.Version;
   
   public class AssetImageModuleListPanel extends AssetManagerPanel 
   {
      protected var mAssetImageModuleManager:AssetImageModuleManager;
      
      public function SetAssetImageModuleManager (assetImageModuleManager:AssetImageModuleManager):void
      {
         super.SetAssetManager (assetImageModuleManager);
         
         if (mAssetImageModuleManager != assetImageModuleManager)
         {
            mAssetImageModuleManager = assetImageModuleManager;
            
            if (mAssetImageModuleManager != null && mAssetImageModuleManager.GetLayout () == null)
            {
               mAssetImageModuleManager.SetLayout (new AssetManagerArrayLayout (mAssetImageModuleManager, mAssetImageModuleManager.GetModuleIconSize () + 16));
               mAssetImageModuleManager.UpdateLayout (true, true);
            }
         }
      }
      
      override public function GetMouseWheelFunction (ctrlDown:Boolean, shiftDown:Boolean):int
      {
         if (ctrlDown || shiftDown)
            return kMouseWheelFunction_Zoom;
         
         return kMouseWheelFunction_Scroll;
      }
      
   }
}
