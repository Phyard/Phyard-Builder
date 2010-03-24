
package editor.world {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import com.tapirgames.util.Logger;
   
   import editor.entity.Entity;
   import editor.entity.SubEntity;
   
   import editor.entity.EntityShape;
   import editor.entity.EntityShapeCircle;
   import editor.entity.EntityShapeRectangle;
   import editor.entity.EntityShapeText;
   
   import editor.entity.EntityJoint;
   import editor.entity.EntityJointDistance;
   import editor.entity.EntityJointHinge;
   import editor.entity.EntityJointSlider;
   import editor.entity.EntityJointSpring;
   
   
   
   import editor.entity.SubEntitySliderAnchor;
   
   import editor.entity.VertexController;
   
   import editor.selection.SelectionEngine;
   
   import editor.trigger.entity.Linkable;
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class EntityContainer extends Sprite 
   {
      public var mCoordinateSystem:CoordinateSystem;
      
      public var mSelectionEngine:SelectionEngine; // used within package
      
      public var mSelectionListManager:SelectionListManager;
      
      protected var mEntitiesSortedByCreationId:Array = new Array ();
      
      public function EntityContainer ()
      {
         mCoordinateSystem = Define.kDefaultCoordinateSystem;
         
         mSelectionEngine = new SelectionEngine ();
         
         mSelectionListManager = new SelectionListManager ();
      }
      
      public function Destroy ():void
      {
         DestroyAllEntities ();
         
         mSelectionEngine.Destroy ();
      }
      
      public function RebuildCoordinateSystem (originX:Number, originY:Number, scale:Number, rightHand:Boolean):void
      {
         if (scale <= 0)
            scale = 1.0;
         
         mCoordinateSystem = new CoordinateSystem (originX, originY, scale, rightHand);
      }
      
      public function GetCoordinateSystem ():CoordinateSystem
      {
         return mCoordinateSystem;
      }
      
      //public function GetWorldHints ():Object
      //{
      //   var world_hints:Object = new Object ();
      //   world_hints.mPhysicsShapesPotentialMaxCount = ValueAdjuster.AdjustPhysicsShapesPotentialMaxCount (4096);
      //   world_hints.mPhysicsShapesPopulationDensityLevel = ValueAdjuster.AdjustPhysicsShapesPopulationDensityLevel (4);
      //   
      //   return world_hints;
      //}
      
      public function Update (escapedTime:Number):void
      {
         var numEntities:int = mEntitiesSortedByCreationId.length;
         
         for (var i:uint = 0; i < numEntities; ++ i)
         {
            var entity:Entity = GetEntityByCreationId (i);
            
            if (entity != null)
            {
               entity.Update (escapedTime);
            }
         }
      }
      
//=================================================================================
//   destroy entities
//=================================================================================
      
      public function DestroyAllEntities ():void
      {
         while (mEntitiesSortedByCreationId.length > 0)
         {
            var entity:Entity = GetEntityByCreationId (0);
            DestroyEntity (entity.GetMainEntity ());
         }
      }
      
      public function DestroyEntity (entity:Entity):void
      {
      // selected
      
         mSelectionListManager.RemoveSelectedEntity (entity);
         
      // 
         
         entity.Destroy ();
         
         if ( contains (entity) )
            removeChild (entity);
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
            if (entityArray[i] != null && entityArray[i] is Entity)
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
//   vertex controller
//=================================================================================
      
      private var mTheSelectedVertexController:VertexController = null; // currently, only one VertexController can be selected
      
      public function SetSelectedVertexController (vertexController:VertexController):void
      {
         if (mTheSelectedVertexController != null)
            mTheSelectedVertexController.NotifySelectedChanged (false);
         
         mTheSelectedVertexController = vertexController;
         
         if (mTheSelectedVertexController != null)
            mTheSelectedVertexController.NotifySelectedChanged (true);
      }
      
      public function GetSelectedVertexControllers ():Array
      {
         if (mTheSelectedVertexController == null)
            return [];
         
         return [mTheSelectedVertexController];
      }
      
      public function MoveSelectedVertexControllers (offsetX:Number, offsetY:Number):void
      {
         if (mTheSelectedVertexController != null)
         {
            mTheSelectedVertexController.Move (offsetX, offsetY);
         }
      }
      
      public function DeleteSelectedVertexControllers ():void
      {
         if (mTheSelectedVertexController != null)
         {
            mTheSelectedVertexController = mTheSelectedVertexController.GetOwnerEntity ().RemoveVertexController (mTheSelectedVertexController);
         }
      }
      
      public function InsertVertexControllerBeforeSelectedVertexControllers ():void
      {
         if (mTheSelectedVertexController != null)
         {
            mTheSelectedVertexController = mTheSelectedVertexController.GetOwnerEntity ().InsertVertexController (mTheSelectedVertexController)
         }
      }
      
//=================================================================================
//   entity sorter
//=================================================================================
      
      public function GetObjectEntityAncestor (displayObject:DisplayObject):Entity
      {
         while (displayObject != null)
         {
            if (displayObject is Entity)
               return displayObject as Entity;
            else
               displayObject = displayObject.parent;
         }
         
         return null;
      }
      
      public function EntitySorter_ByAppearanceId (o1:Object, o2:Object):int
      {
         var id1:int = -1;
         var id2:int = -1;
         
         var entity:Entity;
         
         entity = o1 as Entity;
         if (entity != null)
            id1 = entity.GetAppearanceLayerId ();
         else
         {
            entity = GetObjectEntityAncestor (o1 as DisplayObject);
            if (entity != null)
               id1 = entity.GetAppearanceLayerId ();
         }
         
         entity = o2 as Entity;
         if (entity != null)
            id2 = entity.GetAppearanceLayerId ();
         else
         {
            entity = GetObjectEntityAncestor (o2 as DisplayObject);
            if (entity != null)
               id2 = entity.GetAppearanceLayerId ();
         }
         
         if (id1 > id2)
            return -1;
         else if (id1 < id2)
            return 1;
         else
            return 0;
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
         entityArray.sort (EntitySorter_ByAppearanceId);
         
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
            if (objectArray [i] is Entity && objectArray [i].IsVisibleInEditor ())
               entityArray.push (objectArray [i]);
         }
         
         return entityArray;
      }
      
      public function GetFirstLinkablesAtPoint (displayX:Number, displayY:Number):Linkable
      {
         var objectArray:Array = mSelectionEngine.GetObjectsAtPoint (displayX, displayY);
         objectArray.sort (EntitySorter_ByAppearanceId);
         var linkable:Linkable = null;
         for (var i:uint = 0; i < objectArray.length; ++ i)
         {
            if (objectArray [i] is Linkable && objectArray [i] is DisplayObject)
            {
               if ( (! (objectArray [i] is Entity)) || (objectArray [i] as Entity).IsVisibleInEditor ())
               {
                  linkable = objectArray [i] as Linkable;
                  if (linkable.CanStartCreatingLink (displayX, displayY))
                     return linkable;
                  else
                     return null;
               }
            }
         }
         
         return null;
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
         if (ratio <= 0)
            return;
         
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
      
      public function CloneSelectedEntities (offsetX:Number, offsetY:Number, cloningInfo:Array = null):void
      {
         var selectedEntities:Array = GetSelectedEntities ();
         var mainEntities:Array = new Array ();
         //var cloningInfo:Array = new Array ();
         var mainEntity:Entity;
         var i:uint;
         var index:int;
         var info:Object;
         var params:Object;
         
         for (i = 0; i < selectedEntities.length; ++ i)
         {
            mainEntity = (selectedEntities [i] as Entity).GetMainEntity ();
            
            index = mainEntities.indexOf (mainEntity);
            if (index < 0)
            {
               index = mainEntities.length;
               mainEntities.push (mainEntity);
            }
            
            if (cloningInfo != null)
            {
               info = new Object ();
               info.mMainEntity = mainEntity;
               info.mMainEntityOldArrayIndex = index;
               cloningInfo.push (info);
            }
         }
         
         for (i = 0; i < mainEntities.length; ++ i)
         {
            params = new Object ();
            params.mOldArrayIndex = i;
            params.mCreateOrderId = GetEntityCreationId (mainEntities [i]);
            params.mMainEntity = mainEntities [i];
            mainEntities [i] = params;
         }
         
         mainEntities.sortOn("mCreateOrderId", Array.NUMERIC);
         
         mSelectionListManager.ClearSelectedEntities ();
         
         var oldIndex2NewIndex:Array = new Array (mainEntities.length);
         var newEntity:Entity;
         
         var oldNumChildren:int = numChildren;
         var clonedEntities:Array = new Array ();
         var newEntitiesSortedByLayerId:Array = new Array ();
         var object:Object;
         var oldSubEntities:Array;
         var newSubEntities:Array;
         var j:int;
         
         for (i = 0; i < mainEntities.length; ++ i)
         {
            params = mainEntities [i];
            oldIndex2NewIndex [params.mOldArrayIndex] = i;
            
            mainEntity = params.mMainEntity;
            
            if (numChildren >= Define.MaxEntitiesCount)
               newEntity = null;
            else
               newEntity = mainEntity.Clone (offsetX, offsetY);
            
            params.mClonedEntity = newEntity;
            
            if (newEntity != null)
            {
               //addChild (newEntity); // entities will be added by appearane layer id
               //SelectEntities (newEntity.GetSubEntities ());
               
               oldSubEntities = mainEntity.GetSubEntities ();
               oldSubEntities.push (mainEntity);
               
               newSubEntities = newEntity.GetSubEntities ();
               newSubEntities.push (newEntity);
               
               for (j = 0; j < newSubEntities.length; ++ j)
               {
                  if (clonedEntities.indexOf (newSubEntities [j]) < 0)
                  {
                     clonedEntities.push (newSubEntities [j]);
                     
                     object = new Object ();
                     object.mClonedEntity = newSubEntities [j];
                     object.mAppearOrderId = GetEntityAppearanceId (oldSubEntities [j]);
                     
                     newEntitiesSortedByLayerId.push (object);
                  }
               }
            }
         }
         
         while (numChildren > oldNumChildren)
            removeChildAt (oldNumChildren); // remvoe then re-add
         
         newEntitiesSortedByLayerId.sortOn("mAppearOrderId", Array.NUMERIC);
         for (i = 0; i < newEntitiesSortedByLayerId.length; ++ i)
         {
            object = newEntitiesSortedByLayerId [i];
            newEntity = object.mClonedEntity;
            
            if (newEntity != null)
            {
               addChild (newEntity);
               SelectEntities (newEntity.GetSubEntities ());
            }
         }
         
         if (cloningInfo != null)
         {
            for (i = 0; i < selectedEntities.length; ++ i)
            {
               info = cloningInfo [i];
               
               //trace ("info.mMainEntityOldArrayIndex = " + info.mMainEntityOldArrayIndex);
               //trace ("oldIndex2NewIndex = " + oldIndex2NewIndex);
               //trace ("oldIndex2NewIndex[info.mMainEntityOldArrayIndex] = " + oldIndex2NewIndex[info.mMainEntityOldArrayIndex]);
               //trace ("mainEntities [ oldIndex2NewIndex[info.mMainEntityOldArrayIndex] ] = " + mainEntities [ oldIndex2NewIndex[info.mMainEntityOldArrayIndex] ]);
               //trace ("mainEntities [ oldIndex2NewIndex[info.mMainEntityOldArrayIndex] ].mClonedEntity = " + mainEntities [ oldIndex2NewIndex[info.mMainEntityOldArrayIndex] ].mClonedEntity);
               
               info.mClonedMainEntity = mainEntities [ oldIndex2NewIndex[info.mMainEntityOldArrayIndex] ].mClonedEntity;
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
      
      public function EntitySorter_ByEntityAppearanceId (entity1:Entity, entity2:Entity):int
      {
         return entity1.GetAppearanceLayerId () < entity2.GetAppearanceLayerId () ? - 1 : 1;
      }
      
      public function MoveSelectedEntitiesToTop ():void
      {
         var entityArray:Array = GetSelectedEntities ();
         entityArray.sort (EntitySorter_ByEntityAppearanceId);
         
         var entity:Entity;
         
         for (var i:int = 0; i < entityArray.length; ++ i)
         {
            entity = entityArray [i];
            
            //if ( entity.GetMainEntity () != null && contains (entity.GetMainEntity ()) )
            //{
            //   removeChild (entity.GetMainEntity ());
            //   addChild (entity.GetMainEntity ());
            //}
            
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
         entityArray.sort (EntitySorter_ByEntityAppearanceId);
         
         var entity:Entity;
         
         for (var i:int = entityArray.length - 1; i >= 0; -- i)
         {
            entity = entityArray [i];
            
            if ( entity != null && contains (entity) )
            {
               removeChild (entity);
               addChildAt (entity, 0);
            }
            
            //if ( entity.GetMainEntity () != null && contains (entity.GetMainEntity ()) )
            //{
            //   removeChild (entity.GetMainEntity ());
            //   addChildAt (entity.GetMainEntity (), 0);
            //}
         }
      }
      
//=================================================================================
//   draw ids
//=================================================================================
      
      public function DrawEntityIds (canvasSprite:Sprite):void
      {
         var entity:Entity;
         var i:int;
         var numEntities:int = mEntitiesSortedByCreationId.length;
         for (i = 0; i < numEntities; ++ i)
         {
            entity = GetEntityByCreationId (i);
            if (entity != null)
            {
               entity.DrawEntityId (canvasSprite);
            }
         }
      }
      
//=================================================================================
// 
//=================================================================================
      
      override public function addChild(child:DisplayObject):DisplayObject
      {
         mNeedToCorrectEntityAppearanceIds = true;
         mNeedToCorrectEntityCreationIds = true;
         
         return super.addChild(child);
      }
      
      override public function addChildAt(child:DisplayObject, index:int):DisplayObject
      {
         mNeedToCorrectEntityAppearanceIds = true;
         mNeedToCorrectEntityCreationIds = true;
         
         return super.addChildAt(child, index);
      }
      
      override public function removeChild(child:DisplayObject):DisplayObject
      {
         mNeedToCorrectEntityAppearanceIds = true;
         mNeedToCorrectEntityCreationIds = true;
         
         var entity:Entity = child as Entity;
         if (entity != null)
         {
            entity.SetAppearanceLayerId (-1);
         }
         
         return super.removeChild(child);
      }
      
      override public function removeChildAt(index:int):DisplayObject
      {
         mNeedToCorrectEntityAppearanceIds = true;
         mNeedToCorrectEntityCreationIds = true;
         
         var child:DisplayObject = super.removeChildAt(index);
         var entity:Entity = child as Entity;
         if (entity != null)
         {
            entity.SetAppearanceLayerId (-1);
         }
         
         return child;
      }
      
      override public function setChildIndex(child:DisplayObject, index:int):void
      {
         mNeedToCorrectEntityAppearanceIds = true;
         
         super.setChildIndex(child, index);
      }
      
      override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
      {
         mNeedToCorrectEntityAppearanceIds = true;
         
         super.swapChildren(child1, child2);
      }
      
      override public function swapChildrenAt(index1:int, index2:int):void
      {
         mNeedToCorrectEntityAppearanceIds = true;
         
         super.swapChildrenAt(index1, index2);
      }
      
      protected var mNeedToCorrectEntityAppearanceIds:Boolean = false;
      
      public function CorrectEntityAppearanceIds ():void
      {
         if ( mNeedToCorrectEntityAppearanceIds)
         {
            mNeedToCorrectEntityAppearanceIds = false;
            
            var entity:Entity;
            var i:int = 0;
            for (i = 0; i < numChildren; ++ i)
            {
               entity = getChildAt (i) as Entity;
               if (entity != null)
                  entity.SetAppearanceLayerId (i);
            }
         }
      }
      
      public function GetEntityByAppearanceId (appearanceId:int):Entity
      {
         CorrectEntityAppearanceIds ();
         
         if (appearanceId < 0 || appearanceId >= numChildren)
            return null;
         
         return getChildAt (appearanceId) as Entity;
      }
      
//============================================================================
// 
//============================================================================
      
      public function OnEntityCreated (entity:Entity):void
      {
         mNeedToCorrectEntityCreationIds = true;
         
         if (mIsCreationArrayOpened)
         {
            if (mEntitiesSortedByCreationId.indexOf (entity) < 0)
               mEntitiesSortedByCreationId.push (entity);
         }
      }
      
      public function OnEntityDestroyed (entity:Entity):void
      {
         mNeedToCorrectEntityCreationIds = true;
         
         if (mIsCreationArrayOpened)
         {
            var index:int = mEntitiesSortedByCreationId.indexOf (entity);
            if (index >= 0)
            {
               mEntitiesSortedByCreationId.splice (index, 1);
               entity.SetCreationOrderId (-1);
            }
         }
      }
      
      private var mNeedToCorrectEntityCreationIds:Boolean = false;
      
      public function CorrectEntityCreationIds ():void
      {
         if (mNeedToCorrectEntityCreationIds)
         {
            mNeedToCorrectEntityCreationIds = false;
            
            var numEntities:int = mEntitiesSortedByCreationId.length;
            for (var i:int = 0; i < numEntities; ++ i)
            {
               (mEntitiesSortedByCreationId [i] as Entity).SetCreationOrderId (i);
            }
         }
      }
      
      public function GetEntityByCreationId (creationId:int):Entity
      {
         CorrectEntityCreationIds ();
         
         if (creationId < 0 || creationId >= mEntitiesSortedByCreationId.length)
            return null;
         
         return mEntitiesSortedByCreationId [creationId];
      }
      
      // for loading into editor
      private var mIsCreationArrayOpened:Boolean = true;
      public function SetCreationEntityArrayLocked (locked:Boolean):void
      {
         mIsCreationArrayOpened = ! locked;
      }
      
      public function AddEntityToCreationArray (entity:Entity):void
      {
         mNeedToCorrectEntityCreationIds = true;
         
         if (mIsCreationArrayOpened)
            mEntitiesSortedByCreationId.push (entity);
      }
      
//============================================================================
// utils
//============================================================================
      
      public function GetNumEntities (filterFunc:Function = null):int
      {
         var numEntities:int = mEntitiesSortedByCreationId.length;
         if ( filterFunc == null)
            return numEntities;
         
         var count:int = 0;
         var entity:Entity;
         for (var i:int = 0; i < numEntities; ++ i)
         {
            entity = GetEntityByCreationId (i);
            if (filterFunc (entity))
               ++ count;
         }
         
         return count;
      }
      
      public function GetEntityAppearanceId (entity:Entity):int
      {
         if (entity == null)
            return -1;
         
         // for speed, commented off
         //if (entity.GetContainer () != this)
         //   return -1;
         
         return entity.GetAppearanceLayerId ();
      }
      
      public function GetEntityCreationId (entity:Entity):int
      {
         if (entity == null)
            return -1;
         
         // for speed, commented off
         //if (entity.GetContainer () != this)
         //   return -1;
         
         return entity.GetCreationOrderId ();
      }
      
      public function EntitiyArray2EntityCreationIdArray (entities:Array):Array
      {
         if (entities == null)
            return null;
         
         var ids:Array = new Array (entities.length);
         for (var i:int = 0; i < entities.length; ++ i)
         {
            ids [i] = GetEntityCreationId (entities [i] as Entity);
         }
         
         return ids;
      }
      
      public function EntityCreationIdArray2EntityArray (ids:Array):Array
      {
         if (ids == null)
            return null;
         
         var entities:Array = new Array (ids.length);
         for (var i:int = 0; i < ids.length; ++ i)
         {
            entities [i] = GetEntityByCreationId ( int (ids [i]) );
         }
         
         return entities;
      }
      
//====================================================================
//   properties
//====================================================================
      
      public function GetPropertyValue (propertyId:int):Object
      {
         return null;
      }
      
      public function SetPropertyValue (propertyId:int, value:Object):void
      {
      }
   }
}

