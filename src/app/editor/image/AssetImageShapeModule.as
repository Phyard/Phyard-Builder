
package editor.image {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   
   import flash.geom.Rectangle;
   import flash.geom.Point;
   
   import flash.utils.ByteArray;
   
   import flash.events.Event;
   
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.asset.Asset;
   import editor.asset.AssetManager;
   
   import editor.image.vector.VectorShapeForEditing;
   
   import common.Transform2D;
   import common.shape.VectorShape;
  
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageShapeModule extends AssetImageModule
   {
      protected var mVectorShape:VectorShapeForEditing; // also is a VectorShape, must not be null
      protected var mIsValid:Boolean;
      
      // vectorShape must not be null
      public function AssetImageShapeModule (vectorShape:VectorShapeForEditing)
      {
         super (null); // no manager
         
         removeEventListener (Event.ADDED_TO_STAGE , OnAddedToStage); // added in super class
         
         mVectorShape = vectorShape;
         mIsValid = false;
      }
      
      public function GetVectorShape ():VectorShapeForEditing
      {
         return mVectorShape;
      }
      
      public function IsValid ():Boolean
      {
         return (mVectorShape as VectorShape).IsValid ();
      }
       
//=============================================================
//   
//=============================================================
      
      // return position
      public function OnCreating (points:Array):Point
      {
         return mVectorShape.OnCreating (points);
      }
      
//=============================================================
//   
//=============================================================

      override public function BuildImageModuleAppearance (container:Sprite, transform:Transform2D = null):void
      {
         var shapeSprite:DisplayObject = mVectorShape.CreateSprite ();
         
         if (transform != null )
            transform.TransformUntransformedDisplayObject (shapeSprite);
         
         container.addChild (shapeSprite);
      }
      
      override public function BuildImageModulePhysicsAppearance (container:Sprite, transform:Transform2D = null):void
      {
      }
      
      override public function BuildImageModuleSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void
      {
         mVectorShape.BuildSelectionProxy (selectionProxy, transform, visualScale);
      }
      
  }
}