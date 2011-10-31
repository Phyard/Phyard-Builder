
package editor.entity {

   import flash.display.Sprite;
   import flash.display.Shape;
   
   import flash.geom.Rectangle;

   import com.tapirgames.util.GraphicsUtil;

   import editor.world.World;

   import editor.selection.SelectionProxy;

   import editor.image.AssetImageModule;
   import editor.image.AssetImageNullModule;

   import common.Define;
   import common.Transform2D;

   public class EntityImageModuleShape extends EntityShape
   {  
      protected var mAssetImageModule:AssetImageModule;
      
//====================================================================
//
//====================================================================

      public function EntityImageModuleShape (world:World)
      {
         super (world);
         
         SetAssetImageModule (AssetImageModule.mCurrentAssetImageModule);
      }

      override public function GetTypeName ():String
      {
         return "Module Shape";
      }

      override public function IsBasicShapeEntity ():Boolean
      {
         return false;
      }
      
//====================================================================
//   clone
//====================================================================

      public function GetAssetImageModule ():AssetImageModule
      {
         return mAssetImageModule;
      }

      public function SetAssetImageModule (imageModule:AssetImageModule):void
      {
         if (imageModule == null)
            mAssetImageModule = new AssetImageNullModule ();
         else
            mAssetImageModule = imageModule;
      }
      
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
            mSelectionProxy = mWorld.mSelectionEngine.CreateProxyGeneral ();
            mSelectionProxy.SetUserData (this);
         }
         
         mSelectionProxy.Rebuild (GetPositionX (), GetPositionY (), 0.0);
         mAssetImageModule.BuildImageModuleSelectionProxy (mSelectionProxy, 
               new Transform2D (0.0, 0.0, 1.0, false, GetRotation ()), mWorld.GetZoomScale ());
               //new Transform2D (0.0, 0.0, GetScale (), IsFlipped (), GetRotation ()), mAssetManager.GetScale () * GetScale ());
      }

//====================================================================
//   clone
//====================================================================

      // to override
      override protected function CreateCloneShell ():Entity
      {
         return null;
      }

      // to override
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);

         var shape:EntityImageModuleShape = entity as EntityImageModuleShape;
      }
   }
}
