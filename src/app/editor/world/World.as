
package editor.world {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import com.tapirgames.util.Logger;
   
   import editor.entity.Entity;
   import editor.entity.SubEntity;
   
   import editor.entity.EntityShapeCircle;
   import editor.entity.EntityShapeRectangle;
   
   import editor.entity.EntityJointDistance;
   import editor.entity.EntityJointHinge;
   import editor.entity.EntityJointSlider;
   import editor.entity.EntityJointSpring;
   
   import editor.entity.SubEntitySliderAnchor;
   
   import editor.entity.VertexController;
   
   import editor.selection.SelectionEngine;
   
   import common.Define;
   
   public class World extends Sprite 
   {
      
      public var mSelectionEngine:SelectionEngine; // used within package
      
      public var mSelectionListManager:SelectionListManager;
      
      public var mBrothersManager:BrothersManager;
      
      private var mAuthorName:String = "";
      private var mAuthorHomepage:String = "";
      
      public function World ()
      {
      //
         mSelectionEngine = new SelectionEngine ();
         
         mSelectionListManager = new SelectionListManager ();
         
         mBrothersManager = new BrothersManager ();
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
//   author
//=================================================================================
      
      public function SetAuthorName (name:String):void
      {
         mAuthorName = name;
      }
      
      public function GetAuthorName ():String
      {
         return mAuthorName;
      }
      
      public function SetAuthorHomepage (link:String):void
      {
         mAuthorHomepage = link;
      }
      
      public function GetAuthorHomepage ():String
      {
         return mAuthorHomepage;
      }
      
//=================================================================================
//   create and destroy entities
//=================================================================================
      
      public function DestroyAllEntities ():void
      {
         while (numChildren > 0)
         {
            var entity:Entity = getChildAt (0) as Entity;
            DestroyEntity (entity.GetMainEntity ());
         }
      }
      
      public function DestroyEntity (entity:Entity):void
      {
      // selected
      
         mSelectionListManager.RemoveSelectedEntity (entity);
         
      // friends
         
         
         
      // brothers
         
         mBrothersManager.OnDestroyEntity (entity);
         
      // ...
         
         entity.Destroy ();
         
         if ( contains (entity) )
            removeChild (entity);
      }
      
      public function CreateEntityShapeCircle ():EntityShapeCircle
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
            
         var circle:EntityShapeCircle = new EntityShapeCircle (this);
         addChild (circle);
         
         return circle;
      }
      
      public function CreateEntityShapeRectangle ():EntityShapeRectangle
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
            
         var rect:EntityShapeRectangle = new EntityShapeRectangle (this);
         addChild (rect);
         
         return rect;
      }
      
      public function CreateEntityJointDistance ():EntityJointDistance
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
            
         var distaneJoint:EntityJointDistance = new EntityJointDistance (this);
         addChild (distaneJoint);
         
         return distaneJoint;
      }
      
      public function CreateEntityJointHinge ():EntityJointHinge
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
            
         var hinge:EntityJointHinge = new EntityJointHinge (this);
         addChild (hinge);
         
         return hinge;
      }
      
      public function CreateEntityJointSlider ():EntityJointSlider
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
            
         var slider:EntityJointSlider = new EntityJointSlider (this);
         addChild (slider);
         
         return slider;
      }
      
      public function CreateEntityJointSpring ():EntityJointSpring
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
            
         var spring:EntityJointSpring = new EntityJointSpring (this);
         addChild (spring);
         
         return spring;
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
//   move. clone, flip, ...
//=================================================================================
      
      
      public function MoveSelectedEntities (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean):void
      {
         var entityArray:Array = GetSelectedEntities ();
         
         var entity:Entity;
         
         for (var i:int = 0; i < entityArray.length; ++ i)
         {
            entity = entityArray [i] as Entity;
            
            entity.Move (offsetX, offsetY, updateSelectionProxy);
         }
      }
      
      public function RotateSelectedEntities (centerX:Number, centerY:Number, dRadians:Number, updateSelectionProxy:Boolean):void
      {
         var entityArray:Array = GetSelectedEntities ();
         
         var entity:Entity;
         
         for (var i:int = 0; i < entityArray.length; ++ i)
         {
            entity = entityArray [i] as Entity;
            
            entity.Rotate (centerX, centerY, dRadians, updateSelectionProxy);
         }
      }
      
      public function ScaleSelectedEntities (centerX:Number, centerY:Number, ratio:Number, updateSelectionProxy:Boolean):void
      {
         var entityArray:Array = GetSelectedEntities ();
         
         var entity:Entity;
         
         for (var i:int = 0; i < entityArray.length; ++ i)
         {
            entity = entityArray [i] as Entity;
            
            entity.Scale (centerX, centerY, ratio, updateSelectionProxy);
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
               if (numChildren >= Define.MaxEntitiesCount)
                  return;
                  
               var newEntity:Entity = entity.Clone (offsetX, offsetY);
               
               if (newEntity != null)
               {
                  addChild (newEntity);
                  
                  SelectEntities (newEntity.GetSubEntities ());
               }
            }
         }
      }
      
      public function FlipSelectedEntitiesHorizontally (mirrorX:Number):void
      {
         var entityArray:Array = GetSelectedEntities ();
         
         var entity:Entity;
         
         for (var i:int = 0; i < entityArray.length; ++ i)
         {
            entity = entityArray [i] as Entity;
            
            entity.FlipHorizontally (mirrorX);
         }
      }
      
      public function FlipSelectedEntitiesVertically (mirrorY:Number):void
      {
         var entityArray:Array = GetSelectedEntities ();
         
         var entity:Entity;
         
         for (var i:int = 0; i < entityArray.length; ++ i)
         {
            entity = entityArray [i] as Entity;
            
            entity.FlipVertically (mirrorY);
         }
      }
      
      public function MoveSelectedEntitiesToTop ():void
      {
         var entityArray:Array = GetSelectedEntities ();
         
         var entity:Entity;
         
         for (var i:int = 0; i < entityArray.length; ++ i)
         {
            entity = entityArray [i];
            
            if ( entity.GetMainEntity () != null && contains (entity.GetMainEntity ()) )
            {
               removeChild (entity.GetMainEntity ());
               addChild (entity.GetMainEntity ());
            }
            
            if ( entity != null && contains (entity) )
            {
               removeChild (entity);
               addChild (entity);
            }
         }
      }
      
      public function MoveSelectedEntitiesToBottom ():void
      {
         var entityArray:Array = GetSelectedEntities ();
         
         var entity:Entity;
         
         for (var i:int = 0; i < entityArray.length; ++ i)
         {
            entity = entityArray [i];
            
            if ( entity != null && contains (entity) )
            {
               removeChild (entity);
               addChildAt (entity, 0);
            }
            
            if ( entity.GetMainEntity () != null && contains (entity.GetMainEntity ()) )
            {
               removeChild (entity.GetMainEntity ());
               addChildAt (entity.GetMainEntity (), 0);
            }
         }
      }
      
      
      
