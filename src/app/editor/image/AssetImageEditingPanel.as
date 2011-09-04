
package editor.image {
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
   
   import editor.runtime.Runtime;
   
   import common.Define;
   import common.Version;
   
   public class AssetImageEditingPanel extends AssetManagerPanel 
   {
      protected var mAssetImageManager:AssetImageManager;
      
      public function AssetImageEditingPanel ()
      {
      }
      
      public function SetAssetImageManager (aim:AssetImageManager):void
      {
         super.SetAssetManager (aim);
         
         mAssetImageManager = aim;
      }

//============================================================================
//   contet menu, for PC only
//============================================================================
      
      
      
//============================================================================
//   interfaces for UI
//============================================================================
      
      public function CreateNewImage ():void
      {
         if (mAssetImageManager == null)
            return;
         
         SetCurrentIntent (null); // cancel possible ongoing IntentPutAsset
         
         var image:AssetImage = mAssetImageManager.CreateImage (true); // ture means insert before the selected one and select the new created one.
         
         SetCurrentIntent (new IntentPutAsset (image, OnCreateNewImageFinished, OnCreateNewImageCancelled));
      }
      
      protected function OnCreateNewImageFinished ():void
      {  
      }
      
      protected function OnCreateNewImageCancelled ():void
      {
         DeleteImage ();
      }
      
      public function DeleteImage ():void
      {
         if (mAssetImageManager == null)
            return;
         
         mAssetImageManager.DeleteSelectedAssets ();
      }

      public function SetImageAssetName (imageName:String):void
      {
         if (mAssetImageManager == null)
            return;
         
         var image:AssetImage = mAssetImageManager.GetTheFirstSelectedAsset () as AssetImage;
         if (image != null)
         {
            image.SetName (imageName);
         }
      }
      
   }
}
