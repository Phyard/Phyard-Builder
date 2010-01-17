
package editor.world {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   
   import com.tapirgames.util.Logger;
   
   import editor.entity.Entity;
   import editor.entity.SubEntity;
   
   import editor.entity.EntityShape;
   import editor.entity.EntityShapeCircle;
   import editor.entity.EntityShapeRectangle;
   import editor.entity.EntityShapePolygon;
   import editor.entity.EntityShapePolyline;
   import editor.entity.EntityShapeText;
   import editor.entity.EntityShapeTextButton;
   import editor.entity.EntityShapeGravityController;
   import editor.entity.EntityUtilityCamera;
   
   import editor.entity.EntityJoint;
   import editor.entity.EntityJointDistance;
   import editor.entity.EntityJointHinge;
   import editor.entity.EntityJointSlider;
   import editor.entity.EntityJointSpring;
   
   import editor.entity.SubEntityJointAnchor;
   
   import editor.trigger.entity.EntityBasicCondition;
   import editor.trigger.entity.EntityConditionDoor;
   import editor.trigger.entity.EntityTask;
   import editor.trigger.entity.EntityInputEntityAssigner;
   import editor.trigger.entity.EntityInputEntityPairAssigner;
   import editor.trigger.entity.EntityEventHandler;
   import editor.trigger.entity.EntityEventHandler_Timer;
   import editor.trigger.entity.EntityEventHandler_Keyboard;
   import editor.trigger.entity.EntityEventHandler_Mouse;
   import editor.trigger.entity.EntityAction;
   
   import editor.entity.VertexController;
   
   import editor.entity.EntityCollisionCategory;
   
   import editor.selection.SelectionEngine;
   
   import editor.trigger.TriggerEngine;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class World extends EntityContainer 
   {
      public var mBrothersManager:BrothersManager;
      
      public var mCollisionManager:CollisionManager;
      
      public var mSelectionEngineForVertexes:SelectionEngine; // used within package
      
      public var mTiggerEngine:TriggerEngine;
      
      // temp the 2 is not used
      // somewhere need to be modified to use the 2 
      public var mNumGravityControllers:int = 0;
      public var mNumCameraEntities:int = 0;
      
      public function World ()
      {
      //
         mBrothersManager = new BrothersManager ();
         
         mCollisionManager = new CollisionManager ();
         
         //mSelectionEngineForVertexes = new SelectionEngine ();
         mSelectionEngineForVertexes = mSelectionEngine;
         
         mTiggerEngine = new TriggerEngine ();
      }
      
      override public function Destroy ():void
      {
         mCollisionManager.Destroy ();
         
         super.Destroy ();
         
         if (mSelectionEngineForVertexes != mSelectionEngine)
            mSelectionEngineForVertexes.Destroy ();
      }
      
      override public function DestroyAllEntities ():void
      {
         mCollisionManager.DestroyAllEntities ();
         
         super.DestroyAllEntities ();
      }
      
      override public function DestroyEntity (entity:Entity):void
      {
      // friends
         
         
         
      // brothers
         
         mBrothersManager.OnDestroyEntity (entity);
         
      // ...
         
         super.DestroyEntity (entity);
      }
      
      override public function GetVertexControllersAtPoint (displayX:Number, displayY:Number):Array
      {
         var objectArray:Array = mSelectionEngineForVertexes.GetObjectsAtPoint (displayX, displayY);
         var vertexControllerArray:Array = new Array ();
         
         for (var i:uint = 0; i < objectArray.length; ++ i)
         {
            if (objectArray [i] is VertexController)
               vertexControllerArray.push (objectArray [i]);
         }
         
         return vertexControllerArray;
      }
      
//=================================================================================
//   settings 
//=================================================================================
      
      private var mAuthorName:String = "";
      private var mAuthorHomepage:String = "";
      private var mShareSourceCode:Boolean = false;
      private var mPermitPublishing:Boolean = false;
      
      // display values, pixles
      private var mInfiniteWorldSize:Boolean = false;
      
      private var mWorldLeft:int = 0;
      private var mWorldTop:int = 0;
      private var mWorldWidth:int = Define.DefaultWorldWidth;
      private var mWorldHeight:int = Define.DefaultWorldHeight;
      
      //>>v1.08
      private var mWorldBorderLeftThickness:Number = Define.WorldBorderThinknessLR;
      private var mWorldBorderTopThickness:Number = Define.WorldBorderThinknessTB;
      private var mWorldBorderRightThickness:Number = Define.WorldBorderThinknessLR;
      private var mWorldBorderBottomThickness:Number = Define.WorldBorderThinknessTB;
      //<<
      
      // display values, pixles
      private var mCameraCenterX:int = mWorldLeft + mWorldWidth * 0.5;
      private var mCameraCenterY:int = mWorldTop  + mWorldHeight * 0.5;
      
      private var mBackgroundColor:uint = 0xDDDDA0;
      private var mBuildBorder:Boolean = true;
      private var mBorderColor:uint = Define.ColorStaticObject;
      
      //>>v1.08
      private var mBorderAtTopLayer:Boolean = true;
      //<<
      
      private var mZoomScale:Number = 1.0;
      
      private var mPhysicsShapesPotentialMaxCount:int = 1024;
      private var mPhysicsShapesPopulationDensityLevel:int = 8;
      
      //>>v1.08
      // the 2 are both display values
      private var mDefaultGravityAccelerationMagnitude:Number = 196; // pixels
      private var mDefaultGravityAccelerationAngle:Number = 90; // degrees in left hand coordinates
      //<<
      
      //
      private var mCiRulesEnabled:Boolean = true;
      
      public function SetAuthorName (name:String):void
      {
         if (name == null)
            name = "";
         
         if (name.length > 30)
            name = name.substr (0, 30);
         
         mAuthorName = name;
      }
      
      public function GetAuthorName ():String
      {
         return mAuthorName;
      }
      
      public function SetAuthorHomepage (url:String):void
      {
         if (url == null)
            url = "";
         
         if (url.length > 0)
         {
            if (url.substr (0, 4).toLowerCase() != "http")
                url = "http://" + url;
            if (url.length > 100)
               url = url.substr (0, 100);
         }
         
         mAuthorHomepage = url;
      }
      
      public function GetAuthorHomepage ():String
      {
         return mAuthorHomepage;
      }
      
      public function SetShareSourceCode (share:Boolean):void
      {
         mShareSourceCode = share;
      }
      
      public function IsShareSourceCode ():Boolean
      {
         return mShareSourceCode;
      }
      
      public function SetPermitPublishing (permit:Boolean):void
      {
         mPermitPublishing = permit;
      }
      
      public function IsPermitPublishing ():Boolean
      {
         return mPermitPublishing;
      }
      
      public function SetWorldLeft (left:int):void
      {
         mWorldLeft = left;
      }
      
      public function GetWorldLeft ():int
      {
         return mWorldLeft;
      }
      
      public function SetWorldTop (top:int):void
      {
         mWorldTop = top;
      }
      
      public function GetWorldTop ():int
      {
         return mWorldTop;
      }
      
      public function SetWorldWidth (ww:int):void
      {
         mWorldWidth = ww;
      }
      
      public function GetWorldWidth ():int
      {
         return mWorldWidth;
      }
      
      public function SetWorldHeight (wh:int):void
      {
         mWorldHeight = wh;
      }
      
      public function GetWorldHeight ():int
      {
         return mWorldHeight;
      }
      
      public function GetWorldRight ():int
      {
         return mWorldLeft + mWorldWidth;
      }
      
      public function GetWorldBottom ():int
      {
         return mWorldTop + mWorldHeight;
      }
      
      public function SetWorldBorderLeftThickness (thickness:Number):void
      {
         mWorldBorderLeftThickness = thickness;
      }
      
      public function SetWorldBorderTopThickness (thickness:Number):void
      {
         mWorldBorderTopThickness = thickness;
      }
      
      public function SetWorldBorderRightThickness (thickness:Number):void
      {
         mWorldBorderRightThickness = thickness;
      }
      
      public function SetWorldBorderBottomThickness (thickness:Number):void
      {
         mWorldBorderBottomThickness = thickness;
      }
      
      public function GetWorldBorderLeftThickness ():Number
      {
         return mWorldBorderLeftThickness;
      }
      
      public function GetWorldBorderTopThickness ():Number
      {
         return mWorldBorderTopThickness;
      }
      
      public function GetWorldBorderRightThickness ():Number
      {
         return mWorldBorderRightThickness;
      }
      
      public function GetWorldBorderBottomThickness ():Number
      {
         return mWorldBorderBottomThickness;
      }
      
      public function SetCameraCenterX (centerX:int):void
      {
         mCameraCenterX = centerX;
      }
      
      public function GetCameraCenterX ():int
      {
         return mCameraCenterX;
      }
      
      public function SetCameraCenterY (centerY:int):void
      {
         mCameraCenterY = centerY;
      }
      
      public function GetCameraCenterY ():int
      {
         return mCameraCenterY;
      }
      
      public function SetBackgroundColor (bgColor:uint):void
      {
         mBackgroundColor = bgColor;
      }
      
      public function GetBackgroundColor ():uint
      {
         return mBackgroundColor;
      }
      
      public function SetBorderColor (bgColor:uint):void
      {
         mBorderColor = bgColor;
      }
      
      public function GetBorderColor ():uint
      {
         return mBorderColor;
      }
      
      public function SetBuildBorder (buildBorder:Boolean):void
      {
         mBuildBorder = buildBorder;
      }
      
      public function IsBuildBorder ():Boolean
      {
         return mBuildBorder;
      }
      
      public function SetBorderAtTopLayer (topLayer:Boolean):void
      {
         mBorderAtTopLayer = topLayer;
      }
      
      public function IsBorderAtTopLayer ():Boolean
      {
         return mBorderAtTopLayer;
      }
      
      public function GetZoomScale ():Number
      {
         return mZoomScale;
      }
      
      public function SetZoomScale (zoomScale:Number):void
      {
         mZoomScale = zoomScale;
         
         scaleX = zoomScale;
         scaleY = zoomScale;
         
         var entity:Entity;
         var numEntities:int = mEntitiesSortedByCreationId.length;
         
         for (var entityId:int = 0; entityId < numEntities; ++ entityId)
         {
            entity = GetEntityByCreationId (entityId);
            entity.OnWorldZoomScaleChanged ();
         }
      }
      
      public function StatisticsPhysicsShapes ():void
      {
         var entity:Entity;
         
         var shapes_count:int = 0;
         var bombs_count:int = 0;
         
         var numEntities:int = mEntitiesSortedByCreationId.length;
         
         for (var i:int = 0; i < numEntities; ++ i)
         {
            entity = GetEntityByCreationId (i);
            if (entity != null)
               shapes_count += entity.GetPhysicsShapesCount ()
            
            if (entity is EntityShape)
            {
               bombs_count += Define.IsBombShape ((entity as EntityShape).GetAiType ()) ? 1 : 0;
            }
         }
         
         shapes_count *= 1.1; // safety factor
         shapes_count += 4; // border
         
         if (bombs_count > 0)
            shapes_count += Define.MaxCoexistParticles;
         
         mPhysicsShapesPotentialMaxCount = shapes_count;
         
         mPhysicsShapesPopulationDensityLevel = bombs_count > 0 && mPhysicsShapesPotentialMaxCount <= 2048 ? 8 : 4;
      }
      
      public function GetPhysicsShapesPotentialMaxCount ():uint
      {
         return mPhysicsShapesPotentialMaxCount;
      }
      
      public function GetPhysicsShapesPopulationDensityLevel ():uint
      {
         return mPhysicsShapesPopulationDensityLevel;
      }
      
      public function SetDefaultGravityAccelerationMagnitude (magnitude:Number):void
      {
         mDefaultGravityAccelerationMagnitude = magnitude;
      }
      
      public function GetDefaultGravityAccelerationMagnitude ():Number
      {
         return mDefaultGravityAccelerationMagnitude;
      }
      
      public function SetDefaultGravityAccelerationAngle (angle:Number):void
      {
         mDefaultGravityAccelerationAngle = angle;
      }
      
      public function GetDefaultGravityAccelerationAngle ():Number
      {
         return mDefaultGravityAccelerationAngle;
      }
      
      public function SetInfiniteSceneSize (infinite:Boolean):void
      {
         mInfiniteWorldSize = infinite;
      }
      
      public function IsInfiniteSceneSize ():Boolean
      {
         return mInfiniteWorldSize;
      }
      
      public function SetCiRulesEnabled (enabled:Boolean):void
      {
         mCiRulesEnabled = enabled;
      }
      
      public function IsCiRulesEnabled ():Boolean
      {
         return mCiRulesEnabled;
      }
      
//=================================================================================
//   clone
//=================================================================================
      
      override public function CloneSelectedEntities (offsetX:Number, offsetY:Number, cloningInfo:Array = null):void
      {
         var selectedEntities:Array = GetSelectedEntities ();
         var cloningInfoArray:Array = new Array ();
         
         super.CloneSelectedEntities (offsetX, offsetY, cloningInfoArray);
         
      // keep glued relation, shape index
         
         if (selectedEntities.length != cloningInfoArray.length)
            return;
         
         var i:int;
         var j:int;
         var index:int;
         var info:Object;
         var selectedEntity:Entity;
         var mainEntity:Entity;
         var clonedMainEntity:Entity;
         var subEntities:Array;
         var clonedSubEntities:Array;
         
         var jointEntity:EntityJoint;
         var shapeIndex1:int;
         var shapeIndex2:int;
         var newJointEntity:EntityJoint;
         var shapeEntity:EntityShape;
         var newShapeEntity:EntityShape;
         
         var count:int = selectedEntities.length;
         var clonedEntities:Array = new Array (count);
         
         for (i = 0; i < count; ++ i)
         {
            info = cloningInfoArray [i];
            
            mainEntity = info.mMainEntity;
            clonedMainEntity = info.mClonedMainEntity;
            
            if (clonedMainEntity == null)
               continue;
            
            if (mainEntity is EntityJoint)
            {
               if (info.mChecked != null && info.mChecked)
                  continue;
               
            ////////////////////////////////////////////////////////
            // auto set shape indexes for joints
            ///////////////////////////////////////////////////////
               
               jointEntity = mainEntity as EntityJoint;
               newJointEntity = clonedMainEntity as EntityJoint;
               
               shapeIndex1 = jointEntity.GetConnectedShape1Index ();
               shapeIndex2 = jointEntity.GetConnectedShape2Index ();
               
               if (shapeIndex1 >= 0)
               {
                  shapeEntity = GetEntityByCreationId (shapeIndex1) as EntityShape;
                  index = selectedEntities.indexOf (shapeEntity);
                  if (index >= 0)
                  {
                     newShapeEntity = cloningInfoArray [index].mClonedMainEntity;
                     newJointEntity.SetConnectedShape1Index (GetEntityCreationId (newShapeEntity));
                  }
               }
               
               if (shapeIndex2 >= 0)
               {
                  shapeEntity = GetEntityByCreationId (shapeIndex2) as EntityShape;
                  index = selectedEntities.indexOf (shapeEntity);
                  if (index >= 0)
                  {
                     newShapeEntity = cloningInfoArray [index].mClonedMainEntity;
                     newJointEntity.SetConnectedShape2Index (GetEntityCreationId (newShapeEntity));
                  }
               }
           //<<
           ///////////////////////////////////////////////////////
               
               subEntities = mainEntity.GetSubEntities ();
               clonedSubEntities = clonedMainEntity.GetSubEntities ();
               
               for (j = 0; j < subEntities.length; ++ j)
               {
                  index = selectedEntities.indexOf (subEntities [j]);
                  if (index < 0)
                  {
                     index = selectedEntities.length;
                     selectedEntities.push (subEntities [j]);
                     cloningInfoArray.push (info);
                  }
                  
                  clonedEntities [index] = clonedSubEntities [j];
                  
                  cloningInfoArray [index].mChecked = true;
               }
            } // if (mainEntity is EntityJoint)
            else
            {
               clonedEntities [i] = clonedMainEntity;
            }
         }
         
         var botherGroupDict:Dictionary = new Dictionary ();
         var newBotherGroupArray:Array = new Array ();
         var oldBrotherGroup:Array;
         var newBrotherGroup:Array;
         
         for (i = 0; i < selectedEntities.length; ++ i)
         {
            selectedEntity = selectedEntities [i];
            
            oldBrotherGroup = selectedEntity.GetBrothers ();
            
            if (oldBrotherGroup == null)
               continue;
            
            newBrotherGroup = botherGroupDict [oldBrotherGroup];
            if (newBrotherGroup == null)
            {
               newBrotherGroup = new Array ();
               botherGroupDict [oldBrotherGroup] = newBrotherGroup;
               
               newBotherGroupArray.push (newBrotherGroup);
            }
            
            if (clonedEntities [i] != null)
               newBrotherGroup.push (clonedEntities [i]);
         }
         
         for (i = 0; i < newBotherGroupArray.length; ++ i)
         {
            newBrotherGroup = newBotherGroupArray [i];
            
            if (newBrotherGroup.length <= 1)
               return;
            
            GlueEntities (newBrotherGroup);
         }
      }
      
//=================================================================================
//   create and destroy entities
//=================================================================================
      
      public function CreateEntityShapeCircle ():EntityShapeCircle
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
            
         var circle:EntityShapeCircle = new EntityShapeCircle (this);
         addChild (circle);
         
         circle.SetCollisionCategoryIndex (GetCollisionCategoryIndex (GetDefaultCollisionCategory ()));
         
         return circle;
      }
      
      public function CreateEntityShapeRectangle ():EntityShapeRectangle
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
            
         var rect:EntityShapeRectangle = new EntityShapeRectangle (this);
         addChild (rect);
         
         rect.SetCollisionCategoryIndex (GetCollisionCategoryIndex (GetDefaultCollisionCategory ()));
         
         return rect;
      }
      
      public function CreateEntityShapePolygon ():EntityShapePolygon
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
            
         var polygon:EntityShapePolygon = new EntityShapePolygon (this);
         addChild (polygon);
         
         polygon.SetCollisionCategoryIndex (GetCollisionCategoryIndex (GetDefaultCollisionCategory ()));
         
         return polygon;
      }
      
      public function CreateEntityShapePolyline ():EntityShapePolyline
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
            
         var polyline:EntityShapePolyline = new EntityShapePolyline (this);
         addChild (polyline);
         
         polyline.SetCollisionCategoryIndex (GetCollisionCategoryIndex (GetDefaultCollisionCategory ()));
         
         return polyline;
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
      
      public function CreateEntityShapeText ():EntityShapeText
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
            
         var text:EntityShapeText = new EntityShapeText(this);
         addChild (text);
         
         return text;
      }
      
      public function CreateEntityShapeTextButton ():EntityShapeTextButton
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
            
         var button:EntityShapeTextButton = new EntityShapeTextButton (this);
         addChild (button);
         
         return button;
      }
      
      public function CreateEntityShapeGravityController ():EntityShapeGravityController
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
         
         var gController:EntityShapeGravityController = new EntityShapeGravityController(this);
         addChild (gController);
         
         return gController;
      }
      
      public function CreateEntityUtilityCamera ():EntityUtilityCamera
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
         
         var camera:EntityUtilityCamera = new EntityUtilityCamera(this);
         addChild (camera);
         
         return camera;
      }
      
      public function CreateEntityCondition ():EntityBasicCondition
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
         
         var condition:EntityBasicCondition = new EntityBasicCondition(this);
         addChild (condition);
         
         return condition;
      }
      
      public function CreateEntityConditionDoor ():EntityConditionDoor
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
         
         var condition_door:EntityConditionDoor = new EntityConditionDoor(this);
         addChild (condition_door);
         
         return condition_door;
      }
      
      public function CreateEntityTask ():EntityTask
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
         
         var task:EntityTask = new EntityTask(this);
         addChild (task);
         
         return task;
      }
      
      public function CreateEntityInputEntityAssigner ():EntityInputEntityAssigner
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
         
         var entity_assigner:EntityInputEntityAssigner = new EntityInputEntityAssigner(this);
         addChild (entity_assigner);
         
         return entity_assigner;
      }
      
      public function CreateEntityInputEntityPairAssigner ():EntityInputEntityPairAssigner
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
         
         var entity_pair_assigner:EntityInputEntityPairAssigner = new EntityInputEntityPairAssigner(this);
         addChild (entity_pair_assigner);
         
         return entity_pair_assigner;
      }
      
      public function CreateEntityEventHandler (defaultEventId:int, potientialEventIds:Array = null):EntityEventHandler
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
         
         var handler:EntityEventHandler = new EntityEventHandler (this, defaultEventId, potientialEventIds);
         addChild (handler);
         
         return handler;
      }
      
      public function CreateEntityEventHandler_Timer (defaultEventId:int, potientialEventIds:Array = null):EntityEventHandler_Timer
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
         
         var handler:EntityEventHandler_Timer = new EntityEventHandler_Timer (this, defaultEventId, potientialEventIds);
         addChild (handler);
         
         return handler;
      }
      
      public function CreateEntityEventHandler_Keyboard (defaultEventId:int, potientialEventIds:Array = null):EntityEventHandler_Keyboard
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
         
         var handler:EntityEventHandler_Keyboard = new EntityEventHandler_Keyboard (this, defaultEventId, potientialEventIds);
         addChild (handler);
         
         return handler;
      }
      
      public function CreateEntityEventHandler_Mouse (defaultEventId:int, potientialEventIds:Array = null):EntityEventHandler_Mouse
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
         
         var handler:EntityEventHandler_Mouse = new EntityEventHandler_Mouse (this, defaultEventId, potientialEventIds);
         addChild (handler);
         
         return handler;
      }
      
      public function CreateEntityAction ():EntityAction
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
         
         var action:EntityAction = new EntityAction (this);
         addChild (action);
         
         return action;
      }
      
