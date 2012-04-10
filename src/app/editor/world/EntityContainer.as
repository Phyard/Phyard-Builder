
package editor.world {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   
   import com.tapirgames.util.Logger;

   import editor.entity.Entity;

   import editor.entity.EntityVectorShape;
   import editor.entity.EntityVectorShapeCircle;
   import editor.entity.EntityVectorShapeRectangle;
   import editor.entity.EntityVectorShapePolygon;
   import editor.entity.EntityVectorShapePolyline;
   import editor.entity.EntityVectorShapeText;
   import editor.entity.EntityVectorShapeTextButton;
   import editor.entity.EntityVectorShapeGravityController;
   
   import editor.entity.EntityShapeImageModule;
   import editor.entity.EntityShapeImageModuleButton;

   import editor.entity.EntityUtility;
   import editor.entity.EntityUtilityCamera;
   import editor.entity.EntityUtilityPowerSource;

   import editor.entity.EntityJoint;
   import editor.entity.EntityJointDistance;
   import editor.entity.EntityJointHinge;
   import editor.entity.EntityJointSlider;
   import editor.entity.EntityJointSpring;
   import editor.entity.EntityJointWeld;
   import editor.entity.EntityJointDummy;

   import editor.entity.SubEntityJointAnchor;

   import editor.trigger.entity.EntityLogic;
   import editor.trigger.entity.EntityBasicCondition;
   import editor.trigger.entity.EntityConditionDoor;
   import editor.trigger.entity.EntityTask;
   import editor.trigger.entity.EntityInputEntityAssigner;
   import editor.trigger.entity.EntityInputEntityPairAssigner;
   import editor.trigger.entity.EntityInputEntityScriptFilter;
   import editor.trigger.entity.EntityInputEntityPairScriptFilter;
   import editor.trigger.entity.EntityInputEntityRegionSelector;
   import editor.trigger.entity.EntityEventHandler;
   import editor.trigger.entity.EntityEventHandler_Timer;
   import editor.trigger.entity.EntityEventHandler_TimerWithPrePostHandling;
   import editor.trigger.entity.EntityEventHandler_Keyboard;
   import editor.trigger.entity.EntityEventHandler_Mouse;
   import editor.trigger.entity.EntityEventHandler_Contact;
   import editor.trigger.entity.EntityEventHandler_JointReachLimit;
   import editor.trigger.entity.EntityEventHandler_ModuleLoopToEnd;
   import editor.trigger.entity.EntityEventHandler_GameLostOrGotFocus;
   import editor.trigger.entity.EntityAction;

   //import editor.trigger.entity.EntityFunctionPackage;
   //import editor.trigger.entity.EntityFunction;

   import editor.entity.VertexController;
   
   import editor.selection.SelectionEngine;
   
   import editor.trigger.entity.Linkable;
   
   import editor.EditorContext;
   
   import editor.asset.Asset;
   import editor.asset.AssetManager;
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class EntityContainer extends Sprite // AssetManager; //Sprite 
   {
      public var mCoordinateSystem:CoordinateSystem;
      
      public var mSelectionEngine:SelectionEngine; // used within package
      
      public var mSelectionListManager:SelectionListManager;

      public var mBrothersManager:BrothersManager;
      
      protected var mEntitiesSortedByCreationId:Array = new Array ();
      
      public function EntityContainer ()
      {
         SetPhysicsSimulationIterations (Define.WorldStepVelocityIterations_Medium, Define.WorldStepPositionIterations_Medium)
         
         mCoordinateSystem = Define.kDefaultCoordinateSystem;
         
         mSelectionEngine = new SelectionEngine ();
         
         mSelectionListManager = new SelectionListManager ();

         mBrothersManager = new BrothersManager ();
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
      // friends



      // brothers

         mBrothersManager.OnDestroyEntity (entity);
      
      // selected
      
         mSelectionListManager.RemoveSelectedEntity (entity);
         
      // 
         
         entity.Destroy ();
         
         if ( contains (entity) )
            removeChild (entity);
      }
      
//================================================================================
// settings 
//================================================================================

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

      //>>v1.08
      private var mCiRulesEnabled:Boolean = true;
      //<<

      private var mZoomScale:Number = 1.0;

      private var mPhysicsShapesPotentialMaxCount:int = 1024;
      private var mPhysicsShapesPopulationDensityLevel:int = 8;

      //>>v1.08
      // the 2 are both display values
      private var mDefaultGravityAccelerationMagnitude:Number = 196; // pixels
      private var mDefaultGravityAccelerationAngle:Number = 90; // degrees in left hand coordinates
      //<<

      //>>v1.55
      private var mAutoSleepingEnabled:Boolean = true;
      private var mCameraRotatingEnabled:Boolean = false;
      //<<
      
      //>>v1.60
      private var mPhysicsSimulationEnabled:Boolean = true;
      private var mPhysicsSimulationStepTimeLength:Number = 0.04; // 25 fps
      private var mPhysicsSimulationQuality:int = 0x00000803; // constructor will call SetPhysicsSimulationIterations to override this
                        // low 8 bits for positionIterations
                        // next 8 bits for velocityIterations
                        // hight 16 bits are reserved.
      private var mCheckTimeOfImpact:Boolean = true;
      private var mInitialSpeedX:int = 1; // [0, 4]
      
      private var mPreferredFPS:Number = 25;
      //<<

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

            if (entity is EntityVectorShape)
            {
               bombs_count += Define.IsBombShape ((entity as EntityVectorShape).GetAiType ()) ? 1 : 0;
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

      public function IsAutoSleepingEnabled ():Boolean
      {
         return mAutoSleepingEnabled;
      }

      public function SetAutoSleepingEnabled (enabled:Boolean):void
      {
         mAutoSleepingEnabled = enabled;
      }
      
      public function IsPhysicsSimulationEnabled ():Boolean
      {
         return mPhysicsSimulationEnabled;
      }
      
      public function SetPhysicsSimulationEnabled (enabled:Boolean):void
      {
         mPhysicsSimulationEnabled = enabled;
      }
      
      public function GetPhysicsSimulationStepTimeLength ():Number
      {
         return mPhysicsSimulationStepTimeLength;
      }
      
      public function SetPhysicsSimulationStepTimeLength (dt:Number):void
      {
         if (dt < 0)
            dt = -dt;
         
         mPhysicsSimulationStepTimeLength = dt;
      }
      
      public function GetPhysicsSimulationQuality ():int
      {
         return mPhysicsSimulationQuality;
      }
      
      public function SetPhysicsSimulationQuality (quality:int):void
      {
         mPhysicsSimulationQuality = quality;
      }
      
            public function GetPhysicsSimulationVelocityIterations ():int
            {
               return (mPhysicsSimulationQuality >> 8) & 0xFF;
            }
      
            public function GetPhysicsSimulationPositionIterations ():int
            {
               return (mPhysicsSimulationQuality >> 0) & 0xFF;
            }
            
            public function SetPhysicsSimulationIterations (velocityIterations:int, positionIterations:int):void
            {
               if (velocityIterations < Define.WorldStepVelocityIterations_Low)
                  velocityIterations = Define.WorldStepVelocityIterations_Low;
               else if (velocityIterations > 100) //Define.WorldStepVelocityIterations_High)
                  velocityIterations = 100; //Define.WorldStepVelocityIterations_High;
              
               if (positionIterations < Define.WorldStepPositionIterations_Low)
                  positionIterations = Define.WorldStepPositionIterations_Low;
               else if (positionIterations > 100) //Define.WorldStepPositionIterations_High)
                  positionIterations = 100; //Define.WorldStepPositionIterations_High;
              
               // if this changed, DateFormat2.FillMissedFieldsInWorldDefine needs to be changed also.
               mPhysicsSimulationQuality = ((velocityIterations & 0xFF) << 8) | ((positionIterations & 0xFF) << 0);
            }
      
      public function IsCheckTimeOfImpact ():Boolean
      {
         return mCheckTimeOfImpact;
      }
      
      public function SetCheckTimeOfImpact (checkTOI:Boolean):void
      {
         mCheckTimeOfImpact = checkTOI;
      }
      
      public function GetInitialSpeedX ():int
      {
         return mInitialSpeedX;
      }
      
      public function SetInitialSpeedX (speedX:int):void
      {
         mInitialSpeedX = speedX;
      }
      
      public function GetPreferredFPS ():Number
      {
         return mPreferredFPS;
      }
      
      public function SetPreferredFPS (fps:Number):void
      {
         if (fps < Define.MinAppFPS)
            fps = Define.MinAppFPS;
         else if (fps > Define.MaxAppFPS)
            fps = Define.MaxAppFPS;
         
         mPreferredFPS = fps;
      }
      
      public function IsCameraRotatingEnabled ():Boolean
      {
         return mCameraRotatingEnabled;
      }

      public function SetCameraRotatingEnabled (enabled:Boolean):void
      {
         mCameraRotatingEnabled = enabled;
      }
      
//=================================================================================
//   create and destroy entities
//=================================================================================

      public function CreateEntityVectorShapeCircle ():EntityVectorShapeCircle
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var circle:EntityVectorShapeCircle = new EntityVectorShapeCircle (this);
         addChild (circle);

         circle.SetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetDefaultCollisionCategory ()));

         return circle;
      }

      public function CreateEntityVectorShapeRectangle ():EntityVectorShapeRectangle
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var rect:EntityVectorShapeRectangle = new EntityVectorShapeRectangle (this);
         addChild (rect);

         rect.SetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetDefaultCollisionCategory ()));

         return rect;
      }

      public function CreateEntityVectorShapePolygon ():EntityVectorShapePolygon
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var polygon:EntityVectorShapePolygon = new EntityVectorShapePolygon (this);
         addChild (polygon);

         polygon.SetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetDefaultCollisionCategory ()));

         return polygon;
      }

      public function CreateEntityVectorShapePolyline ():EntityVectorShapePolyline
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var polyline:EntityVectorShapePolyline = new EntityVectorShapePolyline (this);
         addChild (polyline);

         polyline.SetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetDefaultCollisionCategory ()));

         return polyline;
      }
      
      public function CreateEntityShapeImageModule ():EntityShapeImageModule
      {  
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var imageModule:EntityShapeImageModule = new EntityShapeImageModule (this);
         addChild (imageModule);

         imageModule.SetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetDefaultCollisionCategory ()));

         return imageModule;
      }
      
      public function CreateEntityShapeImageModuleButton ():EntityShapeImageModuleButton
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var imageModuleButton:EntityShapeImageModuleButton = new EntityShapeImageModuleButton (this);
         addChild (imageModuleButton);

         imageModuleButton.SetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetDefaultCollisionCategory ()));

         return imageModuleButton;
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

      public function CreateEntityJointWeld():EntityJointWeld
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var weld:EntityJointWeld = new EntityJointWeld (this);
         addChild (weld);

         return weld;
      }

      public function CreateEntityJointDummy():EntityJointDummy
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var dummy:EntityJointDummy = new EntityJointDummy (this);
         addChild (dummy);

         return dummy;
      }

      public function CreateEntityVectorShapeText ():EntityVectorShapeText
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var text:EntityVectorShapeText = new EntityVectorShapeText(this);
         addChild (text);

         return text;
      }

      public function CreateEntityVectorShapeTextButton ():EntityVectorShapeTextButton
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var button:EntityVectorShapeTextButton = new EntityVectorShapeTextButton (this);
         addChild (button);

         return button;
      }

      public function CreateEntityVectorShapeGravityController ():EntityVectorShapeGravityController
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var gController:EntityVectorShapeGravityController = new EntityVectorShapeGravityController(this);
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

      public function CreateEntityUtilityPowerSource ():EntityUtilityPowerSource
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var power_source:EntityUtilityPowerSource = new EntityUtilityPowerSource (this);
         addChild (power_source);

         return power_source;
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

      public function CreateEntityInputEntityScriptFilter ():EntityInputEntityScriptFilter
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var entity_filter:EntityInputEntityScriptFilter = new EntityInputEntityScriptFilter(this);
         addChild (entity_filter);

         return entity_filter;
      }

      public function CreateEntityInputEntityPairScriptFilter ():EntityInputEntityPairScriptFilter
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var entity_pair_filter:EntityInputEntityPairScriptFilter = new EntityInputEntityPairScriptFilter(this);
         addChild (entity_pair_filter);

         return entity_pair_filter;
      }

      public function CreateEntityInputEntityRegionSelector ():EntityInputEntityRegionSelector
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var entity_region_selector:EntityInputEntityRegionSelector = new EntityInputEntityRegionSelector(this);
         addChild (entity_region_selector);

         return entity_region_selector;
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

      public function CreateEntityEventHandler_TimerWithPrePostHandling (defaultEventId:int, potientialEventIds:Array = null):EntityEventHandler_Timer
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var handler:EntityEventHandler_Timer = new EntityEventHandler_TimerWithPrePostHandling (this, defaultEventId, potientialEventIds);
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

      public function CreateEntityEventHandler_Contact (defaultEventId:int, potientialEventIds:Array = null):EntityEventHandler_Contact
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var handler:EntityEventHandler_Contact = new EntityEventHandler_Contact (this, defaultEventId, potientialEventIds);
         addChild (handler);

         return handler;
      }

      public function CreateEntityEventHandler_JointReachLimit (defaultEventId:int, potientialEventIds:Array = null):EntityEventHandler_JointReachLimit
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var handler:EntityEventHandler_JointReachLimit = new EntityEventHandler_JointReachLimit (this, defaultEventId, potientialEventIds);
         addChild (handler);

         return handler;
      }
      
      public function CreateEntityEventHandler_ModuleLoopToEnd (defaultEventId:int, potientialEventIds:Array = null):EntityEventHandler_ModuleLoopToEnd
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var handler:EntityEventHandler_ModuleLoopToEnd = new EntityEventHandler_ModuleLoopToEnd (this, defaultEventId, potientialEventIds);
         addChild (handler);

         return handler;
      }
      
      public function CreateEntityEventHandler_GameLostOrGotFocus (defaultEventId:int, potientialEventIds:Array = null):EntityEventHandler_GameLostOrGotFocus
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var handler:EntityEventHandler_GameLostOrGotFocus = new EntityEventHandler_GameLostOrGotFocus (this, defaultEventId, potientialEventIds);
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
//   selection list
//=================================================================================
      
      public function GetNumSelectedEntities ():int
      {
         return mSelectionListManager.GetNumSelectedEntities ();
      }
      
      public function GetSelectedEntities ():Array
      {
         return mSelectionListManager.GetSelectedEntities ();
      }
      
      public function GetMainSelectedEntity ():Entity
      {
         var entityArray:Array = GetSelectedEntities ();
         
         var entity:Entity = null;
         var firstEntity:Entity = null;
         for (var i:uint = 0; i < entityArray.length; ++ i)
         {
            entity = entityArray[i] as Entity;
            if (entity != null)
            {
               if (entity.AreInternalComponentsVisible ())
                  return entity;
               
               if (firstEntity == null)
               {
                  firstEntity = entity;
               }
            }
         }
         
         return firstEntity;
      }
      
      public function ClearSelectedEntities ():void
      {
         mSelectionListManager.ClearSelectedEntities ();
      }
      
      public function SelectEntities (entityArray:Array):void
      {
         /*
         if (entityArray == null)
            return;
         
         for (var i:uint = 0; i < entityArray.length; ++ i)
         {
            if (entityArray[i] != null && entityArray[i] is Entity)
            {
               mSelectionListManager.AddSelectedEntity (entityArray[i]);
            }
         }
         */
         
         SetSelectedEntities (entityArray, false);
      }
      
      public function SelectEntity (entity:Entity):void
      {
         if (entity != null)
         {
            mSelectionListManager.AddSelectedEntity (entity);
         }
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
      
      public function SetSelectedEntities (entityArray:Array, clearOldSelections:Boolean = true):Boolean
      {
         return mSelectionListManager.SelectEntities (entityArray, clearOldSelections);
      }
      
      public function SelectEntitiesByToggleTwoEntityArrays (oldSelections:Array, newSelections:Array):Boolean
      {
         if (oldSelections == null && newSelections == null)
         {
            if (mSelectionListManager.GetNumSelectedEntities () > 0)
            {
               mSelectionListManager.ClearSelectedEntities ();
               
               return true;
            }
            
            return false;
         }
         
         if (oldSelections == null)
         {
            return SetSelectedEntities (newSelections);
         }
         
         if (newSelections == null)
         {
            return SetSelectedEntities (oldSelections);
         }
         
         var entitiesToSelect:Array = new Array ();
         
         var entity:Entity;
         var actionId1:int;
         var actionId2:int;

         actionId1 = Entity.GetNextActionId ();
         for each (entity in newSelections)
         {
            entity.SetCurrentActionId (actionId1);
         }
         
         actionId2 = Entity.GetNextActionId ();
         for each (entity in oldSelections)
         {
            if (entity.GetCurrentActionId () < actionId1)
               entitiesToSelect.push (entity);
            
            entity.SetCurrentActionId (actionId2);
         }
         
         for each (entity in newSelections)
         {
            if (entity.GetCurrentActionId () < actionId2)
               entitiesToSelect.push (entity);
         }
         
         return SetSelectedEntities (entitiesToSelect);
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
      
      public function AreSelectedEntitiesContainingPoint (pointX:Number, pointY:Number):Boolean
      {
         return mSelectionListManager.AreSelectedEntitiesContainingPoint (pointX, pointY);
      }
      
      // ...
      
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
      
      public function GetTheOnlySelectedVertexControllers ():VertexController
      {
         if (mTheSelectedVertexController == null)
            return null;
         
         return mTheSelectedVertexController;
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
      
      public function DeleteSelectedEntities ():Boolean
      {
         var entityArray:Array = mSelectionListManager.GetSelectedMainEntities ();
         
         var entity:Entity;
         
         var count:int = 0;
         
         for (var i:int = 0; i < entityArray.length; ++ i)
         {
            entity = entityArray [i] as Entity;
            
            DestroyEntity (entity);
            
            ++ count;
         }
         
         return count > 0;
      }

//=================================================================================
//   clone
//=================================================================================

      public function CloneSelectedEntities (offsetX:Number, offsetY:Number, cloningInfo:Array = null):void
      {
         var selectedEntities:Array = GetSelectedEntities ();
         var cloningInfoArray:Array = new Array ();

         CloneSelectedEntities_OldEntityContianer (offsetX, offsetY, cloningInfoArray);

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

         var jointEntity:EntityJoint;
         var shapeIndex1:int;
         var shapeIndex2:int;
         var newJointEntity:EntityJoint;
         var shapeEntity:EntityVectorShape;
         var newShapeEntity:EntityVectorShape;

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
                  shapeEntity = GetEntityByCreationId (shapeIndex1) as EntityVectorShape;
                  index = selectedEntities.indexOf (shapeEntity);
                  if (index >= 0)
                  {
                     newShapeEntity = cloningInfoArray [index].mClonedMainEntity;
                     newJointEntity.SetConnectedShape1Index (GetEntityCreationId (newShapeEntity));
                  }
               }

               if (shapeIndex2 >= 0)
               {
                  shapeEntity = GetEntityByCreationId (shapeIndex2) as EntityVectorShape;
                  index = selectedEntities.indexOf (shapeEntity);
                  if (index >= 0)
                  {
                     newShapeEntity = cloningInfoArray [index].mClonedMainEntity;
                     newJointEntity.SetConnectedShape2Index (GetEntityCreationId (newShapeEntity));
                  }
               }
           //<<
           ///////////////////////////////////////////////////////

               var selectableEntities:Array = mainEntity.GetSelectableEntities ();
               var clonedSelectableEntities:Array = clonedMainEntity.GetSelectableEntities ();

               for (j = 0; j < selectableEntities.length; ++ j)
               {
                  index = selectedEntities.indexOf (selectableEntities [j]);
                  if (index < 0)
                  {
                     index = selectedEntities.length;
                     selectedEntities.push (selectableEntities [j]);
                     cloningInfoArray.push (info);
                  }

                  clonedEntities [index] = clonedSelectableEntities [j];

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
      
      private function CloneSelectedEntities_OldEntityContianer (offsetX:Number, offsetY:Number, cloningInfo:Array = null):void
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
               SelectEntities (newEntity.GetSelectableEntities ());
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

         CorrectLayerIdsForJoints ();
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

         CorrectLayerIdsForJoints ();
      }

      // make sure the joint is befind of its anchors in aapearance list
      // so that there are some conviences in playing initization.
      public function CorrectLayerIdsForJoints ():void
      {
         var numEntities:int = mEntitiesSortedByCreationId.length;

         for (var i:int = 0; i < numEntities; ++ i)
         {
            var entity:Entity = mEntitiesSortedByCreationId [i] as Entity;

            if (entity is EntityJoint)
            {
               var maxIndex:int = -1;

               var joint:Object = entity as Object;

               if (joint.hasOwnProperty ("GetAnchor"))
               {
                  var anchor:SubEntityJointAnchor = joint.GetAnchor () as SubEntityJointAnchor;
                  if (anchor != null)
                  {
                     var index:int = getChildIndex (anchor);
                     if (index > maxIndex)
                        maxIndex = index;
                  }
               }
               else
               {
                  if (joint.hasOwnProperty ("GetAnchor1"))
                  {
                     var anchor1:SubEntityJointAnchor = joint.GetAnchor1 () as SubEntityJointAnchor;
                     if (anchor1 != null)
                     {
                        var index1:int = getChildIndex (anchor1);
                        if (index1 > maxIndex)
                           maxIndex = index1;
                     }
                  }

                  if (joint.hasOwnProperty ("GetAnchor2"))
                  {
                     var anchor2:SubEntityJointAnchor = joint.GetAnchor2 () as SubEntityJointAnchor;
                     if (anchor2 != null)
                     {
                        var index2:int = getChildIndex (anchor2);
                        if (index2 > maxIndex)
                           maxIndex = index2;
                     }
                  }
               }

               var oldIndex:int = getChildIndex (entity);
               if (maxIndex > oldIndex)
               {
                  removeChild (entity);
                  addChildAt (entity, maxIndex);
               }
            }
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
      
      final public function OnEntityDestroyed (entity:Entity):void
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
      
      public function EntityArray2EntityCreationIdArray (entities:Array):Array
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

//=================================================================================
//   visibility in editing, not playing
//=================================================================================

      private var mVisiblesVisible:Boolean = true;
      private var mInvisiblesVisible:Boolean = true;
      private var mShapesVisible:Boolean = true;
      private var mJointsVisible:Boolean = true;
      private var mTriggersVisible:Boolean = true;
      private var mLinksVisible:Boolean = true;

      public function SetVisiblesVisible (visible:Boolean):void
      {
         mVisiblesVisible = visible;

         UpdateEntityVisibility ();
      }

      public function SetInvisiblesVisible (visible:Boolean):void
      {
         mInvisiblesVisible = visible;

         UpdateEntityVisibility ();
      }

      public function SetShapesVisible (visible:Boolean):void
      {
         mShapesVisible = visible;

         UpdateEntityVisibility ();
      }

      public function SetJointsVisible (visible:Boolean):void
      {
         mJointsVisible = visible;

         UpdateEntityVisibility ();
      }

      public function SetTriggersVisible (visible:Boolean):void
      {
         mTriggersVisible = visible;

         UpdateEntityVisibility ();
      }

      private function UpdateEntityVisibility ():void
      {
         var entity:Entity;

         var numEntities:int = mEntitiesSortedByCreationId.length;
         if (numEntities != numChildren)
            trace ("!!! numEntities != numChildren");

         var ildVisible:Boolean;

         for (var i:int = 0; i < numEntities; ++ i)
         {
            entity = mEntitiesSortedByCreationId [i] as Entity;
            if (entity == null)
               continue; // should not

            if (entity.IsVisible ())
            {
               entity.SetVisibleInEditor (mVisiblesVisible);
            }
            else
            {
               entity.SetVisibleInEditor (mInvisiblesVisible);
            }

            if (entity.IsVisibleInEditor ())
            {
               if (entity is EntityVectorShape || entity is EntityUtility)
               {
                  entity.SetVisibleInEditor (mShapesVisible);
               }
               else if (entity is EntityJoint || entity is SubEntityJointAnchor)
               {
                  entity.SetVisibleInEditor (mJointsVisible);
               }
               else if (entity is EntityLogic)
               {
                  entity.SetVisibleInEditor (mTriggersVisible);
               }
            }

            if ((! entity.IsVisibleInEditor ()) && entity.IsSelected ())
            {
               mSelectionListManager.RemoveSelectedEntity (entity);
            }
         }
      }
      
//=================================================================================
//   queries
//=================================================================================

      public function GetEntitySelectListDataProviderByFilter (filterFunc:Function = null, includeGround:Boolean = false, nullEntityLable:String = null, isForPureCustomFunction:Boolean = false):Array
      {
         var list:Array = new Array ();

         if (includeGround)
            list.push({label:Define.EntityId_Ground + ":{Ground}", mEntityIndex:Define.EntityId_Ground});

         if (nullEntityLable == null)
            nullEntityLable = "(null)";

         list.push({label:Define.EntityId_None + ":" + nullEntityLable, mEntityIndex:Define.EntityId_None});

         if (! isForPureCustomFunction)
         {
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
      
      public function GetAllGluedEntities (entities:Array):Array
      {
         var allGluedEntities:Array = new Array ();
         
         var entity:Entity;
         var brothers:Array;
         var actionId:int = Entity.GetNextActionId ();
         var brotherGroups:Array = new Array ();
         
         for each (entity in entities)
         {
            if (entity.GetCurrentActionId () < actionId)
            {
               entity.SetCurrentActionId (actionId);
               allGluedEntities.push (entity);
            }
            
            brothers = entity.GetBrothers ();

            if (brothers != null)
            {
               if (brotherGroups.indexOf (brothers) < 0)
                  brotherGroups.push (brothers);
            }
         }
         
         for each (brothers in brotherGroups)
         {
            for each (entity in brothers)
            {
               if (entity.GetCurrentActionId () < actionId)
               {
                  entity.SetCurrentActionId (actionId);
                  allGluedEntities.push (entity);
               }
            }
         }
         
         return allGluedEntities;
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

      // todo
      
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
//   draw links
//=================================================================================

      private static function SortEntitiesByDrawLinksOrder (entity1:Entity, entity2:Entity):int
      {
         var drawLinksOrder1:int = entity1.GetDrawLinksOrder ();
         var drawLinksOrder2:int = entity2.GetDrawLinksOrder ();

         if (drawLinksOrder1 < drawLinksOrder2)
            return -1;
         else if (drawLinksOrder1 > drawLinksOrder2)
            return 1;
         else
            return 0;
      }

      public function DrawEntityLinks (canvasSprite:Sprite, forceDraw:Boolean):void
      {
         var entityArray:Array = mEntitiesSortedByCreationId.concat ();
         entityArray.sort (SortEntitiesByDrawLinksOrder);

         var entity:Entity;
         var i:int;
         var numEntities:int = entityArray.length;
         for (i = 0; i < numEntities; ++ i)
         {
            entity = entityArray [i];
            if (entity != null)
            {
               entity.DrawEntityLinks (canvasSprite, forceDraw);
            }
         }
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

//=================================================================================
//   debug info
//=================================================================================

      // todo: move into 
      public function RepaintContactsInLastRegionSelecting (container:Sprite):void
      {
         mSelectionEngine.RepaintContactsInLastRegionSelecting (container);
      }
   }
}

