
package editor.entity {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import editor.world.EntityContainer;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.Resource;
   
   
   import common.Define;
   
   public class EntityUtilityCamera extends EntityUtility 
   {
      private var mCameraBitmap:Bitmap = new Resource.IconCamera ();
      private var mBackgroundShape:Shape = new Shape ();
      
      private var mCameraWidth:uint = 600;
      private var mCameraHeight:uint = 600;
      
      public function EntityUtilityCamera (container:EntityContainer)
      {
         super (container);
         
         SetVisible (false);
         
         addChild (mCameraBitmap);
         mCameraBitmap.x = - mCameraBitmap.bitmapData.width * 0.5;
         mCameraBitmap.y = - mCameraBitmap.bitmapData.height * 0.5;
         
         addChild (mBackgroundShape);
      }
      
      override public function GetTypeName ():String
      {
         return "Camera";
      }
      
      override public function GetPhysicsShapesCount ():uint
      {
         return 0;
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mFollowedTarget:int = Define.Camera_FollowedTarget_Brothers; //Camera_FollowedTarget_Self;
      protected var mFollowingStyle:int = Define.Camera_FollowingStyle_Default;
      
      public function SetFollowedTarget (target:int):void
      {
         mFollowedTarget = target;
      }
      
      public function GetFollowedTarget ():int
      {
         return mFollowedTarget;
      }
      
      public function SetFollowingStyle (style:int):void
      {
         mFollowingStyle = style;
      }
      
      public function GetFollowingStyle ():int
      {
         return mFollowingStyle;
      }
      
//=============================================================
//   
//=============================================================
      
      override public function UpdateAppearance ():void
      {
         mCameraBitmap.alpha = 0.7;
         mBackgroundShape.alpha = 0.7;
         
         var borderColor:uint = 0x0;
         var borderThickness:uint = 2;
         var drawBg:Boolean = false;
         var filledColor:uint = 0x0000FF;
         
         GraphicsUtil.Clear (mBackgroundShape)
         
         if ( IsSelected () )
         {
            borderColor = Define.BorderColorSelectedObject;
            if (borderThickness * mEntityContainer.GetZoomScale () < 3)
               borderThickness  = 3.0 / mEntityContainer.GetZoomScale ();
            
            //GraphicsUtil.DrawRect (mBackgroundShape, - mCameraWidth * 0.5, - mCameraHeight * 0.5, mCameraWidth, mCameraHeight, borderColor, borderThickness, false, filledColor);
         }
         
         GraphicsUtil.DrawRect (mBackgroundShape, - mCameraBitmap.width * 0.5, - mCameraBitmap.height * 0.5, mCameraBitmap.bitmapData.width, mCameraBitmap.bitmapData.height, borderColor, borderThickness, false, filledColor);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mEntityContainer.mSelectionEngine.CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
         }
         
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle (GetPositionX (), GetPositionY (), mCameraBitmap.width * 0.5, mCameraBitmap.height * 0.5, GetRotation ());
      }
      
//====================================================================
//   clone
//====================================================================
      
      // only one gc most in a scene
      override protected function CreateCloneShell ():Entity
      {
         return new EntityUtilityCamera (mEntityContainer);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var camera:EntityUtilityCamera = entity as EntityUtilityCamera;
         
         camera.SetFollowedTarget (GetFollowedTarget ());
         camera.SetFollowingStyle (GetFollowingStyle ());
      }
      
   }
}
