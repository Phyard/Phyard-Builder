
package editor.image {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   
   import flash.geom.Rectangle;
   import flash.geom.Point;
   
   import flash.utils.ByteArray;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
         
   import flash.net.FileReference;
   import flash.net.FileFilter;
   import flash.events.IOErrorEvent;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.LocalImageLoader;
   
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.asset.Asset;
   import editor.asset.AssetManager;
   
   import editor.image.vector.VectorShape;
   import editor.image.vector.VectorShapeForEditing;
   
   import common.Transform2D;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageShapeModule extends AssetImageModule
   {
      protected var mVectorShape:VectorShapeForEditing; // also is a VectorShape
      protected var mIsValid:Boolean;
      
      // vectorShape must not be null
      public function AssetImageShapeModule (vectorShape:VectorShapeForEditing)
      {
         super (null); // no manager
         
         removeEventListener (Event.ADDED_TO_STAGE , OnAddedToStage); // added in super class
         
         mVectorShape = vectorShape;
         mIsValid = false;
      }
      
      public function IsValid ():Boolean
      {
         return mVectorShape == null ? false : (mVectorShape as VectorShape).IsValid ();
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
         
         if (shapeSprite != null)
         {
            if (transform != null )
               transform.TransformUntransformedDisplayObject (shapeSprite);
            
            container.addChild (shapeSprite);
         }
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