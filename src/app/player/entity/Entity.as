package player.entity {

   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;

   import player.world.World;
   import player.world.EntityList;
   import player.physics.PhysicsProxy;

   import player.trigger.Parameter;
   import player.trigger.Parameter_Direct;

   import player.trigger.VariableSpace;
   import player.trigger.VariableInstance;

   import player.trigger.entity.EntityEventHandler;
   import player.trigger.data.ListElement_EventHandler;

   import player.design.Global;

   import common.trigger.CoreEventIds;

   import common.Define;
   import common.trigger.ValueDefine;

   public class Entity
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
            if (entityDefine.mIsEnabled != undefined)
               SetEnabled    (entityDefine.mIsEnabled);
         }
      }

      public function ToEntityDefine (entityDefine:Object):Object
      {
         entityDefine.mPosX = mWorld.GetCoordinateSystem ().P2D_PositionX (GetPositionX ());
         entityDefine.mPosY = mWorld.GetCoordinateSystem ().P2D_PositionY (GetPositionY ());
         entityDefine.mRotation = mWorld.GetCoordinateSystem ().P2D_RotationRadians (GetRotation  ());
         entityDefine.mIsVisible = IsVisible   ();
         entityDefine.mAlpha = GetAlpha     ();
         entityDefine.mIsEnabled = IsEnabled    ();

         entityDefine.mEntityType = Define.EntityType_Unkonwn;

         return null;
      }

      public function ToString ():String
      {
         return "Entity#" + mCreationId;
      }

//=============================================================
//
//=============================================================

      public function Clone ():Entity
      {
         return null; // to override
      }

//=============================================================
//   for entities in editor
//=============================================================

      public function GetWorld ():World
      {
         return mWorld;
      }

      // removed from v1.56
      //public function IsDefinedInEditor ():Boolean
      //{
      //   return mCreationId >= 0;
      //}

      public function GetAppearanceId ():int
      {
         return mAppearanceId;
      }

      public function SetCreationId (creationId:int):void
      {
         mCreationId = creationId;
      }

      public function GetCreationId ():int
      {
         return mCreationId;
      }

      internal function GetMainEntity ():Entity
      {
         return this; // SubEntity need to override this function
      }

