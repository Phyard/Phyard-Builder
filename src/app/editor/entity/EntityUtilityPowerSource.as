
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
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.runtime.Resource;
   
   
   import common.Define;
   
   public class EntityUtilityPowerSource extends EntityUtility 
   {
      private var mPowerSourceBitmap:Bitmap = null;
      private var mBorderShape:Shape = new Shape ();
      
      public function EntityUtilityPowerSource (world:World)
      {
         super (world);
         
         SetVisible (false);
         
         SetPowerSourceType (Define.PowerSource_Force);
         
         addChild (mBorderShape);
      }
      
      override public function GetTypeName ():String
      {
         return "Powner Source";
      }
      
      override public function GetPhysicsShapesCount ():uint
      {
         return 0;
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mPowerSourceType:int = -1;
      protected var mPowerMagnitude:Number = 0.0;
      
      public function SetPowerSourceType (type:int):void
      {
         if (mPowerSourceType == type)
            return;
         
         if (mPowerSourceBitmap != null)
            removeChild (mPowerSourceBitmap);
         
         mPowerSourceType = type;
         
         switch (mPowerSourceType)
         {
            case Define.PowerSource_Torque:
               mPowerSourceBitmap = new Resource.IconTorque ();
               break;
            case Define.PowerSource_LinearImpusle:
               mPowerSourceBitmap = new Resource.IconLinearImpulse ();
               break;
            case Define.PowerSource_AngularImpulse:
               mPowerSourceBitmap = new Resource.IconAngularImpulse ();
               break;
            case Define.PowerSource_LinearVelocity:
               mPowerSourceBitmap = new Resource.IconLinearVelocity ();
               break;
            case Define.PowerSource_AngularVelocity:
               mPowerSourceBitmap = new Resource.IconAngularVelocity ();
               break;
            case Define.PowerSource_Force:
            default:
               mPowerSourceType = Define.PowerSource_Force;
               mPowerSourceBitmap = new Resource.IconForce ();
               break;
         }
         
         if (mPowerSourceBitmap != null)
         {
            addChildAt (mPowerSourceBitmap, 0);
            mPowerSourceBitmap.x = - mPowerSourceBitmap.bitmapData.width * 0.5;
            mPowerSourceBitmap.y = - mPowerSourceBitmap.bitmapData.height * 0.5;
         }
      }
      
      public function GetPowerSourceType ():int
      {
         return mPowerSourceType;
      }
      
      public function SetPowerMagnitude (magnitude:Number):void
      {
         mPowerMagnitude = magnitude;
      }
      
      public function GetPowerMagnitude ():Number
      {
         return mPowerMagnitude;
      }
      
//=============================================================
//   
//=============================================================
      
      override public function UpdateAppearance ():void
      {
         mPowerSourceBitmap.alpha = 0.7;
         mBorderShape.alpha = 0.7;
         
         var borderColor:uint = 0x0;
         var borderThickness:uint = 2;
         var drawBg:Boolean = false;
         var filledColor:uint = 0x0000FF;
         
         GraphicsUtil.Clear (mBorderShape)
         
         if ( IsSelected () )
         {
            borderColor = Define.BorderColorSelectedObject;
            if (borderThickness * mWorld.GetZoomScale () < 3)
               borderThickness  = 3.0 / mWorld.GetZoomScale ();
         }
         
         GraphicsUtil.DrawRect (mBorderShape, - mPowerSourceBitmap.width * 0.5, - mPowerSourceBitmap.height * 0.5, mPowerSourceBitmap.bitmapData.width, mPowerSourceBitmap.bitmapData.height, borderColor, borderThickness, false, filledColor);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mWorld.mSelectionEngine.CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
         }
         
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle ( GetRotation (), GetPositionX (), GetPositionY (), mPowerSourceBitmap.width * 0.5, mPowerSourceBitmap.height * 0.5);
      }
      
//====================================================================
//   clone
//====================================================================
      
      // only one gc most in a scene
      override protected function CreateCloneShell ():Entity
      {
         return new EntityUtilityPowerSource (mWorld);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var power_source:EntityUtilityPowerSource = entity as EntityUtilityPowerSource;
         
         power_source.SetPowerSourceType (GetPowerSourceType ());
         power_source.SetPowerMagnitude (GetPowerMagnitude ());
      }
      
   }
}
