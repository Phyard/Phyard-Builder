
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
   import editor.trigger.EventDeclaration;
   import editor.trigger.VariableDefinition;
   import editor.trigger.VariableDefinitionEntity;
   import editor.trigger.CommandListDefinition;
   
   import editor.setting.EditorSetting;
   
   import common.Define;
   
   import common.trigger.ValueDefine;
   
   public class EntityEventHandler extends EntityLogic 
   {
      private var mNumEntityParams:int = 0;
      
      private var mAllPotentialEventDeclarations:Array = null;
      
      //private var 
      
      //
      public var mHalfWidth:Number;
      public var mHalfHeight:Number;
      public var mTextFieldHalfWidth:Number;
      public var mTextFieldHalfHeight:Number;
      public var mBorderThickness:Number = 1;
      
      //
      
      protected var mConditionListDefinition:CommandListDefinition;
      protected var mCommandListDefinition:CommandListDefinition;
      
      protected var mExternalCondition:ConditionAndTargetValue = new ConditionAndTargetValue (null, ValueDefine.BoolValue_True);
      
      protected var mExternalAction:EntityAction = null;
      
      protected var mEntityAssignerList:Array = new Array ();
      
      public function EntityEventHandler (world:World, defaultEventId:int, potientialEventIds:Array = null)
      {
         super (world);
         
         doubleClickEnabled = true;
         addEventListener(MouseEvent.DOUBLE_CLICK, OnMouseDoubleClick);
         
         var event_decl:EventDeclaration = TriggerEngine.GetEventDeclarationById (defaultEventId);
         mConditionListDefinition = new CommandListDefinition (event_decl);
         mCommandListDefinition = new CommandListDefinition (event_decl);
         
         var i:int;
         mNumEntityParams = 0;
         for (i = 0; i < event_decl.GetNumParameters (); ++ i)
         {
            var variable_def:VariableDefinition = event_decl.GetParamDefinitionAt (i);
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
      
      public function GetEntityAssigners ():Array
      {
         return mEntityAssignerList; //.slice ();
      }
      
      public function GetInputConditionEntity ():EntityCondition
      {
         return mExternalCondition.mConditionEntity;
      }
      
      public function GetInputConditionTargetValue ():int
      {
         return mExternalCondition.mTargetValue;
      }
      
      public function GetPostActionEntity ():EntityAction
      {
         return mExternalAction;
      }
      
      public function GetConditionCommandListDefinition ():CommandListDefinition
      {
         return mConditionListDefinition;
      }
      
      public function GetActionCommandListDefinition ():CommandListDefinition
      {
         return mCommandListDefinition;
      }
      
      public function ValidateEntityLinks ():void
      {
         mConditionListDefinition.ValidateValueSources ();
         mCommandListDefinition.ValidateValueSources ();
         
         EntityLogic.ValidateLinkedEntities (mEntityAssignerList);
         
         if (mExternalAction != null && mExternalAction.GetEntityIndex () < 0)
            mExternalAction = null;
         
         if (mExternalCondition.mConditionEntity != null && mExternalCondition.mConditionEntity.GetEntityIndex () < 0)
         {
            mExternalCondition.mConditionEntity = null;
            mExternalCondition.mTargetValue = ValueDefine.BoolValue_True;
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
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         // text
         
         var text:String = mCommandListDefinition.GetName ();
         
         var text_field:TextFieldEx;
         text_field = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>" + text + "</font>", false, 0xFFFFFF, 0x0);
         
         var tw:int = text_field.width;
         var th:int = text_field.height;
         
         mHalfWidth  = (tw + 20) * 0.5;
         mHalfHeight = (th + 6) * 0.5;
         
         mTextFieldHalfWidth = tw * 0.5;
         mTextFieldHalfHeight = th * 0.5;
         
         // background
         
         var borderColor:int = 0x0;
         mBorderThickness = 1;
         if ( IsSelected () )
         {
            borderColor = EditorSetting.BorderColorSelectedObject;
            if (mBorderThickness * mWorld.GetZoomScale () < 3)
               mBorderThickness  = 3.0 / mWorld.GetZoomScale ();
         }
         
         var background:Shape = new Shape ();
         GraphicsUtil.ClearAndDrawRect (background, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, mBorderThickness, true, 0xB0B0FF);
         var background2:Shape = new Shape ();
         GraphicsUtil.ClearAndDrawRect (background2, - tw * 0.5, - th * 0.5, tw, th, 0x0, 1, true, 0xFFFFFF);
         
      // children
         
         background.alpha = 0.90;
         background2.alpha = 1.0;
         text_field.alpha = 1.0;
         
         addChild (background);
         addChild (background2);
         addChild (text_field); 
         text_field.x = - 0.5 * text_field.width;
         text_field.y = - 0.5 * text_field.height;
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mWorld.mSelectionEngine.CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
            
            SetInternalComponentsVisible (AreInternalComponentsVisible ());
         }
         
         var borderThickness:Number = mBorderThickness;
         
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle ( GetRotation (), GetPositionX (), GetPositionY (), mHalfWidth + borderThickness * 0.5 , mHalfHeight + borderThickness * 0.5 );
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
      
      override public function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int
      {
         if (localX > mTextFieldHalfWidth || localX < -mTextFieldHalfWidth || localY > mTextFieldHalfHeight || localY < -mTextFieldHalfHeight)
            return 0;
         
         return -1;
      }
      
      override public function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean
      {
         var local_point:Point = DisplayObjectUtil.LocalToLocal (mWorld, this, new Point (worldDisplayX, worldDisplayY));
         
         return GetLinkZoneId (local_point.x, local_point.y) >= 0;
      }
      
      override public function TryToCreateLink (fromWorldDisplayX:Number, fromWorldDisplayY:Number, toEntity:Entity, toWorldDisplayX:Number, toWorldDisplayY:Number):Boolean
      {
         ValidateEntityLinks ();
         
         if (toEntity is EntityAction)
         {
            if (mExternalAction == toEntity)
               mExternalAction = null;
            else
               mExternalAction = toEntity as EntityAction;
            
            return true;
         }
         else if (toEntity is EntityCondition)
         {
            var point:Point = DisplayObjectUtil.LocalToLocal (mWorld, toEntity as EntityCondition, new Point (toWorldDisplayX, toWorldDisplayY));
            var zone_id:int = (toEntity as EntityCondition).GetLinkZoneId (point.x, point.y);
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
         
         if (mExternalAction != null)
         {
            GraphicsUtil.DrawLine (canvasSprite, GetPositionX () + mHalfWidth, GetPositionY (), mExternalAction.GetPositionX (), mExternalAction.GetPositionY ());
         }
         
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
      }
   }
}
