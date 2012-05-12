
package editor.entity {
   
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
   import editor.trigger.entity.EntityEventHandler_MouseGesture;
   import editor.trigger.entity.EntityAction;

   //import editor.trigger.entity.EntityFunctionPackage;
   //import editor.trigger.entity.EntityFunction;
   
   import editor.selection.SelectionEngine;
   
   import editor.EditorContext;
   
   import editor.asset.Asset;
   import editor.asset.AssetManager;
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class Scene extends AssetManager //Sprite 
   {
      
      public function Scene ()
      {
         super ();
         
         SetPhysicsSimulationIterations (Define.WorldStepVelocityIterations_Medium, Define.WorldStepPositionIterations_Medium)
      }
      
//================================================================================
//  
//================================================================================
      
      override public function SetScale (s:Number):void
      {
         super.SetScale (s);
         
         SetZoomScale (super.GetScale ());
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

      //>>1.51
      private var mViewerUiFlags:int = Define.DefaultPlayerUiFlags;
      private var mPlayBarColor:uint = 0x606060;

      private var mViewportWidth:int = Define.DefaultPlayerWidth;
      private var mViewportHeight:int = Define.DefaultPlayerHeight;
      //<<

      //>>v1.60
      private var mPauseOnFocusLost:Boolean = false;
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
      }

      public function StatisticsPhysicsShapes ():void
      {
         var entity:Entity;

         var shapes_count:int = 0;
         var bombs_count:int = 0;

         var numEntities:int = mAssetsSortedByCreationId.length;

         for (var i:int = 0; i < numEntities; ++ i)
         {
            entity = GetAssetByCreationId (i) as Entity;
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
      
      public function SetViewerUiFlags (flags:int):void
      {
         mViewerUiFlags = flags;
      }

      public function GetViewerUiFlags ():int
      {
         return mViewerUiFlags;
      }

      public function SetPlayBarColor (color:uint):void
      {
         mPlayBarColor = color;
      }

      public function GetPlayBarColor ():uint
      {
         return mPlayBarColor;
      }

      public function SetViewportWidth (width:int):void
      {
         mViewportWidth = width;
         
         ValidateViewportSize ();
      }

      public function GetViewportWidth ():int
      {
         return mViewportWidth;
      }

      public function SetViewportHeight (height:int):void
      {
         mViewportHeight = height;
         
         ValidateViewportSize ();
      }

      public function GetViewportHeight ():int
      {
         return mViewportHeight;
      }

      private function ValidateViewportSize ():void
      {
         if (mViewportWidth > Define.MaxViewportSize)
            mViewportWidth = Define.MaxViewportSize;
         if (mViewportWidth < Define.MinViewportSize)
            mViewportWidth = Define.MinViewportSize;

         if (mViewportHeight > Define.MaxViewportSize)
            mViewportHeight = Define.MaxViewportSize;
         if (mViewportHeight < Define.MinViewportSize)
            mViewportHeight = Define.MinViewportSize;
      }
      
      public function IsPauseOnFocusLost ():Boolean
      {
         return mPauseOnFocusLost;
      }
      
      public function SetPauseOnFocusLost (pauseOnFocusLost:Boolean):void
      {
         mPauseOnFocusLost = pauseOnFocusLost;
      }
      
//=================================================================================
//   create and destroy entities
//=================================================================================

      public function CreateEntityVectorShapeCircle (aiType:int=Define.ShapeAiType_Unknown, selectIt:Boolean = false):EntityVectorShapeCircle
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var circle:EntityVectorShapeCircle = new EntityVectorShapeCircle (this);
         circle.SetAiType (aiType);
         addChild (circle);

         if (selectIt)
         {
            circle.ValidateAfterJustCreated ();
            circle.SetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetDefaultCollisionCategory ()));
            
            circle.SetPosition (mouseX, mouseY);
            SetSelectedAsset (circle);
         }
         
         return circle;
      }

      public function CreateEntityVectorShapeRectangle (aiType:int=Define.ShapeAiType_Unknown, selectIt:Boolean = false):EntityVectorShapeRectangle
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var rect:EntityVectorShapeRectangle = new EntityVectorShapeRectangle (this);
         rect.SetAiType (aiType);
         addChild (rect);

         if (selectIt)
         {
            rect.ValidateAfterJustCreated ();
            rect.SetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetDefaultCollisionCategory ()));
            
            rect.SetPosition (mouseX, mouseY);
            SetSelectedAsset (rect);
         }

         return rect;
      }

      public function CreateEntityVectorShapePolygon (aiType:int=Define.ShapeAiType_Unknown, selectIt:Boolean = false):EntityVectorShapePolygon
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var polygon:EntityVectorShapePolygon = new EntityVectorShapePolygon (this);
         polygon.SetAiType (aiType);
         addChild (polygon);

         if (selectIt)
         {
            polygon.ValidateAfterJustCreated ();
            polygon.SetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetDefaultCollisionCategory ()));
            
            polygon.SetPosition (mouseX, mouseY);
            SetSelectedAsset (polygon);
         }
         
         return polygon;
      }

      public function CreateEntityVectorShapePolyline (aiType:int=Define.ShapeAiType_Unknown, selectIt:Boolean = false):EntityVectorShapePolyline
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var polyline:EntityVectorShapePolyline = new EntityVectorShapePolyline (this);
         polyline.SetAiType (aiType);
         addChild (polyline);

         if (selectIt)
         {
            polyline.ValidateAfterJustCreated ();
            polyline.SetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetDefaultCollisionCategory ()));
            
            polyline.SetPosition (mouseX, mouseY);
            SetSelectedAsset (polyline);
         }
         
         return polyline;
      }

      public function CreateEntityJointDistance (selectIt:Boolean = false):EntityJointDistance
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var distaneJoint:EntityJointDistance = new EntityJointDistance (this);
         addChild (distaneJoint);
         
         if (selectIt)
         {
            distaneJoint.SetPosition (mouseX, mouseY);
            SetSelectedAsset (distaneJoint);
         }

         return distaneJoint;
      }

      public function CreateEntityJointHinge (selectIt:Boolean = false):EntityJointHinge
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var hinge:EntityJointHinge = new EntityJointHinge (this);
         addChild (hinge);
         
         if (selectIt)
         {
            hinge.SetPosition (mouseX, mouseY);
            SetSelectedAsset (hinge);
         }

         return hinge;
      }

      public function CreateEntityJointSlider (selectIt:Boolean = false):EntityJointSlider
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var slider:EntityJointSlider = new EntityJointSlider (this);
         addChild (slider);
         
         if (selectIt)
         {
            slider.SetPosition (mouseX, mouseY);
            SetSelectedAsset (slider);
         }

         return slider;
      }

      public function CreateEntityJointSpring (selectIt:Boolean = false):EntityJointSpring
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var spring:EntityJointSpring = new EntityJointSpring (this);
         addChild (spring);
         
         if (selectIt)
         {
            spring.SetPosition (mouseX, mouseY);
            SetSelectedAsset (spring);
         }

         return spring;
      }

      public function CreateEntityJointWeld(selectIt:Boolean = false):EntityJointWeld
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var weld:EntityJointWeld = new EntityJointWeld (this);
         addChild (weld);
         
         if (selectIt)
         {
            weld.SetPosition (mouseX, mouseY);
            SetSelectedAsset (weld);
         }

         return weld;
      }

      public function CreateEntityJointDummy(selectIt:Boolean = false):EntityJointDummy
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var dummy:EntityJointDummy = new EntityJointDummy (this);
         addChild (dummy);
         
         if (selectIt)
         {
            dummy.SetPosition (mouseX, mouseY);
            SetSelectedAsset (dummy);
         }

         return dummy;
      }

      public function CreateEntityVectorShapeText (selectIt:Boolean = false):EntityVectorShapeText
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var text:EntityVectorShapeText = new EntityVectorShapeText(this);
         addChild (text);
         
         if (selectIt)
         {
            text.SetPosition (mouseX, mouseY);
            SetSelectedAsset (text);
         }

         return text;
      }

      public function CreateEntityVectorShapeTextButton (selectIt:Boolean = false):EntityVectorShapeTextButton
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var button:EntityVectorShapeTextButton = new EntityVectorShapeTextButton (this);
         addChild (button);
         
         if (selectIt)
         {
            button.SetPosition (mouseX, mouseY);
            SetSelectedAsset (button);
         }

         return button;
      }
      
      public function CreateEntityShapeImageModule (selectIt:Boolean = false):EntityShapeImageModule
      {  
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var imageModule:EntityShapeImageModule = new EntityShapeImageModule (this);
         addChild (imageModule);
         
         if (selectIt)
         {
            imageModule.SetPosition (mouseX, mouseY);
            SetSelectedAsset (imageModule);
         }

         imageModule.SetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetDefaultCollisionCategory ()));

         return imageModule;
      }
      
      public function CreateEntityShapeImageModuleButton (selectIt:Boolean = false):EntityShapeImageModuleButton
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var imageModuleButton:EntityShapeImageModuleButton = new EntityShapeImageModuleButton (this);
         addChild (imageModuleButton);
         
         if (selectIt)
         {
            imageModuleButton.SetPosition (mouseX, mouseY);
            SetSelectedAsset (imageModuleButton);
         }

         imageModuleButton.SetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetCollisionCategoryIndex (EditorContext.GetEditorApp ().GetWorld ().GetCollisionCategoryManager ().GetDefaultCollisionCategory ()));

         return imageModuleButton;
      }

      public function CreateEntityVectorShapeGravityController (selectIt:Boolean = false):EntityVectorShapeGravityController
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var gController:EntityVectorShapeGravityController = new EntityVectorShapeGravityController(this);
         addChild (gController);
         
         if (selectIt)
         {
            gController.SetPosition (mouseX, mouseY);
            SetSelectedAsset (gController);
         }

         return gController;
      }

      public function CreateEntityUtilityCamera (selectIt:Boolean = false):EntityUtilityCamera
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var camera:EntityUtilityCamera = new EntityUtilityCamera(this);
         addChild (camera);
         
         if (selectIt)
         {
            camera.SetPosition (mouseX, mouseY);
            SetSelectedAsset (camera);
         }

         return camera;
      }

      public function CreateEntityUtilityPowerSource (sourceType:int = Define.PowerSource_Force, selectIt:Boolean = false):EntityUtilityPowerSource
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var power_source:EntityUtilityPowerSource = new EntityUtilityPowerSource (this);
         power_source.SetPowerSourceType (sourceType);
         addChild (power_source);
         
         if (selectIt)
         {
            power_source.SetPosition (mouseX, mouseY);
            SetSelectedAsset (power_source);
         }

         return power_source;
      }

      public function CreateEntityCondition (selectIt:Boolean = false):EntityBasicCondition
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var condition:EntityBasicCondition = new EntityBasicCondition(this);
         addChild (condition);
         
         if (selectIt)
         {
            condition.SetPosition (mouseX, mouseY);
            SetSelectedAsset (condition);
         }

         return condition;
      }

      public function CreateEntityConditionDoor (selectIt:Boolean = false):EntityConditionDoor
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var condition_door:EntityConditionDoor = new EntityConditionDoor(this);
         addChild (condition_door);
         
         if (selectIt)
         {
            condition_door.SetPosition (mouseX, mouseY);
            SetSelectedAsset (condition_door);
         }

         return condition_door;
      }

      public function CreateEntityTask (selectIt:Boolean = false):EntityTask
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var task:EntityTask = new EntityTask(this);
         addChild (task);
         
         if (selectIt)
         {
            task.SetPosition (mouseX, mouseY);
            SetSelectedAsset (task);
         }

         return task;
      }

      public function CreateEntityInputEntityAssigner (selectIt:Boolean = false):EntityInputEntityAssigner
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var entity_assigner:EntityInputEntityAssigner = new EntityInputEntityAssigner(this);
         addChild (entity_assigner);
         
         if (selectIt)
         {
            entity_assigner.SetPosition (mouseX, mouseY);
            SetSelectedAsset (entity_assigner);
         }

         return entity_assigner;
      }

      public function CreateEntityInputEntityPairAssigner (selectIt:Boolean = false):EntityInputEntityPairAssigner
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var entity_pair_assigner:EntityInputEntityPairAssigner = new EntityInputEntityPairAssigner(this);
         addChild (entity_pair_assigner);
         
         if (selectIt)
         {
            entity_pair_assigner.SetPosition (mouseX, mouseY);
            SetSelectedAsset (entity_pair_assigner);
         }

         return entity_pair_assigner;
      }

      public function CreateEntityInputEntityScriptFilter (selectIt:Boolean = false):EntityInputEntityScriptFilter
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var entity_filter:EntityInputEntityScriptFilter = new EntityInputEntityScriptFilter(this);
         addChild (entity_filter);
         
         if (selectIt)
         {
            entity_filter.SetPosition (mouseX, mouseY);
            SetSelectedAsset (entity_filter);
         }

         return entity_filter;
      }

      public function CreateEntityInputEntityPairScriptFilter (selectIt:Boolean = false):EntityInputEntityPairScriptFilter
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var entity_pair_filter:EntityInputEntityPairScriptFilter = new EntityInputEntityPairScriptFilter(this);
         addChild (entity_pair_filter);
         
         if (selectIt)
         {
            entity_pair_filter.SetPosition (mouseX, mouseY);
            SetSelectedAsset (entity_pair_filter);
         }

         return entity_pair_filter;
      }

      public function CreateEntityInputEntityRegionSelector (selectIt:Boolean = false):EntityInputEntityRegionSelector
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var entity_region_selector:EntityInputEntityRegionSelector = new EntityInputEntityRegionSelector(this);
         addChild (entity_region_selector);
         
         if (selectIt)
         {
            entity_region_selector.SetPosition (mouseX, mouseY);
            SetSelectedAsset (entity_region_selector);
         }

         return entity_region_selector;
      }

      public function CreateEntityEventHandler (defaultEventId:int, potientialEventIds:Array = null, selectIt:Boolean = false):EntityEventHandler
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var handler:EntityEventHandler = new EntityEventHandler (this, defaultEventId, potientialEventIds);
         addChild (handler);
         
         if (selectIt)
         {
            handler.SetPosition (mouseX, mouseY);
            SetSelectedAsset (handler);
         }

         return handler;
      }

      public function CreateEntityEventHandler_Timer (defaultEventId:int, potientialEventIds:Array = null, selectIt:Boolean = false):EntityEventHandler_Timer
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var handler:EntityEventHandler_Timer = new EntityEventHandler_Timer (this, defaultEventId, potientialEventIds);
         addChild (handler);
         
         if (selectIt)
         {
            handler.SetPosition (mouseX, mouseY);
            SetSelectedAsset (handler);
         }

         return handler;
      }

      public function CreateEntityEventHandler_TimerWithPrePostHandling (defaultEventId:int, potientialEventIds:Array = null, selectIt:Boolean = false):EntityEventHandler_Timer
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var handler:EntityEventHandler_Timer = new EntityEventHandler_TimerWithPrePostHandling (this, defaultEventId, potientialEventIds);
         addChild (handler);
         
         if (selectIt)
         {
            handler.SetPosition (mouseX, mouseY);
            SetSelectedAsset (handler);
         }

         return handler;
      }

      public function CreateEntityEventHandler_Keyboard (defaultEventId:int, potientialEventIds:Array = null, selectIt:Boolean = false):EntityEventHandler_Keyboard
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var handler:EntityEventHandler_Keyboard = new EntityEventHandler_Keyboard (this, defaultEventId, potientialEventIds);
         addChild (handler);
         
         if (selectIt)
         {
            handler.SetPosition (mouseX, mouseY);
            SetSelectedAsset (handler);
         }

         return handler;
      }

      public function CreateEntityEventHandler_Mouse (defaultEventId:int, potientialEventIds:Array = null, selectIt:Boolean = false):EntityEventHandler_Mouse
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var handler:EntityEventHandler_Mouse = new EntityEventHandler_Mouse (this, defaultEventId, potientialEventIds);
         addChild (handler);
         
         if (selectIt)
         {
            handler.SetPosition (mouseX, mouseY);
            SetSelectedAsset (handler);
         }

         return handler;
      }

      public function CreateEntityEventHandler_Contact (defaultEventId:int, potientialEventIds:Array = null, selectIt:Boolean = false):EntityEventHandler_Contact
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var handler:EntityEventHandler_Contact = new EntityEventHandler_Contact (this, defaultEventId, potientialEventIds);
         addChild (handler);
         
         if (selectIt)
         {
            handler.SetPosition (mouseX, mouseY);
            SetSelectedAsset (handler);
         }

         return handler;
      }

      public function CreateEntityEventHandler_JointReachLimit (defaultEventId:int, potientialEventIds:Array = null, selectIt:Boolean = false):EntityEventHandler_JointReachLimit
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var handler:EntityEventHandler_JointReachLimit = new EntityEventHandler_JointReachLimit (this, defaultEventId, potientialEventIds);
         addChild (handler);
         
         if (selectIt)
         {
            handler.SetPosition (mouseX, mouseY);
            SetSelectedAsset (handler);
         }

         return handler;
      }
      
      public function CreateEntityEventHandler_ModuleLoopToEnd (defaultEventId:int, potientialEventIds:Array = null, selectIt:Boolean = false):EntityEventHandler_ModuleLoopToEnd
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var handler:EntityEventHandler_ModuleLoopToEnd = new EntityEventHandler_ModuleLoopToEnd (this, defaultEventId, potientialEventIds);
         addChild (handler);
         
         if (selectIt)
         {
            handler.SetPosition (mouseX, mouseY);
            SetSelectedAsset (handler);
         }

         return handler;
      }
      
      public function CreateEntityEventHandler_GameLostOrGotFocus (defaultEventId:int, potientialEventIds:Array = null, selectIt:Boolean = false):EntityEventHandler_GameLostOrGotFocus
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var handler:EntityEventHandler_GameLostOrGotFocus = new EntityEventHandler_GameLostOrGotFocus (this, defaultEventId, potientialEventIds);
         addChild (handler);
         
         if (selectIt)
         {
            handler.SetPosition (mouseX, mouseY);
            SetSelectedAsset (handler);
         }

         return handler;
      }
      
      public function CreateEntityEventHandler_MouseGesture (defaultEventId:int, potientialEventIds:Array = null, selectIt:Boolean = false):EntityEventHandler_MouseGesture
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var handler:EntityEventHandler_MouseGesture = new EntityEventHandler_MouseGesture (this, defaultEventId, potientialEventIds);
         addChild (handler);
         
         if (selectIt)
         {
            handler.SetPosition (mouseX, mouseY);
            SetSelectedAsset (handler);
         }

         return handler;
      }
      
      public function CreateEntityAction (selectIt:Boolean = false):EntityAction
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var action:EntityAction = new EntityAction (this);
         addChild (action);
         
         if (selectIt)
         {
            action.SetPosition (mouseX, mouseY);
            SetSelectedAsset (action);
         }

         return action;
      }
      
