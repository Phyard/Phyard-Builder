
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   
   
   import common.Define;
   import common.ValueAdjuster;
   import common.Config;
   
   public class EntityJointHinge extends EntityJoint 
   {
      
      public var mAnchor:SubEntityHingeAnchor;
      
      protected var mEnableLimits:Boolean = false;
      protected var mLowerAngle:Number = -30;
      protected var mUpperAngle:Number = 30;
      public var mEnableMotor:Boolean = false;
      public var mMotorSpeed:Number = Define.DefaultHingeMotorSpeed;
      public var mBackAndForth:Boolean = false;
      
      protected var mMaxMotorTorque:Number = Define.DefaultHingeMotorTorque; // v1.04
      
      public function EntityJointHinge (container:Scene)
      {
         super (container);
         
         mAnchor = new SubEntityHingeAnchor (container, this);
         mEntityContainer.addChild (mAnchor);
      }
      
      override public function GetTypeName ():String
      {
         return "Hinge Joint";
      }
      
      public function IsLimitsEnabled ():Boolean
      {
         return mEnableLimits;
      }
      
      public function SetLimitsEnabled (enabled:Boolean):void
      {
         mEnableLimits = enabled;
      }
      
      public function SetLimits (lower:Number, upper:Number):void
      {
         if (lower < upper)
         {
            mLowerAngle = lower;
            mUpperAngle = upper;
         }
         else
         {
            mLowerAngle = upper;
            mUpperAngle = lower;
         }
         
         UpdateAppearance ();
      }
      
      public function GetLowerLimit ():Number
      {
         return mLowerAngle;
      }
      
      public function GetUpperLimit ():Number
      {
         return mUpperAngle;
      }
      
      public function GetMaxMotorTorque ():Number
      {
         return mMaxMotorTorque;
      }
      
      public function SetMaxMotorTorque (maxMotorTorque:Number):void
      {
         if (maxMotorTorque < 0)
            maxMotorTorque = 0.0;
         
         mMaxMotorTorque = maxMotorTorque;
      }
      
      override public function Destroy ():void
      {
         mEntityContainer.DestroyAsset (mAnchor);
         
         super.Destroy ();
      }
      
      override public function UpdateJointPosition ():void
      {
         SetPosition (mAnchor.x, mAnchor.y);
         SetRotation (0.0);
      }
      
      public function GetAnchor ():SubEntityHingeAnchor
      {
         return mAnchor;
      }
      
//====================================================================
//   flip
//====================================================================
      /*
      override public function FlipSelfHorizontally ():void
      {
         //super.FlipSelfHorizontally ();
         
         FlipParams ();
      }
      
      override public function FlipSelfVertically ():void
      {
         //super.FlipSelfVertically ();
         
         FlipParams ();
      }
      */
      
      override public function FlipSelf (intentionDone:Boolean = true):void
      {
         super.FlipSelf (intentionDone);
         
         FlipParams ();
      }
      
      private function FlipParams ():void
      {
         SetLimits (- mUpperAngle, - mLowerAngle);
         
         mMotorSpeed = - mMotorSpeed;
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityJointHinge (mEntityContainer);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, 0, 0);
         
         var hinge:EntityJointHinge = entity as EntityJointHinge;
         
         hinge.SetLimitsEnabled ( IsLimitsEnabled () );
         hinge.SetLimits (GetLowerLimit (), GetUpperLimit ());
         hinge.mEnableMotor = mEnableMotor;
         hinge.mMotorSpeed = mMotorSpeed;
         hinge.mBackAndForth = mBackAndForth;
         hinge.mMaxMotorTorque = mMaxMotorTorque;
         
         var anchor:SubEntityHingeAnchor = GetAnchor ();
         var newAnchor:SubEntityHingeAnchor = hinge.GetAnchor ();
         
         anchor.SetPropertiesForClonedEntity (newAnchor, displayOffsetX, displayOffsetY);
         
         newAnchor.UpdateAppearance ();
         newAnchor.UpdateSelectionProxy ();
      }
      
      override public function GetSubAssets ():Array
      {
         return [mAnchor];
      }
      
      
   }
}