//=============================================================
//
//=============================================================

      internal var mPositionX:Number = 0.0;
      internal var mPositionY:Number = 0.0;
      internal var mPhysicsRotation:Number = 0.0; // here, use a word "physics" to indicate the value is not limited between 0 and 2 * PI
      protected var mRotationInTwoPI:Number; // this is the rotation value represent the rotation direction. Value range: [0, 2 * PI)
                                             // it is not the Sprite.rotation.
                                             // this value only modified in SetRotation and is related with mPhysicsRotation,
                                             // so DON'T assign value to mPhysicsRotation directly, please use SetRotation instead.
                                             // use this variable for efficiency. Maybe it is not very essential and calculate it in GetRotationInTwoPI runtimely.

      protected var mVisible:Boolean = true;
      protected var mAlpha:Number = 1.0;
      protected var mIsEnabled:Boolean = true;

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

      // the value exposed to API is in range [0, PI * 2).
      // for internal flash display object, Sprite.rotation is in range [-180, 180).
      //
      // this method will never be exposed to designers! Use SetPhysicsRotation instead
      //public function SetRotation (rot:Number):void
      //{
      //   mRotation = rot % Define.kPI_x_2;
      //   if (mRotation < 0) // should not
      //   {
      //      mRotation += Define.kPI_x_2;
      //   }
      //}
      //
      //public function GetRotation ():Number
      //{
      //   // for EntityBody, the value is not limited between [0, 2 * PI)
      //   return mRotation;
      //}

      // here use internal, is to avoid be called by APIs
      internal function SetRotation (rot:Number):void
      {
         mPhysicsRotation = rot;

         mRotationInTwoPI = rot % Define.kPI_x_2;
         if (mRotationInTwoPI < 0) // should not, just make sure
         {
            mRotationInTwoPI += Define.kPI_x_2;
         }
      }

      public function GetRotation ():Number
      {
         return mPhysicsRotation;
      }

      public function GetRotationInTwoPI ():Number
      {
         return mRotationInTwoPI;
      }

      // to avoid a large rotation jump
      // targetRotation - shape.GetRotation ()
      // the targetRotation value just represents a direction.
      public function GetRotationOffset (targetRotation:Number):Number
      {
         var offset:Number = targetRotation - mPhysicsRotation;
         offset = offset % Define.kPI_x_2;
         if (offset > Math.PI)
            offset -= Math.PI;

         return offset;
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

      public function SetEnabled (enabled:Boolean):void
      {
         if (CanBeDisabled ())
         {
            mIsEnabled = enabled;
         }
      }

      public function IsEnabled ():Boolean
      {
         return mIsEnabled;
      }

      protected function CanBeDisabled ():Boolean
      {
         return false;
      }

//====================================================================================================
//   custom properties
//====================================================================================================

      //protected var mCustomProeprtySpaces:Array = new Array (); // v1.52 only
      protected var mCustomProeprtySpace:VariableSpace;

      public function InitCustomPropertyValues ():void
      {
         mCustomProeprtySpace = Global.CloneEntityPropertyInitialValues ();
      }

      public function GetCustomProperty (spaceId:int, propertyId:int):Object
      {
         //if (spaceId < 0 || spaceId >= mCustomProeprtySpaces.length)
         //   return null;
         //
         //return (mCustomProeprtySpaces [spaceId] as VariableSpace).GetVariableAt (propertyId).GetValueObject ();

         var vi:VariableInstance = mCustomProeprtySpace.GetVariableAt (propertyId);
         if (vi != null)
         {
            return vi.GetValueObject ();
         }

         if (propertyId < 0)
            return null;

         return vi == Global.GetDefaultEntityPropertyValue (propertyId);
      }

      public function SetCustomProperty (spaceId:int, propertyId:int, valueObject:Object):void
      {
         //if (spaceId < 0 || spaceId >= mCustomProeprtySpaces.length)
         //   return;
         //
         //var vi:VariableInstance = (mCustomProeprtySpaces [spaceId] as VariableSpace).GetVariableAt (propertyId);

         var vi:VariableInstance = mCustomProeprtySpace.GetVariableAt (propertyId);
         if (vi != null)
         {
            vi.SetValueObject (valueObject);
         }
      }

//====================================================================================================
//   event value sources, they are static, so parallel computing is not supported
//====================================================================================================

      protected static var mEventHandlerValueSource0:Parameter_Direct = new Parameter_Direct (null, null);
      protected static var mEventHandlerValueSourceList:Parameter = mEventHandlerValueSource0;

      private var mCreateEventHandlerList:ListElement_EventHandler = null;
      private var mInitializeEventHandlerList:ListElement_EventHandler = null;
      private var mUpdateEventHandlerList:ListElement_EventHandler = null;
      private var mDestroyEventHandlerList:ListElement_EventHandler = null;

      public function RegisterEventHandler (eventId:int, eventHandler:EntityEventHandler):void
      {
         switch (eventId)
         {
            case CoreEventIds.ID_OnEntityCreated:
               mCreateEventHandlerList = RegisterEventHandlerToList (mCreateEventHandlerList, eventHandler);
               break;
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

      protected static function RegisterEventHandlerToList (list:ListElement_EventHandler, eventHandler:EntityEventHandler):ListElement_EventHandler
      {
         var  list_element:ListElement_EventHandler = list;

         // avoid duplicated ones
         while (list_element != null)
         {
            if (list_element.mEventHandler == eventHandler)
               return list;

            list_element = list_element.mNextListElement;
         }

         // ok, not exist yet, add it as new
         var new_element:ListElement_EventHandler = new ListElement_EventHandler (eventHandler);
         new_element.mNextListElement = list;

         return new_element;
      }

//=============================================================
//   on created
//=============================================================

      public function OnCreated ():void
      {
         var list_element:ListElement_EventHandler = mCreateEventHandlerList;

         mEventHandlerValueSource0.mValueObject = this;

         mWorld.IncStepStage ();
         while (list_element != null)
         {
            list_element.mEventHandler.HandleEvent (mEventHandlerValueSourceList);

            list_element = list_element.mNextListElement;
         }
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

         var list_element:ListElement_EventHandler = mInitializeEventHandlerList;

         mEventHandlerValueSource0.mValueObject = this;

         mWorld.IncStepStage ();
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

         mWorld.IncStepStage ();
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

      // this one is for internal, reasons:
      // - avoid destroying a sub entity only
      // DestroyEntity is for external use
      final internal function Destroy ():void
      {
         if (mAlreadyDestroyed)
            return;

         mAlreadyDestroyed = true;

         DestroyInternal ();

         DestroyPhysicsProxy ();

         var list_element:ListElement_EventHandler = mDestroyEventHandlerList;

         mEventHandlerValueSource0.mValueObject = this;

         mWorld.IncStepStage ();
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
         if (! (mIsAlreadyInDelayUpdateAppearanceList || mAlreadyDestroyed))
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

      protected var mAppearanceObject:DisplayObject = null;

      final public function AdjustAppearanceOrder (relativeTo:Entity, frontOfRelativeTo:Boolean):void
      {
         if (mAppearanceObject == null)
            return;

         var layerContainer:DisplayObjectContainer;

         if (relativeTo == null)
         {
            layerContainer = mAppearanceObject.parent as DisplayObjectContainer;
            if (layerContainer != null)
            {
               layerContainer.removeChild (mAppearanceObject);
               if (frontOfRelativeTo)
                  layerContainer.addChild (mAppearanceObject);
               else
                  layerContainer.addChildAt (mAppearanceObject, 0);
            }
         }
         else if (relativeTo.mAppearanceObject != null)
         {
            layerContainer = relativeTo.mAppearanceObject.parent as DisplayObjectContainer;
            if (layerContainer != null)
            {
               layerContainer.addChildAt (mAppearanceObject, layerContainer.getChildIndex (relativeTo.mAppearanceObject) + (frontOfRelativeTo ? 1 : 0));
            }
         }
      }

//=============================================================
//   physics proxy
//
//   !!! can't call any function which will change the physics world in mWorld.StepPhysicsWorld
//=============================================================

      internal var mPhysicsProxy:PhysicsProxy = null;

      public function IsPhysicsBuilt ():Boolean
      {
         return mPhysicsProxy != null;
      }

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
// mouse event
//==============================================================================



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
