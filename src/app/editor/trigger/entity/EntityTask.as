
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
   
   import editor.world.World;
   import editor.entity.Entity;
   import editor.entity.WorldEntity;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   import common.Define;
   
   import common.trigger.ValueDefine;
   
   public class EntityTask extends EntityCondition 
   {
      public static var kRadius:Number = 16;
      public static var kRadius1:Number = 6;
      public static var kRadius2:Number = 5;
      public static var kRadius3:Number = kRadius1 + kRadius2;
      
      private static var mStatusCirclePositionX:Array = [kRadius3 * Math.cos (0), kRadius3 * Math.cos (Math.PI * 2.0 / 3.0), kRadius3 * Math.cos (Math.PI * 4.0 / 3.0)];
      private static var mStatusCirclePositionY:Array = [kRadius3 * Math.sin (0), kRadius3 * Math.sin (Math.PI * 2.0 / 3.0), kRadius3 * Math.sin (Math.PI * 4.0 / 3.0)];
      private static var mStatusCircleColor:Array = [0xFFA0A0, 0xA0FFA0, 0xFFFFFF];
      
      private static var mStatusCirclePositionXb:Array = [kRadius * Math.cos (0), kRadius * Math.cos (Math.PI * 2.0 / 3.0), kRadius * Math.cos (Math.PI * 4.0 / 3.0)];
      private static var mStatusCirclePositionYb:Array = [kRadius * Math.sin (0), kRadius * Math.sin (Math.PI * 2.0 / 3.0), kRadius * Math.sin (Math.PI * 4.0 / 3.0)];
      
      protected var mBorderThickness:Number = 1;
      
      protected var mEntityAssignerList:Array = new Array ();
      
      public function EntityTask (world:World)
      {
         super (world);
      }
      
      override public function GetTypeName ():String
      {
         return "Task";
      }
      
      public function ValidateEntityLinks ():void
      {
         EntityLogic.ValidateLinkedEntities (mEntityAssignerList);
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
            mEntityAssignerList.splice (0, 0, assigners);
         
         ValidateEntityLinks ();
      }
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         var borderColor:int = 0x0;
         mBorderThickness = 1;
         if ( IsSelected () )
         {
            borderColor = EditorSetting.BorderColorSelectedObject;
            if (mBorderThickness * mWorld.GetZoomScale () < 3)
               mBorderThickness  = 3.0 / mWorld.GetZoomScale ();
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
            mSelectionProxy = mWorld.mSelectionEngine.CreateProxyCircle ();
            mSelectionProxy.SetUserData (this);
            
            SetInternalComponentsVisible (AreInternalComponentsVisible ());
         }
         
         var borderThickness:Number = mBorderThickness;
         
         (mSelectionProxy as SelectionProxyCircle).RebuildCircle( GetRotation (), GetPositionX (), GetPositionY (), kRadius );
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
         var local_point:Point = DisplayObjectUtil.LocalToLocal (mWorld, this, new Point (worldDisplayX, worldDisplayY));
         
         return local_point.x * local_point.x + local_point.y * local_point.y > kRadius1 * kRadius1;
      }
      
      override public function TryToCreateLink (fromWorldDisplayX:Number, fromWorldDisplayY:Number, toEntity:Entity, toWorldDisplayX:Number, toWorldDisplayY:Number):Boolean
      {
         if (toEntity is EntityInputEntityAssigner)
         {
            var index:int = mEntityAssignerList.indexOf (toEntity);
            if (index >= 0)
               mEntityAssignerList.splice (index, 1);
            else
               mEntityAssignerList.push (toEntity);
            
            return true;
         }
         
         return false;
      }
      
//====================================================================
//   entity links
//====================================================================
      
      override public function DrawEntityLinkLines (canvasSprite:Sprite):void
      {
         if (mEntityAssignerList.length > 0)
         {
            ValidateEntityLinks ();
            
            for (var i:int = 0; i < mEntityAssignerList.length; ++ i)
            {
               var entity:Entity = mEntityAssignerList [i] as Entity;
               GraphicsUtil.DrawLine (canvasSprite, GetPositionX (), GetPositionY (), entity.GetPositionX (), entity.GetPositionY ());
            }
         }
      }
      
//====================================================================
//   storer
//====================================================================
      
      override public function GetTargetValueByLinkZoneId (zoneId:int):int
      {
         if (zoneId == 0)
            return ValueDefine.TaskStatus_Failed;
         
         if (zoneId == 2)
            return ValueDefine.TaskStatus_Undetermined;
         
         return ValueDefine.TaskStatus_Successed;
      }
      
      override public function GetTargetValueZoneWorldCenter (targetValue:int):Point
      {
         if (targetValue == ValueDefine.TaskStatus_Failed)
            return DisplayObjectUtil.LocalToLocal (this, mWorld, new Point (mStatusCirclePositionXb [0], mStatusCirclePositionYb [0]));
         
         if (targetValue == ValueDefine.TaskStatus_Successed)
            return DisplayObjectUtil.LocalToLocal (this, mWorld, new Point (mStatusCirclePositionXb [1], mStatusCirclePositionYb [1]));
         
         return DisplayObjectUtil.LocalToLocal (this, mWorld, new Point (mStatusCirclePositionXb [2], mStatusCirclePositionYb [2]));
      }
      
   }
}
