
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
   
   import common.Define;
   
   public class EntityContainer extends Sprite 
   {
      
      public var mSelectionEngine:SelectionEngine; // used within package
      
      public var mSelectionListManager:SelectionListManager;
      
      public function EntityContainer ()
      {
      //
         // it is best to set the aabb runtimely when user change the playfield size
         
         var largestHalfSideWidth :int = Define.LargeWorldHalfWidth + 1000 
         var largestHalfSideHeight:int = Define.LargeWorldHalfHeight + 1000;
         mSelectionEngine = new SelectionEngine (new Point (-largestHalfSideWidth, -largestHalfSideHeight), new Point (largestHalfSideWidth, largestHalfSideHeight));
         
         mSelectionListManager = new SelectionListManager ();
      }
      
      public function Destroy ():void
      {
         DestroyAllEntities ();
         
         mSelectionEngine.Destroy ();
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
            params.mEntityIndex = contains (mainEntities [i]) ? getChildIndex (mainEntities [i]) : -1;
            params.mMainEntity = mainEntities [i];
            mainEntities [i] = params;
         }
         
         mainEntities.sortOn("mEntityIndex", Array.NUMERIC);
         
         mSelectionListManager.ClearSelectedEntities ();
         
         var oldIndex2NewIndex:Array = new Array (mainEntities.length);
         var newEntity:Entity;
         
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
         
         /*
         var mainEntityArray:Array = mSelectionListManager.GetSelectedMainEntities ();
         
         var i:uint;
         for (i = 0; i < mainEntityArray.length; ++ i)
         {
            var params:Object = new Object ();
            params.mEntity = mainEntityArray [i];
            params.mEntityIndex = contains (mainEntityArray [i]) ? getChildIndex (mainEntityArray [i]) : -1;
            mainEntityArray [i] = params;
         }
         
         mainEntityArray.sortOn("mEntityIndex", Array.NUMERIC);
         
         for (i = 0; i < mainEntityArray.length; ++ i)
         {
            mainEntityArray [i] = mainEntityArray [i].mEntity;
         }
         
         var entity:Entity;
         var clonedEntities:Array = new Array ();
         var clonePair:Object;
         
         mSelectionListManager.ClearSelectedEntities ();
         
         for (i = 0; i < mainEntityArray.length; ++ i)
         {
            entity = mainEntityArray [i] as Entity;
            
            if (entity != null)
            {
               if (numChildren >= Define.MaxEntitiesCount)
                  return;
                  
               var newEntity:Entity = entity.Clone (offsetX, offsetY);
               
               if (newEntity != null)
               {
                  addChild (newEntity);
                  
                  SelectEntities (newEntity.GetSubEntities ());
                  
                  clonePair = new Object ();
                  clonePair.mMainEntity = entity;
                  clonePair.mClonedEntity = newEntity;
                  clonedEntities.push (clonePair);
               }
            }
         }
         */
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
//  
//=================================================================================
      
   }
}
