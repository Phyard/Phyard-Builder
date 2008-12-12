
package editor.world {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   import com.tapirgames.util.Logger;
   
   import editor.entity.Entity;
   
   import editor.entity.EntityShapeCircle;
   import editor.entity.EntityShapeRectangle;
   
   import editor.entity.EntityJointRope;
   import editor.entity.EntityJointHinge;
   
   import editor.entity.EntityJointSlider;
   import editor.entity.SubEntitySliderAnchor;
   
   import editor.entity.VertexController;
   
   import editor.selection.SelectionEngine;
   
   public class World extends Sprite 
   {
      
      public var mSelectionEngine:SelectionEngine; // used within package
      
      public var mSelectionListManager:SelectionListManager; 
      
      
      public function World ()
      {
      //
         mSelectionEngine = new SelectionEngine ();
         
         mSelectionListManager = new SelectionListManager ();
      }
      
      
      public function Update (escapedTime:Number):void
      {
         for (var i:uint = 0; i < numChildren; ++ i)
         {
            var child:Object = getChildAt (i);
            
            if (child is Entity)
            {
               (child as Entity).Update (escapedTime);
            }
         }
      }
      
//=================================================================================
//   create and destroy
//=================================================================================
      
      public function DestroyEntity (entity:Entity):void
      {
      // selected
      
         mSelectionListManager.RemoveSelectedEntity (entity);
         
      // friends
         
         
         
      // brothers
         
         
      // ...
         
         entity.Destroy ();
         
         if ( contains (entity) )
            removeChild (entity);
      }
      
      public function CreateEntityShapeCircle ():EntityShapeCircle
      {
         var circle:EntityShapeCircle = new EntityShapeCircle (this);
         addChild (circle);
         
         return circle;
      }
      
      public function CreateEntityShapeRectangle ():EntityShapeRectangle
      {
         var rect:EntityShapeRectangle = new EntityShapeRectangle (this);
         addChild (rect);
         
         return rect;
      }
      
      public function CreateEntityJointRope ():EntityJointRope
      {
         var rope:EntityJointRope = new EntityJointRope (this);
         addChild (rope);
         
         return rope;
      }
      
      public function CreateEntityJointHinge ():EntityJointHinge
      {
         var hinge:EntityJointHinge = new EntityJointHinge (this);
         addChild (hinge);
         
         return hinge;
      }
      
      public function CreateEntityJointSlider ():EntityJointSlider
      {
         var slider:EntityJointSlider = new EntityJointSlider (this);
         addChild (slider);
         
         return slider;
      }
      
      
//=================================================================================
//   selection list
//=================================================================================
      
      public function GetSelectedEntities ():Array
      {
         return mSelectionListManager.GetSelectedEntities ();
      }
      
      public function ClearSelectedEntities ():void
      {
         mSelectionListManager.ClearSelectedEntities ();
      }
      
      public function SelectEntities (entityArray:Array):void
      {
         if (entityArray == null)
            return;
         
         for (var i:uint = 0; i < entityArray.length; ++ i)
         {
            if (entityArray[i] is Entity)
            {
               mSelectionListManager.AddSelectedEntity (entityArray[i]);
            }
         }
      }
      
      public function SelectEntity (entity:Entity):void
      {
         SelectEntities ([entity]);
      }
      
      public function UnselectEntities (entityArray:Array):void
      {
         if (entityArray == null)
            return;
         
         for (var i:uint = 0; i < entityArray.length; ++ i)
         {
            if (entityArray[i] is Entity)
            {
               mSelectionListManager.RemoveSelectedEntity (entityArray[i]);
            }
         }
      }
      
      public function UnselectEntity (entity:Entity):void
      {
         UnselectEntities ([entity]);
      }
      
      public function SetSelectedEntities (entityArray:Array):void
      {
         ClearSelectedEntities ();
         
         SelectEntities (entityArray);
      }
      
      public function SetSelectedEntity (entity:Entity):void
      {
         SetSelectedEntities ([entity]);
      }
      
      public function IsEntitySelected (entity:Entity):Boolean
      {
         return mSelectionListManager.IsEntitySelected (entity);
      }
      
      public function ToggleEntitySelected (entity:Entity):void
      {
         if ( IsEntitySelected (entity) )
            mSelectionListManager.RemoveSelectedEntity (entity);
         else
            mSelectionListManager.AddSelectedEntity (entity);
      }
      
      public function IsSelectedEntitiesContainPoint (pointX:Number, pointY:Number):Boolean
      {
         return mSelectionListManager.IsSelectedEntitiesContainPoint (pointX, pointY);
      }
      
      
//=================================================================================
//   select
//=================================================================================
      
      public function GetEntitiesIntersectWithRegion (displayX1:Number, displayY1:Number, displayX2:Number, displayY2:Number):Array
      {
         var objectArray:Array = mSelectionEngine.GetObjectsIntersectWithRegion (displayX1, displayY1, displayX2, displayY2);
         
         return ConvertObjectArrayToEntityArray (objectArray);
      }
      
      public function GetEntitiesAtPoint (displayX:Number, displayY:Number, lastSelectedEntity:Entity = null):Array
      {
         var objectArray:Array = mSelectionEngine.GetObjectsAtPoint (displayX, displayY);
         
         var entityArray:Array = ConvertObjectArrayToEntityArray (objectArray);
         
         if (lastSelectedEntity != null)
         {
            for (var i:int = 0; i < entityArray.length - 1; ++ i)
            {
               if (entityArray [i] == lastSelectedEntity)
               {
                  while (i -- >= 0)
                  {
                     entityArray.push (entityArray.shift ());
                  }
                  
                  break;
               }
            }
         }
         
         return entityArray;
      }
      
      public function GetVertexControllersAtPoint (displayX:Number, displayY:Number):Array
      {
         var objectArray:Array = mSelectionEngine.GetObjectsAtPoint (displayX, displayY);
         var vertexControllerArray:Array = new Array ();
         
         for (var i:uint = 0; i < objectArray.length; ++ i)
         {
            if (objectArray [i] is VertexController)
               vertexControllerArray.push (objectArray [i]);
         }
         
         trace ("objectArray.length = " + objectArray.length);
         trace ("vertexControllerArray.length = " + vertexControllerArray.length);
         
         return vertexControllerArray;
      }
      
      private function ConvertObjectArrayToEntityArray (objectArray:Array):Array
      {
         var entityArray:Array = new Array ();
         
         for (var i:uint = 0; i < objectArray.length; ++ i)
         {
            if (objectArray [i] is Entity)
               entityArray.push (objectArray [i]);
         }
         
         return entityArray;
      }
      
//=================================================================================
//   move. clone, destroy
//=================================================================================
      
      
      public function MoveSelectedEntities (offsetX:Number, offsetY:Number):void
      {
         var entityArray:Array = GetSelectedEntities ();
         
         var entity:Entity;
         
         for (var i:int = 0; i < entityArray.length; ++ i)
         {
            entity = entityArray [i] as Entity;
            
            entity.Move (offsetX, offsetY);
         }
      }
      
      public function RotateSelectedEntities (centerX:Number, centerY:Number, dRadians:Number):void
      {
         var entityArray:Array = GetSelectedEntities ();
         
         var entity:Entity;
         
         for (var i:int = 0; i < entityArray.length; ++ i)
         {
            entity = entityArray [i] as Entity;
            
            entity.Rotate (centerX, centerY, dRadians);
         }
      }
      
      public function ScaleSelectedEntities (centerX:Number, centerY:Number, ratio:Number):void
      {
         var entityArray:Array = GetSelectedEntities ();
         
         var entity:Entity;
         
         for (var i:int = 0; i < entityArray.length; ++ i)
         {
            entity = entityArray [i] as Entity;
            
            entity.Scale (centerX, centerY, ratio);
         }
      }
      
      public function DeleteSelectedEntities ():void
      {
         var entityArray:Array = mSelectionListManager.GetSelectedMainEntities ();
         
         var entity:Entity;
         
         for (var i:int = 0; i < entityArray.length; ++ i)
         {
            entity = entityArray [i] as Entity;
            
            DestroyEntity (entity);
         }
      }
      
      public function CloneSelectedEntities (offsetX:Number, offsetY:Number):void
      {
         var entityArray:Array = mSelectionListManager.GetSelectedMainEntities ();
         
         var entity:Entity;
         
         mSelectionListManager.ClearSelectedEntities ();
         
         for (var i:uint = 0; i < entityArray.length; ++ i)
         {
            entity = entityArray [i] as Entity;
            
            if (entity != null)
            {
               var newEntity:Entity = entity.Clone (offsetX, offsetY);
               
               if (newEntity != null)
               {
                  addChild (newEntity);
                  
                  SelectEntity (newEntity);
               }
            }
         }
      }
      
      
//=================================================================================
//   brothers
//=================================================================================
      
      
      public function GlueSelectedEntities ():void
      {
      }
      
      public function BreakApartSelectedEntities ():void
      {
      }
      
//=================================================================================
//   friends
//=================================================================================
      
      
      public function MakeFrinedsBetweenSelectedEntities ():void
      {
      }
      
      public function BreakFriendsWithSelectedEntities ():void
      {
      }
      
      public function BreakFriendsBwtweenSelectedEntities ():void
      {
         
      }
      
      
//=================================================================================
//   utils
//=================================================================================
      
      // here, the display1 and display2 are not essentially the children of this world
      public static function LocalToLocal (display1:DisplayObject, display2:DisplayObject, point:Point):Point
      {
         return display2.globalToLocal ( display1.localToGlobal (point) );
      }
      
      
   }
}

