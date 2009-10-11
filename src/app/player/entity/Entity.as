
package player.entity {
   
   import flash.display.Sprite;
   
   import player.world.World;
   
   import player.physics.PhysicsProxy;
   
   import player.trigger.IPropertyOwner;
   import player.trigger.ValueSource;
   import player.trigger.ValueSource_Direct;
   
   import player.trigger.entity.EntityEventHandler;
   import player.trigger.data.ListElement_EventHandler;
   
   import common.trigger.CoreEventIds;
   
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
      
//=============================================================
//   event value sources, they are static, so parallel computing is not supported
//=============================================================
      
      protected static var mEventHandlerValueSource0:ValueSource_Direct = new ValueSource_Direct (null, null);
      protected static var mEventHandlerValueSourceList:ValueSource = mEventHandlerValueSource0;
      
      private var mInitializeEventHandlerList:ListElement_EventHandler = null;
      private var mUpdateEventHandlerList:ListElement_EventHandler = null;
      private var mDestroyEventHandlerList:ListElement_EventHandler = null;
      
      public function RegisterEventHandler (eventId:int, eventHandler:EntityEventHandler):void
      {
         switch (eventId)
         {
            case CoreEventIds.ID_OnEntityInitialized:
               mInitializeEventHandlerList = RegisterEventHandlerToList (mInitializeEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnEntityUpdated:
               mUpdateEventHandlerList = RegisterEventHandlerToList (mUpdateEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnEntityDestroyed:
               mDestroyEventHandlerList = RegisterEventHandlerToList (mDestroyEventHandlerList, eventHandler);
               break;
            default:
               break;
         }
      }
      
      public static function RegisterEventHandlerToList (list:ListElement_EventHandler, eventHandler:EntityEventHandler):ListElement_EventHandler
      {
         var  list_element:ListElement_EventHandler = list;
         
         while (list_element != null)
         {
            if (list_element.mEventHandler == eventHandler)
               return list;
            
            list_element = list_element.mNextListElement;
         }
         
         var new_element:ListElement_EventHandler = new ListElement_EventHandler (eventHandler);
         new_element.mNextListElement = list;
         
         return new_element;
      }
      
//=============================================================
//   intialize
//=============================================================
      
      final public function Initialize ():void
      {
         var  list_element:ListElement_EventHandler = mInitializeEventHandlerList;
         
         mEventHandlerValueSource0.mValueObject = this;
         
         while (list_element != null)
         {
            list_element.mEventHandler.HandleEvent (mEventHandlerValueSourceList);
            
            list_element = list_element.mNextListElement;
         }
      }
      
//=============================================================
//   update
//=============================================================
      
      final public function Update (dt:Number):void
      {
         UpdateInternal (dt);
         
         // external updaters
         
         var  list_element:ListElement_EventHandler = mUpdateEventHandlerList;
         
         mEventHandlerValueSource0.mValueObject = this;
         
         while (list_element != null)
         {
            list_element.mEventHandler.HandleEvent (mEventHandlerValueSourceList);
            
            list_element = list_element.mNextListElement;
         }
      }
      
      protected function UpdateInternal (dt:Number):void
      {
      }
      
//=============================================================
//   destroy
//=============================================================
      
      private var mAlreadyDestroyed:Boolean = false;
      
      final public function Destroy ():void
      {
         if (mAlreadyDestroyed)
            return;
         
         mAlreadyDestroyed = true;
         
         DestroyInternal ();
         
         DestroyPhysicsProxy ();
         
         var  list_element:ListElement_EventHandler = mDestroyEventHandlerList;
         
         mEventHandlerValueSource0.mValueObject = this;
         
         while (list_element != null)
         {
            list_element.mEventHandler.HandleEvent (mEventHandlerValueSourceList);
            
            list_element = list_element.mNextListElement;
         }
         
         //if (parent != null)
         //{
         //   parent.removeChild (this);
         //}
         mWorld.BufferChildToRemove (this);
      }
      
      //!!! DestroyInternal shouldn't destroy anything related with physics
      protected function DestroyInternal ():void
      {
      }
      
      public function DestroyPhysicsProxy ():void
      {
         if (mPhysicsProxy != null)
         {
            if (mWorld.IsPhysicsLocked ())
            {
               mWorld.BufferEntityToDestroyPhysicsProxy (this);
            }
            else
            {
               mPhysicsProxy.Destroy ();
               mPhysicsProxy = null;
            }
         }
      }
      
//=============================================================
//   build
//=============================================================
      
      public function RebuildAppearance ():void
      {
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
      
//=============================================================
//   
//=============================================================
      
      public function SetRotation (rot:Number):void
      {
         rotation = (rot * 180.0 / Math.PI) % 360;
      }
      
      public function GetRotation ():Number
      {
         return rotation;
      }
      
      public function IsPhysicsShapeEntity ():Boolean
      {
         return false;
      }
      
      public function GetPhysicsProxy ():PhysicsProxy
      {
         return mPhysicsProxy;
      }
      
      public function SetVisible (visible:Boolean):void
      {
         visible = visible;
      }
      
      public function IsVisible ():Boolean
      {
         return visible;
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
