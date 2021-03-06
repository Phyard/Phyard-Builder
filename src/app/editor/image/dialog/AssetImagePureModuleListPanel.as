
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
   
   import editor.image.AssetImagePureModuleManager;
   
   import common.Define;
   import common.Version;
   
   public class AssetImagePureModuleListPanel extends AssetImageModuleListPanel 
   {
      protected var mAssetImagePureModuleManager:AssetImagePureModuleManager;
      
      public function SetAssetImagePureModuleManager (assetImagePureModuleManager:AssetImagePureModuleManager):void
      {
         super.SetAssetImageModuleManager (assetImagePureModuleManager);
         
         if (mAssetImagePureModuleManager != assetImagePureModuleManager)
         {
            mAssetImagePureModuleManager = assetImagePureModuleManager;
         }
      }
      
   }
}