//=================================================================================
//   clone
//=================================================================================

      public function CloneSelectedEntities (offsetX:Number, offsetY:Number, cloningInfo:Array = null):void
      {
         var selectedEntities:Array = GetSelectedAssets ();
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
                  shapeEntity = GetAssetByCreationId (shapeIndex1) as EntityVectorShape;
                  index = selectedEntities.indexOf (shapeEntity);
                  if (index >= 0)
                  {
                     newShapeEntity = cloningInfoArray [index].mClonedMainEntity;
                     newJointEntity.SetConnectedShape1Index (GetAssetCreationId (newShapeEntity));
                  }
               }

               if (shapeIndex2 >= 0)
               {
                  shapeEntity = GetAssetByCreationId (shapeIndex2) as EntityVectorShape;
                  index = selectedEntities.indexOf (shapeEntity);
                  if (index >= 0)
                  {
                     newShapeEntity = cloningInfoArray [index].mClonedMainEntity;
                     newJointEntity.SetConnectedShape2Index (GetAssetCreationId (newShapeEntity));
                  }
               }
           //<<
           ///////////////////////////////////////////////////////

               var selectableEntities:Array = mainEntity.GetSelectableAssets ();
               var clonedSelectableEntities:Array = clonedMainEntity.GetSelectableAssets ();

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

            MakeBrothers (newBrotherGroup);
         }
      }
      
      private function CloneSelectedEntities_OldEntityContianer (offsetX:Number, offsetY:Number, cloningInfo:Array = null):void
      {
         var selectedEntities:Array = GetSelectedAssets ();
         var mainEntities:Array = new Array ();
         //var cloningInfo:Array = new Array ();
         var mainEntity:Entity;
         var i:uint;
         var index:int;
         var info:Object;
         var params:Object;
         
         for (i = 0; i < selectedEntities.length; ++ i)
         {
            mainEntity = (selectedEntities [i] as Entity).GetMainAsset () as Entity;
            
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
            params.mCreateOrderId = GetAssetCreationId (mainEntities [i]);
            params.mMainEntity = mainEntities [i];
            mainEntities [i] = params;
         }
         
         mainEntities.sortOn("mCreateOrderId", Array.NUMERIC);
         
         //mSelectionListManager.ClearSelectedEntities ();
         CancelAllAssetSelections ();
         
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
               //SelectEntities (newEntity.GetSubAssets ());
               
               oldSubEntities = mainEntity.GetSubAssets ();
               oldSubEntities.push (mainEntity);
               
               newSubEntities = newEntity.GetSubAssets ();
               newSubEntities.push (newEntity);
               
               for (j = 0; j < newSubEntities.length; ++ j)
               {
                  if (clonedEntities.indexOf (newSubEntities [j]) < 0)
                  {
                     clonedEntities.push (newSubEntities [j]);
                     
                     object = new Object ();
                     object.mClonedEntity = newSubEntities [j];
                     object.mAppearOrderId = GetAssetAppearanceId (oldSubEntities [j]);
                     
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
               //SelectEntities (newEntity.GetSelectableAssets ());
               AddAssetSelections (newEntity.GetSelectableAssets ());
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
      
      override public function MoveSelectedAssetsToTop ():void
      {
         super.MoveSelectedAssetsToTop ();

         CorrectLayerIdsForJoints ();
      }
      
      override public function MoveSelectedAssetsToBottom ():void
      {
         super.MoveSelectedAssetsToBottom ();

         CorrectLayerIdsForJoints ();
      }

      // make sure the joint is befind of its anchors in apearance list
      // so that there are some conviences in playing initization.
      public function CorrectLayerIdsForJoints ():void
      {
         var numEntities:int = mAssetsSortedByCreationId.length;

         for (var i:int = 0; i < numEntities; ++ i)
         {
            var entity:Entity = mAssetsSortedByCreationId [i] as Entity;

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

         UpdateEntityVisibilityForEditing ();
      }

      public function SetInvisiblesVisible (visible:Boolean):void
      {
         mInvisiblesVisible = visible;

         UpdateEntityVisibilityForEditing ();
      }

      public function SetShapesVisible (visible:Boolean):void
      {
         mShapesVisible = visible;

         UpdateEntityVisibilityForEditing ();
      }

      public function SetJointsVisible (visible:Boolean):void
      {
         mJointsVisible = visible;

         UpdateEntityVisibilityForEditing ();
      }

      public function SetTriggersVisible (visible:Boolean):void
      {
         mTriggersVisible = visible;

         UpdateEntityVisibilityForEditing ();
      }

      private function UpdateEntityVisibilityForEditing ():void
      {
         var entity:Entity;

         var numEntities:int = mAssetsSortedByCreationId.length;
         if (numEntities != numChildren)
            trace ("!!! numEntities != numChildren");

         var ildVisible:Boolean;

         for (var i:int = 0; i < numEntities; ++ i)
         {
            entity = mAssetsSortedByCreationId [i] as Entity;
            if (entity == null)
               continue; // should not

            if (entity.IsVisible ())
            {
               entity.SetVisibleForEditing (mVisiblesVisible);
            }
            else
            {
               entity.SetVisibleForEditing (mInvisiblesVisible);
            }

            if (entity.IsVisibleForEditing ())
            {
               if (entity is EntityVectorShape || entity is EntityUtility)
               {
                  entity.SetVisibleForEditing (mShapesVisible);
               }
               else if (entity is EntityJoint || entity is SubEntityJointAnchor)
               {
                  entity.SetVisibleForEditing (mJointsVisible);
               }
               else if (entity is EntityLogic)
               {
                  entity.SetVisibleForEditing (mTriggersVisible);
               }
            }

            if ((! entity.IsVisibleForEditing ()) && entity.IsSelected ())
            {
               //mSelectionListManager.RemoveSelectedEntity (entity);
               CancelAssetSelection (entity);
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

            var numEntities:int = mAssetsSortedByCreationId.length;
            if (numEntities != numChildren)
               trace ("!!! numEntities != numChildren");

            for (var i:int = 0; i < numEntities; ++ i)
            {
               entity = mAssetsSortedByCreationId [i] as Entity;

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
      
      override public function DrawAssetLinks (canvasSprite:Sprite, forceDraw:Boolean):void
      {
         DrawEntityLinks (canvasSprite, forceDraw);
      }

      public function DrawEntityLinks (canvasSprite:Sprite, forceDraw:Boolean):void
      {
         var entityArray:Array = mAssetsSortedByCreationId.concat ();
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
      
      public function NotifyEntityLinksModified ():void
      {
         if (mAssetLinksChangedCallback != null)
         {
            mAssetLinksChangedCallback ();
         }
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

