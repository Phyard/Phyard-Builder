
package editor.world {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   
   import com.tapirgames.util.Logger;
   
   import editor.entity.Entity;
   import editor.entity.SubEntity;
   import editor.entity.WorldSubEntity;
   
   import editor.entity.EntityShape;
   import editor.entity.EntityShapeCircle;
   import editor.entity.EntityShapeRectangle;
   import editor.entity.EntityShapePolygon;
   import editor.entity.EntityShapePolyline;
   import editor.entity.EntityShapeText;
   import editor.entity.EntityShapeTextButton;
   import editor.entity.EntityShapeGravityController;
   
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
   import editor.trigger.entity.EntityEventHandler_Keyboard;
   import editor.trigger.entity.EntityEventHandler_Mouse;
   import editor.trigger.entity.EntityEventHandler_Contact;
   import editor.trigger.entity.EntityAction;
   
   import editor.trigger.entity.EntityFunctionPackage;
   import editor.trigger.entity.EntityFunction;
   
   import editor.entity.VertexController;
   
   import editor.entity.EntityCollisionCategory;
   
   import editor.selection.SelectionEngine;
   
   import editor.trigger.TriggerEngine;
   import editor.trigger.PlayerFunctionDefinesForEditing;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class World extends EntityContainer 
   {
      public var mBrothersManager:BrothersManager;
      
      public var mCollisionManager:CollisionManager;
      
      public var mFunctionManager:FunctionManager;
      
      public var mSelectionEngineForVertexes:SelectionEngine; // used within package
      
      public var mTriggerEngine:TriggerEngine;
      
      // temp the 2 is not used
      // somewhere need to be modified to use the 2 
      public var mNumGravityControllers:int = 0;
      public var mNumCameraEntities:int = 0;
      
      public function World ()
      {
      //
         mBrothersManager = new BrothersManager ();
         
         mCollisionManager = new CollisionManager ();
         
         mFunctionManager = new FunctionManager (this);
         
         //mSelectionEngineForVertexes = new SelectionEngine ();
         mSelectionEngineForVertexes = mSelectionEngine;
         
         mTriggerEngine = new TriggerEngine ();
         
         mFunctionManager.SetFunctionMenuGroup (PlayerFunctionDefinesForEditing.sCustomMenuGroup);
      }
      
      override public function Destroy ():void
      {
         mCollisionManager.Destroy ();
         mFunctionManager.Destroy ();
         
         super.Destroy ();
         
         if (mSelectionEngineForVertexes != mSelectionEngine)
            mSelectionEngineForVertexes.Destroy ();
      }
      
      override public function DestroyAllEntities ():void
      {
         mCollisionManager.DestroyAllEntities ();
         
         mFunctionManager.DestroyAllEntities ();
         
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
      
      private var mZoomScale:Number = 1.0;
      
      private var mPhysicsShapesPotentialMaxCount:int = 1024;
      private var mPhysicsShapesPopulationDensityLevel:int = 8;
      
      //>>v1.08
      // the 2 are both display values
      private var mDefaultGravityAccelerationMagnitude:Number = 196; // pixels
      private var mDefaultGravityAccelerationAngle:Number = 90; // degrees in left hand coordinates
      //<<
      
      //>>1.51
      private var mViewerUiFlags:int = Define.PlayerUiFlag_ShowPlayBar
                                         | Define.PlayerUiFlag_ShowSpeedAdjustor
                                         | Define.PlayerUiFlag_ShowScaleAdjustor
                                         | Define.PlayerUiFlag_ShowHelpButton
                                         ;
      private var mPlayBarColor:uint = 0x606060;
      
      private var mViewportWidth:int = Define.DefaultPlayerWidth;
      private var mViewportHeight:int = Define.DefaultPlayerHeight;
      //<<
      
      //>>
      //private var mMaskViewerField:Boolean = false;
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
         if (mViewportWidth> 750)
            mViewportWidth = 750;
         if (mViewportWidth < 50)
            mViewportWidth = 50;
         
         if (mViewportHeight < 50)
            mViewportHeight = 50;
         
         if (mViewportWidth > 600)
         {
            if (mViewportHeight > 500)
               mViewportHeight = 500;
         }
         else
         {
            if (mViewportHeight > 600)
               mViewportHeight = 600;
         }
      }
      
      //public function IsMaskViewerField ():Boolean
      //{
      //   return mMaskViewerField;
      //}
      
      //public function SetMaskViewerField (mask:Boolean):void
      //{
      //   mMaskViewerField = mask;
      //}
      
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
//   change layers
//=================================================================================
      
      override public function MoveSelectedEntitiesToTop ():void
      {
         super.MoveSelectedEntitiesToTop ();
         
         CorrectLayerIdsForJoints ();
      }
      
      override public function MoveSelectedEntitiesToBottom ():void
      {
         super.MoveSelectedEntitiesToBottom ();
         
         CorrectLayerIdsForJoints ();
      }
      
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
                  var anchor:WorldSubEntity = joint.GetAnchor () as WorldSubEntity;
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
                     var anchor1:WorldSubEntity = joint.GetAnchor1 () as WorldSubEntity;
                     if (anchor1 != null)
                     {
                        var index1:int = getChildIndex (anchor1);
                        if (index1 > maxIndex)
                           maxIndex = index1;
                     }
                  }
                  
                  if (joint.hasOwnProperty ("GetAnchor2"))
                  {
                     var anchor2:WorldSubEntity = joint.GetAnchor2 () as WorldSubEntity;
                     if (anchor2 != null)
                     {
                        var index2:int = getChildIndex (anchor2);
                        if (index2 > maxIndex)
                           maxIndex = index2;
                     }
                  }
                  
                  if (maxIndex > 0)
                  {
                     removeChild (entity);
                     addChildAt (entity, maxIndex + 1);
                  }
               }
            }
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
         
         circle.SetCollisionCategoryIndex (mCollisionManager.GetCollisionCategoryIndex (mCollisionManager.GetDefaultCollisionCategory ()));
         
         return circle;
      }
      
      public function CreateEntityShapeRectangle ():EntityShapeRectangle
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
            
         var rect:EntityShapeRectangle = new EntityShapeRectangle (this);
         addChild (rect);
         
         rect.SetCollisionCategoryIndex (mCollisionManager.GetCollisionCategoryIndex (mCollisionManager.GetDefaultCollisionCategory ()));
         
         return rect;
      }
      
      public function CreateEntityShapePolygon ():EntityShapePolygon
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
            
         var polygon:EntityShapePolygon = new EntityShapePolygon (this);
         addChild (polygon);
         
         polygon.SetCollisionCategoryIndex (mCollisionManager.GetCollisionCategoryIndex (mCollisionManager.GetDefaultCollisionCategory ()));
         
         return polygon;
      }
      
      public function CreateEntityShapePolyline ():EntityShapePolyline
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
            
         var polyline:EntityShapePolyline = new EntityShapePolyline (this);
         addChild (polyline);
         
         polyline.SetCollisionCategoryIndex (mCollisionManager.GetCollisionCategoryIndex (mCollisionManager.GetDefaultCollisionCategory ()));
         
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
      
      public function CreateEntityInputEntityFilter ():EntityInputEntityScriptFilter
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
         
         var entity_filter:EntityInputEntityScriptFilter = new EntityInputEntityScriptFilter(this);
         addChild (entity_filter);
         
         return entity_filter;
      }
      
      public function CreateEntityInputEntityPairFilter ():EntityInputEntityPairScriptFilter
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
      
      public function CreateEntityAction ():EntityAction
      {
         if (numChildren >= Define.MaxEntitiesCount)
            return null;
         
         var action:EntityAction = new EntityAction (this);
         addChild (action);
         
         return action;
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
               if (entity is EntityShape || entity is EntityUtility)
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
      
      public function GetCollisionCategoryListDataProvider (isForPureCustomFunction:Boolean = false):Array
      {
         var list:Array = new Array ();
         
         list.push ({label:"-1:{Hidden Category}", mCategoryIndex:Define.CCatId_Hidden});
         
         if (! isForPureCustomFunction)
         {
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
         
         return CollisionCategoryIndex2SelectListSelectedIndex (Define.CCatId_Hidden, dataProvider);
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
      
      public function GetCollisionManager ():CollisionManager
      {
         return mCollisionManager;
      }
      
      public function CreateEntityCollisionCategoryFriendLink (categoryIndex1:int, categoryIndex2:int):void
      {
         var category1:EntityCollisionCategory = mCollisionManager.GetCollisionCategoryByIndex (categoryIndex1);
         var category2:EntityCollisionCategory = mCollisionManager.GetCollisionCategoryByIndex (categoryIndex2);
         
         if (category1 != null && category2 != null)
            mCollisionManager.CreateEntityCollisionCategoryFriendLink (category1, category2);
      }
      
//=================================================================================
//   functions
//=================================================================================
      
      public function GetFunctionManager ():FunctionManager
      {
         return mFunctionManager;
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
      
//=================================================================================
//   trigger system
//=================================================================================
      
      public function GetTriggerEngine ():TriggerEngine
      {
         return mTriggerEngine;
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

