
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

   //import editor.entity.EntityCollisionCategory;

   import editor.selection.SelectionEngine;

   import editor.trigger.TriggerEngine;
   import editor.trigger.PlayerFunctionDefinesForEditing;

   import editor.image.AssetImageModule;
   import editor.image.AssetImageNullModule;

   import editor.image.AssetImageManager;
   import editor.image.AssetImagePureModuleManager;
   import editor.image.AssetImageCompositeModuleManager;
   
   import editor.sound.AssetSound;
   import editor.sound.AssetSoundManager;
   
   import editor.ccat.CollisionCategoryManager;
   import editor.ccat.CollisionCategory;
   
   import editor.codelib.CodeLibManager;
   import editor.codelib.AssetFunction;

   import common.Define;
   import common.ValueAdjuster;

   public class World extends EntityContainer
   {
      public var mSelectionEngineForVertexes:SelectionEngine; // used within package

      //public var mCollisionManager:CollisionManager;
      public var mCollisionCategoryManager:CollisionCategoryManager;

      public var mTriggerEngine:TriggerEngine;

      //public var mFunctionManager:FunctionManager;
      public var mCodeLibManager:CodeLibManager;

      protected var mAssetImageManager:AssetImageManager;
      protected var mAssetImagePureModuleManager:AssetImagePureModuleManager;
      protected var mAssetImageAssembledModuleManager:AssetImageCompositeModuleManager;
      protected var mAssetImageSequencedModuleManager:AssetImageCompositeModuleManager;
      protected var mAssetSoundManager:AssetSoundManager;

      // temp the 2 is not used
      // somewhere need to be modified to use the 2
      public var mNumGravityControllers:int = 0;
      public var mNumCameraEntities:int = 0;

      public function World ()
      {
         super ();

      //
         SetPhysicsSimulationIterations (Define.WorldStepVelocityIterations_Medium, Define.WorldStepPositionIterations_Medium)
         
         //mSelectionEngineForVertexes = new SelectionEngine ();
         mSelectionEngineForVertexes = mSelectionEngine;

         //mCollisionManager = new CollisionManager ();
         mCollisionCategoryManager = new CollisionCategoryManager ();

         mTriggerEngine = new TriggerEngine ();

         //mFunctionManager = new FunctionManager (this);
         mCodeLibManager = new CodeLibManager (this);

         mCodeLibManager.SetFunctionMenuGroup (PlayerFunctionDefinesForEditing.sCustomMenuGroup);

         mAssetImageManager = new AssetImageManager ();
         mAssetImagePureModuleManager = new AssetImagePureModuleManager ();
         mAssetImageAssembledModuleManager = new AssetImageCompositeModuleManager (false);
         mAssetImageSequencedModuleManager = new AssetImageCompositeModuleManager (true);
         mAssetSoundManager = new AssetSoundManager ();
      }

      override public function Destroy ():void
      {
         //mCollisionManager.Destroy ();
         mCollisionCategoryManager.Destroy ();
         mCodeLibManager.Destroy ();
         mAssetImageManager.Destroy ();
         mAssetImagePureModuleManager.Destroy ();
         mAssetImageAssembledModuleManager.Destroy ();
         mAssetImageSequencedModuleManager.Destroy ();
         mAssetSoundManager.Destroy ();

         super.Destroy ();

         if (mSelectionEngineForVertexes != mSelectionEngine)
            mSelectionEngineForVertexes.Destroy ();
      }

      override public function DestroyAllEntities ():void
      {
         //mCollisionManager.DestroyAllEntities ();
         mCollisionCategoryManager.DestroyAllAssets ();
         mCodeLibManager.DestroyAllAssets ();
         mAssetImageSequencedModuleManager.DestroyAllAssets ();
         mAssetImageAssembledModuleManager.DestroyAllAssets ();
         mAssetImagePureModuleManager.DestroyAllAssets ();
         mAssetImageManager.DestroyAllAssets ();
         mAssetSoundManager.DestroyAllAssets ();

         super.DestroyAllEntities ();
      }

      override public function DestroyEntity (entity:Entity):void
      {
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
      private var mPermitPublishing:Boolean = true;

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

      //>>1.51
      private var mViewerUiFlags:int = Define.DefaultPlayerUiFlags;
      private var mPlayBarColor:uint = 0x606060;

      private var mViewportWidth:int = Define.DefaultPlayerWidth;
      private var mViewportHeight:int = Define.DefaultPlayerHeight;
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
      private var mPauseOnFocusLost:Boolean = false;
      //<<

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
      }

      public function GetViewportWidth ():int
      {
         return mViewportWidth;
      }

      public function SetViewportHeight (height:int):void
      {
         mViewportHeight = height;
      }

      public function GetViewportHeight ():int
      {
         return mViewportHeight;
      }

      public function ValidateViewportSize ():void
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
      
      public function IsPauseOnFocusLost ():Boolean
      {
         return mPauseOnFocusLost;
      }
      
      public function SetPauseOnFocusLost (pauseOnFocusLost:Boolean):void
      {
         mPauseOnFocusLost = pauseOnFocusLost;
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

         circle.SetCollisionCategoryIndex (mCollisionCategoryManager.GetCollisionCategoryIndex (mCollisionCategoryManager.GetDefaultCollisionCategory ()));

         return circle;
      }

      public function CreateEntityVectorShapeRectangle ():EntityVectorShapeRectangle
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var rect:EntityVectorShapeRectangle = new EntityVectorShapeRectangle (this);
         addChild (rect);

         rect.SetCollisionCategoryIndex (mCollisionCategoryManager.GetCollisionCategoryIndex (mCollisionCategoryManager.GetDefaultCollisionCategory ()));

         return rect;
      }

      public function CreateEntityVectorShapePolygon ():EntityVectorShapePolygon
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var polygon:EntityVectorShapePolygon = new EntityVectorShapePolygon (this);
         addChild (polygon);

         polygon.SetCollisionCategoryIndex (mCollisionCategoryManager.GetCollisionCategoryIndex (mCollisionCategoryManager.GetDefaultCollisionCategory ()));

         return polygon;
      }

      public function CreateEntityVectorShapePolyline ():EntityVectorShapePolyline
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var polyline:EntityVectorShapePolyline = new EntityVectorShapePolyline (this);
         addChild (polyline);

         polyline.SetCollisionCategoryIndex (mCollisionCategoryManager.GetCollisionCategoryIndex (mCollisionCategoryManager.GetDefaultCollisionCategory ()));

         return polyline;
      }
      
      public function CreateEntityShapeImageModule ():EntityShapeImageModule
      {  
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var imageModule:EntityShapeImageModule = new EntityShapeImageModule (this);
         addChild (imageModule);

         imageModule.SetCollisionCategoryIndex (mCollisionCategoryManager.GetCollisionCategoryIndex (mCollisionCategoryManager.GetDefaultCollisionCategory ()));

         return imageModule;
      }
      
      public function CreateEntityShapeImageModuleButton ():EntityShapeImageModuleButton
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;

         var imageModuleButton:EntityShapeImageModuleButton = new EntityShapeImageModuleButton (this);
         addChild (imageModuleButton);

         imageModuleButton.SetCollisionCategoryIndex (mCollisionCategoryManager.GetCollisionCategoryIndex (mCollisionCategoryManager.GetDefaultCollisionCategory ()));

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
//   collision categories
//=================================================================================

      //public function GetCollisionManager ():CollisionManager
      //{
      //   return mCollisionManager;
      //}
      //
      //public function CreateEntityCollisionCategoryFriendLink (categoryIndex1:int, categoryIndex2:int):void
      //{
      //   var category1:EntityCollisionCategory = mCollisionManager.GetCollisionCategoryByIndex (categoryIndex1);
      //   var category2:EntityCollisionCategory = mCollisionManager.GetCollisionCategoryByIndex (categoryIndex2);
      //
      //   if (category1 != null && category2 != null)
      //      mCollisionManager.CreateEntityCollisionCategoryFriendLink (category1, category2);
      //}
      
      public function GetCollisionCategoryManager ():CollisionCategoryManager
      {
         return mCollisionCategoryManager;
      }

      public function CreateCollisionCategoryFriendLink (categoryIndex1:int, categoryIndex2:int):void
      {
         var category1:CollisionCategory = mCollisionCategoryManager.GetCollisionCategoryByIndex (categoryIndex1);
         var category2:CollisionCategory = mCollisionCategoryManager.GetCollisionCategoryByIndex (categoryIndex2);

         if (category1 != null && category2 != null)
            mCollisionCategoryManager.CreateCollisionCategoryFriendLink (category1, category2);
      }

