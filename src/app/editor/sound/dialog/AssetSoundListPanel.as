
package editor.sound.dialog {
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
   
   import editor.asset.AssetManagerListLayout; 
   
   import editor.sound.AssetSound;
   import editor.sound.AssetSoundManager;
   
   import common.Define;
   import common.Version;
   
   public class AssetSoundListPanel extends AssetManagerPanel
   {
      private var mAssetSoundManager:AssetSoundManager = null;
      
      public function SetAssetSoundManager (assetSoundManager:AssetSoundManager):void
      {
         super.SetAssetManager (assetSoundManager);
         
         if (mAssetSoundManager != assetSoundManager)
         {
            mAssetSoundManager = assetSoundManager;
            
            if (mAssetSoundManager != null && mAssetSoundManager.GetLayout () == null)
            {
               mAssetSoundManager.SetLayout (new AssetManagerListLayout (mAssetSoundManager, 76));
               mAssetSoundManager.UpdateLayout (true, true);
            }
         }
      }
      
      override public function GetMouseWheelFunction (ctrlDown:Boolean, shiftDown:Boolean):int
      {
         //if (! (ctrlDown || shiftDown))
         //   return kMouseWheelFunction_Scroll;
         //
         //return kMouseWheelFunction_None;
         //
         
         return kMouseWheelFunction_Scroll;
      }
      
//============================================================================
//   
//============================================================================
      
   }
}