//=================================================================================
//   brothers
//=================================================================================
      
      public function GetBrotherGroups ():Array
      {
         return mBrothersManager.mBrotherGroupArray;
      }
      
      public function GlueEntities (entities:Array):void
      {
         mBrothersManager.MakeBrothers (entities);
      }
      
      public function GlueEntitiesByIndices (entityIndices:Array):void
      {
         var entities:Array = new Array (entityIndices.length);
         
         for (var i:int = 0; i < entityIndices.length; ++ i)
         {
            entities [i] = getChildAt (entityIndices [i]);
         }
         
         mBrothersManager.MakeBrothers (entities);
      }
      
      public function GlueSelectedEntities ():void
      {
         var entityArray:Array = GetSelectedEntities ();
         
         GlueEntities (entityArray);
      }
      
      public function BreakApartSelectedEntities ():void
      {
         var entityArray:Array = GetSelectedEntities ();
         
         mBrothersManager.BreakApartBrothers (entityArray);
      }
      
      public function GetGluedEntitiesWithEntity (entity:Entity):Array
      {
         var brothers:Array = mBrothersManager.GetBrothersOfEntity (entity);
         return brothers == null ? new Array () : brothers;
      }
      
      
      public function SelectGluedEntitiesOfSelectedEntities ():void
      {
         var brotherGroups:Array = new Array ();
         var entityId:int;
         var brothers:Array;
         var groupId:int;
         var index:int;
         var entity:Entity;
         
         var selectedEntities:Array = GetSelectedEntities ();
         
         for (entityId = 0; entityId < selectedEntities.length; ++ entityId)
         {
            brothers = selectedEntities [entityId].GetBrothers ();
            
            if (brothers != null)
            {
               index = brotherGroups.indexOf (brothers);
               if (index < 0)
                  brotherGroups.push (brothers);
            }
         }
         
         for (groupId = 0; groupId < brotherGroups.length; ++ groupId)
         {
            brothers = brotherGroups [groupId];
            
            for (entityId = 0; entityId < brothers.length; ++ entityId)
            {
               entity = brothers [entityId] as Entity;
               
               //if ( ! IsEntitySelected (entity) )
               if ( ! entity.IsSelected () )  // not formal, but fast
               {
                  SelectEntity (entity);
               }
            }
         }
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
         // seems flash will auto postions of displayobjects. so the current implementings of this
         // function is not very accurate!
         
         
         //
         var matrix:Matrix = display2.transform.concatenatedMatrix.clone();
         matrix.invert();
         return matrix.transformPoint (display1.transform.concatenatedMatrix.transformPoint (point));
         
         //return display2.globalToLocal ( display1.localToGlobal (point) );
      }
      
      
   }
}