//=================================================================================
//   functions
//=================================================================================

      //public function GetFunctionManager ():FunctionManager
      //{
      //   return mFunctionManager;
      //}
      
      public function GetCodeLibManager ():CodeLibManager
      {
         return mCodeLibManager
      }

//=================================================================================
//   trigger system
//=================================================================================

      public function GetTriggerEngine ():TriggerEngine
      {
         return mTriggerEngine;
      }

//=================================================================================
//   image asset. (Will move to Runtime if multiple worlds is supported later)
//=================================================================================

      public function GetAssetImageManager ():AssetImageManager
      {
         return mAssetImageManager;
      }

      public function GetAssetImagePureModuleManager ():AssetImagePureModuleManager
      {
         return mAssetImagePureModuleManager;
      }

      public function GetAssetImageAssembledModuleManager ():AssetImageCompositeModuleManager
      {
         return mAssetImageAssembledModuleManager;
      }

      public function GetAssetImageSequencedModuleManager ():AssetImageCompositeModuleManager
      {
         return mAssetImageSequencedModuleManager;
      }
      
      // The global module index
      public function GetImageModuleIndex (imageModule:AssetImageModule):int
      {
         if (imageModule == null)
            return -1;
         
         var moduleType:int = imageModule.GetImageModuleType ();
         if (moduleType < 0 )
            return -1;
         
         var index:int = imageModule.GetAppearanceLayerId ();
         if (index < 0)
            return -1;
         
         if (moduleType == AssetImageModule.ImageModuleType_WholeImage)
         {
            if (imageModule.GetAssetImageModuleManager () != mAssetImageManager)
               return -1;
            else
               return index;
         }

         index += mAssetImageManager.GetNumAssets ();
         
         if (moduleType == AssetImageModule.ImageModuleType_PureModule)
         {
            if (imageModule.GetAssetImageModuleManager () != mAssetImagePureModuleManager)
               return -1;
            else
               return index;
         }
         
         index += mAssetImagePureModuleManager.GetNumAssets ();
         
         if (moduleType == AssetImageModule.ImageModuleType_AssembledModule)
         {
            if (imageModule.GetAssetImageModuleManager () != mAssetImageAssembledModuleManager)
               return -1;
            else
               return index;
         }
         
         if (moduleType == AssetImageModule.ImageModuleType_SequencedModule)
         {
            if (imageModule.GetAssetImageModuleManager () == mAssetImageSequencedModuleManager)
            {
               index += mAssetImageAssembledModuleManager.GetNumAssets ();
               return index;
            }
         }
         
         return -1;
      }
      
      public function GetImageModuleByIndex (index:int):AssetImageModule
      {
         if (index >= 0)
         {
            if (index < mAssetImageManager.GetNumAssets ())
               return mAssetImageManager.GetAssetByAppearanceId (index) as AssetImageModule;
            
            index -= mAssetImageManager.GetNumAssets ();
            
            if (index < mAssetImagePureModuleManager.GetNumAssets ())
               return mAssetImagePureModuleManager.GetAssetByAppearanceId (index) as AssetImageModule;
            
            index -= mAssetImagePureModuleManager.GetNumAssets ();
            
            if (index < mAssetImageAssembledModuleManager.GetNumAssets ())
               return mAssetImageAssembledModuleManager.GetAssetByAppearanceId (index) as AssetImageModule;
            
            index -= mAssetImageAssembledModuleManager.GetNumAssets ();
            
            if (index < mAssetImageSequencedModuleManager.GetNumAssets ())
               return mAssetImageSequencedModuleManager.GetAssetByAppearanceId (index) as AssetImageModule;
         }
         
         return new AssetImageNullModule (); 
      }
      
      public function GetAssetSoundManager ():AssetSoundManager
      {
         return mAssetSoundManager;
      }
      
      public function GetSoundIndex (sound:AssetSound):int
      {
         if (sound == null)
            return -1;
         
         if (sound.GetAssetSoundManager () != mAssetSoundManager)
            return -1;
         
         return sound.GetAppearanceLayerId ();
      }
      
      public function GetSoundByIndex (soundIndex:int):AssetSound
      {
         if (soundIndex < 0 || soundIndex >= mAssetSoundManager.GetNumAssets ())
            return null;
         
         return mAssetSoundManager.GetAssetByAppearanceId (soundIndex) as AssetSound;
      }
   }
}


