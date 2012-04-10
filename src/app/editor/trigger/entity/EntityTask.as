
package editor.trigger.entity {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import editor.entity.Scene;
   import editor.entity.Entity;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   
   
   import common.Define;
   
   import common.trigger.ValueDefine;
   
   public class EntityTask extends EntityLogic implements ICondition 
   {
      public static const kRadius:Number = 16;
      public static const kRadius1:Number = 6;
      public static const kRadius2:Number = 5;
      public static const kRadius3:Number = kRadius1 + kRadius2;
      
      private static const mStatusCirclePositionX:Array = [kRadius3 * Math.cos (0), kRadius3 * Math.cos (Math.PI * 2.0 / 3.0), kRadius3 * Math.cos (Math.PI * 4.0 / 3.0)];
      private static const mStatusCirclePositionY:Array = [kRadius3 * Math.sin (0), kRadius3 * Math.sin (Math.PI * 2.0 / 3.0), kRadius3 * Math.sin (Math.PI * 4.0 / 3.0)];
      private static const mStatusCircleColor:Array = [0xFFA0A0, 0xA0FFA0, 0xFFFFFF];
      
      private static const mStatusCirclePositionXb:Array = [kRadius * Math.cos (0), kRadius * Math.cos (Math.PI * 2.0 / 3.0), kRadius * Math.cos (Math.PI * 4.0 / 3.0)];
      private static const mStatusCirclePositionYb:Array = [kRadius * Math.sin (0), kRadius * Math.sin (Math.PI * 2.0 / 3.0), kRadius * Math.sin (Math.PI * 4.0 / 3.0)];
      
      protected var mBorderThickness:Number = 1;
      
      protected var mEntityAssignerList:Array = new Array ();
      
      public function EntityTask (container:Scene)
      {
         super (container);
      }
      
      override public function GetTypeName ():String
      {
         return "Task Aggregator";
      }
      
      public function ValidateEntityLinks ():void
      {
         EntityLogic.ValidateLinkedEntities (mEntityAssignerList);
      }
      
      public function GetEntityAssigners ():Array
      {
         return mEntityAssignerList; //.concat ();
      }
      
      public function SetEntityAssigners (assigners:Array):void
      {
         mEntityAssignerList.splice (0, mEntityAssignerList.length);
         
         for (var i:int = 0; i < assigners.length; ++ i)
         {
            mEntityAssignerList.push (assigners [i]);
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
               mEntityAssignerList.push (mEntityContainer.GetAssetByCreationId (assignerCreationIds [i]));
            }
         }
      }
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         var borderColor:int = 0x0;
         mBorderThickness = 1;
         if ( IsSelected () )
         {
            borderColor = Define.BorderColorSelectedObject;
            if (mBorderThickness * mEntityContainer.GetZoomScale () < 3)
               mBorderThickness  = 3.0 / mEntityContainer.GetZoomScale ();
         }
         
         var background:Shape = new Shape ();
         GraphicsUtil.ClearAndDrawCircle (background, 0, 0, kRadius, borderColor, -1, true, 0xA0A0A0);
         GraphicsUtil.DrawCircle (background, 0, 0, kRadius1, 0x0, 1, true, 0x0);
         for (var i:int = 0; i < 3; ++ i)
         {
            GraphicsUtil.DrawCircle (background, mStatusCirclePositionX [i], mStatusCirclePositionY [i], kRadius2, 0x0, 1, true, mStatusCircleColor [i]);
         }
         
         background.alpha = 0.90;
         addChild (background);
         
         var border:Shape = new Shape ();
         GraphicsUtil.ClearAndDrawCircle (border, 0, 0, kRadius, borderColor, mBorderThickness);
         border.alpha = 1.0;
         addChild (border);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mEntityContainer.mSelectionEngine.CreateProxyCircle ();
            mSelectionProxy.SetUserData (this);
            
            SetInternalComponentsVisible (AreInternalComponentsVisible ());
         }
         
         var borderThickness:Number = mBorderThickness;
         
         (mSelectionProxy as SelectionProxyCircle).RebuildCircle(GetPositionX (), GetPositionY (), kRadius, GetRotation ());
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityTask (mEntityContainer);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var task:EntityTask = entity as EntityTask;
         
         task.SetEntityAssigners (GetEntityAssigners ());
      }
      
