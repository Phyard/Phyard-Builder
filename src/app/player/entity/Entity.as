
package player.entity {
   
   import flash.display.Sprite;
   
   import player.world.World;
   
   import player.physics.PhysicsProxy;
   
   import player.trigger.IPropertyOwner;
   
   import common.Define;
   
   public class Entity extends Sprite implements IPropertyOwner
   {
      public var mEntityIndexInEditor:int = -1;
      protected var mEntityType:int = Define.EntityType_Unkonwn;
      
      protected var mWorld:World;
      
      public var mPhysicsProxy:PhysicsProxy = null;
      
      public function Entity (world:World)
      {
         mWorld = world;
      }
      
      public function GetEntityIndexInEditor ():int
      {
         return mEntityIndexInEditor;
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
         mEntityIndexInEditor = params.mEntityIndexInEditor;
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
      
//==============================================================================
// command initerface
//==============================================================================
      
      public function ExecuteCommand (commandName:String, params:Object):Boolean
      {
         switch (commandName)
         {
            case "SetVisible":
               SetVisible (params.visible);
               break;
            default:
               return false;
         }
         
         return true;
      }
      
//==============================================================================
// commands
//==============================================================================
      
      public function SetVisible (visible:Boolean):void
      {
         visible = visible;
      }
      
//==============================================================================
// properties
//==============================================================================
      
      public function GetPropertyValue (propertyId:int):Object
      {
         return null;
      }
      
      public function SetPropertyValue (propertyId:int, value:Object):void
      {
      }
      
   }
}
