
package player.entity {
   
   import flash.geom.Point;
   
   import player.world.World;
   
   import player.trigger.entity.EntityEventHandler;
   import player.trigger.entity.EntityEventHandler_Keyboard;
   
   import common.trigger.CoreFunctionIds;
   import common.trigger.CoreEventIds;
   import common.trigger.FunctionCoreBasicDefine;
   import common.trigger.CoreFunctionDeclarations;
   
   import common.trigger.FunctionTypeDefine;
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueTargetTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.CoreClassIds;
   
   import common.trigger.define.FunctionDefine;
   import common.trigger.define.CodeSnippetDefine;
   import common.trigger.define.FunctionCallingDefine;
   import common.trigger.define.ValueSourceDefine_Direct;
   
   import common.KeyCodes;
   import common.Define;
   
   public class EntityShape_PowerSource extends EntityShape
   {
      public function EntityShape_PowerSource (world:World)
      {
         super (world);
         
         mAiTypeChangeable = false;
      }
      
      override public function IsVisualShape ():Boolean
      {
         return false;
      }
      
      override public function SetEnabled (enabled:Boolean):void
      {
         super.SetEnabled (enabled);
         
         if (mEventHandler != null)
            mEventHandler.SetEnabled (IsEnabled ());
      }
      
      override protected function CanBeDisabled ():Boolean
      {
         return true;
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object, extraInfos:Object):void
      {
         super.Create (createStageId, entityDefine, extraInfos);
         
         if (createStageId == 0)
         {
            if (entityDefine.mPowerSourceType != undefined && entityDefine.mPowerMagnitude != undefined)
            {
               SetPowerSourceType (entityDefine.mPowerSourceType);
               mPowerMagnitude = entityDefine.mPowerMagnitude;
               
               var eventHandlerDefine:Object = new Object ();
               //entityDefine.mEventHandlerDefine = eventHandlerDefine;
               entityDefine.mLoadingTimeInfos.mEventHandlerDefine = eventHandlerDefine;
               
               var functionDefine:FunctionDefine = new FunctionDefine ();
               eventHandlerDefine.mFunctionDefine = functionDefine;
               
               var codeSnippetDefine:CodeSnippetDefine = new CodeSnippetDefine ();
               functionDefine.mCodeSnippetDefine = codeSnippetDefine;
               
               codeSnippetDefine.mName = "";
               codeSnippetDefine.mNumCallings = 1;
               
               var callingDefine:FunctionCallingDefine = new FunctionCallingDefine ();
               codeSnippetDefine.mFunctionCallingDefines = [callingDefine];
               
               callingDefine.mFunctionType = FunctionTypeDefine.FunctionType_Core;
               
               var functionDecalaration:FunctionCoreBasicDefine = null;
               switch (mPowerSourceType)
               {
                  case Define.PowerSource_Torque:
                     //SetPowerMagnitude (mWorld.GetCoordinateSystem ().D2P_Torque (entityDefine.mPowerMagnitude));
                     functionDecalaration = CoreFunctionDeclarations.GetCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepTorque);
                     callingDefine.mInputValueSourceDefines = [
                              new ValueSourceDefine_Direct (/*CoreClassIds.ValueType_Entity, */mCreationId), 
                              new ValueSourceDefine_Direct (/*CoreClassIds.ValueType_Number, */entityDefine.mPowerMagnitude)
                        ];
                     break;
                  case Define.PowerSource_LinearImpusle:
                     //SetPowerMagnitude (mWorld.GetCoordinateSystem ().D2P_ImpulseMagnitude (entityDefine.mPowerMagnitude));
                     functionDecalaration = CoreFunctionDeclarations.GetCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseAtLocalPoint);
                     callingDefine.mInputValueSourceDefines = [
                              new ValueSourceDefine_Direct (/*CoreClassIds.ValueType_Entity, */mCreationId), 
                              new ValueSourceDefine_Direct (/*CoreClassIds.ValueType_Number, */entityDefine.mPowerMagnitude),
                              new ValueSourceDefine_Direct (/*CoreClassIds.ValueType_Number, */0.0),
                              new ValueSourceDefine_Direct (/*CoreClassIds.ValueType_Boolean, */true),
                              new ValueSourceDefine_Direct (/*CoreClassIds.ValueType_Number, */0.0),
                              new ValueSourceDefine_Direct (/*CoreClassIds.ValueType_Number, */0.0),
                        ];
                     break;
                  case Define.PowerSource_AngularImpulse:
                     //SetPowerMagnitude (mWorld.GetCoordinateSystem ().D2P_AngularImpulse (entityDefine.mPowerMagnitude));
                     functionDecalaration = CoreFunctionDeclarations.GetCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyAngularImpulse);
                     callingDefine.mInputValueSourceDefines = [
                              new ValueSourceDefine_Direct (/*CoreClassIds.ValueType_Entity, */mCreationId), 
                              new ValueSourceDefine_Direct (/*CoreClassIds.ValueType_Number, */entityDefine.mPowerMagnitude)
                        ];
                     break;
                  case Define.PowerSource_AngularAcceleration:
                     //SetPowerMagnitude (mWorld.GetCoordinateSystem ().D2P_AngularAcceleration (entityDefine.mPowerMagnitude));
                     break;
                  case Define.PowerSource_AngularVelocity:
                     //SetPowerMagnitude (mWorld.GetCoordinateSystem ().D2P_AngularVelocity (entityDefine.mPowerMagnitude));
                     break;
                  case Define.PowerSource_Force:
                  default:
                     //SetPowerMagnitude (mWorld.GetCoordinateSystem ().D2P_ForceMagnitude (entityDefine.mPowerMagnitude));
                     functionDecalaration = CoreFunctionDeclarations.GetCoreFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForceAtLocalPoint);
                     callingDefine.mInputValueSourceDefines = [
                              new ValueSourceDefine_Direct (/*CoreClassIds.ValueType_Entity, */mCreationId), 
                              new ValueSourceDefine_Direct (/*CoreClassIds.ValueType_Number, */entityDefine.mPowerMagnitude),
                              new ValueSourceDefine_Direct (/*CoreClassIds.ValueType_Number, */0.0),
                              new ValueSourceDefine_Direct (/*CoreClassIds.ValueType_Boolean, */true),
                              new ValueSourceDefine_Direct (/*CoreClassIds.ValueType_Number, */0.0),
                              new ValueSourceDefine_Direct (/*CoreClassIds.ValueType_Number, */0.0),
                        ];
                     break;
               }
                  
               if (functionDecalaration != null)
               {
                  callingDefine.mFunctionId = functionDecalaration.GetID ();
                  callingDefine.mNumInputs = functionDecalaration.GetNumInputs ();
                  callingDefine.mNumOutputs = functionDecalaration.GetNumOutputs ();
                  callingDefine.mOutputValueTargetDefines = [];
               }
               
               mKeyCodes = entityDefine.mKeyCodes;
               mKeyboardEventId = entityDefine.mKeyboardEventId;
               
               if (entityDefine.mKeyCodes != undefined && entityDefine.mKeyCodes.length > 0)
               {
                  mEventHandler = new EntityEventHandler_Keyboard (mWorld);
                  eventHandlerDefine.mEventId = entityDefine.mKeyboardEventId != undefined ? entityDefine.mKeyboardEventId : CoreEventIds.ID_OnWorldKeyHold;
                  eventHandlerDefine.mKeyCodes = entityDefine.mKeyCodes;
               }
               else
               {
                  mEventHandler = new EntityEventHandler (mWorld);
                  eventHandlerDefine.mEventId = CoreEventIds.ID_OnEntityUpdated;
               }
               
               mEventHandler.SetEnabled (IsEnabled ());
               //mEventHandler.Create (createStageId, entityDefine.mEventHandlerDefine, extraInfos);
               mEventHandler.Create (createStageId, entityDefine.mLoadingTimeInfos.mEventHandlerDefine, extraInfos);
            }
         }
         else if (createStageId == 1) 
         {
            if (mEventHandler != null)
            {
               //mEventHandler.Create (createStageId, entityDefine.mEventHandlerDefine, extraInfos);
               mEventHandler.Create (createStageId, entityDefine.mLoadingTimeInfos.mEventHandlerDefine, extraInfos);
               this.RegisterEventHandler (mEventHandler.GetEventId (), mEventHandler);
            }
         }
         else
         {
            if (mEventHandler != null)
            {
               //mEventHandler.Create (createStageId, entityDefine.mEventHandlerDefine, extraInfos);
               mEventHandler.Create (createStageId, entityDefine.mLoadingTimeInfos.mEventHandlerDefine, extraInfos);
            }
         }
      }
      
     override public function ToEntityDefine (entityDefine:Object):Object
     {
         super.ToEntityDefine (entityDefine);
         
         entityDefine.mPowerSourceType = GetPowerSourceType ();
         entityDefine.mPowerMagnitude = mPowerMagnitude;
         entityDefine.mKeyCodes = mKeyCodes;
         entityDefine.mKeyboardEventId = mKeyboardEventId;
         
         entityDefine.mEntityType = Define.EntityType_UtilityPowerSource;
         
         return entityDefine;
     }      
      