//=================================================================================
//   queries
//=================================================================================
      
      public function GetEntitySelectListDataProviderByFilter (filterFunc:Function = null, nullEntityLable:String = "(null)", includeGround:Boolean = false):Array
      {
         var list:Array = new Array ();
         
         if (includeGround)
            list.push({label:Define.EntityId_Ground + ":{Ground}", mEntityIndex:Define.EntityId_Ground});
         
         list.push({label:Define.EntityId_None + ":" + nullEntityLable, mEntityIndex:Define.EntityId_None});
         
         var entity:Entity;
         
         var numEntities:int = mEntitiesSortedByCreationId.length;
         if (numEntities != numChildren)
            trace ("!!! numEntities != numChildren");
         
         for (var i:int = 0; i < numEntities; ++ i)
         {
            entity = mEntitiesSortedByCreationId [i] as Entity;
            
            if ( filterFunc == null || filterFunc (entity) )
            {
               var item:Object = new Object ();
               item.label = i + ": " + entity.GetTypeName ();
               item.mEntityIndex = entity.GetCreationOrderId ();
               list.push (item);
            }
         }
         
         return list;
      }
      
      public static function EntityIndex2SelectListSelectedIndex (entityIndex:int, dataProvider:Array):int
      {
         for (var i:int = 0; i < dataProvider.length; ++ i)
         {
            if (dataProvider[i].mEntityIndex == entityIndex)
               return i;
         }
         
         return EntityIndex2SelectListSelectedIndex (Define.EntityId_None, dataProvider);
      }
      
      public function GetCollisionCategoryListDataProvider ():Array
      {
         var list:Array = new Array ();
         
         list.push ({label:"-1:{Hidden Category}", mCategoryIndex:Define.CollisionCategoryId_HiddenCategory});
         
         var child:Object;
         var category:EntityCollisionCategory;
         var numCats:int = mCollisionManager.GetNumCollisionCategories ();
         
         for (var i:int = 0; i < numCats; ++ i)
         {
            category = mCollisionManager.GetCollisionCategoryByIndex (i);
            
            var item:Object = new Object ();
            item.label = i + ": " + category.GetCategoryName ();
            item.mCategoryIndex = category.GetAppearanceLayerId ();
            list.push (item);
         }
         
         return list;
      }
      
      public static function CollisionCategoryIndex2SelectListSelectedIndex (categoryIndex:int, dataProvider:Array):int
      {
         for (var i:int = 0; i < dataProvider.length; ++ i)
         {
            if (dataProvider[i].mCategoryIndex == categoryIndex)
               return i;
         }
         
         return CollisionCategoryIndex2SelectListSelectedIndex (Define.CollisionCategoryId_HiddenCategory, dataProvider);
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
      
      public function GlueEntitiesByCreationIds (entityIndices:Array):void
      {
         var entities:Array = new Array (entityIndices.length);
         
         for (var i:int = 0; i < entityIndices.length; ++ i)
         {
            entities [i] = GetEntityByCreationId (entityIndices [i]);
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
//   collision categories
//=================================================================================
      
      public function GetNumCollisionCategories ():int
      {
         return mCollisionManager.GetNumCollisionCategories ();
      }
      
      public function GetCollisionManager ():CollisionManager
      {
         return mCollisionManager;
      }
      
      public function SetCollisionManager (cm:CollisionManager):void
      {
         mCollisionManager = cm;
      }
      
      public function GetCollisionCategoryIndex (category:EntityCollisionCategory):int
      {
         return mCollisionManager.GetCollisionCategoryIndex (category);
      }
      
      public function GetCollisionCategoryByIndex (index:int):EntityCollisionCategory
      {
         return mCollisionManager.GetCollisionCategoryByIndex (index);
      }
      
      public function GetCollisionCategoryFriendPairs ():Array
      {
         return mCollisionManager.GetCollisionCategoryFriendPairs ();
      }
      
      public function GetDefaultCollisionCategory ():EntityCollisionCategory
      {
         return mCollisionManager.GetDefaultCollisionCategory ();
      }
      
      public function CreateEntityCollisionCategoryFriendLink (categoryIndex1:int, categoryIndex2:int):void
      {
         var category1:EntityCollisionCategory = mCollisionManager.GetCollisionCategoryByIndex (categoryIndex1);
         var category2:EntityCollisionCategory = mCollisionManager.GetCollisionCategoryByIndex (categoryIndex2);
         
         if (category1 != null && category2 != null)
            mCollisionManager.CreateEntityCollisionCategoryFriendLink (category1, category2);
      }
      
      public function CreateEntityCollisionCategory (ccName:String):EntityCollisionCategory
      {
         return mCollisionManager.CreateEntityCollisionCategory (ccName);
      }
      
//=================================================================================
//   debug info
//=================================================================================
      
      public function RepaintContactsInLastRegionSelecting (container:Sprite):void
      {
         mSelectionEngine.RepaintContactsInLastRegionSelecting (container);
      }
   }
}

