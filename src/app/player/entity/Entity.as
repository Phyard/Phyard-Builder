
package player.entity {
   
   import flash.display.Sprite;
   
   import player.world.World;
   
   import player.physics.PhysicsProxy;
   
   import common.Define;
   
   public class Entity extends Sprite
   {
      protected var mEntityType:int = Define.EntityType_Unkonwn;
      protected var mEntityId:int = -1;
      
      protected var mWorld:World;
      
      public var mPhysicsProxy:PhysicsProxy = null;
      
      public function Entity (world:World)
      {
         mWorld = world;
      }
      
      public function GetEntityId ():int
      {
         return mEntityId;
      }
      
      public function Update (dt:Number):void
      {
      }
      
      public function Destroy ():void
      {
         DestroyPhysicsProxy ();
      }
      
      public function SetRotation (rot:Number):void
      {
         rotation = (rot * 180.0 / Math.PI) % 360;
      }
      
      public function GetRotation ():Number
      {
         return rotation;
      }
      
//=============================================================
//   
//=============================================================
      
      public function RebuildAppearance ():void
      {
      }
      
//=============================================================
//   
//=============================================================
      
      public function IsPhysicsEntity ():Boolean
      {
         return true;
      }
      
      public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         mEntityType = params.mEntityType;
         
         // >> from version 1.01
         mEntityId = params.mEntityId;
         // <<
         
         if (Compile::Is_Debugging)
         {
            visible = true;
         }
         else
         {
            visible = params.mIsVisible;
         }
      }
      
      public function DestroyPhysicsProxy ():void
      {
         if (mPhysicsProxy != null)
            mPhysicsProxy.Destroy ();
      }
      
      public function GetPhysicsProxy ():PhysicsProxy
      {
         return mPhysicsProxy;
      }
      
   }
}