//=============================================================
//   
//=============================================================
      
      protected var mPowerSourceType:int = Define.PowerSource_Force;

      public function SetPowerSourceType (type:int):void
      {
         mPowerSourceType = type;
      }
      
      public function GetPowerSourceType ():Number
      {
         return mPowerSourceType;
      }
      
      //protected var mKeyCodes:Array;
      protected var mEventHandler:EntityEventHandler = null;
      
      // these values are the original value, just used to create entityDefine
      protected var mPowerMagnitude:Number = 0.0;
      protected var mKeyCodes:Array = null;
      protected var mKeyboardEventId:int = CoreEventIds.ID_OnWorldKeyDown;
      
//=============================================================
//   initialize
//=============================================================
      
      override protected function InitializeInternal ():void
      {
      }
      
//=============================================================
//   destroy
//=============================================================
      
      override protected function DestroyInternal ():void
      {
         SetEnabled (false);
         
         // todo: remove event handler
         // now it is just disbled but this is not very effective.
      }
      
//=============================================================
//   update
//=============================================================
      
      override protected function UpdateInternal (dt:Number):void
      {
         if (IsEnabled ())
         {
         /*
            switch (mPowerSourceType)
            {
               case Define.PowerSource_Torque:
                  mBody.ApplyTorque (mPowerMagnitude);
                  break;
               case Define.PowerSource_LinearImpusle:
                  SetPowerMagnitude (mWorld.GetCoordinateSystem ().D2P_ImpulseMagnitude (entityDefine.mPowerMagnitude));
                  break;
               case Define.PowerSource_AngularImpulse:
                  SetPowerMagnitude (mWorld.GetCoordinateSystem ().D2P_AngularImpulse (entityDefine.mPowerMagnitude));
                  break;
               case Define.PowerSource_AngularAcceleration:
                  SetPowerMagnitude (mWorld.GetCoordinateSystem ().D2P_AngularAcceleration (entityDefine.mPowerMagnitude));
                  break;
               case Define.PowerSource_AngularVelocity:
                  SetPowerMagnitude (mWorld.GetCoordinateSystem ().D2P_AngularVelocity (entityDefine.mPowerMagnitude));
                  break;
               //case Define.PowerSource_LinearAcceleration:
               //   SetPowerMagnitude (mWorld.GetCoordinateSystem ().D2P_LinearAccelerationMagnitude (entityDefine.mPowerMagnitude));
               //   break;
               //case Define.PowerSource_LinearVelocity:
               //   SetPowerMagnitude (mWorld.GetCoordinateSystem ().D2P_LinearVelocityMagnitude (entityDefine.mPowerMagnitude));
               //   break;
               case Define.PowerSource_Force:
               default:
                  SetPowerMagnitude (mWorld.GetCoordinateSystem ().D2P_ForceMagnitude (entityDefine.mPowerMagnitude));
                  break;
            }
         */
         }
      }
      
   }
   
}