//====================================================================
//   linkable
//====================================================================
      
      override public function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int
      {
         var dx:Number;
         var dy:Number;
         for (var i:int = 0; i < 3; ++ i)
         {
            dx = localX - mStatusCirclePositionX [i];
            dy = localY - mStatusCirclePositionY [i];
            
            if (dx * dx + dy * dy < kRadius2 * kRadius2)
               return i;
         }
         
         if (checkActiveZones)
         {
            if (localX * localX + localY + localY > kRadius1 * kRadius1)
               return 3;
         }
         
         return -1;
      }
      
      override public function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean
      {
         var local_point:Point = DisplayObjectUtil.LocalToLocal (mEntityContainer, this, new Point (worldDisplayX, worldDisplayY));
         
         return local_point.x * local_point.x + local_point.y * local_point.y > kRadius1 * kRadius1;
      }
      
      override public function TryToCreateLink (fromWorldDisplayX:Number, fromWorldDisplayY:Number, toEntity:Entity, toWorldDisplayX:Number, toWorldDisplayY:Number):Boolean
      {
         if (toEntity is IEntityLimiter)
         {
            var limitor:IEntityLimiter = toEntity as IEntityLimiter;
            
            if (! limitor.IsPairLimiter ())
            {
               var index:int = mEntityAssignerList.indexOf (toEntity);
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
      
      override public function GetDrawLinksOrder ():int
      {
         return DrawLinksOrder_Task;
      }
      
      override public function DrawEntityLinks (canvasSprite:Sprite, forceDraw:Boolean, isExpanding:Boolean = false):void
      {
         if (mEntityAssignerList.length > 0)
         {
            ValidateEntityLinks ();
            
            for (var i:int = 0; i < mEntityAssignerList.length; ++ i)
            {
               var entity:Entity = mEntityAssignerList [i] as Entity;
               
               // todo: draw dot lines for Any tyle assigners
               
               //if (IsSelected () || entity.IsSelected ())
               {
                  GraphicsUtil.DrawLine (canvasSprite, GetPositionX (), GetPositionY (), entity.GetPositionX (), entity.GetPositionY (), 0x0, 0);
               }
               
               if ((! forceDraw) && IsSelected ())
               {
                  entity.DrawEntityLinks (canvasSprite, false, true);
               }
            }
         }
      }
      
//====================================================================
//   as EntityCondition
//====================================================================
      
      public function GetTargetValueByLinkZoneId (zoneId:int):int
      {
         if (zoneId == 0)
            return ValueDefine.TaskStatus_Failed;
         
         if (zoneId == 2)
            return ValueDefine.TaskStatus_Unfinished;
         
         return ValueDefine.TaskStatus_Successed;
      }
      
      public function GetTargetValueZoneWorldCenter (targetValue:int):Point
      {
         if (targetValue == ValueDefine.TaskStatus_Failed)
            return DisplayObjectUtil.LocalToLocal (this, mEntityContainer, new Point (mStatusCirclePositionXb [0], mStatusCirclePositionYb [0]));
         
         if (targetValue == ValueDefine.TaskStatus_Successed)
            return DisplayObjectUtil.LocalToLocal (this, mEntityContainer, new Point (mStatusCirclePositionXb [1], mStatusCirclePositionYb [1]));
         
         return DisplayObjectUtil.LocalToLocal (this, mEntityContainer, new Point (mStatusCirclePositionXb [2], mStatusCirclePositionYb [2]));
      }
      
   }
}
