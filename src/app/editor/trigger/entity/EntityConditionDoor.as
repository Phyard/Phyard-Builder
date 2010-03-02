
package editor.trigger.entity {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import editor.world.World;
   import editor.entity.Entity;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   
   
   import common.Define;
   
   import common.trigger.ValueDefine;
   
   public class EntityConditionDoor extends EntityLogic implements EntityCondition 
   {
      public static const kHalfWidth:Number = 12;
      public static const kHalfHeight:Number = 12;
      public static const kBandWidth:Number = 9;
      
      public static const kText_SetAsAnd:String = "Set As \"And\" Door";
      public static const kText_SetAsOr:String = "Set As \"Or\" Door";
      public static const kText_AddNot:String = "Add \"Not\" Door";
      public static const kText_ClearNot:String = "Clear \"Not\" Door";
      
      protected var mContextMenu:ContextMenu;
      protected var mContextMenuItem_ToggleAndOr:ContextMenuItem;
      protected var mContextMenuItem_ToggleNot:ContextMenuItem;
      
      protected var mBorderThickness:Number = 1;
      
   // ...
      
      protected var mIsAnd:Boolean = true; // false means "is or"
      protected var mIsNot:Boolean = false;
      
      protected var mInputConditions:Array = new Array ();
      
      public function EntityConditionDoor (world:World)
      {
         super (world);
         
         BuildContextMenu ();
      }
      
      override public function GetTypeName ():String
      {
         return "Condition Door";
      }
      
      public function SetAsAnd (isAnd:Boolean):void
      {
         mIsAnd = isAnd;
      }
      
      public function SetAsNot (isNot:Boolean):void
      {
         mIsNot = isNot;
      }
      
      public function IsAnd ():Boolean
      {
         return mIsAnd;
      }
      
      public function IsNot ():Boolean
      {
         return mIsNot;
      }
      
      public function ValidateEntityLinks ():void
      {
         var i:int = 0;
         while (i < mInputConditions.length)
         {
            var condition_target:ConditionAndTargetValue = mInputConditions [i] as ConditionAndTargetValue;
            if (condition_target.mConditionEntity == null || (condition_target.mConditionEntity as Entity).GetCreationOrderId () < 0)
               mInputConditions.splice (i, 1);
            else
               ++ i;
         }
      }
      
      public function GetInputConditions ():Array
      {
         return mInputConditions;
      }
      
      public function SetInputConditionByCreationId (conditions:Array):void
      {
         var creationIds:Array = new Array (conditions.length);
         var targetValues:Array = new Array (conditions.length);
         
         var conditionAndTargetValue:ConditionAndTargetValue;
         for (var i:int = 0; i < conditions.length; ++ i)
         {
            conditionAndTargetValue = conditions [i];
            creationIds  [i] = (conditionAndTargetValue.mConditionEntity as Entity).GetCreationOrderId ();
            targetValues [i] = conditionAndTargetValue.mTargetValue;
         }
         
         SetInputConditionsByCreationIds (creationIds, targetValues);
      }
      
      public function SetInputConditionsByCreationIds (conditionEntityCreationIds:Array,conditionTargetValues:Array):void
      {
         if (mInputConditions.length > 0)
            mInputConditions.splice (0, mInputConditions.length);
         
         if (conditionEntityCreationIds != null && conditionTargetValues != null)
         {
            var num:int = conditionEntityCreationIds.length;
            if (num > conditionTargetValues.length)
               num = conditionTargetValues.length;
            
            var condition:EntityCondition;
            for (var i:int = 0; i < num; ++ i)
            {
               condition = mWorld.GetEntityByCreationId (conditionEntityCreationIds [i]) as EntityCondition;
               
               if (condition != null)
                  mInputConditions.push (new ConditionAndTargetValue (condition, conditionTargetValues [i]));
            }
         }
      }
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
      // background
         
         var borderColor:int = 0x0;
         mBorderThickness = 1;
         if ( IsSelected () )
         {
            borderColor = Define.BorderColorSelectedObject;
            if (mBorderThickness * mWorld.GetZoomScale () < 3)
               mBorderThickness  = 3.0 / mWorld.GetZoomScale ();
         }
         
         var background:Shape = new Shape ();
         
         if (mIsAnd)
            GraphicsUtil.ClearAndDrawRect (background, 0, - kHalfHeight, kHalfWidth, kHalfHeight + kHalfHeight, 0x0, 1, true, 0xFFFFFF);
         else
            GraphicsUtil.ClearAndDrawCircle (background, 0, 0, kHalfHeight - 0.5, 0x0, 1, true, 0xFFFFFF);
         
         GraphicsUtil.DrawRect (background, - kBandWidth - kBandWidth, - kHalfHeight, kBandWidth, kHalfHeight + kHalfHeight, 0x0, 1, true, 0x808080);
         GraphicsUtil.DrawRect (background, - kBandWidth,- kHalfHeight, kBandWidth, kHalfHeight + kHalfHeight, 0x0, 1, true, 0x000000);
         
      // children
         
         background.alpha = 0.90;
         addChild (background);
         
         if ( IsSelected () )
         {
            var border:Shape = new Shape ();
            GraphicsUtil.ClearAndDrawRect (border, - kBandWidth - kBandWidth, - kHalfHeight, kBandWidth + kBandWidth + kHalfWidth, kHalfHeight + kHalfHeight, borderColor, mBorderThickness);
            border.alpha = 1.0;
            addChild (border);
         }
         
         if (mIsNot)
         {
            var not_circle:Shape = new Shape ();
            GraphicsUtil.ClearAndDrawCircle (not_circle, kHalfWidth, 0, 3, 0x0, 1, true, 0xFFFFFF);
            not_circle.alpha = 0.90;
            addChild (not_circle);
         }
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
         
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle ( GetRotation (), GetPositionX () + (- kBandWidth - kBandWidth + kHalfWidth) * 0.5, GetPositionY (), (kBandWidth + kBandWidth + kHalfWidth) * 0.5 + borderThickness * 0.5 , kHalfHeight + borderThickness * 0.5 );
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityConditionDoor (mWorld);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var conditionDoor:EntityConditionDoor = entity as EntityConditionDoor;
         
         conditionDoor.SetAsAnd (IsAnd ());
         conditionDoor.SetAsNot (IsNot ());
         conditionDoor.SetInputConditionByCreationId (GetInputConditions ());
      }
      
//==============================================================================================================
//
//==============================================================================================================
      
      private function BuildContextMenu ():void
      {
         contextMenu = new ContextMenu ();
         contextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = contextMenu.builtInItems;
         defaultItems.print = false;
         
         mContextMenuItem_ToggleAndOr = new ContextMenuItem (kText_SetAsAnd, false),
         contextMenu.customItems.push (mContextMenuItem_ToggleAndOr);
         mContextMenuItem_ToggleAndOr.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
         
         mContextMenuItem_ToggleNot = new ContextMenuItem (kText_AddNot, false),
         contextMenu.customItems.push (mContextMenuItem_ToggleNot);
         mContextMenuItem_ToggleNot.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
         
         UpdateMenuItems ();
      }
      
      private function OnContextMenuEvent (event:ContextMenuEvent):void
      {
         var door:EntityConditionDoor = event.mouseTarget as EntityConditionDoor;
         //if (door == null)
         //   return;
         if (door != this)
            return;
         
         if (event.target == mContextMenuItem_ToggleAndOr)
         {
            door.SetAsAnd (mContextMenuItem_ToggleAndOr.caption == kText_SetAsAnd);
            door.UpdateAppearance ();
            
            mContextMenuItem_ToggleAndOr.caption = door.IsAnd () ? kText_SetAsOr : kText_SetAsAnd;
            mContextMenuItem_ToggleNot.caption = door.IsNot () ? kText_ClearNot : kText_AddNot;
         }
         else if (event.target == mContextMenuItem_ToggleNot)
         {
            door.SetAsNot (mContextMenuItem_ToggleNot.caption == kText_AddNot);
            door.UpdateAppearance ();
            
            mContextMenuItem_ToggleAndOr.caption = door.IsAnd () ? kText_SetAsOr : kText_SetAsAnd;
            mContextMenuItem_ToggleNot.caption = door.IsNot () ? kText_ClearNot : kText_AddNot;
         }
      }
      
      override public function SetInternalComponentsVisible (visible:Boolean):void
      {
         super.SetInternalComponentsVisible (visible);
         
         if (AreInternalComponentsVisible ())
         {
            //contextMenu = mContextMenu;
            
            UpdateMenuItems ();
         }
         //else
         //   contextMenu = null;
      }
      
      private function UpdateMenuItems ():void
      {
         mContextMenuItem_ToggleAndOr.caption = IsAnd () ? kText_SetAsOr : kText_SetAsAnd;
         mContextMenuItem_ToggleNot.caption = IsNot () ? kText_ClearNot : kText_AddNot;
      }
      
//====================================================================
//   linkable
//====================================================================
      
      public static const ZoneId_In:int = 0;
      public static const ZoneId_Out:int = 1;
      
      override public function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int
      {
         if (checkActiveZones)
         {
            if (localX < -kBandWidth)
               return ZoneId_In;
         }
         
         if (checkPassiveZones)
         {
            //if (localX > 0)
            if (localX > 2)
               return ZoneId_Out;
         }
         
         return -1;
      }
      
      override public function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean
      {
         var local_point:Point = DisplayObjectUtil.LocalToLocal (mWorld, this, new Point (worldDisplayX, worldDisplayY));
         
         //return local_point.x > 0 || local_point.x < -kBandWidth;
         return local_point.x > 2 || local_point.x < -kBandWidth;
      }
      
      override public function TryToCreateLink (fromWorldDisplayX:Number, fromWorldDisplayY:Number, toEntity:Entity, toWorldDisplayX:Number, toWorldDisplayY:Number):Boolean
      {
         ValidateEntityLinks ();
         
         if (toEntity is EntityCondition)
         {
            var condition:EntityCondition = toEntity as EntityCondition;
            var point1:Point;
            var point2:Point;
            var zone_id1:int;
            var zone_id2:int;
            var target_value:int;
            
            point2 = DisplayObjectUtil.LocalToLocal (mWorld, (condition as Entity), new Point (toWorldDisplayX, toWorldDisplayY));
            zone_id2 = (condition as EntityLogic).GetLinkZoneId (point2.x, point2.y, false, true);
            target_value = condition.GetTargetValueByLinkZoneId (zone_id2);
            
            if (condition is EntityConditionDoor)
            {
               point1 = DisplayObjectUtil.LocalToLocal (mWorld, this, new Point (fromWorldDisplayX, fromWorldDisplayY));
               zone_id1 = GetLinkZoneId (point1.x, point1.y, true, false);
               
               if (zone_id1 == ZoneId_In && zone_id2 == ZoneId_Out)
               {
                  if (HasDirectInput (toEntity as EntityCondition, target_value, true))
                     return true;
                  
                  if (! IsInputOf (condition as EntityConditionDoor) )
                  {
                     mInputConditions.push (new ConditionAndTargetValue (condition, target_value));
                     
                     return true;
                  }
               }
            }
            else // basic condition
            {
               if (HasDirectInput (toEntity as EntityCondition, target_value, true))
                  return true;
               
               mInputConditions.push (new ConditionAndTargetValue (condition, target_value));
               
               return true;
            }
         }
         
         return false;
      }
      
      private function HasDirectInput (condition:EntityCondition, targetValue:int, removeInputIfTrue:Boolean=false):Boolean
      {
         var condition_and_target:ConditionAndTargetValue;
         var input_conditions:Array = GetInputConditions ();
         for (var i:int = 0; i < input_conditions.length; ++ i)
         {
            condition_and_target = input_conditions [i] as ConditionAndTargetValue;
            
            if (condition_and_target.mConditionEntity == condition)
            {
               if (removeInputIfTrue)
                  input_conditions.splice (i, 1);
               
               if (condition_and_target.mTargetValue == targetValue)
                  return true;
               else
                  return false;
            }
         }
         
         return false;
      }
      
      private function IsInputOf (conditionDoor:EntityConditionDoor):Boolean
      {
         var condition_door:EntityConditionDoor;
         var input_conditions:Array;
         var i:int;
         var condition_and_target:ConditionAndTargetValue;
         var stack:Array = new Array ();
         stack.push (conditionDoor);
         
         while (stack.length > 0)
         {
            condition_door = stack.shift ();
            input_conditions = condition_door.GetInputConditions ();
            for (i = 0; i < input_conditions.length; ++ i)
            {
               condition_and_target = input_conditions [i] as ConditionAndTargetValue;
               
               if (condition_and_target.mConditionEntity is EntityConditionDoor)
               {
                  if (condition_and_target.mConditionEntity == this)
                     return true;
                  
                  stack.push (condition_and_target.mConditionEntity);
               }
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
         
         if (mInputConditions.length > 0)
         {
            var point1:Point = DisplayObjectUtil.LocalToLocal (this, mWorld, new Point (- kBandWidth - kBandWidth, 0));
            for (var i:int = 0; i < mInputConditions.length; ++ i)
            {
               var condition_target:ConditionAndTargetValue = mInputConditions [i] as ConditionAndTargetValue;
               var point2:Point = condition_target.mConditionEntity.GetTargetValueZoneWorldCenter (condition_target.mTargetValue);
               GraphicsUtil.DrawLine (canvasSprite, point1.x, point1.y, point2.x, point2.y);
            }
         }
      }
      
//====================================================================
//   as EntityCondition
//====================================================================
      
      public function GetTargetValueByLinkZoneId (zoneId:int):int
      {
         return ValueDefine.BoolValue_True;
      }
      
      public function GetTargetValueZoneWorldCenter (targetValue:int):Point
      {
         return DisplayObjectUtil.LocalToLocal (this, mWorld, new Point (kHalfWidth, 0));
      }
      
   }
}
