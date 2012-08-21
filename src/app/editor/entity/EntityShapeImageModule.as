
package editor.entity {

   import flash.display.Sprite;
   import flash.display.Shape;
   
   import flash.geom.Rectangle;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;

   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionProxy;
   
   import editor.core.EditorObject;
   import editor.core.ReferPair;

   import editor.image.AssetImageModule;
   import editor.image.AssetImageNullModule;
   
   import editor.EditorContext;

   import common.Define;
   import common.Transform2D;

   public class EntityShapeImageModule extends EntityShape
   {
      
      public static const kText_ChangeModule:String = "Change To The Current Module";
      
      protected var mContextMenu:ContextMenu;
      protected var mContextMenuItem_ChangeModule:ContextMenuItem;
      
      //============================================
      
      protected var mAssetImageModule:AssetImageModule;
      
//====================================================================
//
//====================================================================

      public function EntityShapeImageModule (container:Scene)
      {
         super (container);
         
         SetAssetImageModule (null);
         
         BuildContextMenu ();
      }

      override public function GetTypeName ():String
      {
         return "Module Shape";
      }

      override public function IsBasicVectorShapeEntity ():Boolean
      {
         return false;
      }
      
//====================================================================
//   
//====================================================================

      public function GetAssetImageModule ():AssetImageModule
      {
         return mAssetImageModule;
      }

      public function SetAssetImageModule (imageModule:AssetImageModule):void
      {
         if (mReferPair != null)
         {
            mReferPair.Break ();
            mAssetImageModule = null;
         }
         
         if (imageModule == null)
            imageModule = new AssetImageNullModule ();
         
         if (imageModule != null)
         {
            mAssetImageModule = imageModule;
            mReferPair = ReferObject (mAssetImageModule);
         }
      }
      
      // for loading
      public function SetAssetImageModuleByIndex (index:int, world:World):void
      {
         //SetAssetImageModule (EditorContext.GetEditorApp ().GetWorld ().GetImageModuleByIndex (index));// bug!
         SetAssetImageModule (world.GetImageModuleByIndex (index));
      }
      
//=============================================================
//   
//=============================================================
      
      private var mReferPair:ReferPair;
      
      override public function OnReferingModified (referPair:ReferPair, info:Object = null):void
      {
         super.OnReferingModified (referPair, info);
         
         if (referPair == mReferPair)
         {
            UpdateAppearance ();
            UpdateSelectionProxy ();
         }
      }

      override public function OnReferingDestroyed (referPair:ReferPair):void
      {
         super.OnReferingDestroyed (referPair);
         
         if (referPair == mReferPair)
         {
            SetAssetImageModule (null);
            
            UpdateAppearance ();
            UpdateSelectionProxy ();
         }
      }
      
//=============================================================
//   temp. When Entity is extended from Asset, remove these
//=============================================================
      /*
      override public function RotateSelf (dRadians:Number):void
      {
         if (IsFlipped ())
            dRadians = - dRadians;
         
         SetRotation (GetRotation () + dRadians);
      }
      
      override public function ScaleSelf (ratio:Number):void
      {
         if (ratio < 0)
            ratio = - ratio;
         
         SetScale (GetScale () * ratio);
      }
      
      override public function FlipSelfHorizontally ():void
      {
         SetFlipped (! IsFlipped ());
      }
      
      override public function FlipSelfVertically ():void
      {
         FlipSelfHorizontally ();
         RotateSelf (Math.PI);
      }
      */
//=============================================================
//   
//=============================================================
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         GraphicsUtil.Clear (this);
         
         mAssetImageModule.BuildImageModuleAppearance (this);
         alpha = 0.70;
         
         if (IsSelected ())
         {
            var shape:Shape = new Shape ();

            var rectangle:Rectangle = this.getBounds (this);
            GraphicsUtil.DrawRect (shape, rectangle.left, rectangle.top, rectangle.width, rectangle.height,
                                       0x0000FF, -1, true, 0xC0C0FF, false);
            
            addChild (shape);
         }
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mEntityContainer.mSelectionEngine.CreateProxyGeneral ();
            mSelectionProxy.SetUserData (this);
         }
         
         mSelectionProxy.Rebuild (GetPositionX (), GetPositionY (), 0.0);
         mAssetImageModule.BuildImageModuleSelectionProxy (mSelectionProxy, 
               //new Transform2D (0.0, 0.0, 1.0, false, GetRotation ()), mEntityContainer.GetZoomScale ());
               new Transform2D (0.0, 0.0, GetScale (), IsFlipped (), GetRotation ()), mEntityContainer.GetZoomScale () * GetScale ());
      }

//====================================================================
//   clone
//====================================================================

      // to override
      override protected function CreateCloneShell ():Entity
      {
         return new EntityShapeImageModule (mEntityContainer);
      }

      // to override
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);

         var imageModuleShape:EntityShapeImageModule = entity as EntityShapeImageModule;
         imageModuleShape.SetAssetImageModule (GetAssetImageModule ());
      }
      
//==============================================================================================================
//
//==============================================================================================================
      
      private function BuildContextMenu ():void
      {
         contextMenu = new ContextMenu ();
         contextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = contextMenu.builtInItems;
         defaultItems.print = false;
         
         mContextMenuItem_ChangeModule = new ContextMenuItem (kText_ChangeModule, false);
         contextMenu.customItems.push (mContextMenuItem_ChangeModule);
         mContextMenuItem_ChangeModule.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
      }
      
      private function OnContextMenuEvent (event:ContextMenuEvent):void
      {
         if (event.target == mContextMenuItem_ChangeModule)
         {
            ChangeToCurrentAssetImageModule ();
         }
      }
      
      public function ChangeToCurrentAssetImageModule ():void
      {
         SetAssetImageModule (EditorContext.GetSingleton ().mCurrentAssetImageModule);
         UpdateAppearance ();
         UpdateSelectionProxy ();
      }
   }
}
