
package editor.trigger.entity {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import flash.events.MouseEvent;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import editor.world.World;
   import editor.entity.Entity;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.trigger.TriggerEngine;
   import editor.trigger.FunctionDeclaration_EventHandler;
   import editor.trigger.FunctionDefinition;
   import editor.trigger.VariableDefinition;
   import editor.trigger.VariableDefinitionEntity;
   import editor.trigger.CodeSnippet;
   
   import editor.runtime.Resource;
   
   import common.Define;
   
   import common.trigger.ValueDefine;
   
   public class EntityEventHandler extends EntityCodeSnippetHolder 
   {
      protected var mNumEntityParams:int = 0;
      
      protected var mAllPotentialEventDeclarations:Array = null;
      
      //private var 
      
      //
      protected var mEventHandlerDefinition:FunctionDefinition;
      protected var mEventId:int;
      
      protected var mExternalCondition:ConditionAndTargetValue = new ConditionAndTargetValue (null, ValueDefine.BoolValue_True);
      
      protected var mEntityAssignerList:Array = new Array ();
      
      protected var mExternalActionEntity:EntityAction = null;
      
      public function EntityEventHandler (world:World, defaultEventId:int, potientialEventIds:Array = null)
      {
         super (world);
         
         doubleClickEnabled = true;
         addEventListener(MouseEvent.DOUBLE_CLICK, OnMouseDoubleClick);
         
         mEventId = defaultEventId;
         
         mEventHandlerDefinition = new FunctionDefinition (TriggerEngine.GetEventDeclarationById (mEventId));
         
         mCodeSnippet = new CodeSnippet (mEventHandlerDefinition);
         mBackgroundColor = 0xB0B0FF;
         
         mEventIconBitmap = Resource.EventId2IconBitmap (mEventId);
         
         var i:int;
         mNumEntityParams = 0;
         for (i = 0; i < mEventHandlerDefinition.GetNumInputs (); ++ i)
         {
            var variable_def:VariableDefinition = mEventHandlerDefinition.GetInputParamDefinitionAt (i);
            if (variable_def is VariableDefinitionEntity)
               ++ mNumEntityParams;
         }
         
         if (potientialEventIds != null)
         {
            if (potientialEventIds.indexOf (defaultEventId) < 0)
               potientialEventIds.unshift (defaultEventId);
            
            mAllPotentialEventDeclarations = new Array (potientialEventIds.length);
            
            for (i = 0; i < potientialEventIds.length; ++ i)
               mAllPotentialEventDeclarations [i] = TriggerEngine.GetEventDeclarationById (potientialEventIds [i]);
         }
      }
      
      public function GetEventName ():String
      {
         return mEventHandlerDefinition.GetName ();
      }
      
      public function GetEventId ():int
      {
         return mEventId;
      }
      
      public function GetInputConditionEntity ():EntityCondition
      {
         return mExternalCondition.mConditionEntity;
      }
      
      public function GetInputConditionTargetValue ():int
      {
         return mExternalCondition.mTargetValue;
      }
      
      public function SetInputCondition (condition:EntityCondition, inputConditionTargetValue:int):void
      {
         mExternalCondition.mConditionEntity = condition;
         mExternalCondition.mTargetValue = inputConditionTargetValue;
      }
      
      public function SetInputConditionByCreationId (inputConditionEntityCreationId:int, inputConditionTargetValue:int):void
      {
         var condition:EntityCondition = mWorld.GetEntityByCreationId (inputConditionEntityCreationId) as EntityCondition;
         
         if (condition != null)
         {
            SetInputCondition (condition, inputConditionTargetValue);
         }
      }
      
      public function GetEntityAssigners ():Array
      {
         return mEntityAssignerList; //.slice ();
      }
      
      public function SetEntityAssigners (assigners:Array):void
      {
         if (mEntityAssignerList.length > 0)
            mEntityAssignerList.splice (0, mEntityAssignerList.length);
         
         if (assigners != null && assigners.length > 0)
         {
            var num:int = assigners.length;
            for (var i:int = 0; i < num; ++ i)
            {
               mEntityAssignerList.push (assigners [i]);
            }
         }
      }
      
      public function SetEntityAssignersByCreationIds (assignerCreationIds:Array):void
      {
         if (mEntityAssignerList.length > 0)
            mEntityAssignerList.splice (0, mEntityAssignerList.length);
         
         if (assignerCreationIds != null && assignerCreationIds.length > 0)
         {
            var num:int = assignerCreationIds.length;
            for (var i:int = 0; i < num; ++ i)
            {
               mEntityAssignerList.push (mWorld.GetEntityByCreationId (assignerCreationIds [i]));
            }
         }
      }
      
      public function GetExternalAction ():EntityAction
      {
         return mExternalActionEntity;
      }
      
      public function SetExternalAction (action:EntityAction):void
      {
         mExternalActionEntity = action;
      }
      
      public function SetExternalActionByCreationId (actionCreationId:int):void
      {
         mExternalActionEntity = mWorld.GetEntityByCreationId (actionCreationId) as EntityAction;
      }
      
      override public function ValidateEntityLinks ():void
      {
         //mCodeSnippet.ValidateValueSources ();
         super.ValidateEntityLinks ();
         
         EntityLogic.ValidateLinkedEntities (mEntityAssignerList);
         
         if (mExternalCondition.mConditionEntity != null && (mExternalCondition.mConditionEntity as Entity).GetCreationOrderId () < 0)
         {
            mExternalCondition.mConditionEntity = null;
            mExternalCondition.mTargetValue = ValueDefine.BoolValue_True;
         }
         
         if (mExternalActionEntity != null && mExternalActionEntity.GetCreationOrderId () < 0)
         {
            SetExternalAction (null);
         }
      }
      
      override public function GetTypeName ():String
      {
         return "Event Handler";
      }
      
      public function GetAllPotentialEventDeclarations ():Array
      {
         return mAllPotentialEventDeclarations;
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityEventHandler (mWorld, mEventId);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var eventHandler:EntityEventHandler = entity as EntityEventHandler;
         
         eventHandler.SetInputCondition (GetInputConditionEntity (), GetInputConditionTargetValue ());
         eventHandler.SetEntityAssigners (GetEntityAssigners ());
         eventHandler.SetExternalAction (GetExternalAction ());
      }
      
//==========================================================================================
//
//==========================================================================================
      
     // private var mInputEntitySelector:
      
      private function OnMouseDoubleClick (e:MouseEvent):void
      {
         
      }
      
//====================================================================
//   linkable
//====================================================================
      
      override public function TryToCreateLink (fromWorldDisplayX:Number, fromWorldDisplayY:Number, toEntity:Entity, toWorldDisplayX:Number, toWorldDisplayY:Number):Boolean
      {
         ValidateEntityLinks ();
         
         if (toEntity is EntityCondition)
         {
            var point:Point = DisplayObjectUtil.LocalToLocal (mWorld, toEntity as Entity, new Point (toWorldDisplayX, toWorldDisplayY));
            var zone_id:int = (toEntity as EntityLogic).GetLinkZoneId (point.x, point.y);
            var target_value:int = (toEntity as EntityCondition).GetTargetValueByLinkZoneId (zone_id);
            
            var to_remove:Boolean =  mExternalCondition.mConditionEntity == toEntity && ( (!(toEntity is EntityTask)) || (target_value ==  mExternalCondition.mTargetValue) );
            
            if (to_remove)
               mExternalCondition.mConditionEntity = null;
            else
            {
               mExternalCondition.mConditionEntity = toEntity as EntityCondition;
               mExternalCondition.mTargetValue = target_value;
            }
            
            return true;
         }
         else if (toEntity is EntityAction)
         {
            if (mExternalActionEntity == toEntity)
               SetExternalAction (null);
            else
               SetExternalAction (toEntity as EntityAction);
            
            return true;
         }
         else 
         {
            var index:int;
            
            if (mNumEntityParams == 1 && toEntity is EntityInputEntityAssigner)
            {
               index = mEntityAssignerList.indexOf (toEntity);
               if (index >= 0)
                  mEntityAssignerList.splice (index, 1);
               else
                  mEntityAssignerList.push (toEntity);
               
               return true;
            }
            else if (mNumEntityParams == 2 && toEntity is EntityInputEntityPairAssigner)
            {
               index = mEntityAssignerList.indexOf (toEntity);
               if (index >= 0)
                  mEntityAssignerList.splice (index, 1);
               else
                  mEntityAssignerList.push (toEntity);
               
               return true;
            }
         }
         
         return false;
      }
      
//====================================================================
//   entity links
//====================================================================
      
      override public function DrawEntityLinkLines (canvasSprite:Sprite):void
      {
         ValidateEntityLinks ();
         
         if (!visible)
            return;
         
         if (mExternalCondition.mConditionEntity != null)
         {
            var point:Point = mExternalCondition.mConditionEntity.GetTargetValueZoneWorldCenter (mExternalCondition.mTargetValue);
            GraphicsUtil.DrawLine (canvasSprite, GetPositionX () - mHalfWidth, GetPositionY (), point.x, point.y);
         }
         
         if (mEntityAssignerList.length > 0)
         {
            var entity:Entity;
            
            for (var i:int = 0; i < mEntityAssignerList.length; ++ i)
            {
               entity = mEntityAssignerList [i] as Entity;
               GraphicsUtil.DrawLine (canvasSprite, GetPositionX (), GetPositionY (), entity.GetPositionX (), entity.GetPositionY ());
            }
         }
         
         if (mExternalActionEntity != null)
         {
            GraphicsUtil.DrawLine (canvasSprite, GetPositionX () + mHalfWidth, GetPositionY (), mExternalActionEntity.GetPositionX (), mExternalActionEntity.GetPositionY ());
         }
      }
   }
}
