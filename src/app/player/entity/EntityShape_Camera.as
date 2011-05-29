
package player.entity {
   
   import flash.geom.Point;
   
   import player.world.World;
   
   import common.Define;
   
   public class EntityShape_Camera extends EntityShape
   {
      public function EntityShape_Camera (world:World)
      {
         super (world);
         
         mAiTypeChangeable = false;
      }
      
      override public function IsVisualShape ():Boolean
      {
         return false;
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mFollowedTarget != undefined)
               SetFollowedTarget (entityDefine.mFollowedTarget);
            if (entityDefine.mFollowingStyle != undefined)
               SetFollowingStyle (entityDefine.mFollowingStyle);
         }
      }
      
     override public function ToEntityDefine (entityDefine:Object):Object
     {
         super.ToEntityDefine (entityDefine);
         
         entityDefine.mFollowedTarget = GetFollowedTarget ();
         entityDefine.mFollowingStyle = GetFollowingStyle ();
         
         entityDefine.mEntityType = Define.EntityType_UtilityCamera;
         
         return entityDefine;
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
//   initialize
//=============================================================
      
      override protected function InitializeInternal ():void
      {
         var targetEntity:Entity = null;
         
         if (mFollowedTarget == Define.Camera_FollowedTarget_Self)
            targetEntity = this;
         else if (mFollowedTarget == Define.Camera_FollowedTarget_Brothers)
            targetEntity = mBody;
         
         if (targetEntity != null)
         {
            if ((mFollowingStyle & Define.Camera_FollowingStyle_X) == Define.Camera_FollowingStyle_X)
               mWorld.FollowCameraCenterXWithEntity (targetEntity, (mFollowingStyle & Define.Camera_FollowingStyle_SmoothlyX) == Define.Camera_FollowingStyle_SmoothlyX);
            if ((mFollowingStyle & Define.Camera_FollowingStyle_Y) == Define.Camera_FollowingStyle_Y)
               mWorld.FollowCameraCenterYWithEntity (targetEntity, (mFollowingStyle & Define.Camera_FollowingStyle_SmoothlyY) == Define.Camera_FollowingStyle_SmoothlyY);
            if ((mFollowingStyle & Define.Camera_FollowingStyle_Angle) == Define.Camera_FollowingStyle_Angle)
               mWorld.FollowCameraAngleWithEntity (targetEntity, (mFollowingStyle & Define.Camera_FollowingStyle_SmoothlyAngle) == Define.Camera_FollowingStyle_SmoothlyAngle);
         }
      }
      
   }
   
}
