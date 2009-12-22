package player.entity {
   
   import player.world.World;   
   import player.world.EntityList;   
   import player.physics.PhysicsProxy;

   import player.trigger.IPropertyOwner;
   import player.trigger.ValueSource;
   import player.trigger.ValueSource_Direct;
   
   import player.trigger.entity.EntityEventHandler;
   import player.trigger.data.ListElement_EventHandler;
   
   import common.trigger.CoreEventIds;
   
   import common.Define;
   import common.trigger.ValueDefine;
   
   public class Entity implements IPropertyOwner
   {
      protected var mCreationId:int = -1; // will not change once assigned
      protected var mAppearanceId:int = -1;
      
      // ...
      protected var mWorld:World;
      
      // an entity can registered into many EntityLists, BUT at the same time it can only stay in one list.
      // these variables should only be modified by EntityList class
      public var mEntityList:EntityList = null;
      public var mPrevEntity:Entity = null;
      public var mNextEntity:Entity = null;
      
      public var mIsToRemove:Boolean = false;
      public var mEntityListToAddIn:EntityList = null;

      public function Entity (world:World)
      {
         mWorld = world;
      }
      
//=============================================================
//   create
//=============================================================
      
      public function Register (creationId:int, appearanceId:int):void
      {
         mCreationId   = creationId;
         mAppearanceId = appearanceId;
         
         mWorld.RegisterEntity (this);
      }
      
      public function Create (createStageId:int, entityDefine:Object):void
      {
         if (createStageId == 0)
         {
            if (entityDefine.mPosX != undefined)
               SetPositionX (mWorld.GetCoordinateSystem ().D2P_PositionX (entityDefine.mPosX));
            if (entityDefine.mPosY != undefined)
               SetPositionY (mWorld.GetCoordinateSystem ().D2P_PositionY (entityDefine.mPosY));
            if (entityDefine.mRotation != undefined)
               SetRotation  (mWorld.GetCoordinateSystem ().D2P_RotationRadians (entityDefine.mRotation));
            if (entityDefine.mIsVisible != undefined)
               SetVisible   (entityDefine.mIsVisible);
            if (entityDefine.mAlpha != undefined)
               SetAlpha     (entityDefine.mAlpha);
            if (entityDefine.mIsActive != undefined)
               SetActive    (entityDefine.mIsActive);
         }
      }
      
//=============================================================
//   for entities in editor
//=============================================================
      
      public function GetWorld ():World
      {
         return mWorld;
      }
      
      public function IsDefinedInEditor ():Boolean
      {
         return mCreationId >= 0;
      }
      
      public function GetAppearanceId ():int
      {
         return mAppearanceId;
      }
      
      public function GetCreationId ():int
      {
         return mCreationId;
      }
      
      internal function GetMainEntity ():Entity
      {
         return this; // for SubEntity to override
      }
      
//=============================================================
//   
//=============================================================
      
      internal var mPositionX:Number = 0.0;
      internal var mPositionY:Number = 0.0;
      internal var mRotation:Number = 0.0;
      internal var mVisible:Boolean = true;
      internal var mAlpha:Number = 1.0;
      internal var mIsActive:Boolean = true;
      internal var mIsEnabled:Boolean = true;
      
      // here, for shapes, the SetPosition will not not change the mass of the body of shape,
      // also not call shape.UpdateLocalPosition.
      // Those functions must be called mannually if needed.
      
      public function SetPositionX (x:Number):void
      {
         mPositionX = x;
      }
      
      public function SetPositionY (y:Number):void
      {
         mPositionY = y;
      }
      
      public function GetPositionX ():Number
      {
         return mPositionX;
      }
      
      public function GetPositionY ():Number
      {
         return mPositionY;
      }
      
      public function SetRotation (rot:Number):void
      {
         mRotation = rot % Define.kPI_x_2;
      }
      
      public function GetRotation ():Number
      {
         return mRotation;
      }
      
      public function SetVisible (visible:Boolean):void
      {
         mVisible = visible;
         
         DelayUpdateAppearance ();
      }
      
      public function IsVisible ():Boolean
      {
         return mVisible;
      }
      
      public function SetAlpha (alpha:Number):void
      {
         mAlpha = alpha;
         
         DelayUpdateAppearance ();
      }
      
      public function GetAlpha ():Number
      {
         return mAlpha;
      }
      
      public function SetActive (active:Boolean):void
      {
         mIsActive = active;
      }
      
      public function IsActive ():Boolean
      {
         return mIsActive;
      }
      
      public function SetEnabled (enabled:Boolean):void
      {
         mIsEnabled = enabled;
      }
      
      public function IsEnabled ():Boolean
      {
         return mIsEnabled;
      }
      
//====================================================================================================
//   event value sources, they are static, so parallel computing is not supported
//====================================================================================================
      
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
      
      protected var mAlreadyInitialized:Boolean = false;
      
      public function IsInitializedAlready ():Boolean
      {
         return mAlreadyInitialized;
      }
      
      final public function Initialize ():void
      {
         if (mAlreadyDestroyed || mAlreadyInitialized) // if is possible an entity initialized before this entity has made this entity destroyed.
            return;
         
         mAlreadyInitialized = true;
         
         InitializeInternal ();
         
         var  list_element:ListElement_EventHandler = mInitializeEventHandlerList;
         
         mEventHandlerValueSource0.mValueObject = this;
         
         while (list_element != null)
         {
            list_element.mEventHandler.HandleEvent (mEventHandlerValueSourceList);
            
            list_element = list_element.mNextListElement;
         }
      }
      
      protected function InitializeInternal ():void
      {
         // to override
      }
      
//=============================================================
//   update
//=============================================================
      
      final public function Update (dt:Number):void
      {
         if (mAlreadyDestroyed)
            return;
         
         UpdateInternal (dt);
         
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
         // to override
      }
      
//=============================================================
//   destroy
//=============================================================
      
      protected var mAlreadyDestroyed:Boolean = false;
      
      public var mNextEntityToDelayRemove:Entity = null;
      
      public function IsDestroyedAlready ():Boolean
      {
         return mAlreadyDestroyed;
      }
      
      // this function is for outer packages.
      // EntityShapes overrides this function
      public function DestroyEntity ():void
      {
         GetMainEntity ().Destroy (); // a main entity must destroy its sub entities
      }
      
      // this one is for internal 
      final internal function Destroy ():void
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
         
         mWorld.UnregisterEntity (this);
      }
      
      //!!! DestroyInternal shouldn't destroy anything related with physics
      protected function DestroyInternal ():void
      {
      }
      
//=============================================================
//   appearance
//=============================================================
      
      // defaultly, DelayRebuildAppearance will be delayed. If a RebuildAppearance is really needed to excute, call RebuildAppearance instead.
      
      public var mNextEntityToDelayUpdateAppearance:Entity = null;
      
      public var mIsAlreadyInDelayUpdateAppearanceList:Boolean = false;
      
      final public function DelayUpdateAppearance ():void
      {
         if (! mIsAlreadyInDelayUpdateAppearanceList)
         {
            mIsAlreadyInDelayUpdateAppearanceList = true;
            mWorld.DelayUpdateEntityAppearance (this);
         }
      }
      
      // to override
      public function UpdateAppearance ():void // used internally
      {
         // to overrride
      }
      
//=============================================================
//   physics proxy
//
//   !!! can't call any function which will change the physics world in mWorld.StepPhysicsWorld
//=============================================================
      
      internal var mPhysicsProxy:PhysicsProxy = null;
      
      public function GetPhysicsProxy ():PhysicsProxy
      {
         return mPhysicsProxy;
      }
      
      public function DestroyPhysicsProxy ():void
      {
         if (mPhysicsProxy != null)
         {
            mPhysicsProxy.Destroy ();
            mPhysicsProxy = null;
         }
      }
      
//=============================================================
//   
//=============================================================
      
      public function SynchronizeWithPhysicsProxy ():void
      {
         // to ovrride
      }
      
//==============================================================================
// as task
//==============================================================================
      
      protected var mTaskStatus_UserAssigned:int = ValueDefine.LevelStatus_Unfinished;
      
      public function IsTaskSuccessed ():Boolean
      {
         return mTaskStatus_UserAssigned == ValueDefine.LevelStatus_Successed;
      }
      
      public function SetTaskSuccessed ():void
      {
         mTaskStatus_UserAssigned = ValueDefine.LevelStatus_Successed;
      }
      
      public function IsTaskFailed ():Boolean
      {
         return mTaskStatus_UserAssigned == ValueDefine.LevelStatus_Failed;
      }
      
      public function SetTaskFailed ():void
      {
         mTaskStatus_UserAssigned = ValueDefine.LevelStatus_Failed;
      }
      
      public function IsTaskUnfinished ():Boolean
      {
         return mTaskStatus_UserAssigned == ValueDefine.LevelStatus_Unfinished;
      }
      
      public function SetTaskUnfinished ():void
      {
         mTaskStatus_UserAssigned = ValueDefine.LevelStatus_Unfinished;
      }
      
//==============================================================================
// as property owner
//==============================================================================
      
      public function GetPropertyValue (propertyId:int):Object
      {
         return null;
      }
      
      public function SetPropertyValue (propertyId:int, value:Object):void
      {
      }
      
//==============================================================================
// some variables for APIs
//==============================================================================
      
   // for some API convinience
      
      internal var mSpecialId:int = 0;
      internal static var sLastSpecialId:int = 0;
      
      internal function IncreaseLastSpecialId ():void
      {
         if (sLastSpecialId == 0x7FFFFFFF)
            ResetEntitySpecialIds (); // generally, this will not happen
         
         ++ sLastSpecialId;
      }
      
      protected function ResetEntitySpecialIds ():void
      {
         sLastSpecialId = 0;
         
         mWorld.ResetEntitySpecialIds ();
      }
      
      public function ResetSpecialId ():void
      {
         mSpecialId = 0;
      }
   }
}
