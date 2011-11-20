
package common {
   
   import flash.utils.ByteArray;
   import flash.geom.Point;
   
   import editor.world.World;
   
   import editor.entity.Entity;
   
   import editor.entity.EntityShape;
   import editor.entity.EntityShapeImageModule;
   import editor.entity.EntityShapeImageModuleButton;
   
   import editor.entity.EntityVectorShape;
   import editor.entity.EntityVectorShapeCircle;
   import editor.entity.EntityVectorShapeRectangle;
   import editor.entity.EntityVectorShapePolygon;
   import editor.entity.EntityVectorShapePolyline;
   import editor.entity.EntityVectorShapeText;
   import editor.entity.EntityVectorShapeTextButton;
   import editor.entity.EntityVectorShapeGravityController;
   
   import editor.entity.EntityJoint;
   import editor.entity.EntityJointHinge;
   import editor.entity.EntityJointSlider;
   import editor.entity.EntityJointDistance;
   import editor.entity.EntityJointSpring;
   import editor.entity.EntityJointWeld;
   import editor.entity.EntityJointDummy;
   
   import editor.entity.SubEntityJointAnchor;
   
   import editor.entity.EntityUtility;
   import editor.entity.EntityUtilityCamera;
   import editor.entity.EntityUtilityPowerSource;
   
   import editor.entity.EntityCollisionCategory;
   
   import editor.image.AssetImage;
   import editor.image.AssetImageManager;
   import editor.image.AssetImagePureModule;
   import editor.image.AssetImagePureModuleManager;
   import editor.image.AssetImageCompositeModule;
   import editor.image.AssetImageCompositeModuleManager;
   import editor.image.AssetImageShapeModule;
   import editor.image.AssetImageNullModule;
   import editor.image.AssetImageDivision;
   import editor.image.AssetImageModule;
   import editor.image.AssetImageModuleInstance;
   import editor.image.AssetImageModuleInstanceManager;
   
   import common.shape.VectorShape;
   import common.shape.VectorShapePath;
   import common.shape.VectorShapeArea;
   import common.shape.VectorShapeCircle;
   import common.shape.VectorShapeRectangle;
   import common.shape.VectorShapePolygon;
   import common.shape.VectorShapePolyline;
   import common.shape.VectorShapeText;
   
   import editor.image.vector.VectorShapeForEditing;
   import editor.image.vector.VectorShapeCircleForEditing;
   import editor.image.vector.VectorShapeRectangleForEditing;
   import editor.image.vector.VectorShapePolygonForEditing;
   import editor.image.vector.VectorShapePolylineForEditing;
   import editor.image.vector.VectorShapeTextForEditing;
   
   import editor.trigger.entity.EntityLogic;
   import editor.trigger.entity.EntityTask;
   import editor.trigger.entity.EntityBasicCondition;
   import editor.trigger.entity.EntityConditionDoor;
   import editor.trigger.entity.EntityInputEntityAssigner;
   import editor.trigger.entity.EntityInputEntityPairAssigner;
   import editor.trigger.entity.EntityInputEntityScriptFilter;
   import editor.trigger.entity.EntityInputEntityPairScriptFilter;
   import editor.trigger.entity.EntityAction;
   import editor.trigger.entity.EntityEventHandler;
   import editor.trigger.entity.EntityEventHandler_Timer;
   import editor.trigger.entity.EntityEventHandler_TimerWithPrePostHandling;
   import editor.trigger.entity.EntityEventHandler_Keyboard;
   import editor.trigger.entity.EntityEventHandler_Mouse;
   import editor.trigger.entity.EntityEventHandler_Contact;
   import editor.trigger.entity.EntityEventHandler_JointReachLimit;
   
   import editor.trigger.entity.EntityFunction;
   
   import editor.trigger.VariableSpace;
   import editor.trigger.VariableInstance;
   
   import editor.runtime.Runtime;
   
   import common.trigger.define.FunctionDefine;
   //import common.trigger.define.VariableSpaceDefine;
   
   import common.trigger.ValueSpaceTypeDefine;
   
   import common.trigger.CoreEventIds;
   
   public class DataFormat
   {
      
      
      
//===========================================================================
//   
//===========================================================================
      
      // create a world define from a editor world.
      // the created word define can be used to create either a player world or a editor world
      
      public static function EditorWorld2WorldDefine (editorWorld:World):WorldDefine
      {
         if (editorWorld == null)
            return null;
         
         var worldDefine:WorldDefine = new WorldDefine ();
         
         // basic
         {
            worldDefine.mVersion = Version.VersionNumber;
            
            worldDefine.mAuthorName = editorWorld.GetAuthorName ();
            worldDefine.mAuthorHomepage = editorWorld.GetAuthorHomepage ();
            
            //>>from v1.02
            worldDefine.mShareSourceCode = editorWorld.IsShareSourceCode ();
            worldDefine.mPermitPublishing = editorWorld.IsPermitPublishing ();
            //<<
         }
         
         // settings
         {
            //>>from v1.51
            worldDefine.mSettings.mViewerUiFlags = editorWorld.GetViewerUiFlags ();
            worldDefine.mSettings.mPlayBarColor = editorWorld.GetPlayBarColor ();
            worldDefine.mSettings.mViewportWidth = editorWorld.GetViewportWidth ();
            worldDefine.mSettings.mViewportHeight = editorWorld.GetViewportHeight ();
            worldDefine.mSettings.mZoomScale = editorWorld.GetZoomScale ();
            //<<
            
            //>>from v1.04
            worldDefine.mSettings.mCameraCenterX = editorWorld.GetCameraCenterX ();
            worldDefine.mSettings.mCameraCenterY = editorWorld.GetCameraCenterY ();
            worldDefine.mSettings.mWorldLeft = editorWorld.GetWorldLeft ();
            worldDefine.mSettings.mWorldTop = editorWorld.GetWorldTop ();
            worldDefine.mSettings.mWorldWidth = editorWorld.GetWorldWidth ();
            worldDefine.mSettings.mWorldHeight = editorWorld.GetWorldHeight ();
            worldDefine.mSettings.mBackgroundColor = editorWorld.GetBackgroundColor ();
            worldDefine.mSettings.mBuildBorder = editorWorld.IsBuildBorder ();
            worldDefine.mSettings.mBorderColor = editorWorld.GetBorderColor ();
            //<<
            
            //>>added from v1.06
            //>>removed from v1.08
            editorWorld.StatisticsPhysicsShapes ();
            worldDefine.mSettings.mPhysicsShapesPotentialMaxCount = editorWorld.GetPhysicsShapesPotentialMaxCount ();
            worldDefine.mSettings.mPhysicsShapesPopulationDensityLevel = editorWorld.GetPhysicsShapesPopulationDensityLevel ();
            //<<
            //<<
            
            //>>from v1.08
            worldDefine.mSettings.mIsInfiniteWorldSize = editorWorld.IsInfiniteSceneSize ();
            
            worldDefine.mSettings.mBorderAtTopLayer = editorWorld.IsBorderAtTopLayer ();
            worldDefine.mSettings.mWorldBorderLeftThickness = editorWorld.GetWorldBorderLeftThickness ();
            worldDefine.mSettings.mWorldBorderTopThickness = editorWorld.GetWorldBorderTopThickness ();
            worldDefine.mSettings.mWorldBorderRightThickness = editorWorld.GetWorldBorderRightThickness ();
            worldDefine.mSettings.mWorldBorderBottomThickness = editorWorld.GetWorldBorderBottomThickness ();
            
            worldDefine.mSettings.mDefaultGravityAccelerationMagnitude = editorWorld.GetDefaultGravityAccelerationMagnitude ();
            worldDefine.mSettings.mDefaultGravityAccelerationAngle     = editorWorld.GetDefaultGravityAccelerationAngle ();
            
            worldDefine.mSettings.mRightHandCoordinates   = editorWorld.GetCoordinateSystem ().IsRightHand ();
            worldDefine.mSettings.mCoordinatesOriginX     = editorWorld.GetCoordinateSystem ().GetOriginX ();
            worldDefine.mSettings.mCoordinatesOriginY     = editorWorld.GetCoordinateSystem ().GetOriginY ();
            worldDefine.mSettings.mCoordinatesScale       = editorWorld.GetCoordinateSystem ().GetScale ();
            
            worldDefine.mSettings.mIsCiRulesEnabled = editorWorld.IsCiRulesEnabled ();
            //<<
            
            //>>from v1.55
            worldDefine.mSettings.mAutoSleepingEnabled = editorWorld.IsAutoSleepingEnabled ();
            worldDefine.mSettings.mCameraRotatingEnabled = editorWorld.IsCameraRotatingEnabled ();
            //<<
         }
         
         var numEntities:int = editorWorld.GetNumEntities ();
         var appearId:int;
         var createId:int;
         var editorEntity:Entity;
         //var arraySortedByCreationId:Array = new Array ();
         
         for (createId = 0; createId < numEntities; ++ createId)
         {
            editorEntity = editorWorld.GetEntityByCreationId (createId);
            
            var entityDefine:Object = new Object ();
            
            entityDefine.mEntityType = Define.EntityType_Unkonwn; // default
            
            entityDefine.mPosX = editorEntity.GetPositionX ();
            entityDefine.mPosY = editorEntity.GetPositionY ();
            entityDefine.mRotation = editorEntity.GetRotation ();
            //>>from v1.58
            entityDefine.mScale = editorEntity.GetScale ();
            entityDefine.mIsFlipped = editorEntity.IsFlipped ();
            //<<
            entityDefine.mIsVisible = editorEntity.IsVisible ();
            
            //>>from v1.08
            entityDefine.mAlpha = editorEntity.GetAlpha ();
            entityDefine.mIsEnabled = editorEntity.IsEnabled ();
            //<<
            
            if (editorEntity is EntityUtility)
            {
               //>>from v1.05
                if (editorEntity is EntityUtilityCamera)
               {
                  entityDefine.mEntityType = Define.EntityType_UtilityCamera;
                  
                  var camera:EntityUtilityCamera = editorEntity as EntityUtilityCamera;
                  
                  //>>from v.108
                  entityDefine.mFollowedTarget = camera.GetFollowedTarget ();
                  entityDefine.mFollowingStyle = camera.GetFollowingStyle ();
                  //<<
               }
               //<<
               //>>from v1.10
               else if (editorEntity is EntityUtilityPowerSource)
               {
                  entityDefine.mEntityType = Define.EntityType_UtilityPowerSource;
                  
                  var powerSource:EntityUtilityPowerSource = editorEntity as EntityUtilityPowerSource;
                  
                  entityDefine.mPowerSourceType = powerSource.GetPowerSourceType ();
                  entityDefine.mPowerMagnitude = powerSource.GetPowerMagnitude ();
                  entityDefine.mKeyboardEventId = powerSource.GetKeyboardEventId ();
                  entityDefine.mKeyCodes = powerSource.GetKeyCodes ();
               }
               //<<
            }
            else if (editorEntity is EntityLogic) // from v1.07
            {
               var entityIndexArray:Array;
               
               if (editorEntity is EntityBasicCondition)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicCondition;
                  
                  var basicCondition:EntityBasicCondition = editorEntity as EntityBasicCondition;
                  
                  basicCondition.GetCodeSnippet ().ValidateCallings ();
                  entityDefine.mFunctionDefine = TriggerFormatHelper.Function2FunctionDefine (editorWorld, basicCondition.GetCodeSnippet ());
               }
               else if (editorEntity is EntityTask)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicTask;
                  
                  var task:EntityTask = editorEntity as EntityTask;
                  entityIndexArray = editorWorld.EntityArray2EntityCreationIdArray (task.GetEntityAssigners ());
                  
                  entityDefine.mInputAssignerCreationIds = entityIndexArray;
               }
               else if (editorEntity is EntityConditionDoor)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicConditionDoor;
                  
                  var conditionDoor:EntityConditionDoor = editorEntity as EntityConditionDoor;
                  
                  entityDefine.mIsAnd = conditionDoor.IsAnd ();
                  entityDefine.mIsNot = conditionDoor.IsNot ();
                  TriggerFormatHelper.ConditionAndTargetValueArray2EntityDefineProperties (editorWorld, conditionDoor.GetInputConditions (), entityDefine);
               }
               else if (editorEntity is EntityInputEntityAssigner)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicInputEntityAssigner;
                  
                  var entityAssigner:EntityInputEntityAssigner = editorEntity as EntityInputEntityAssigner;
                  entityIndexArray = editorWorld.EntityArray2EntityCreationIdArray (entityAssigner.GetInputEntities ());
                  
                  entityDefine.mSelectorType = entityAssigner.GetSelectorType ();
                  entityDefine.mNumEntities = entityIndexArray == null ? 0 : entityIndexArray.length;
                  entityDefine.mEntityCreationIds = entityIndexArray;
               }
               else if (editorEntity is EntityInputEntityPairAssigner)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicInputEntityPairAssigner;
                  
                  var pairAssigner:EntityInputEntityPairAssigner = editorEntity as EntityInputEntityPairAssigner;
                  
                  entityDefine.mPairingType = pairAssigner.GetPairingType ();
                  
                  var pairEntities:Array = pairAssigner.GetInputPairEntities ();
                  entityIndexArray = editorWorld.EntityArray2EntityCreationIdArray (pairEntities [0]);
                  
                  entityDefine.mNumEntities1 = entityIndexArray == null ? 0 : entityIndexArray.length;
                  entityDefine.mEntityCreationIds1 = entityIndexArray;
                  
                  entityIndexArray = editorWorld.EntityArray2EntityCreationIdArray (pairEntities [1]);
                  
                  entityDefine.mNumEntities2 = entityIndexArray == null ? 0 : entityIndexArray.length;
                  entityDefine.mEntityCreationIds2 = entityIndexArray;
               }
               else if (editorEntity is EntityEventHandler)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicEventHandler;
                  
                  var eventHandler:EntityEventHandler = editorEntity as EntityEventHandler;
                  entityIndexArray = editorWorld.EntityArray2EntityCreationIdArray (eventHandler.GetEntityAssigners ());
                  
                  entityDefine.mEventId = eventHandler.GetEventId ();
                  
                  entityDefine.mInputConditionEntityCreationId = editorWorld.GetEntityCreationId (eventHandler.GetInputConditionEntity () as Entity);
                  entityDefine.mInputConditionTargetValue = eventHandler.GetInputConditionTargetValue ();
                  
                  entityDefine.mInputAssignerCreationIds = entityIndexArray;
                  
                  //>>v1.08
                  entityDefine.mExternalActionEntityCreationId = editorWorld.GetEntityCreationId (eventHandler.GetExternalAction ());
                  
                  if (editorEntity is EntityEventHandler_Timer)
                  {
                     var timerEventHandler:EntityEventHandler_Timer = eventHandler as EntityEventHandler_Timer;
                     
                     entityDefine.mRunningInterval = timerEventHandler.GetRunningInterval ();
                     entityDefine.mOnlyRunOnce = timerEventHandler.IsOnlyRunOnce ();
                     
                     //>>1.56
                     if (editorEntity is EntityEventHandler_TimerWithPrePostHandling)
                     {
                        var timerEventHandlerWithPrePostHandling:EntityEventHandler_TimerWithPrePostHandling = eventHandler as EntityEventHandler_TimerWithPrePostHandling;
                        
                        timerEventHandlerWithPrePostHandling.GetPreCodeSnippet ().ValidateCallings ();
                        entityDefine.mPreFunctionDefine = TriggerFormatHelper.Function2FunctionDefine (editorWorld, timerEventHandlerWithPrePostHandling.GetPreCodeSnippet (), false);
                        
                        timerEventHandlerWithPrePostHandling.GetPostCodeSnippet ().ValidateCallings ();
                        entityDefine.mPostFunctionDefine = TriggerFormatHelper.Function2FunctionDefine (editorWorld, timerEventHandlerWithPrePostHandling.GetPostCodeSnippet (), false);
                     }
                     //<<
                  }
                  else if (editorEntity is EntityEventHandler_Keyboard)
                  {
                     var keyboardEventHandler:EntityEventHandler_Keyboard = eventHandler as EntityEventHandler_Keyboard;
                     
                     entityDefine.mKeyCodes = keyboardEventHandler.GetKeyCodes ();
                  }
                  else if (editorEntity is EntityEventHandler_Mouse)
                  {
                     var mouseEventHandler:EntityEventHandler_Mouse = eventHandler as EntityEventHandler_Mouse;
                  }
                  else if (editorEntity is EntityEventHandler_Contact)
                  {
                     var contactEventHandler:EntityEventHandler_Contact = eventHandler as EntityEventHandler_Contact;
                  }
                  else if (editorEntity is EntityEventHandler_JointReachLimit)
                  {
                     var jointReachLimitEventHandler:EntityEventHandler_JointReachLimit = eventHandler as EntityEventHandler_JointReachLimit;
                  }
                  //<<
                  
                  eventHandler.GetCodeSnippet ().ValidateCallings ();
                  entityDefine.mFunctionDefine = TriggerFormatHelper.Function2FunctionDefine (editorWorld, eventHandler.GetCodeSnippet ());
               }
               else if (editorEntity is EntityAction)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicAction;
                  
                  var action:EntityAction = editorEntity as EntityAction;
                  
                  action.GetCodeSnippet ().ValidateCallings ();
                  entityDefine.mFunctionDefine = TriggerFormatHelper.Function2FunctionDefine (editorWorld, action.GetCodeSnippet ());
               }
               //>>from v1.56
               else if (editorEntity is EntityInputEntityScriptFilter)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicInputEntityFilter;
                  
                  var entityFilter:EntityInputEntityScriptFilter = editorEntity as EntityInputEntityScriptFilter;
                  
                  entityFilter.GetCodeSnippet ().ValidateCallings ();
                  entityDefine.mFunctionDefine = TriggerFormatHelper.Function2FunctionDefine (editorWorld, entityFilter.GetCodeSnippet ());
               }
               else if (editorEntity is EntityInputEntityPairScriptFilter)
               {
                  entityDefine.mEntityType = Define.EntityType_LogicInputEntityPairFilter;
                  
                  var entityPairFilter:EntityInputEntityPairScriptFilter = editorEntity as EntityInputEntityPairScriptFilter;
                  
                  entityPairFilter.GetCodeSnippet ().ValidateCallings ();
                  entityDefine.mFunctionDefine = TriggerFormatHelper.Function2FunctionDefine (editorWorld, entityPairFilter.GetCodeSnippet ());
               }
               //<<
            }
            else if (editorEntity is EntityVectorShape)
            {
               var vectorShape:EntityVectorShape = editorEntity as EntityVectorShape;
               
               //>>from v1.02
               entityDefine.mDrawBorder = vectorShape.IsDrawBorder ();
               entityDefine.mDrawBackground = vectorShape.IsDrawBackground ();
               //<<
               
               //>>from v1.04
               entityDefine.mBorderColor = vectorShape.GetBorderColor ();
               entityDefine.mBorderThickness = vectorShape.GetBorderThickness ();
               entityDefine.mBackgroundColor = vectorShape.GetFilledColor ();
               entityDefine.mTransparency = vectorShape.GetTransparency ();
               //<<
               
               //>>from v1.05
               entityDefine.mBorderTransparency = vectorShape.GetBorderTransparency ();
               //<<
               
               if (vectorShape.IsBasicVectorShapeEntity ())
               {
                  //>> move up from v1.04
                  entityDefine.mAiType = vectorShape.GetAiType ();
                  //<<
                  
                  //
                  RetrieveShapePhysicsProperties (entityDefine, vectorShape);
                  
                  if (editorEntity is EntityVectorShapeCircle)
                  {
                     entityDefine.mEntityType = Define.EntityType_ShapeCircle;
                     
                     entityDefine.mRadius = (vectorShape as EntityVectorShapeCircle).GetRadius ();
                     
                     entityDefine.mAppearanceType = (vectorShape as EntityVectorShapeCircle).GetAppearanceType ();
                  }
                  else if (editorEntity is EntityVectorShapeRectangle)
                  {
                     entityDefine.mEntityType = Define.EntityType_ShapeRectangle;
                     
                     entityDefine.mHalfWidth = (vectorShape as EntityVectorShapeRectangle).GetHalfWidth ();
                     entityDefine.mHalfHeight = (vectorShape as EntityVectorShapeRectangle).GetHalfHeight ();
                     
                     //from v1.08
                     entityDefine.mIsRoundCorners = (vectorShape as EntityVectorShapeRectangle).IsRoundCorners ();
                     //<<
                  }
                  //>>from v1.04
                  else if (editorEntity is EntityVectorShapePolygon)
                  {
                     entityDefine.mEntityType = Define.EntityType_ShapePolygon;
                     
                     entityDefine.mLocalPoints = (vectorShape as EntityVectorShapePolygon).GetLocalVertexPoints ();
                  }
                  //<<
                  //>>from v1.05
                  else if (editorEntity is EntityVectorShapePolyline)
                  {
                     entityDefine.mEntityType = Define.EntityType_ShapePolyline;
                     
                     entityDefine.mCurveThickness = (vectorShape as EntityVectorShapePolyline).GetCurveThickness ();
                     
                     //>> from v1.08
                     entityDefine.mIsRoundEnds = (vectorShape as EntityVectorShapePolyline).IsRoundEnds ();
                     //<<
                     //>> from v1.57
                     entityDefine.mIsClosed = (vectorShape as EntityVectorShapePolyline).IsClosed ();
                     //<<
                     
                     entityDefine.mLocalPoints = (vectorShape as EntityVectorShapePolyline).GetLocalVertexPoints ();
                  }
                  //<<
               }
               else // not physics entity
               {
                  //>>from v1.02
                  if (editorEntity is EntityVectorShapeText)
                  {
                     entityDefine.mText = (vectorShape as EntityVectorShapeText).GetText ();
                     
                     entityDefine.mHalfWidth = (vectorShape as EntityVectorShapeRectangle).GetHalfWidth ();
                     entityDefine.mHalfHeight = (vectorShape as EntityVectorShapeRectangle).GetHalfHeight ();
                     
                     entityDefine.mWordWrap = (vectorShape as EntityVectorShapeText).IsWordWrap ();
                     
                     //from v1.08
                     entityDefine.mAdaptiveBackgroundSize = (vectorShape as EntityVectorShapeText).IsAdaptiveBackgroundSize ();
                     entityDefine.mTextColor = (vectorShape as EntityVectorShapeText).GetTextColor ();
                     entityDefine.mFontSize = (vectorShape as EntityVectorShapeText).GetFontSize ();
                     entityDefine.mIsBold = (vectorShape as EntityVectorShapeText).IsBold ();
                     entityDefine.mIsItalic = (vectorShape as EntityVectorShapeText).IsItalic ();
                     //<<
                     
                     //from v1.09
                     entityDefine.mTextAlign = (vectorShape as EntityVectorShapeText).GetTextAlign ();
                     entityDefine.mIsUnderlined = (vectorShape as EntityVectorShapeText).IsUnderlined ();
                     //<<
                     
                     // from v1.08
                     if (editorEntity is EntityVectorShapeTextButton) 
                     {
                        entityDefine.mEntityType = Define.EntityType_ShapeTextButton;
                        
                        entityDefine.mUsingHandCursor = (vectorShape as EntityVectorShapeTextButton).UsingHandCursor ();
                        
                        var mouseOverShape:EntityVectorShape = (vectorShape as EntityVectorShapeTextButton).GetMouseOverShape ();
                        
                        entityDefine.mDrawBackground_MouseOver = mouseOverShape.IsDrawBackground ();
                        entityDefine.mBackgroundColor_MouseOver = mouseOverShape.GetFilledColor ();
                        entityDefine.mBackgroundTransparency_MouseOver = mouseOverShape.GetTransparency ();
                        
                        entityDefine.mDrawBorder_MouseOver = mouseOverShape.IsDrawBorder ();
                        entityDefine.mBorderColor_MouseOver = mouseOverShape.GetBorderColor ();
                        entityDefine.mBorderThickness_MouseOver = mouseOverShape.GetBorderThickness ();
                        entityDefine.mBorderTransparency_MouseOver = mouseOverShape.GetBorderTransparency ();
                     }
                     //<<
                     else
                     {
                        entityDefine.mEntityType = Define.EntityType_ShapeText;
                     }
                  }
                  else if (editorEntity is EntityVectorShapeGravityController)
                  {
                     entityDefine.mEntityType = Define.EntityType_ShapeGravityController;
                     
                     entityDefine.mRadius = (vectorShape as EntityVectorShapeCircle).GetRadius ();
                     
                     // removed from v1.05
                     /////entityDefine.mIsInteractive = (vectorShape as EntityVectorShapeGravityController).IsInteractive ();
                     
                     // added in v1,05
                     entityDefine.mInteractiveZones = (vectorShape as EntityVectorShapeGravityController).GetInteractiveZones ();
                     entityDefine.mInteractiveConditions = (vectorShape as EntityVectorShapeGravityController).mInteractiveConditions;
                     
                     // ...
                     entityDefine.mInitialGravityAcceleration = (vectorShape as EntityVectorShapeGravityController).GetInitialGravityAcceleration ();
                     entityDefine.mInitialGravityAngle = (vectorShape as EntityVectorShapeGravityController).GetInitialGravityAngle ();
                     
                     //>> from v1,08
                     entityDefine.mMaximalGravityAcceleration = (vectorShape as EntityVectorShapeGravityController).GetMaximalGravityAcceleration ();
                     //<<
                  }
                  //<<
               }
            }
            //>> from v1.58
            else if (editorEntity is EntityShape)
            {
               var shape:EntityShape = editorEntity as EntityShape;
               
               if (editorEntity is EntityShapeImageModule)
               {
                  entityDefine.mEntityType = Define.EntityType_ShapeImageModule;
                  
                  RetrieveShapePhysicsProperties (entityDefine, editorEntity as EntityShapeImageModule);
                  
                  entityDefine.mModuleIndex = editorWorld.GetImageModuleIndex ((editorEntity as EntityShapeImageModule).GetAssetImageModule ());
               }
               else if (editorEntity is EntityShapeImageModuleButton)
               {
                  entityDefine.mEntityType = Define.EntityType_ShapeImageModuleButton;
                  
                  RetrieveShapePhysicsProperties (entityDefine, editorEntity as EntityShapeImageModuleButton);
                  
                  entityDefine.mModuleIndexUp = editorWorld.GetImageModuleIndex ((editorEntity as EntityShapeImageModuleButton).GetAssetImageModuleForMouseUp ());
                  entityDefine.mModuleIndexOver = editorWorld.GetImageModuleIndex ((editorEntity as EntityShapeImageModuleButton).GetAssetImageModuleForMouseOver ());
                  entityDefine.mModuleIndexDown = editorWorld.GetImageModuleIndex ((editorEntity as EntityShapeImageModuleButton).GetAssetImageModuleForMouseDown ());
               }
            }
            //<<
            else if (editorEntity is EntityJoint)
            {
               var joint:EntityJoint = (editorEntity as EntityJoint);
               
               entityDefine.mCollideConnected = joint.mCollideConnected;
               
               //>>from v1.02
               entityDefine.mConnectedShape1Index = joint.GetConnectedShape1Index ();
               entityDefine.mConnectedShape2Index = joint.GetConnectedShape2Index ();
               //<<
               
               //>>from v1.08
               entityDefine.mBreakable = joint.IsBreakable ();
               //<<
               
               if (editorEntity is EntityJointHinge)
               {
                  var hinge:EntityJointHinge = editorEntity as EntityJointHinge;
                  
                  entityDefine.mEntityType = Define.EntityType_JointHinge;
                  entityDefine.mAnchorEntityIndex = editorWorld.GetEntityCreationId ( hinge.GetAnchor () );
                  
                  entityDefine.mEnableLimits = hinge.IsLimitsEnabled ();
                  entityDefine.mLowerAngle = hinge.GetLowerLimit ();
                  entityDefine.mUpperAngle = hinge.GetUpperLimit ();
                  entityDefine.mEnableMotor = hinge.mEnableMotor;
                  entityDefine.mMotorSpeed = hinge.mMotorSpeed;
                  entityDefine.mBackAndForth = hinge.mBackAndForth;
                  
                  //>>from v1.04
                  entityDefine.mMaxMotorTorque = hinge.GetMaxMotorTorque ();
                  //<<
               }
               else if (editorEntity is EntityJointSlider)
               {
                  var slider:EntityJointSlider = editorEntity as EntityJointSlider;
                  
                  entityDefine.mEntityType = Define.EntityType_JointSlider;
                  entityDefine.mAnchor1EntityIndex = editorWorld.GetEntityCreationId ( slider.GetAnchor1 () );
                  entityDefine.mAnchor2EntityIndex = editorWorld.GetEntityCreationId ( slider.GetAnchor2 () );
                  
                  entityDefine.mEnableLimits = slider.IsLimitsEnabled ();
                  entityDefine.mLowerTranslation = slider.GetLowerLimit ();
                  entityDefine.mUpperTranslation = slider.GetUpperLimit ();
                  entityDefine.mEnableMotor = slider.mEnableMotor;
                  entityDefine.mMotorSpeed = slider.mMotorSpeed;
                  entityDefine.mBackAndForth = slider.mBackAndForth;
                  
                  //>>from v1.04
                  entityDefine.mMaxMotorForce = slider.GetMaxMotorForce ();
                  //<<
               }
               else if (editorEntity is EntityJointDistance)
               {
                  var distanceJoint:EntityJointDistance = editorEntity as EntityJointDistance;
                  
                  entityDefine.mEntityType = Define.EntityType_JointDistance;
                  entityDefine.mAnchor1EntityIndex = editorWorld.GetEntityCreationId ( distanceJoint.GetAnchor1 () );
                  entityDefine.mAnchor2EntityIndex = editorWorld.GetEntityCreationId ( distanceJoint.GetAnchor2 () );
                  
                  //>>from v1.08
                  entityDefine.mBreakDeltaLength = distanceJoint.GetBreakDeltaLength ();
                  //<<
               }
               else if (editorEntity is EntityJointSpring)
               {
                  var spring:EntityJointSpring = editorEntity as EntityJointSpring;
                  
                  entityDefine.mEntityType = Define.EntityType_JointSpring;
                  entityDefine.mAnchor1EntityIndex = editorWorld.GetEntityCreationId ( spring.GetAnchor1 () );
                  entityDefine.mAnchor2EntityIndex = editorWorld.GetEntityCreationId ( spring.GetAnchor2 () );
                  
                  entityDefine.mStaticLengthRatio = spring.GetStaticLengthRatio ();
                  //entityDefine.mFrequencyHz = spring.GetFrequencyHz ();
                  entityDefine.mSpringType = spring.GetSpringType ();
                  entityDefine.mDampingRatio = spring.mDampingRatio;
                  
                  //>>from v1.08
                  entityDefine.mFrequencyDeterminedManner = spring.GetFrequencyDeterminedManner ();
                  entityDefine.mFrequency = spring.GetFrequency ();
                  entityDefine.mSpringConstant = spring.GetSpringConstant ();
                  entityDefine.mBreakExtendedLength = spring.GetBreakExtendedLength ();
                  //<<
               }
               else if (editorEntity is EntityJointWeld)
               {
                  var weld:EntityJointWeld = editorEntity as EntityJointWeld;
                  
                  entityDefine.mEntityType = Define.EntityType_JointWeld;
                  entityDefine.mAnchorEntityIndex = editorWorld.GetEntityCreationId ( weld.GetAnchor () );
               }
               else if (editorEntity is EntityJointDummy)
               {
                  var dummy:EntityJointDummy = editorEntity as EntityJointDummy;
                  
                  entityDefine.mEntityType = Define.EntityType_JointDummy;
                  entityDefine.mAnchor1EntityIndex = editorWorld.GetEntityCreationId ( dummy.GetAnchor1 () );
                  entityDefine.mAnchor2EntityIndex = editorWorld.GetEntityCreationId ( dummy.GetAnchor2 () );
               }
               
               if (joint != null)
               {
                  joint.UpdateJointPosition ();
               }
            }
            else if (editorEntity is SubEntityJointAnchor)
            {
               entityDefine.mEntityType = Define.SubEntityType_JointAnchor;
            }
            
            worldDefine.mEntityDefines.push (entityDefine);
            
            //arraySortedByCreationId.push ({entity:editorEntity, creationId:editorEntity.GetCreationOrderId ()});
         }
         
         // 
         //arraySortedByCreationId.sortOn ("creationId", Array.NUMERIC);
         //for (var arrayIndex:int = 0; arrayIndex < arraySortedByCreationId.length; ++ arrayIndex)
         //{
         //   editorEntity = arraySortedByCreationId [arrayIndex].entity;
         //   worldDefine.mEntityAppearanceOrder.push (editorEntity.GetEntityIndex ());
         //}
         
         for (appearId = 0; appearId < numEntities; ++ appearId)
         {
            editorEntity = editorWorld.GetEntityByAppearanceId (appearId);
            worldDefine.mEntityAppearanceOrder.push (editorEntity.GetCreationOrderId ());
         }
         
         // 
         var brotherGroupArray:Array = editorWorld.GetBrotherGroups ();
         var groupId:int;
         var brotherId:int;
         var brotherGroup:Array;
         
         for (groupId = 0; groupId < brotherGroupArray.length; ++ groupId)
         {
            brotherGroup = brotherGroupArray [groupId] as Array;
            
            if (brotherGroup == null)
            {
               trace ("brotherGroup == null");
               continue;
            }
            if (brotherGroup.length == 0)
            {
               trace ("blacnk group");
               continue;
            }
            if (brotherGroup.length < 2)
            {
               trace ("one entity group, id = " + editorWorld.GetEntityCreationId (brotherGroup [brotherId] as Entity));
               continue;
            }
            
            var brotherIDs:Array = new Array (brotherGroup.length);
            for (brotherId = 0; brotherId < brotherGroup.length; ++ brotherId)
            {
               editorEntity = brotherGroup [brotherId] as Entity;
               brotherIDs [brotherId] = editorWorld.GetEntityCreationId (editorEntity);
            }
            worldDefine.mBrotherGroupDefines.push (brotherIDs);
         }
         
         //>>fromv1.02
         // collision category
         {
            var numCats:int = editorWorld.GetCollisionManager ().GetNumCollisionCategories ();
            
            for (var ccId:int = 0; ccId < numCats; ++ ccId)
            {
               var collisionCategory:EntityCollisionCategory = editorWorld.GetCollisionManager ().GetCollisionCategoryByIndex (ccId);
               
               var ccDefine:Object = new Object ();
               
               ccDefine.mName = collisionCategory.GetCategoryName ();
               ccDefine.mCollideInternally = collisionCategory.IsCollideInternally ();
               ccDefine.mPosX = collisionCategory.GetPositionX ();
               ccDefine.mPosY = collisionCategory.GetPositionY ();
               
               worldDefine.mCollisionCategoryDefines.push (ccDefine);
            }
            
            worldDefine.mDefaultCollisionCategoryIndex = editorWorld.GetCollisionManager ().GetCollisionCategoryIndex (editorWorld.GetCollisionManager ().GetDefaultCollisionCategory ());
            
            var ccFriendPairs:Array = editorWorld.GetCollisionManager ().GetCollisionCategoryFriendPairs ();
            for (var pairId:int = 0; pairId < ccFriendPairs.length; ++ pairId)
            {
               var friendPair:Object = ccFriendPairs [pairId];
               
               var pairDefine:Object = new Object ();
               
               pairDefine.mCollisionCategory1Index = editorWorld.GetCollisionManager ().GetCollisionCategoryIndex (friendPair.mCategory1);
               pairDefine.mCollisionCategory2Index = editorWorld.GetCollisionManager ().GetCollisionCategoryIndex (friendPair.mCategory2);
               
               worldDefine.mCollisionCategoryFriendLinkDefines.push (pairDefine);
            }
         }
         //<<
         
         //>>from v1.52
         // global variables and custom entity properties
         //{
            //>> from v1.57
            TriggerFormatHelper.VariableSpace2VariableDefines (editorWorld, editorWorld.GetTriggerEngine ().GetSessionVariableSpace (), worldDefine.mSessionVariableDefines, true);
            //<<
            
            TriggerFormatHelper.VariableSpace2VariableDefines (editorWorld, editorWorld.GetTriggerEngine ().GetGlobalVariableSpace (), worldDefine.mGlobalVariableDefines, true);
            
            TriggerFormatHelper.VariableSpace2VariableDefines (editorWorld, editorWorld.GetTriggerEngine ().GetEntityVariableSpace (), worldDefine.mEntityPropertyDefines, true);
         //}
         //<<
         
         //from v1.53
         // custom functions
         //{
            // packages
            
            // package variables
            
            // functions 
            
            var numFunctions:int = editorWorld.GetFunctionManager().GetNumFunctions ();
            for (var functionId:int = 0; functionId < numFunctions; ++ functionId)
            {
               var functionEntity:EntityFunction = editorWorld.GetFunctionManager().GetFunctionByIndex (functionId);
               
               functionEntity.GetCodeSnippet ().ValidateCallings ();
               var functionDefine:FunctionDefine = TriggerFormatHelper.Function2FunctionDefine (editorWorld, functionEntity.GetCodeSnippet ());
               functionDefine.mName = functionEntity.GetName ();
               functionDefine.mPosX = functionEntity.GetPositionX ();
               functionDefine.mPosY = functionEntity.GetPositionY ();
               
               //>>v1.56
               functionDefine.mDesignDependent = functionEntity.IsDesignDependent ();
               //<<
               
               worldDefine.mFunctionDefines.push (functionDefine);
            }
         //}
         //<<
         
         //>>from v1.58
         // iamge modules
         //{
            var assetImageManager:AssetImageManager = editorWorld.GetAssetImageManager ();
            var pureModuleManager:AssetImagePureModuleManager = editorWorld.GetAssetImagePureModuleManager ();
            var assembledModuleManager:AssetImageCompositeModuleManager = editorWorld.GetAssetImageAssembledModuleManager ();
            var sequencedModuleManager:AssetImageCompositeModuleManager = editorWorld.GetAssetImageSequencedModuleManager ();
            
            var numImages:int = assetImageManager.GetNumAssets ();
            for (var imageId:int = 0; imageId < numImages; ++ imageId)
            {
               var imageAsset:AssetImage = assetImageManager.GetAssetByAppearanceId (imageId) as AssetImage;
               
               var imageDefine:Object = new Object ();
               
               imageDefine.mName = imageAsset.GetName ();
               imageDefine.mFileData = imageAsset.CloneBitmapFileData ();
               
               worldDefine.mImageDefines.push (imageDefine);
            }
            
            var numDivisions:int = pureModuleManager.GetNumAssets ();
            for (var divisionId:int = 0; divisionId < numDivisions; ++ divisionId)
            {
               var imageDivison:AssetImageDivision = (pureModuleManager.GetAssetByAppearanceId (divisionId) as AssetImagePureModule).GetImageDivisionPeer ();
               
               var divisionDefine:Object = new Object ();
               divisionDefine.mImageIndex = imageDivison.GetAssetImageId ();
               divisionDefine.mLeft = imageDivison.GetLeft ();
               divisionDefine.mTop = imageDivison.GetTop ();
               divisionDefine.mRight = imageDivison.GetRight ();
               divisionDefine.mBottom = imageDivison.GetBottom ();
               
               worldDefine.mPureImageModuleDefines.push (divisionDefine);
            }
            
            var numAssembledModules:int = assembledModuleManager.GetNumAssets ();
            for (var assembledModuleId:int = 0; assembledModuleId < numAssembledModules; ++ assembledModuleId)
            {
               var assembledModule:AssetImageCompositeModule = assembledModuleManager.GetAssetByAppearanceId (assembledModuleId) as AssetImageCompositeModule;
               
               var assembledModuleDefine:Object = new Object ();
               
               assembledModuleDefine.mModulePartDefines = ModuleInstances2Define (editorWorld, assembledModule.GetModuleInstanceManager (), false);
               
               worldDefine.mAssembledModuleDefines.push (assembledModuleDefine);
            }
   
            var numSequencedModules:int = sequencedModuleManager.GetNumAssets ();
            for (var sequencedModuleId:int = 0; sequencedModuleId < numSequencedModules; ++ sequencedModuleId)
            {
               var sequencedModule:AssetImageCompositeModule = sequencedModuleManager.GetAssetByAppearanceId (sequencedModuleId) as AssetImageCompositeModule;
               
               var sequencedModuleDefine:Object = new Object ();
               
               //sequencedModuleDefine.mIsLooped = sequencedModule.IsLooped ();
               sequencedModuleDefine.mModuleSequenceDefines = ModuleInstances2Define (editorWorld, sequencedModule.GetModuleInstanceManager (), true);
               
               worldDefine.mSequencedModuleDefines.push (sequencedModuleDefine);
            }
         //}
         //<<
         
         return worldDefine;
      }
      
      public static function RetrieveShapePhysicsProperties (entityDefine:Object, entityShape:EntityShape):void
      {
         //>>from v1.04
         entityDefine.mIsPhysicsEnabled = entityShape.IsPhysicsEnabled ();
         /////entityDefine.mIsSensor = entityShape.mIsSensor; // move down from v1.05
         //<<
         
         //if (entityDefine.mIsPhysicsEnabled)  // always true before v1.04
         {
            //>>from v1.02
            entityDefine.mCollisionCategoryIndex = entityShape.GetCollisionCategoryIndex ();
            //<<
            
            //>> removed here, move up from v1.04
            /////entityDefine.mAiType = Define.GetShapeAiType (entityShape.GetFilledColor ()); // move up from v1.04
            //<<
            
            entityDefine.mIsStatic = entityShape.IsStatic ();
            entityDefine.mIsBullet = entityShape.mIsBullet;
            entityDefine.mDensity = entityShape.mDensity;
            entityDefine.mFriction = entityShape.mFriction;
            entityDefine.mRestitution = entityShape.mRestitution;
            
            // add in v1,04, move here from above since v1.05
            entityDefine.mIsSensor = entityShape.mIsSensor;
            
            //>>from v1.05
            entityDefine.mIsHollow = entityShape.IsHollow ();
            //<<
            
            //>>from v1.08
            entityDefine.mBuildBorder = entityShape.IsBuildBorder ();
            entityDefine.mIsSleepingAllowed = entityShape.IsAllowSleeping ();
            entityDefine.mIsRotationFixed = entityShape.IsFixRotation ();
            entityDefine.mLinearVelocityMagnitude = entityShape.GetLinearVelocityMagnitude ();
            entityDefine.mLinearVelocityAngle = entityShape.GetLinearVelocityAngle ();
            entityDefine.mAngularVelocity = entityShape.GetAngularVelocity ();
            //<<
         }
      }
      
      public static function ModuleInstances2Define (editorWorld:World, moduleInstanceManager:AssetImageModuleInstanceManager, forSequencedModule:Boolean):Array
      {
         var moduleInstanceDefines:Array = new Array ();
         
         var numModuleInstances:int = moduleInstanceManager.GetNumAssets ();
         for (var instanceId:int = 0; instanceId < numModuleInstances; ++ instanceId)
         {
            var moduleInstance:AssetImageModuleInstance = moduleInstanceManager.GetAssetByAppearanceId (instanceId) as AssetImageModuleInstance;
      
            var moduleInstanceDefine:Object = new Object ();
            
            moduleInstanceDefine.mVisible = moduleInstance.IsVisible ();
            moduleInstanceDefine.mAlpha = moduleInstance.GetAlpha ();
            moduleInstanceDefine.mPosX = moduleInstance.GetPositionX ();
            moduleInstanceDefine.mPosY = moduleInstance.GetPositionY ();
            moduleInstanceDefine.mScale = moduleInstance.GetScale ();
            moduleInstanceDefine.mIsFlipped = moduleInstance.IsFlipped ();
            moduleInstanceDefine.mRotation = moduleInstance.GetRotation ();
            
            if (forSequencedModule)
               moduleInstanceDefine.mModuleDuration = moduleInstance.GetDuration ();
            
            var imageModule:AssetImageModule = moduleInstance.GetAssetImageModule ();
            ModuleInstance2Define (moduleInstanceDefine, editorWorld, imageModule);
            
            moduleInstanceDefines.push (moduleInstanceDefine);
         }
         
         return moduleInstanceDefines;
      }
      
      public static function ModuleInstance2Define (moduleInstanceDefine:Object, editorWorld:World, imageModule:AssetImageModule):Object
      {
         moduleInstanceDefine.mModuleType = Define.EntityType_Unkonwn; // default, may be modified in following branches.
         
         if (imageModule is AssetImageShapeModule)
         {
            var vectorShape:VectorShape = (imageModule as AssetImageShapeModule).GetVectorShape () as VectorShape;
            
            moduleInstanceDefine.mShapeAttributeBits = vectorShape.GetAttributeBits ();
            moduleInstanceDefine.mShapeBodyOpacityAndColor = vectorShape.GetBodyOpacityAndColor (); // argb
            
            if (vectorShape is VectorShapePath)
            {
               var pathVectorShape:VectorShapePath = vectorShape as VectorShapePath;
               
               moduleInstanceDefine.mShapePathThickness = pathVectorShape.GetPathThickness ();
               
               if (vectorShape is VectorShapePolyline)
               {
                  var polylineShape:VectorShapePolyline = pathVectorShape as VectorShapePolyline;
                  
                  moduleInstanceDefine.mModuleType = Define.EntityType_ShapePolyline;
                  
                  moduleInstanceDefine.mPolyLocalPoints = polylineShape.GetLocalVertexPoints ();
               }
            }
            else if (vectorShape is VectorShapeArea)
            {
               var areaVectorShape:VectorShapeArea = vectorShape as VectorShapeArea;
               
               moduleInstanceDefine.mShapeBorderOpacityAndColor = areaVectorShape.GetBorderOpacityAndColor (); // argb
               moduleInstanceDefine.mShapeBorderThickness = areaVectorShape.GetBorderThickness ();
               
               if (vectorShape is VectorShapeCircle)
               {
                  var circleShape:VectorShapeCircle = areaVectorShape as VectorShapeCircle;
                  
                  moduleInstanceDefine.mModuleType = Define.EntityType_ShapeCircle;
                  
                  moduleInstanceDefine.mCircleRadius = circleShape.GetRadius ();
               }
               else if (vectorShape is VectorShapePolygon)
               {
                  var polygonShape:VectorShapePolygon = areaVectorShape as VectorShapePolygon;
                  
                  moduleInstanceDefine.mModuleType = Define.EntityType_ShapePolygon;
                  
                  moduleInstanceDefine.mPolyLocalPoints = polygonShape.GetLocalVertexPoints ();
               }
               else if (vectorShape is VectorShapeRectangle)
               {
                  var rectangleShape:VectorShapeRectangle = areaVectorShape as VectorShapeRectangle;
                  
                  moduleInstanceDefine.mModuleType = Define.EntityType_ShapeRectangle;
                  
                  moduleInstanceDefine.mRectHalfWidth = rectangleShape.GetHalfWidth ();
                  moduleInstanceDefine.mRectHalfHeight = rectangleShape.GetHalfHeight ();
                  
                  //if (vectorShape is VectorShapeText)
                  //{
                  //   moduleInstanceDefine.mModuleType = Define.EntityType_ShapeText;
                  //   
                  //   var textShape:VectorShapeText = vectorShape as VectorShapeText;
                  //}
                  //
                  //Text Shape 最好还是不从Rectangle继承下来。以后可以选择多种气泡背景，Rectangle只是其中之一。
                  //原点可以选在网格9个位置
               }
            }
         }
         else if (imageModule is AssetImageNullModule)
         {
            //moduleInstanceDefine.mModuleType = Define.EntityType_Unkonwn;
         }
         else
         {
            moduleInstanceDefine.mModuleType = Define.EntityType_ShapeImageModule;
            
            moduleInstanceDefine.mModuleIndex = editorWorld.GetImageModuleIndex (imageModule);
         }
         
         return moduleInstanceDefine;
      }     
      
//==============================================================
//
//==============================================================
      
      public static function ModuleInstanceDefinesToModuleInstances (moduleInstanceDefines:Array, imageModuleRefIndex_CorrectionTable:Array, editorWorld:World, moduleInstanceManager:AssetImageModuleInstanceManager, forSequencedModule:Boolean):void
      {
         for each (var moduleInstanceDefine:Object in moduleInstanceDefines)
         {
            var moduleInstance:AssetImageModuleInstance = moduleInstanceManager.CreateImageModuleInstance (
                                                           ModuleInstanceDefineToModuleInstance (moduleInstanceDefine, imageModuleRefIndex_CorrectionTable, editorWorld)
                                                        );
             
            moduleInstance.SetVisible (moduleInstanceDefine.mVisible);
            moduleInstance.SetAlpha (moduleInstanceDefine.mAlpha);
            moduleInstance.SetPosition (moduleInstanceDefine.mPosX, moduleInstanceDefine.mPosY);
            moduleInstance.SetScale (moduleInstanceDefine.mScale);
            moduleInstance.SetFlipped (moduleInstanceDefine.mIsFlipped);
            moduleInstance.SetRotation (moduleInstanceDefine.mRotation);
            
            if (forSequencedModule)
            {
               moduleInstance.SetDuration (moduleInstanceDefine.mModuleDuration);
            }
            
            // ...
            moduleInstance.UpdateAppearance ();
            moduleInstance.UpdateSelectionProxy ();
         }
      }
      
      public static function ModuleInstanceDefineToModuleInstance (moduleInstanceDefine:Object, imageModuleRefIndex_CorrectionTable:Array, editorWorld:World):AssetImageModule
      {
         var imageModule:AssetImageModule = null;
         
         if (Define.IsVectorShapeEntity (moduleInstanceDefine.mModuleType))
         {
            var vectorShape:VectorShape = null;
            
            if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolyline)
            {
               var pathVectorShape:VectorShapePath = null;
               
               // polyline
               //{
                  var polylineShape:VectorShapePolylineForEditing = new VectorShapePolylineForEditing ();
                  
                  polylineShape.SetLocalVertexPoints (moduleInstanceDefine.mPolyLocalPoints);
                  
                  pathVectorShape = polylineShape as VectorShapePath;
               //}
               
               if (pathVectorShape != null)
               {
                  pathVectorShape.SetPathThickness (moduleInstanceDefine.mShapePathThickness);
               }
               
               vectorShape = pathVectorShape;
            }
            else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeCircle
                  || moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolygon
                  || moduleInstanceDefine.mModuleType == Define.EntityType_ShapeRectangle
               )
            {
               var areaVectorShape:VectorShapeArea = null;
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeCircle)
               {
                  var circleShape:VectorShapeCircleForEditing = new VectorShapeCircleForEditing ();
                  
                  circleShape.SetRadius (moduleInstanceDefine.mCircleRadius);
                  
                  areaVectorShape = circleShape as VectorShapeArea;
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolygon)
               {
                  var polygonShape:VectorShapePolygonForEditing = new VectorShapePolygonForEditing ();
                  
                  polygonShape.SetLocalVertexPoints (moduleInstanceDefine.mPolyLocalPoints);
                  
                  areaVectorShape = polygonShape as VectorShapeArea;
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeRectangle)
               {
                  var rectangleShape:VectorShapeRectangleForEditing = new VectorShapeRectangleForEditing ();
                  
                  rectangleShape.SetHalfWidth (moduleInstanceDefine.mRectHalfWidth);
                  rectangleShape.SetHalfHeight (moduleInstanceDefine.mRectHalfHeight);
                  
                  areaVectorShape = rectangleShape as VectorShapeArea;
               }

               if (areaVectorShape != null)
               {
                  areaVectorShape.SetBorderOpacityAndColor (moduleInstanceDefine.mShapeBorderOpacityAndColor); // argb
                  areaVectorShape.SetBorderThickness (moduleInstanceDefine.mShapeBorderThickness);
               }
               
               vectorShape = areaVectorShape;
            }

            
            if (vectorShape != null)
            {
               vectorShape.SetAttributeBits (moduleInstanceDefine.mShapeAttributeBits);
               vectorShape.SetBodyOpacityAndColor (moduleInstanceDefine.mShapeBodyOpacityAndColor); // argb

               imageModule = new AssetImageShapeModule (vectorShape as VectorShapeForEditing);
            }
         }
         else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeImageModule)
         {
            if (moduleInstanceDefine.mModuleIndex >= 0)
            {
               moduleInstanceDefine.mModuleIndex = imageModuleRefIndex_CorrectionTable [moduleInstanceDefine.mModuleIndex];
               imageModule = editorWorld.GetImageModuleByIndex (moduleInstanceDefine.mModuleIndex);
            }
         }
         
         if (imageModule == null)
            imageModule = new AssetImageNullModule ();
      
         return imageModule;
      }
      
      public static function SetShapePhysicsProperties (shape:EntityShape, entityDefine:Object, beginningCollisionCategoryIndex:int):void
      {
         //>>from v1.04
         shape.SetPhysicsEnabled (entityDefine.mIsPhysicsEnabled);
         /////shape.mIsSensor = entityDefine.mIsSensor; // move down from v1.05
         //<<
         
         if (entityDefine.mIsPhysicsEnabled) // always true before v1.04
         {
            //>>from v1.02
            if (entityDefine.mCollisionCategoryIndex >= 0)
               shape.SetCollisionCategoryIndex ( int(entityDefine.mCollisionCategoryIndex) + beginningCollisionCategoryIndex);
            else
               shape.SetCollisionCategoryIndex (entityDefine.mCollisionCategoryIndex);
            //<<
            
            shape.SetStatic (entityDefine.mIsStatic);
            shape.mIsBullet = entityDefine.mIsBullet;
            shape.mDensity = entityDefine.mDensity;
            shape.mFriction = entityDefine.mFriction;
            shape.mRestitution = entityDefine.mRestitution;
            
            // add in v1,04, move here from above from v1.05
            shape.mIsSensor = entityDefine.mIsSensor;
            
            //>>from v1.05
            shape.SetHollow (entityDefine.mIsHollow);
            //<<
            
            //>>from v1.08
            shape.SetBuildBorder (entityDefine.mBuildBorder);
            shape.SetAllowSleeping (entityDefine.mIsSleepingAllowed);
            shape.SetFixRotation (entityDefine.mIsRotationFixed);
            shape.SetLinearVelocityMagnitude (entityDefine.mLinearVelocityMagnitude);
            shape.SetLinearVelocityAngle (entityDefine.mLinearVelocityAngle);
            shape.SetAngularVelocity (entityDefine.mAngularVelocity);
            //<<
         }
      }
      
      public static function WorldDefine2EditorWorld (worldDefine:WorldDefine, adjustPrecisionsInWorldDefine:Boolean = true, editorWorld:editor.world.World = null, mergeVariablesWithSameNames:Boolean = false):editor.world.World
      {
         if (worldDefine == null)
            return editorWorld;
         
         var isCreatingNewWorld:Boolean = (editorWorld == null);
         
         // from v1,03
         DataFormat2.FillMissedFieldsInWorldDefine (worldDefine);
         if (adjustPrecisionsInWorldDefine)
            DataFormat2.AdjustNumberValuesInWorldDefine (worldDefine);
         
         //
         if (isCreatingNewWorld)
         {
            editorWorld = new editor.world.World ();
            
            // basic
            {
               editorWorld.SetAuthorName (worldDefine.mAuthorName);
               editorWorld.SetAuthorHomepage (worldDefine.mAuthorHomepage);
               
               editorWorld.SetShareSourceCode (worldDefine.mShareSourceCode);
               editorWorld.SetPermitPublishing (worldDefine.mPermitPublishing);
            }
            
            // settings
            {
               //>>from v1.51
               editorWorld.SetViewerUiFlags (worldDefine.mSettings.mViewerUiFlags);
               editorWorld.SetPlayBarColor (worldDefine.mSettings.mPlayBarColor);
               editorWorld.SetViewportWidth (worldDefine.mSettings.mViewportWidth);
               editorWorld.SetViewportHeight (worldDefine.mSettings.mViewportHeight);
               editorWorld.SetZoomScale (worldDefine.mSettings.mZoomScale);
               //<<
               
               //>> from v1.04
               editorWorld.SetCameraCenterX (worldDefine.mSettings.mCameraCenterX);
               editorWorld.SetCameraCenterY (worldDefine.mSettings.mCameraCenterY);
               editorWorld.SetWorldLeft (worldDefine.mSettings.mWorldLeft);
               editorWorld.SetWorldTop (worldDefine.mSettings.mWorldTop);
               editorWorld.SetWorldWidth (worldDefine.mSettings.mWorldWidth);
               editorWorld.SetWorldHeight (worldDefine.mSettings.mWorldHeight);
               editorWorld.SetBackgroundColor (worldDefine.mSettings.mBackgroundColor);
               editorWorld.SetBuildBorder (worldDefine.mSettings.mBuildBorder);
               editorWorld.SetBorderColor (worldDefine.mSettings.mBorderColor);
               //<<
               
               
               //>> [v1.06, v1.08)
               //worldDefine.mSettings.mPhysicsShapesPotentialMaxCount;
               //worldDefine.mSettings.mPhysicsShapesPopulationDensityLevel;
               //<<
               
               //>>from v1.08
               editorWorld.SetInfiniteSceneSize (worldDefine.mSettings.mIsInfiniteWorldSize);
               
               editorWorld.SetBorderAtTopLayer (worldDefine.mSettings.mBorderAtTopLayer);
               editorWorld.SetWorldBorderLeftThickness (worldDefine.mSettings.mWorldBorderLeftThickness);
               editorWorld.SetWorldBorderTopThickness (worldDefine.mSettings.mWorldBorderTopThickness);
               editorWorld.SetWorldBorderRightThickness (worldDefine.mSettings.mWorldBorderRightThickness);
               editorWorld.SetWorldBorderBottomThickness (worldDefine.mSettings.mWorldBorderBottomThickness);
               
               editorWorld.SetDefaultGravityAccelerationMagnitude (worldDefine.mSettings.mDefaultGravityAccelerationMagnitude);
               editorWorld.SetDefaultGravityAccelerationAngle (worldDefine.mSettings.mDefaultGravityAccelerationAngle);
               
               editorWorld.RebuildCoordinateSystem (
                     worldDefine.mSettings.mCoordinatesOriginX,
                     worldDefine.mSettings.mCoordinatesOriginY,
                     worldDefine.mSettings.mCoordinatesScale,
                     worldDefine.mSettings.mRightHandCoordinates
                  );
               
               editorWorld.SetCiRulesEnabled (worldDefine.mSettings.mIsCiRulesEnabled);
               //<<
               
               //>>from v1.55
               editorWorld.SetAutoSleepingEnabled (worldDefine.mSettings.mAutoSleepingEnabled);
               editorWorld.SetCameraRotatingEnabled (worldDefine.mSettings.mCameraRotatingEnabled);
               //<<
            }
         }
         
         // collision category
         
         var beginningCollisionCategoryIndex:int = editorWorld.GetCollisionManager ().GetNumCollisionCategories ();
         
         //>> from v1.02
         {
            var collisionCategory:EntityCollisionCategory;
            
            for (var ccId:int = 0; ccId < worldDefine.mCollisionCategoryDefines.length; ++ ccId)
            {
               var ccDefine:Object = worldDefine.mCollisionCategoryDefines [ccId];
               
               collisionCategory = editorWorld.GetCollisionManager ().CreateEntityCollisionCategory (ccDefine.mName);
               collisionCategory.SetCollideInternally (ccDefine.mCollideInternally);
               
               collisionCategory.SetPosition (ccDefine.mPosX, ccDefine.mPosY);
               
               collisionCategory.UpdateAppearance ();
               collisionCategory.UpdateSelectionProxy ();
            }
            
            if (isCreatingNewWorld)
            {
               collisionCategory = editorWorld.GetCollisionManager ().GetCollisionCategoryByIndex (worldDefine.mDefaultCollisionCategoryIndex);
               if (collisionCategory != null)
                  collisionCategory.SetDefaultCategory (true);
            }
            
            for (var pairId:int = 0; pairId < worldDefine.mCollisionCategoryFriendLinkDefines.length; ++ pairId)
            {
               var pairDefine:Object = worldDefine.mCollisionCategoryFriendLinkDefines [pairId];
               
               //editorWorld.CreateEntityCollisionCategoryFriendLink (pairDefine.mCollisionCategory1Index, pairDefine.mCollisionCategory2Index);
               editorWorld.CreateEntityCollisionCategoryFriendLink (beginningCollisionCategoryIndex + pairDefine.mCollisionCategory1Index, 
                                                                    beginningCollisionCategoryIndex + pairDefine.mCollisionCategory2Index);
            }
         }
         //<<
         
         //>> from v1.58
         // iamge modules
         //{
            var assetImageManager:AssetImageManager = editorWorld.GetAssetImageManager ();
            var pureModuleManager:AssetImagePureModuleManager = editorWorld.GetAssetImagePureModuleManager ();
            var assembledModuleManager:AssetImageCompositeModuleManager = editorWorld.GetAssetImageAssembledModuleManager ();
            var sequencedModuleManager:AssetImageCompositeModuleManager = editorWorld.GetAssetImageSequencedModuleManager ();
            
            var oldNumImageModules:int = assetImageManager.GetNumAssets ();
            var oldNumImageDivisions:int = pureModuleManager.GetNumAssets ();
            var oldNumAssembledModules:int = assembledModuleManager.GetNumAssets ();
            var oldNumSequencedModules:int = sequencedModuleManager.GetNumAssets ();
            
            var deltaNumImageModules:int = worldDefine.mImageDefines.length;
            var deltaNumImageDivisions:int = worldDefine.mPureImageModuleDefines.length;
            var deltaNumAssembledModules:int = worldDefine.mAssembledModuleDefines.length;
            var deltaNumSequencedModules:int = worldDefine.mSequencedModuleDefines.length;

            //
            var imageModuleRefIndex_CorrectionTable:Array = new Array (deltaNumImageModules + deltaNumImageDivisions + deltaNumAssembledModules + deltaNumSequencedModules);
            var moduleId:int = 0;
            //
         
            var correctedModuleId:int = oldNumImageModules;
            for (var imageId:int = 0; imageId < deltaNumImageModules; ++ imageId)
            {
               var imageDefine:Object = worldDefine.mImageDefines [imageId]
               
               var imageAsset:AssetImage = assetImageManager.CreateImage ();
               imageAsset.OnLoadLocalImageFinished (imageDefine.mFileData, imageDefine.mName);
               
               imageModuleRefIndex_CorrectionTable [moduleId ++] = correctedModuleId ++;
            }
            
            correctedModuleId += oldNumImageDivisions;
            for (var divisionId:int = 0; divisionId < deltaNumImageDivisions; ++ divisionId)
            { 
               var divisionDefine:Object = worldDefine.mPureImageModuleDefines [divisionId];
               
               divisionDefine.mImageIndex += oldNumImageModules;
               var imageDivision:AssetImageDivision = (assetImageManager.GetAssetByAppearanceId (divisionDefine.mImageIndex) as AssetImage)
                                             .GetAssetImageDivisionManager ().CreateImageDivision (
                                                divisionDefine.mLeft, divisionDefine.mTop, divisionDefine.mRight, divisionDefine.mBottom,
                                                false, pureModuleManager
                                             );
               
               
               imageModuleRefIndex_CorrectionTable [moduleId ++] = correctedModuleId ++;
            }
            
            correctedModuleId += oldNumAssembledModules;
            var numNewAssembledModules:int = deltaNumAssembledModules;
            while (-- numNewAssembledModules >= 0)
            {
               assembledModuleManager.CreateImageCompositeModule ();
               
               imageModuleRefIndex_CorrectionTable [moduleId ++] = correctedModuleId ++;
            }
   
            correctedModuleId += oldNumSequencedModules;
            var numNewSequencedModules:int = deltaNumSequencedModules;
            while (-- numNewSequencedModules >= 0)
            {
               sequencedModuleManager.CreateImageCompositeModule ();
               
               imageModuleRefIndex_CorrectionTable [moduleId ++] = correctedModuleId ++;
            }
            
            for (var assembledModuleId:int = 0; assembledModuleId < deltaNumAssembledModules; ++ assembledModuleId)
            {
               var assembledModuleDefine:Object = worldDefine.mAssembledModuleDefines [assembledModuleId];
               
               var assembledModule:AssetImageCompositeModule = assembledModuleManager.GetAssetByAppearanceId (assembledModuleId + oldNumAssembledModules) as AssetImageCompositeModule;

               ModuleInstanceDefinesToModuleInstances (assembledModuleDefine.mModulePartDefines, imageModuleRefIndex_CorrectionTable, editorWorld, assembledModule.GetModuleInstanceManager (), false);
               
               assembledModule.UpdateAppearance ();
            }
   
            for (var sequencedModuleId:int = 0; sequencedModuleId < deltaNumSequencedModules; ++ sequencedModuleId)
            {
               var sequencedModuleDefine:Object = worldDefine.mSequencedModuleDefines [sequencedModuleId];
               
               var sequencedModule:AssetImageCompositeModule = sequencedModuleManager.GetAssetByAppearanceId (sequencedModuleId + oldNumSequencedModules) as AssetImageCompositeModule;
               
               //sequencedModule.SetLooped (sequencedModuleDefine.mIsLooped);
               ModuleInstanceDefinesToModuleInstances (sequencedModuleDefine.mModuleSequenceDefines, imageModuleRefIndex_CorrectionTable, editorWorld, sequencedModule.GetModuleInstanceManager (), true);
               
               sequencedModule.UpdateAppearance ();
            }
         //}
         //<<

         //>> todo: move function creations here from the below
         //<<
         
         // entities
         
         var beginningEntityIndex:int = editorWorld.GetNumEntities ();
         
         var appearId:int;
         var createId:int;
         var entityDefine:Object;
         var entity:Entity;
         var vectorShape:EntityVectorShape;
         var shape:EntityShape;
         var anchorDefine:Object;
         var joint:EntityJoint;
         var utility:EntityUtility;
         var logic:EntityLogic;
         
         var numEntities:int = worldDefine.mEntityDefines.length;
         
         editorWorld.SetCreationEntityArrayLocked (true);
         
         Runtime.mPauseCreateShapeProxy = true;
         
         for (createId = 0; createId < numEntities; ++ createId)
         {
            entityDefine = worldDefine.mEntityDefines [createId];
            
            entity = null;
            
            if ( Define.IsUtilityEntity (entityDefine.mEntityType) )
            {
               utility = null;
               
               //>>from v1.05
               if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
               {
                  var camera:EntityUtilityCamera = editorWorld.CreateEntityUtilityCamera ();
                  
                  //>>from v.108
                  camera.SetFollowedTarget (entityDefine.mFollowedTarget);
                  camera.SetFollowingStyle (entityDefine.mFollowingStyle);
                  //<<
                  
                  entity = utility = camera;
               }
               //<<
               //>>from v1.10
               else if (entityDefine.mEntityType == Define.EntityType_UtilityPowerSource)
               {
                  var power_source:EntityUtilityPowerSource = editorWorld.CreateEntityUtilityPowerSource ();
                  
                  power_source.SetPowerSourceType (entityDefine.mPowerSourceType);
                  power_source.SetPowerMagnitude (entityDefine.mPowerMagnitude);
                  power_source.SetKeyboardEventId (entityDefine.mKeyboardEventId)
                  power_source.SetKeyCodes (entityDefine.mKeyCodes);
                  
                  entity = utility = power_source;
               }
               //<<
            }
            else if ( Define.IsLogicEntity (entityDefine.mEntityType) ) // from v1.07
            {
               logic = null;
               
               if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
               {
                  entity = logic = editorWorld.CreateEntityCondition ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
               {
                  entity = logic = editorWorld.CreateEntityTask ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
               {
                  entity = logic = editorWorld.CreateEntityConditionDoor ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
               {
                  entity = logic = editorWorld.CreateEntityInputEntityAssigner ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
               {
                  entity = logic = editorWorld.CreateEntityInputEntityPairAssigner ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
               {
                  switch (entityDefine.mEventId)
                  {
                     case CoreEventIds.ID_OnWorldTimer:
                        entity = logic = editorWorld.CreateEntityEventHandler_Timer (entityDefine.mEventId);
                        break;
                     case CoreEventIds.ID_OnEntityTimer:
                     case CoreEventIds.ID_OnEntityPairTimer:
                        entity = logic = editorWorld.CreateEntityEventHandler_TimerWithPrePostHandling (entityDefine.mEventId);
                        break;
                     case CoreEventIds.ID_OnWorldKeyDown:
                     case CoreEventIds.ID_OnWorldKeyUp:
                     case CoreEventIds.ID_OnWorldKeyHold:
                        entity = logic = editorWorld.CreateEntityEventHandler_Keyboard (entityDefine.mEventId);
                        break;
                     case CoreEventIds.ID_OnPhysicsShapeMouseDown:
                     case CoreEventIds.ID_OnPhysicsShapeMouseUp:
                     case CoreEventIds.ID_OnEntityMouseClick:
                     case CoreEventIds.ID_OnEntityMouseDown:
                     case CoreEventIds.ID_OnEntityMouseUp:
                     case CoreEventIds.ID_OnEntityMouseMove:
                     case CoreEventIds.ID_OnEntityMouseEnter:
                     case CoreEventIds.ID_OnEntityMouseOut:
                     case CoreEventIds.ID_OnWorldMouseClick:
                     case CoreEventIds.ID_OnWorldMouseDown:
                     case CoreEventIds.ID_OnWorldMouseUp:
                     case CoreEventIds.ID_OnWorldMouseMove:
                        entity = logic = editorWorld.CreateEntityEventHandler_Mouse (entityDefine.mEventId);
                        break;
                     case CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting:
                     case CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting:
                     case CoreEventIds.ID_OnTwoPhysicsShapesEndContacting:
                        entity = logic = editorWorld.CreateEntityEventHandler_Contact (entityDefine.mEventId);
                        break;
                     case CoreEventIds.ID_OnJointReachLowerLimit:
                     case CoreEventIds.ID_OnJointReachUpperLimit:
                        entity = logic = editorWorld.CreateEntityEventHandler_JointReachLimit (entityDefine.mEventId);
                        break;
                     default:
                        entity = logic = editorWorld.CreateEntityEventHandler (entityDefine.mEventId);
                        break;
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
               {
                  entity = logic = editorWorld.CreateEntityAction ();
               }
               //>>1.56
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityFilter)
               {
                  entity = logic = editorWorld.CreateEntityInputEntityScriptFilter ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairFilter)
               {
                  entity = logic = editorWorld.CreateEntityInputEntityPairScriptFilter ();
               }
               //<<
            }
            else if ( Define.IsVectorShapeEntity (entityDefine.mEntityType) )
            {
               vectorShape = null;
               
               if ( Define.IsBasicVectorShapeEntity (entityDefine.mEntityType) )
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                     var circle:EntityVectorShapeCircle = editorWorld.CreateEntityVectorShapeCircle ();
                     circle.SetAppearanceType (entityDefine.mAppearanceType);
                     circle.SetRadius (entityDefine.mRadius);
                     
                     entity = vectorShape = circle;
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     var rect:EntityVectorShapeRectangle = editorWorld.CreateEntityVectorShapeRectangle ();
                     rect.SetHalfWidth (entityDefine.mHalfWidth);
                     rect.SetHalfHeight (entityDefine.mHalfHeight);
                     
                     //from v1.08
                     rect.SetRoundCorners (entityDefine.mIsRoundCorners);
                     //<<
                     
                     entity = vectorShape = rect;
                  }
                  //>> from v1.04
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                  {
                     var polygon:EntityVectorShapePolygon = editorWorld.CreateEntityVectorShapePolygon ();
                     
                     // commented off, do it in the 2nd round below
                     //   polygon.SetPosition (entityDefine.mPosX, entityDefine.mPosY); // the position and rotation are set again below, 
                     //   polygon.SetRotation (entityDefine.mRotation);                 // but the SetLocalVertexPoints needs position and rotation set before
                     //polygon.SetLocalVertexPoints (entityDefine.mLocalPoints);
                     
                     entity = vectorShape = polygon;
                  }
                  //<<
                  //>>from v1.05
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                  {
                     var polyline:EntityVectorShapePolyline = editorWorld.CreateEntityVectorShapePolyline ();
                     
                     polyline.SetCurveThickness (entityDefine.mCurveThickness);
                     
                     //>> from v1.08
                     polyline.SetRoundEnds (entityDefine.mIsRoundEnds);
                     //<<
                     
                     //>> from v1.57
                     polyline.SetClosed (entityDefine.mIsClosed);
                     //<<
                     
                     // commented off, do it in the 2nd round below
                     //   polyline.SetPosition (entityDefine.mPosX, entityDefine.mPosY); // the position and rotation are set again below, 
                     //   polyline.SetRotation (entityDefine.mRotation);                 // but the SetLocalVertexPoints needs position and rotation set before
                     //polyline.SetLocalVertexPoints (entityDefine.mLocalPoints);
                     
                     entity = vectorShape = polyline;
                  }
                  //<<
                  
                  if (vectorShape != null)
                  {
                     vectorShape.SetAiType (entityDefine.mAiType);
                     
                     //
                     SetShapePhysicsProperties (vectorShape, entityDefine, beginningCollisionCategoryIndex);
                  }
               }
               else // not physics vectorShape
               {
                  //>> v1.02
                  if (entityDefine.mEntityType == Define.EntityType_ShapeText || entityDefine.mEntityType == Define.EntityType_ShapeTextButton)
                  {
                     var text:EntityVectorShapeText;
                     
                     // from v1.08
                     if (entityDefine.mEntityType == Define.EntityType_ShapeTextButton)
                     {
                        var textButton:EntityVectorShapeTextButton = editorWorld.CreateEntityVectorShapeTextButton ();
                        
                        textButton.SetUsingHandCursor (entityDefine.mUsingHandCursor);
                        
                        var mouseOverShape:EntityVectorShape = textButton.GetMouseOverShape ();
                        
                        mouseOverShape.SetDrawBackground (entityDefine.mDrawBackground_MouseOver);
                        mouseOverShape.SetFilledColor (entityDefine.mBackgroundColor_MouseOver);
                        mouseOverShape.SetTransparency (entityDefine.mBackgroundTransparency_MouseOver);
                        
                        mouseOverShape.SetDrawBorder (entityDefine.mDrawBorder_MouseOver);
                        mouseOverShape.SetBorderColor (entityDefine.mBorderColor_MouseOver);
                        mouseOverShape.SetBorderThickness (entityDefine.mBorderThickness_MouseOver);
                        mouseOverShape.SetBorderTransparency (entityDefine.mBorderTransparency_MouseOver);
                        
                        text = textButton;
                     }
                     //<<
                     else
                     {
                        text = editorWorld.CreateEntityVectorShapeText ();
                     }
                     
                     text.SetText (entityDefine.mText);
                     text.SetWordWrap (entityDefine.mWordWrap);
                     
                     //from v1.08
                     text.SetAdaptiveBackgroundSize (entityDefine.mAdaptiveBackgroundSize);
                     text.SetTextColor (entityDefine.mTextColor);
                     text.SetFontSize (entityDefine.mFontSize);
                     text.SetBold (entityDefine.mIsBold);
                     text.SetItalic (entityDefine.mIsItalic);
                     //<<
                     
                     //from v1.09
                     text.SetTextAlign (entityDefine.mTextAlign);
                     text.SetUnderlined (entityDefine.mIsUnderlined);
                     //<<
                     
                     text.SetHalfWidth (entityDefine.mHalfWidth);
                     text.SetHalfHeight (entityDefine.mHalfHeight);
                     
                     entity = vectorShape = text;
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                  {
                     var gController:EntityVectorShapeGravityController = editorWorld.CreateEntityVectorShapeGravityController ();
                     
                     gController.SetRadius (entityDefine.mRadius)
                     
                     // removed from v1.05
                     /////gController.SetInteractive (entityDefine.mIsInteractive)
                     
                     // added in v1.05
                     gController.SetInteractiveZones (entityDefine.mInteractiveZones);
                     gController.mInteractiveConditions = entityDefine.mInteractiveConditions
                     
                     // ...
                     gController.SetInitialGravityAcceleration (entityDefine.mInitialGravityAcceleration)
                     gController.SetInitialGravityAngle (entityDefine.mInitialGravityAngle)
                     
                     //>> from v1,08
                     gController.SetMaximalGravityAcceleration (entityDefine.mMaximalGravityAcceleration);
                     //<<
                     
                     entity = vectorShape = gController;
                  }
                  //<<
               }
               
               if (vectorShape != null)
               {
                  //>>v1.02
                  vectorShape.SetDrawBorder (entityDefine.mDrawBorder);
                  vectorShape.SetDrawBackground (entityDefine.mDrawBackground);
                  //<<
                  
                  //>>from v1.04
                  vectorShape.SetBorderColor (entityDefine.mBorderColor);
                  vectorShape.SetBorderThickness (entityDefine.mBorderThickness);
                  vectorShape.SetFilledColor (entityDefine.mBackgroundColor);
                  vectorShape.SetTransparency (entityDefine.mTransparency);
                  //<<
                  
                  //>>from v1.05
                  vectorShape.SetBorderTransparency (entityDefine.mBorderTransparency);
                  //<<
               }
            }
            //>> from v1.58
            else if (Define.IsShapeEntity (entityDefine.mEntityType))
            {
               shape = null;
               
               if (entityDefine.mEntityType == Define.EntityType_ShapeImageModule)
               {
                  var imageModuleShape:EntityShapeImageModule = editorWorld.CreateEntityShapeImageModule ();
                  
                  if (entityDefine.mModuleIndex >= 0)
                     entityDefine.mModuleIndex = imageModuleRefIndex_CorrectionTable [entityDefine.mModuleIndex];
                  
                  imageModuleShape.SetAssetImageModuleByIndex (entityDefine.mModuleIndex);
                  
                  SetShapePhysicsProperties (imageModuleShape, entityDefine, beginningCollisionCategoryIndex);
                  
                  entity = shape = imageModuleShape;
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeImageModuleButton)
               {
                  var imageModuleShapeButton:EntityShapeImageModuleButton = editorWorld.CreateEntityShapeImageModuleButton ();
                  
                  if (entityDefine.mModuleIndexUp >= 0)
                     entityDefine.mModuleIndexUp = imageModuleRefIndex_CorrectionTable [entityDefine.mModuleIndexUp];
                  if (entityDefine.mModuleIndexOver >= 0)
                     entityDefine.mModuleIndexOver = imageModuleRefIndex_CorrectionTable [entityDefine.mModuleIndexOver];
                  if (entityDefine.mModuleIndexDown >= 0)
                     entityDefine.mModuleIndexDown = imageModuleRefIndex_CorrectionTable [entityDefine.mModuleIndexDown];
                  
                  imageModuleShapeButton.SetAssetImageModuleForMouseUpByIndex (entityDefine.mModuleIndexUp);
                  imageModuleShapeButton.SetAssetImageModuleForMouseOverByIndex (entityDefine.mModuleIndexOver);
                  imageModuleShapeButton.SetAssetImageModuleForMouseDownByIndex (entityDefine.mModuleIndexDown);
                  
                  SetShapePhysicsProperties (imageModuleShapeButton, entityDefine, beginningCollisionCategoryIndex);
                  
                  entity = shape = imageModuleShapeButton;
               }
            }
            //<<
            else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               joint = null;
               
               if (entityDefine.mEntityType == Define.EntityType_JointHinge)
               {
                  var hinge:EntityJointHinge = editorWorld.CreateEntityJointHinge ();
                  
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchorEntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (hinge.GetAnchor ());
                  anchorDefine.mEntity = hinge.GetAnchor ();
                  
                  hinge.SetLimitsEnabled (entityDefine.mEnableLimits);
                  hinge.SetLimits (entityDefine.mLowerAngle, entityDefine.mUpperAngle);
                  hinge.mEnableMotor = entityDefine.mEnableMotor;
                  hinge.mMotorSpeed = entityDefine.mMotorSpeed;
                  hinge.mBackAndForth = entityDefine.mBackAndForth;
                  
                  //>>v1.04
                  hinge.SetMaxMotorTorque (entityDefine.mMaxMotorTorque);
                  //<<
                  
                  entity = joint = hinge;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
               {
                  var slider:EntityJointSlider = editorWorld.CreateEntityJointSlider ();
                  
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (slider.GetAnchor1 ());
                  anchorDefine.mEntity = slider.GetAnchor1 ();
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (slider.GetAnchor2 ());
                  anchorDefine.mEntity = slider.GetAnchor2 ();
                  
                  slider.SetLimitsEnabled (entityDefine.mEnableLimits);
                  slider.SetLimits (entityDefine.mLowerTranslation, entityDefine.mUpperTranslation);
                  slider.mEnableMotor = entityDefine.mEnableMotor;
                  slider.mMotorSpeed = entityDefine.mMotorSpeed;
                  slider.mBackAndForth = entityDefine.mBackAndForth;
                  
                  //>>v1.04
                  slider.SetMaxMotorForce (entityDefine.mMaxMotorForce);
                  //<<
                  
                  entity = joint = slider;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
               {
                  var distanceJoint:EntityJointDistance = editorWorld.CreateEntityJointDistance ();
                  
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (distanceJoint.GetAnchor1 ());
                  anchorDefine.mEntity = distanceJoint.GetAnchor1 ();
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (distanceJoint.GetAnchor2 ());
                  anchorDefine.mEntity = distanceJoint.GetAnchor2 ();
                  
                  //>>from v1.08
                  distanceJoint.SetBreakDeltaLength (entityDefine.mBreakDeltaLength);
                  //<<
                  
                  entity = joint = distanceJoint;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  var spring:EntityJointSpring = editorWorld.CreateEntityJointSpring ();
                  
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (spring.GetAnchor1 ());
                  anchorDefine.mEntity = spring.GetAnchor1 ();
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (spring.GetAnchor2 ());
                  anchorDefine.mEntity = spring.GetAnchor2 ();
                  
                  spring.SetStaticLengthRatio (entityDefine.mStaticLengthRatio);
                  //spring.SetFrequencyHz (entityDefine.mFrequencyHz);
                  spring.SetSpringType (entityDefine.mSpringType);
                  
                  spring.mDampingRatio = entityDefine.mDampingRatio;
                  
                  //>>from v1.08
                  spring.SetFrequencyDeterminedManner (entityDefine.mFrequencyDeterminedManner);
                  spring.SetFrequency (entityDefine.mFrequency);
                  spring.SetSpringConstant (entityDefine.mSpringConstant);
                  spring.SetBreakExtendedLength (entityDefine.mBreakExtendedLength);
                  //<<
                  
                  entity = joint = spring;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointWeld)
               {
                  var weld:EntityJointWeld = editorWorld.CreateEntityJointWeld ();
                  
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchorEntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (hinge.GetAnchor ());
                  anchorDefine.mEntity = weld.GetAnchor ();
                  
                  entity = joint = weld;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDummy)
               {
                  var dummy:EntityJointDummy = editorWorld.CreateEntityJointDummy ();
                  
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (spring.GetAnchor1 ());
                  anchorDefine.mEntity = dummy.GetAnchor1 ();
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (spring.GetAnchor2 ());
                  anchorDefine.mEntity = dummy.GetAnchor2 ();
                  
                  entity = joint = dummy;
               }
               
               if (joint != null)
               {
                  joint.mCollideConnected = entityDefine.mCollideConnected ;
                  
                  //>>from v1.08
                  joint.SetBreakable (entityDefine.mBreakable);
                  //<<
               }
            }
            else if ( Define.IsJointAnchorEntity (entityDefine.mEntityType) )
            {
               //entityDefine.mEntityType = Define.SubEntityType_JointAnchor;
            }
            else
            {
               //entityDefine.mEntityType = Define.EntityType_Unkonwn;
            }
            
            if (entity != null)
            {
               entityDefine.mEntity = entity;
               
               entity.SetPosition (entityDefine.mPosX, entityDefine.mPosY);
               //>>from v1.58
               entity.SetScale (entityDefine.mScale)
               entity.SetFlipped (entityDefine.mIsFlipped)
               //<<
               entity.SetRotation (entityDefine.mRotation);
               entity.SetVisible (entityDefine.mIsVisible);
               
               //>>from v1.08
               entity.SetAlpha (entityDefine.mAlpha);
               entity.SetEnabled (entityDefine.mIsEnabled);
               //<<
            }
            else
            {
               //trace ("!!! entity is null, id = " + createId);
            }
         }
         
         // remove entities then readd them by appearance id order
         //>>>
         while (editorWorld.numChildren > beginningEntityIndex)
            editorWorld.removeChildAt (beginningEntityIndex);
         
         for (appearId = 0; appearId < numEntities; ++ appearId)
         {
            createId = worldDefine.mEntityAppearanceOrder [appearId];
            entityDefine = worldDefine.mEntityDefines [createId];
            editorWorld.addChild (entityDefine.mEntity);
         }
         //<<<
         
         editorWorld.SetCreationEntityArrayLocked (false);
         
         //>>> add entities by creation id order
         // from version 0x0107)
         for (createId = 0; createId < numEntities; ++ createId)
         {
            entityDefine = worldDefine.mEntityDefines [createId];
            entity = entityDefine.mEntity;
            
            editorWorld.AddEntityToCreationArray (entity);
         }
         //<<<
         
         Runtime.mPauseCreateShapeProxy = false;
         
         //>>> load custom variables
         // from v1.52
         var beginningSessionVariableIndex:int = editorWorld.GetTriggerEngine ().GetSessionVariableSpace ().GetNumVariableInstances ();
         var beginningGlobalVariableIndex:int = editorWorld.GetTriggerEngine ().GetGlobalVariableSpace ().GetNumVariableInstances ();
         var beginningEntityVariableIndex:int = editorWorld.GetTriggerEngine ().GetEntityVariableSpace ().GetNumVariableInstances ();
         if (worldDefine.mSessionVariableDefines.length > 0)
         {
            if (mergeVariablesWithSameNames)
               editorWorld.GetTriggerEngine ().GetSessionVariableSpace ().BeginMergeVariablesWithSameNamesInCreatingVariables (); // important
            TriggerFormatHelper.VariableDefines2VariableSpace (editorWorld, worldDefine.mSessionVariableDefines, editorWorld.GetTriggerEngine ().GetSessionVariableSpace (), true);
         }
         if (worldDefine.mGlobalVariableDefines.length > 0)
         {
            if (mergeVariablesWithSameNames)
               editorWorld.GetTriggerEngine ().GetGlobalVariableSpace ().BeginMergeVariablesWithSameNamesInCreatingVariables (); // important
            TriggerFormatHelper.VariableDefines2VariableSpace (editorWorld, worldDefine.mGlobalVariableDefines, editorWorld.GetTriggerEngine ().GetGlobalVariableSpace (), true);
         }
         if (worldDefine.mEntityPropertyDefines.length > 0)
         {
            if (mergeVariablesWithSameNames)
               editorWorld.GetTriggerEngine ().GetEntityVariableSpace ().BeginMergeVariablesWithSameNamesInCreatingVariables ();
            TriggerFormatHelper.VariableDefines2VariableSpace (editorWorld, worldDefine.mEntityPropertyDefines, editorWorld.GetTriggerEngine ().GetEntityVariableSpace (), true);
         }
         editorWorld.GetTriggerEngine ().NotifySessionVariableSpaceModified ();
         editorWorld.GetTriggerEngine ().NotifyGlobalVariableSpaceModified ();
         editorWorld.GetTriggerEngine ().NotifyEntityVariableSpaceModified ();
         //<<<
         
         //>>> load custom functions
         // from v1.53
         editorWorld.GetFunctionManager().SetDelayUpdateFunctionMenu (true);
         var beginningCustomFunctionIndex:int = editorWorld.GetFunctionManager().GetNumFunctions ();
         
         var functionId:int;
         var functionEntity:EntityFunction;
         var functionDefine:FunctionDefine;
         
         for (functionId = 0; functionId < worldDefine.mFunctionDefines.length; ++ functionId)
         {
            functionEntity = editorWorld.GetFunctionManager ().CreateEntityFunction ();
            functionDefine = worldDefine.mFunctionDefines [functionId] as FunctionDefine;
            
            //>>v1.56
            functionEntity.SetDesignDependent (functionDefine.mDesignDependent);
            //<<
            
            TriggerFormatHelper.FunctionDefine2FunctionDefinition (editorWorld, functionDefine, functionEntity.GetCodeSnippet (), functionEntity.GetCodeSnippet ().GetOwnerFunctionDefinition (), true ,false);
            functionEntity.GetFunctionDefinition ().SybchronizeDeclarationWithDefinition ();
         }
         
         for (functionId = 0; functionId < worldDefine.mFunctionDefines.length; ++ functionId)
         {
            functionEntity = editorWorld.GetFunctionManager ().GetFunctionByIndex (functionId + beginningCustomFunctionIndex);
            functionDefine = worldDefine.mFunctionDefines [functionId] as FunctionDefine;
            
            functionEntity.SetFunctionName (functionDefine.mName);
            functionEntity.SetPosition (functionDefine.mPosX, functionDefine.mPosY);
            
            functionEntity.UpdateAppearance ();
            functionEntity.UpdateSelectionProxy ();
            
            TriggerFormatHelper.ShiftReferenceIndexesInCodeSnippetDefine (editorWorld, functionDefine.mCodeSnippetDefine, true, beginningEntityIndex, beginningCollisionCategoryIndex, beginningGlobalVariableIndex, beginningEntityVariableIndex, beginningCustomFunctionIndex, beginningSessionVariableIndex);
            TriggerFormatHelper.FunctionDefine2FunctionDefinition (editorWorld, functionDefine, functionEntity.GetCodeSnippet (), functionEntity.GetCodeSnippet ().GetOwnerFunctionDefinition (), false, true);
         }
         editorWorld.GetFunctionManager().SetDelayUpdateFunctionMenu (false);
         //<<<
         
         // modify, 2nd round
         
         for (createId = 0; createId < numEntities; ++ createId)
         {
            entityDefine = worldDefine.mEntityDefines [createId];
            entity = entityDefine.mEntity;
            
            if ( Define.IsVectorShapeEntity (entityDefine.mEntityType) )
            {
               if ( Define.IsBasicVectorShapeEntity (entityDefine.mEntityType) )
               {
                  //>> from v1.04
                  if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                  {
                     polygon = entityDefine.mEntity as EntityVectorShapePolygon;
                     polygon.SetLocalVertexPoints (entityDefine.mLocalPoints);
                  }
                  //<<
                  //>>from v1.05
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                  {
                     polyline = entityDefine.mEntity as  EntityVectorShapePolyline;
                     polyline.SetLocalVertexPoints (entityDefine.mLocalPoints);
                  }
                  //<<
               }
            }
            else if ( Define.IsJointAnchorEntity (entityDefine.mEntityType) )
            {
               //trace ("entityDefine.mPosX = " + entityDefine.mPosX + ", entityDefine.mPosY = " + entityDefine.mPosY);
               
               entity = entityDefine.mEntity as Entity;
               entity.SetPosition (entityDefine.mPosX, entityDefine.mPosY);
               //>>from v1.58
               entity.SetScale (entityDefine.mScale);
               entity.SetFlipped (entityDefine.mIsFlipped);
               //<<
               entity.SetRotation (entityDefine.mRotation);
               entity.SetVisible (entityDefine.mIsVisible);
               
               entity.UpdateAppearance ();
               entity.UpdateSelectionProxy ();
               
               entity.GetMainEntity ().UpdateAppearance ();
               
               //editorWorld.addChildAt (entity, appearId);
            }
            else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               joint = entityDefine.mEntity as EntityJoint;
               
               // from v1.02
               if (entityDefine.mConnectedShape1Index >= 0)
                  entityDefine.mConnectedShape1Index += beginningEntityIndex;
               
               joint.SetConnectedShape1Index (entityDefine.mConnectedShape1Index);
               
               if (entityDefine.mConnectedShape2Index >= 0)
                  entityDefine.mConnectedShape2Index += beginningEntityIndex;
               
               joint.SetConnectedShape2Index (entityDefine.mConnectedShape2Index);
               //<<
            }
            else if ( Define.IsLogicEntity (entityDefine.mEntityType) )
            {
               if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
               {
                  var condition:EntityBasicCondition = entityDefine.mEntity as EntityBasicCondition;
                  
                  TriggerFormatHelper.ShiftReferenceIndexesInCodeSnippetDefine (editorWorld, entityDefine.mFunctionDefine.mCodeSnippetDefine, false, beginningEntityIndex, beginningCollisionCategoryIndex, beginningGlobalVariableIndex, beginningEntityVariableIndex, beginningCustomFunctionIndex, beginningSessionVariableIndex);
                  TriggerFormatHelper.FunctionDefine2FunctionDefinition (editorWorld, entityDefine.mFunctionDefine, condition.GetCodeSnippet (), condition.GetCodeSnippet ().GetOwnerFunctionDefinition ());
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
               {
                  var task:EntityTask = entityDefine.mEntity as EntityTask;
                  
                  ShiftEntityRefIndexes (entityDefine.mInputAssignerCreationIds, beginningEntityIndex);
                  task.SetEntityAssignersByCreationIds (entityDefine.mInputAssignerCreationIds);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
               {
                  var conditionDoor:EntityConditionDoor = entityDefine.mEntity as EntityConditionDoor;
                  conditionDoor.SetAsAnd (entityDefine.mIsAnd);
                  conditionDoor.SetAsNot (entityDefine.mIsNot);
                  ShiftEntityRefIndexes (entityDefine.mInputConditionEntityCreationIds, beginningEntityIndex);
                  conditionDoor.SetInputConditionsByCreationIds (entityDefine.mInputConditionEntityCreationIds, entityDefine.mInputConditionTargetValues);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
               {
                  var entityAssigner:EntityInputEntityAssigner = entityDefine.mEntity as EntityInputEntityAssigner;
                  
                  entityAssigner.SetSelectorType (entityDefine.mSelectorType);
                  ShiftEntityRefIndexes (entityDefine.mEntityCreationIds, beginningEntityIndex);
                  entityAssigner.SetInputEntitiesByCreationIds (entityDefine.mEntityCreationIds);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
               {
                  var pairAsigner:EntityInputEntityPairAssigner = entityDefine.mEntity as EntityInputEntityPairAssigner;
                  
                  pairAsigner.SetPairingType (entityDefine.mPairingType);
                  ShiftEntityRefIndexes (entityDefine.mEntityCreationIds1, beginningEntityIndex);
                  ShiftEntityRefIndexes (entityDefine.mEntityCreationIds2, beginningEntityIndex);
                  pairAsigner.SetInputPairEntitiesByCreationdIds (entityDefine.mEntityCreationIds1, entityDefine.mEntityCreationIds2);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
               {
                  var eventHandler:EntityEventHandler = entityDefine.mEntity as EntityEventHandler;
                  
                  if (entityDefine.mInputConditionEntityCreationId >= 0)
                     entityDefine.mInputConditionEntityCreationId += beginningEntityIndex;
                  
                  eventHandler.SetInputConditionByCreationId (entityDefine.mInputConditionEntityCreationId, entityDefine.mInputConditionTargetValue);
                  ShiftEntityRefIndexes (entityDefine.mInputAssignerCreationIds, beginningEntityIndex);
                  eventHandler.SetEntityAssignersByCreationIds (entityDefine.mInputAssignerCreationIds);

                  //>> from v1.08, if (worldDefine.mVersion >= 0x0108)
                  {
                     if (entityDefine.mExternalActionEntityCreationId >= 0)
                        entityDefine.mExternalActionEntityCreationId += beginningEntityIndex;
                     
                     eventHandler.SetExternalActionByCreationId (entityDefine.mExternalActionEntityCreationId);
                     
                     if (eventHandler is EntityEventHandler_Timer)
                     {
                        var timerEventHandler:EntityEventHandler_Timer = eventHandler as EntityEventHandler_Timer;
                        
                        timerEventHandler.SetRunningInterval (entityDefine.mRunningInterval);
                        timerEventHandler.SetOnlyRunOnce (entityDefine.mOnlyRunOnce);
                        
                        //>>from v1.56
                        if (eventHandler is EntityEventHandler_TimerWithPrePostHandling)
                        {
                           // the block is move down, see below. For need local variaible space of the main code snippet
                        }
                        //<<
                     }
                     else if (eventHandler is EntityEventHandler_Keyboard)
                     {
                        var keyboardEventHandler:EntityEventHandler_Keyboard = eventHandler as EntityEventHandler_Keyboard;
                        
                        keyboardEventHandler.SetKeyCodes (entityDefine.mKeyCodes);
                     }
                     else if (eventHandler is EntityEventHandler_Mouse)
                     {
                        var mouseEventHandler:EntityEventHandler_Mouse = eventHandler as EntityEventHandler_Mouse;
                     }
                     else if (eventHandler is EntityEventHandler_Contact)
                     {
                        var contactEventHandler:EntityEventHandler_Contact = eventHandler as EntityEventHandler_Contact;
                     }
                     else if (eventHandler is EntityEventHandler_JointReachLimit)
                     {
                        var jointReachLimitEventHandler:EntityEventHandler_JointReachLimit = eventHandler as EntityEventHandler_JointReachLimit;
                     }
                  }
                  //<<
                  
                  TriggerFormatHelper.ShiftReferenceIndexesInCodeSnippetDefine (editorWorld, entityDefine.mFunctionDefine.mCodeSnippetDefine, false, beginningEntityIndex, beginningCollisionCategoryIndex, beginningGlobalVariableIndex, beginningEntityVariableIndex, beginningCustomFunctionIndex, beginningSessionVariableIndex);
                  TriggerFormatHelper.FunctionDefine2FunctionDefinition (editorWorld, entityDefine.mFunctionDefine, eventHandler.GetCodeSnippet (), eventHandler.GetCodeSnippet ().GetOwnerFunctionDefinition ());
                  
                  //>>from v1.56
                  if (eventHandler is EntityEventHandler_TimerWithPrePostHandling)
                  {
                     var timerEventHandlerWithPrePostHandling:EntityEventHandler_TimerWithPrePostHandling = eventHandler as EntityEventHandler_TimerWithPrePostHandling;
            
                     if (entityDefine.mPreFunctionDefine != undefined)
                     {
                        TriggerFormatHelper.ShiftReferenceIndexesInCodeSnippetDefine (editorWorld, entityDefine.mPreFunctionDefine.mCodeSnippetDefine, false, beginningEntityIndex, beginningCollisionCategoryIndex, beginningGlobalVariableIndex, beginningEntityVariableIndex, beginningCustomFunctionIndex, beginningSessionVariableIndex);
                        TriggerFormatHelper.FunctionDefine2FunctionDefinition (editorWorld, entityDefine.mPreFunctionDefine, timerEventHandlerWithPrePostHandling.GetPreCodeSnippet (), timerEventHandlerWithPrePostHandling.GetPreCodeSnippet ().GetOwnerFunctionDefinition (), true, true, eventHandler.GetEventHandlerDefinition ().GetLocalVariableSpace ());
                     }
                     
                     if (entityDefine.mPostFunctionDefine != undefined)
                     {
                        TriggerFormatHelper.ShiftReferenceIndexesInCodeSnippetDefine (editorWorld, entityDefine.mPostFunctionDefine.mCodeSnippetDefine, false, beginningEntityIndex, beginningCollisionCategoryIndex, beginningGlobalVariableIndex, beginningEntityVariableIndex, beginningCustomFunctionIndex, beginningSessionVariableIndex);
                        TriggerFormatHelper.FunctionDefine2FunctionDefinition (editorWorld, entityDefine.mPostFunctionDefine, timerEventHandlerWithPrePostHandling.GetPostCodeSnippet (), timerEventHandlerWithPrePostHandling.GetPostCodeSnippet ().GetOwnerFunctionDefinition (), true, true, eventHandler.GetEventHandlerDefinition ().GetLocalVariableSpace ());
                     }
                  }
                  //<<
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
               {
                  var action:EntityAction = entityDefine.mEntity as EntityAction;
                  
                  TriggerFormatHelper.ShiftReferenceIndexesInCodeSnippetDefine (editorWorld, entityDefine.mFunctionDefine.mCodeSnippetDefine, false, beginningEntityIndex, beginningCollisionCategoryIndex, beginningGlobalVariableIndex, beginningEntityVariableIndex, beginningCustomFunctionIndex, beginningSessionVariableIndex);
                  TriggerFormatHelper.FunctionDefine2FunctionDefinition (editorWorld, entityDefine.mFunctionDefine, action.GetCodeSnippet (), action.GetCodeSnippet ().GetOwnerFunctionDefinition ());
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityFilter)
               {
                  var entityFilter:EntityInputEntityScriptFilter = entityDefine.mEntity as EntityInputEntityScriptFilter;
                  
                  TriggerFormatHelper.ShiftReferenceIndexesInCodeSnippetDefine (editorWorld, entityDefine.mFunctionDefine.mCodeSnippetDefine, false, beginningEntityIndex, beginningCollisionCategoryIndex, beginningGlobalVariableIndex, beginningEntityVariableIndex, beginningCustomFunctionIndex, beginningSessionVariableIndex);
                  TriggerFormatHelper.FunctionDefine2FunctionDefinition (editorWorld, entityDefine.mFunctionDefine, entityFilter.GetCodeSnippet (), entityFilter.GetCodeSnippet ().GetOwnerFunctionDefinition ());
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairFilter)
               {
                  var entityPairFilter:EntityInputEntityPairScriptFilter = entityDefine.mEntity as EntityInputEntityPairScriptFilter;
                  
                  TriggerFormatHelper.ShiftReferenceIndexesInCodeSnippetDefine (editorWorld, entityDefine.mFunctionDefine.mCodeSnippetDefine, false, beginningEntityIndex, beginningCollisionCategoryIndex, beginningGlobalVariableIndex, beginningEntityVariableIndex, beginningCustomFunctionIndex, beginningSessionVariableIndex);
                  TriggerFormatHelper.FunctionDefine2FunctionDefinition (editorWorld, entityDefine.mFunctionDefine, entityPairFilter.GetCodeSnippet (), entityPairFilter.GetCodeSnippet ().GetOwnerFunctionDefinition ());
               }
            }
            
            // ...
            if (entity != null)
            {
               entity.UpdateAppearance ();
               entity.UpdateSelectionProxy ();
            }
         }
         
         var groupId:int;
         var brotherId:int;
         var brotherIds:Array;
         var entities:Array;
         
         for (groupId = 0; groupId < worldDefine.mBrotherGroupDefines.length; ++ groupId)
         {
            brotherIds = worldDefine.mBrotherGroupDefines [groupId] as Array;
            
            ShiftEntityRefIndexes (brotherIds, beginningEntityIndex);
            
            for (brotherId = 0; brotherId < brotherIds.length; ++ brotherId)
            {
               entityDefine = worldDefine.mEntityDefines [brotherIds [brotherId]];
               
               brotherIds [brotherId] = brotherIds [brotherId];
            }
            
            editorWorld.GlueEntitiesByCreationIds (brotherIds);
         }
         
         // important
         if (mergeVariablesWithSameNames)
         {
            if (worldDefine.mSessionVariableDefines.length > 0)
            {
               editorWorld.GetTriggerEngine ().GetSessionVariableSpace ().EndMergeVariablesWithSameNamesInCreatingVariables ();
            }
            if (worldDefine.mGlobalVariableDefines.length > 0)
            {
               editorWorld.GetTriggerEngine ().GetGlobalVariableSpace ().EndMergeVariablesWithSameNamesInCreatingVariables ();
            }
            if (worldDefine.mEntityPropertyDefines.length > 0)
            {
               editorWorld.GetTriggerEngine ().GetEntityVariableSpace ().EndMergeVariablesWithSameNamesInCreatingVariables ();
            }
         }
        
         return editorWorld;
      }
      
      public static function ShiftEntityRefIndexes (entityIndexes:Array, idShiftedValue:int):void
      {
         if (entityIndexes != null)
         {
            var num:int = entityIndexes.length;
            var id:int;
            for (var i:int = 0; i < num; ++ i)
            {
               id = entityIndexes [i];
               
               if (id >= 0)
                  entityIndexes [i] = id + idShiftedValue;
            }
         }
      }
      
      public static function Xml2WorldDefine (worldXml:XML):WorldDefine
      {
         if (worldXml == null || worldXml.localName() != "World")
            return null;
         
         var worldDefine:WorldDefine = new WorldDefine ();
         
         // basic
         {
            worldDefine.mVersion = parseInt (worldXml.@version, 16);
            worldDefine.mAuthorName = worldXml.@author_name;
            worldDefine.mAuthorHomepage = worldXml.@author_homepage;
            
            if (worldDefine.mVersion >= 0x0102)
            {
               worldDefine.mShareSourceCode = parseInt (worldXml.@share_source_code) != 0;
               worldDefine.mPermitPublishing = parseInt (worldXml.@permit_publishing) != 0;
            }
            else
            {
               // ...
            }
         }
         
         var element:XML;
         
         // settings
         if (worldDefine.mVersion >= 0x0104)
         {
            for each (element in worldXml.Settings.Setting)
            {
               //>>from v1.51
               if (element.@name == "ui_flags")
                  worldDefine.mSettings.mViewerUiFlags = parseInt (element.@value);
               else if (element.@name == "play_bar_color")
                  worldDefine.mSettings.mPlayBarColor = parseInt ( (element.@value).substr (2), 16);
               else if (element.@name == "viewport_width")
                  worldDefine.mSettings.mViewportWidth = parseInt (element.@value)
               else if (element.@name == "viewport_height")
                  worldDefine.mSettings.mViewportHeight = parseInt (element.@value)
               else if (element.@name == "zoom_scale")
                  worldDefine.mSettings.mZoomScale = parseFloat (element.@value);
               //<<
               
               else if (element.@name == "camera_center_x")
                  worldDefine.mSettings.mCameraCenterX = parseInt (element.@value);
               else if (element.@name == "camera_center_y")
                  worldDefine.mSettings.mCameraCenterY = parseInt (element.@value);
               else if (element.@name == "world_left")
                  worldDefine.mSettings.mWorldLeft = parseInt (element.@value);
               else if (element.@name == "world_top")
                  worldDefine.mSettings.mWorldTop  = parseInt (element.@value);
               else if (element.@name == "world_width")
                  worldDefine.mSettings.mWorldWidth  = parseInt (element.@value);
               else if (element.@name == "world_height")
                  worldDefine.mSettings.mWorldHeight = parseInt (element.@value);
               else if (element.@name == "background_color")
                  worldDefine.mSettings.mBackgroundColor  = parseInt ( (element.@value).substr (2), 16);
               else if (element.@name == "build_border")
                  worldDefine.mSettings.mBuildBorder  = parseInt (element.@value) != 0;
               else if (element.@name == "border_color")
                  worldDefine.mSettings.mBorderColor = parseInt ( (element.@value).substr (2), 16);
               
               //>>from v1.06 to v1.08 (not include 1.08)
               else if (element.@name == "physics_shapes_potential_max_count")
                  worldDefine.mSettings.mPhysicsShapesPotentialMaxCount = parseInt (element.@value);
               else if (element.@name == "physics_shapes_population_density_level")
                  worldDefine.mSettings.mPhysicsShapesPopulationDensityLevel = parseInt (element.@value);
               //<<
               
               //>>from v1.08
               else if (element.@name == "infinite_scene_size")
                  worldDefine.mSettings.mIsInfiniteWorldSize = parseInt (element.@value) != 0;
               
               else if (element.@name == "border_at_top_layer")
                  worldDefine.mSettings.mBorderAtTopLayer = parseInt (element.@value) != 0;
               else if (element.@name == "border_left_thinckness")
                  worldDefine.mSettings.mWorldBorderLeftThickness = parseFloat (element.@value);
               else if (element.@name == "border_top_thinckness")
                  worldDefine.mSettings.mWorldBorderTopThickness = parseFloat (element.@value);
               else if (element.@name == "border_right_thinckness")
                  worldDefine.mSettings.mWorldBorderRightThickness = parseFloat (element.@value);
               else if (element.@name == "border_bottom_thinckness")
                  worldDefine.mSettings.mWorldBorderBottomThickness = parseFloat (element.@value);
               
               else if (element.@name == "gravity_acceleration_magnitude")
                  worldDefine.mSettings.mDefaultGravityAccelerationMagnitude = parseFloat (element.@value);
               else if (element.@name == "gravity_acceleration_angle")
                  worldDefine.mSettings.mDefaultGravityAccelerationAngle = parseFloat (element.@value);
               
               else if (element.@name == "right_hand_coordinates")
                  worldDefine.mSettings.mRightHandCoordinates = parseInt (element.@value) != 0;
               else if (element.@name == "coordinates_origin_x")
                  worldDefine.mSettings.mCoordinatesOriginX = parseFloat (element.@value);
               else if (element.@name == "coordinates_origin_y")
                  worldDefine.mSettings.mCoordinatesOriginY = parseFloat (element.@value);
               else if (element.@name == "coordinates_scale")
                  worldDefine.mSettings.mCoordinatesScale = parseFloat (element.@value);
               
               else if (element.@name == "ci_rules_enabled")
                  worldDefine.mSettings.mIsCiRulesEnabled = parseInt (element.@value) != 0;
               //<<
               
               //>>from v1.55
               else if (element.@name == "auto_sleeping_enabled")
                  worldDefine.mSettings.mAutoSleepingEnabled = parseInt (element.@value) != 0;
               else if (element.@name == "camera_rotating_enabled")
                  worldDefine.mSettings.mCameraRotatingEnabled = parseInt (element.@value) != 0;
               //<<
               
               else
                  trace ("Unkown setting: " + element.@name);
            }
         }
         
         // must be loaded before loading codesnippets in entities.
         if (worldDefine.mVersion >= 0x0153)
         {
            var functionDefine:FunctionDefine;
            
            for each (element in worldXml.CustomFunctions.Function)
            {
               functionDefine = new FunctionDefine ();
               
               TriggerFormatHelper.Xml2FunctionDefine (element, functionDefine, true, true, null);
               
               worldDefine.mFunctionDefines.push (functionDefine);
            }
            
            var functionId:int = 0;
            for each (element in worldXml.CustomFunctions.Function)
            {
               functionDefine = worldDefine.mFunctionDefines [functionId ++];
               
               TriggerFormatHelper.Xml2FunctionDefine (element, functionDefine, true, false, worldDefine.mFunctionDefines);
               
               functionDefine.mName = element.@name;
               functionDefine.mPosX = parseFloat (element.@x);
               functionDefine.mPosY = parseFloat (element.@y);
               if (worldDefine.mVersion >= 0x0156)
               {
                  functionDefine.mDesignDependent = parseInt (element.@design_dependent) != 0;
               }
            }
         }
         
         var appearId:int;
         var createId:int;
         
         for each (element in worldXml.Entities.Entity)
         {
            var entityDefine:Object = XmlElement2EntityDefine (element, worldDefine);
            
            worldDefine.mEntityDefines.push (entityDefine);
         }
         
         // ...
         // worldDefine.mVersion >= 0x0107
         if (worldXml.EntityAppearingOrder != undefined)
         {
            IndicesString2IntegerArray (worldXml.EntityAppearingOrder.@entity_indices, worldDefine.mEntityAppearanceOrder);
         }
         
         // ...
         
         var groupId:int;
         var brotherGroup:Array;
         var brotherIDs:Array;
         
         for each (element in worldXml.BrotherGroups.BrotherGroup)
         {
            brotherIDs = IndicesString2IntegerArray (element.@brother_indices);
            
            worldDefine.mBrotherGroupDefines.push (brotherIDs);
         }
         
         // collision category
         
         if (worldDefine.mVersion >= 0x0102)
         {
            for each (element in worldXml.CollisionCategories.CollisionCategory)
            {
               var ccDefine:Object = new Object ();
               
               ccDefine.mName = element.@name;
               ccDefine.mCollideInternally = parseInt (element.@collide_internally) != 0;
               ccDefine.mPosX = parseFloat (element.@x);
               ccDefine.mPosY = parseFloat (element.@y);
               
               worldDefine.mCollisionCategoryDefines.push (ccDefine);
            }
            
            worldDefine.mDefaultCollisionCategoryIndex = parseInt (worldXml.CollisionCategories.@default_category_index);
            
            for each (element in worldXml.CollisionCategoryFriendPairs.CollisionCategoryFriendPair)
            {
               var pairDefine:Object = new Object ();
               
               pairDefine.mCollisionCategory1Index = parseInt (element.@category1_index);
               pairDefine.mCollisionCategory2Index = parseInt (element.@category2_index);
               
               worldDefine.mCollisionCategoryFriendLinkDefines.push (pairDefine);
            }
         }
         
         // custom variables
         
         if (worldDefine.mVersion >= 0x0152)
         {
            //>> v1.52 only
            //var variableSpaceDefine:VariableSpaceDefine;
            //
            //for each (element in worldXml.GlobalVariables.VariablePackage)
            //{
            //   variableSpaceDefine = TriggerFormatHelper.VariableSpaceXml2Define (element);
            //   variableSpaceDefine.mSpaceType = ValueSpaceTypeDefine.ValueSpace_Global;
            //   worldDefine.mGlobalVariableSpaceDefines.push (variableSpaceDefine);
            //}
            
            //for each (element in worldXml.EntityProperties.VariablePackage)
            //{
            //   variableSpaceDefine = TriggerFormatHelper.VariableSpaceXml2Define (element);
            //   variableSpaceDefine.mSpaceType = ValueSpaceTypeDefine.ValueSpace_Entity;
            //   worldDefine.mEntityPropertySpaceDefines.push (variableSpaceDefine);
            //}
            
            if (worldDefine.mVersion == 0x0152)
            {
               TriggerFormatHelper.VariablesXml2Define (worldXml.GlobalVariables.VariablePackage [0], worldDefine.mGlobalVariableDefines, true);
               TriggerFormatHelper.VariablesXml2Define (worldXml.EntityProperties.VariablePackage [0], worldDefine.mEntityPropertyDefines, true);
            }
            else
            {
               if (worldDefine.mVersion >= 0x0157)
               {
                  TriggerFormatHelper.VariablesXml2Define (worldXml.SessionVariables [0], worldDefine.mSessionVariableDefines, true);
               }
               
               TriggerFormatHelper.VariablesXml2Define (worldXml.GlobalVariables [0], worldDefine.mGlobalVariableDefines, true);
               TriggerFormatHelper.VariablesXml2Define (worldXml.EntityProperties [0], worldDefine.mEntityPropertyDefines, true);
            }
         }
         
         // image modules
         
         if (worldDefine.mVersion >= 0x0158)
         {
            for each (element in worldXml.Images.Image)
            {
               var imageDefine:Object = new Object ();
               
               imageDefine.mName = element.@name;
               var fileDataBase64:String = element.text () [0];
               if (fileDataBase64 == null)
               {
                  imageDefine.mFileData = null;
               }
               else
               {
                  fileDataBase64 = fileDataBase64.replace (DataFormat3.Base64CharsRegExp, "");
                  imageDefine.mFileData = DataFormat3.DecodeString2ByteArray (fileDataBase64);
               }
               
               worldDefine.mImageDefines.push (imageDefine);
            }
            
            for each (element in worldXml.ImageDivisions.ImageDivision)
            {
               var divisionDefine:Object = new Object ();
               
               divisionDefine.mImageIndex = parseInt (element.@image_index);
               divisionDefine.mLeft = parseInt (element.@left);
               divisionDefine.mTop = parseInt (element.@top);
               divisionDefine.mRight = parseInt (element.@right);
               divisionDefine.mBottom = parseInt (element.@bottom);
               
               worldDefine.mPureImageModuleDefines.push (divisionDefine);
            }
            
            for each (element in worldXml.AssembledModules.AssembledModule)
            {
               var assembledModuleDefine:Object = new Object ();
               
               assembledModuleDefine.mModulePartDefines = XmlElements2ModuleInstanceDefines (element.ModulePart, false);
               
               worldDefine.mAssembledModuleDefines.push (assembledModuleDefine);
            }
            
            for each (element in worldXml.SequencedModules.SequencedModule)
            {
               var sequencedModuleDefine:Object = new Object ();
               
               //sequencedModuleDefine.mIsLooped = parseInt(element.@looped) != 0;
               sequencedModuleDefine.mModuleSequenceDefines = XmlElements2ModuleInstanceDefines (element.ModuleSequence, true);
               
               worldDefine.mSequencedModuleDefines.push (sequencedModuleDefine);
            }
         }
         
         return worldDefine;
      }
      
      public static function XmlElements2ModuleInstanceDefines (xmlElements:XMLList, forSequencedModule:Boolean):Array
      {
         var moduleInstanceDefines:Array = new Array ();
         
         for each (var element:XML in xmlElements)
         {
            var moduleInstanceDefine:Object = new Object ();
            
            moduleInstanceDefine.mPosX = parseFloat (element.@x);
            moduleInstanceDefine.mPosY = parseFloat (element.@y);
            moduleInstanceDefine.mScale = parseFloat(element.@scale);
            moduleInstanceDefine.mIsFlipped = parseInt (element.@flipped) != 0;
            moduleInstanceDefine.mRotation = parseFloat (element.@r);
            moduleInstanceDefine.mVisible = parseInt (element.@visible) != 0;
            moduleInstanceDefine.mAlpha = parseFloat (element.@alpha);
            
            if (forSequencedModule)
            {
               moduleInstanceDefine.mModuleDuration = parseFloat (element.@duration);
            }
            
            XmlElement2ModuleInstanceDefine (moduleInstanceDefine, element);
            
            moduleInstanceDefines.push (moduleInstanceDefine);
         }
         
         return moduleInstanceDefines;
      }
      
      public static function XmlElement2ModuleInstanceDefine (moduleInstanceDefine:Object, element:XML):void
      {
         moduleInstanceDefine.mModuleType = element.@module_type;
         
         if (Define.IsVectorShapeEntity (moduleInstanceDefine.mModuleType))
         {
            moduleInstanceDefine.mShapeAttributeBits = parseInt (element.@shape_attribute_bits);
            moduleInstanceDefine.mShapeBodyOpacityAndColor = element.@shape_body_argb == undefined ? 0x0 : uint (parseInt ( (element.@shape_body_argb).substr (2), 16));
            
            if (Define.IsBasicPathVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               moduleInstanceDefine.mShapePathThickness = parseFloat (element.@shape_path_thickness);
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolyline)
               {
                  moduleInstanceDefine.mPolyLocalPoints = XmlElement2LocalVertices (element);
               }
            }
            else if (Define.IsBasicAreaVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               moduleInstanceDefine.mShapeBorderOpacityAndColor = element.@shape_border_argb == undefined ? 0x0 : uint (parseInt ( (element.@shape_border_argb).substr (2), 16));
               moduleInstanceDefine.mShapeBorderThickness = parseFloat (element.@shape_border_thickness);
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeCircle)
               {
                  moduleInstanceDefine.mCircleRadius = parseFloat (element.@circle_radius);
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeRectangle)
               {
                  moduleInstanceDefine.mRectHalfWidth = parseFloat (element.@rect_half_width);
                  moduleInstanceDefine.mRectHalfHeight = parseFloat (element.@rect_half_height);
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolygon)
               {
                  moduleInstanceDefine.mPolyLocalPoints = XmlElement2LocalVertices (element);
               }
            }
         }
         else if (Define.IsShapeEntity (moduleInstanceDefine.mModuleType))
         {
            if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeImageModule)
            {
               moduleInstanceDefine.mModuleIndex = parseInt (element.@module_index);
            }
         }
         else // ...
         {
         }
      }
      
      public static function Xml2ShapePhysicsProperties (entityDefine:Object, element:XML, worldDefine:WorldDefine):void
      {
         if (worldDefine.mVersion >= 0x0104)
         {
            entityDefine.mIsPhysicsEnabled = parseInt (element.@enable_physics) != 0;
            
            // move down from v1.05
            /////entityDefine.mIsSensor = parseInt (element.@is_sensor) != 0; 
         }
         else
         {
            entityDefine.mIsPhysicsEnabled = true; // always true before v1.04
            // entityDefine.mIsSensor will be filled in FillMissedFieldsInWorldDefine
         }
         
         if (entityDefine.mIsPhysicsEnabled)
         {
            if (worldDefine.mVersion >= 0x0102)
            {
               entityDefine.mCollisionCategoryIndex = element.@collision_category_index;
            }
            
            entityDefine.mIsStatic = parseInt (element.@is_static) != 0;
            entityDefine.mIsBullet = parseInt (element.@is_bullet) != 0;
            entityDefine.mDensity = parseFloat (element.@density);
            entityDefine.mFriction = parseFloat (element.@friction);
            entityDefine.mRestitution = parseFloat (element.@restitution);
            
            if (worldDefine.mVersion >= 0x0104)
            {
               // add in v1,04, move here from above from v1.05
               entityDefine.mIsSensor = parseInt (element.@is_sensor) != 0
            }
            
            if (worldDefine.mVersion >= 0x0105)
            {
               entityDefine.mIsHollow = parseInt (element.@is_hollow) != 0;
            }
            
            if (worldDefine.mVersion >= 0x0108)
            {
               entityDefine.mBuildBorder = parseInt (element.@build_border) != 0;
               entityDefine.mIsSleepingAllowed = parseInt (element.@sleeping_allowed) != 0;
               entityDefine.mIsRotationFixed = parseInt (element.@rotation_fixed) != 0;
               entityDefine.mLinearVelocityMagnitude = parseFloat (element.@linear_velocity_magnitude);
               entityDefine.mLinearVelocityAngle = parseFloat (element.@linear_velocity_angle);
               entityDefine.mAngularVelocity = parseFloat (element.@angular_velocity);
            }
         }
      }
      
      public static function XmlElement2LocalVertices (element:XML):Array
      {
         var points:Array = new Array ();
         for each (var elementLocalVertex:XML in element.LocalVertices.Vertex)
         {
            points.push (new Point (parseFloat (elementLocalVertex.@x), parseFloat (elementLocalVertex.@y)));
         }
         
         return points;
      }
      
      public static function IndicesString2IntegerArray (indicesStr:String, idArray:Array = null):Array
      {
         if (idArray == null)
            idArray = new Array ();
         
         if (indicesStr == null || indicesStr.length == 0)
            return idArray;
         
         var indexStrArray:Array = indicesStr.split (/,/);
         
         var index:int;
         for (var i:int = 0; i < indexStrArray.length; ++ i)
         {
            index = parseInt (indexStrArray [i]);;
            if (isNaN (index))
               index = -1;
            
            idArray.push (index);
         }
         
         return idArray;
      }
      
      public static function XmlElement2EntityDefine (element:XML, worldDefine:WorldDefine):Object
      {
         var elementLocalVertex:XML;
         
         var entityDefine:Object = new Object ();
         
         entityDefine.mEntityType = parseInt (element.@entity_type);
         entityDefine.mPosX = parseFloat (element.@x);
         entityDefine.mPosY = parseFloat (element.@y);
         if (worldDefine.mVersion >= 0x0158)
         {
            entityDefine.mScale = parseFloat (element.@scale);
            entityDefine.mIsFlipped = parseInt (element.@flipped) != 0;
         }
         entityDefine.mRotation = parseFloat (element.@r);
         entityDefine.mIsVisible = parseInt (element.@visible) != 0;
         
         if (worldDefine.mVersion >= 0x0108)
         {
            entityDefine.mAlpha = parseFloat (element.@alpha);;
            entityDefine.mIsEnabled = parseInt (element.@active) != 0;
         }
         
         if ( Define.IsUtilityEntity (entityDefine.mEntityType) )
         {
            //>>from v1.05
            if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
            {
               if (worldDefine.mVersion >= 0x0108)
               {
                  entityDefine.mFollowedTarget = parseFloat (element.@followed_target);
                  entityDefine.mFollowingStyle = parseFloat (element.@following_style);
               }
            }
            //<<
            //>>from v1.10
            else if (entityDefine.mEntityType == Define.EntityType_UtilityPowerSource)
            {
               entityDefine.mPowerSourceType = parseInt (element.@power_source_type);
               entityDefine.mPowerMagnitude = parseFloat (element.@power_magnitude);
               entityDefine.mKeyboardEventId = parseInt (element.@keyboard_event_id);
               entityDefine.mKeyCodes = IndicesString2IntegerArray (element.@key_codes);
            }
            //<<
         }
         else if ( Define.IsLogicEntity (entityDefine.mEntityType) )
         {
            if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
            {
               entityDefine.mFunctionDefine = new FunctionDefine ();
               
               if (worldDefine.mVersion >= 0x0153)
                  TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mFunctionDefine, false, true, worldDefine.mFunctionDefines);
               else
                  TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mFunctionDefine, false, false, worldDefine.mFunctionDefines);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
            {
               entityDefine.mInputAssignerCreationIds = IndicesString2IntegerArray (element.@assigner_indices);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
            {
               entityDefine.mIsAnd = parseInt (element.@is_and) != 0;
               entityDefine.mIsNot = parseInt (element.@is_not) != 0;
               
               TriggerFormatHelper.CondtionListXml2EntityDefineProperties (element.Conditions, entityDefine);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
            {
               entityDefine.mSelectorType = parseInt (element.@selector_type);
               entityDefine.mEntityCreationIds = IndicesString2IntegerArray (element.@entity_indices);
               entityDefine.mNumEntities = entityDefine.mEntityCreationIds.length;
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
            {
               entityDefine.mPairingType = parseInt (element.@pairing_type);
               entityDefine.mEntityCreationIds1 = IndicesString2IntegerArray (element.@entity_indices1);
               entityDefine.mNumEntities1 = entityDefine.mEntityCreationIds1.length;
               entityDefine.mEntityCreationIds2 = IndicesString2IntegerArray (element.@entity_indices2);
               entityDefine.mNumEntities2 = entityDefine.mEntityCreationIds2.length;
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
            {
               entityDefine.mEventId = parseInt (element.@event_id);
               entityDefine.mInputConditionEntityCreationId = parseInt (element.@input_condition_entity_index);
               entityDefine.mInputConditionTargetValue = parseInt (element.@input_condition_target_value);
               entityDefine.mInputAssignerCreationIds = IndicesString2IntegerArray (element.@assigner_indices);
               
               if (worldDefine.mVersion >= 0x0108)
               {
                  entityDefine.mExternalActionEntityCreationId = parseInt (element.@external_action_entity_index);
               }
               
               if (worldDefine.mVersion >= 0x0108)
               {
                  switch (entityDefine.mEventId)
                  {
                     case CoreEventIds.ID_OnWorldTimer:
                     case CoreEventIds.ID_OnEntityTimer:
                     case CoreEventIds.ID_OnEntityPairTimer:
                        entityDefine.mRunningInterval = parseFloat (element.@running_interval);
                        entityDefine.mOnlyRunOnce = parseInt (element.@only_run_once) != 0;
                        
                        if (worldDefine.mVersion >= 0x0156)
                        {
                           if (entityDefine.mEventId == CoreEventIds.ID_OnEntityTimer || entityDefine.mEventId == CoreEventIds.ID_OnEntityPairTimer)
                           {
                              entityDefine.mPreFunctionDefine = new FunctionDefine ();
                              TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mPreFunctionDefine, false, true, worldDefine.mFunctionDefines, false, element.PreHandlingCodeSnippet [0]);
                              
                              entityDefine.mPostFunctionDefine = new FunctionDefine ();
                              TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mPostFunctionDefine, false, true, worldDefine.mFunctionDefines, false, element.PostHandlingCodeSnippet [0]);
                           }
                        }
                        
                        break;
                     case CoreEventIds.ID_OnWorldKeyDown:
                     case CoreEventIds.ID_OnWorldKeyUp:
                     case CoreEventIds.ID_OnWorldKeyHold:
                        entityDefine.mKeyCodes = IndicesString2IntegerArray (element.@key_codes);
                        break;
                     default:
                        break;
                  }
               }
               
               entityDefine.mFunctionDefine = new FunctionDefine ();
               if (worldDefine.mVersion >= 0x0153)
               {
                  TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mFunctionDefine, false, true, worldDefine.mFunctionDefines);
               }
               else
               {
                  TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mFunctionDefine, false, false, worldDefine.mFunctionDefines);
               }
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
            {
               entityDefine.mFunctionDefine = new FunctionDefine ();
               
               if (worldDefine.mVersion >= 0x0153)
                  TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mFunctionDefine, false, true, worldDefine.mFunctionDefines);
               else
                  TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mFunctionDefine, false, false, worldDefine.mFunctionDefines);
            }
            //>>from v1.56
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityFilter)
            {
               entityDefine.mFunctionDefine = new FunctionDefine ();
               
               TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mFunctionDefine, false, true, worldDefine.mFunctionDefines);
            }
            else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairFilter)
            {
               entityDefine.mFunctionDefine = new FunctionDefine ();
               
               TriggerFormatHelper.Xml2FunctionDefine (element, entityDefine.mFunctionDefine, false, true, worldDefine.mFunctionDefines);
            }
            //<<     
         }
         else if ( Define.IsVectorShapeEntity (entityDefine.mEntityType) )
         {
            if (worldDefine.mVersion >= 0x0102)
            {
               entityDefine.mDrawBorder = parseInt (element.@draw_border) != 0;
               entityDefine.mDrawBackground = parseInt (element.@draw_background) != 0;
            }
            
            if (worldDefine.mVersion >= 0x0104)
            {
               entityDefine.mBorderColor = parseInt ( (element.@border_color).substr (2), 16);
               entityDefine.mBorderThickness = parseInt (element.@border_thickness);
               entityDefine.mBackgroundColor = parseInt ( (element.@background_color).substr (2), 16);
               
               if (worldDefine.mVersion >= 0x0107)
                  entityDefine.mTransparency = parseInt (element.@background_opacity);
               else
                  entityDefine.mTransparency = parseInt (element.@transparency);
            }
            
            if (worldDefine.mVersion >= 0x0105)
            {
               if (worldDefine.mVersion >= 0x0107)
                  entityDefine.mBorderTransparency = parseInt (element.@border_opacity);
               else
                  entityDefine.mBorderTransparency = parseInt (element.@border_transparency);
            }
            
            if ( Define.IsBasicVectorShapeEntity (entityDefine.mEntityType) )
            {
               entityDefine.mAiType = parseInt (element.@ai_type);
               
               //...
               Xml2ShapePhysicsProperties (entityDefine, element, worldDefine);
               
               // ...
               if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
               {
                  entityDefine.mRadius = parseFloat (element.@radius);
                  entityDefine.mAppearanceType = parseInt (element.@appearance_type);
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
               {
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mIsRoundCorners = parseInt (element.@round_corners) != 0;
                  }
                  
                  entityDefine.mHalfWidth = parseFloat (element.@half_width);
                  entityDefine.mHalfHeight = parseFloat (element.@half_height);
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
               {
                  entityDefine.mLocalPoints = XmlElement2LocalVertices (element);
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
               {
                  entityDefine.mCurveThickness = parseInt (element.@curve_thickness);
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mIsRoundEnds = parseInt (element.@round_ends) != 0;
                  }
                  
                  if (worldDefine.mVersion >= 0x0157)
                  {
                     entityDefine.mIsClosed = parseInt (element.@closed) != 0;
                  }
                  
                  entityDefine.mLocalPoints = XmlElement2LocalVertices (element);
               }
            }
            else
            {
               if (entityDefine.mEntityType == Define.EntityType_ShapeText 
                  || entityDefine.mEntityType == Define.EntityType_ShapeTextButton // v1.08
                  )
               {
                  entityDefine.mText = element.@text;
                  if (worldDefine.mVersion < 0x0108)
                     entityDefine.mWordWrap = parseInt (element.@autofit_width) != 0;
                  else
                     entityDefine.mWordWrap = parseInt (element.@word_wrap) != 0;
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mAdaptiveBackgroundSize = parseInt (element.@adaptive_background_size) != 0;
                     entityDefine.mTextColor = element.@text_color == undefined ? 0x0 : parseInt ( (element.@text_color).substr (2), 16);
                     entityDefine.mFontSize = parseInt (element.@font_size);
                     entityDefine.mIsBold = parseInt (element.@bold) != 0;
                     entityDefine.mIsItalic = parseInt (element.@italic) != 0;
                  }
                  
                  if (worldDefine.mVersion >= 0x0109)
                  {
                     entityDefine.mTextAlign = parseInt (element.@align) != 0;;
                     entityDefine.mIsUnderlined = parseInt (element.@underlined) != 0;;
                  }
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     if (entityDefine.mEntityType == Define.EntityType_ShapeTextButton) 
                     {
                        entityDefine.mUsingHandCursor = parseInt (element.@using_hand_cursor) != 0;
                        
                        entityDefine.mDrawBackground_MouseOver = parseInt (element.@draw_background_on_mouse_over) != 0;
                        entityDefine.mBackgroundColor_MouseOver = parseInt ( (element.@background_color_on_mouse_over).substr (2), 16);
                        entityDefine.mBackgroundTransparency_MouseOver = parseInt (element.@background_opacity_on_mouse_over);
                        
                        entityDefine.mDrawBorder_MouseOver = parseInt (element.@draw_border_on_mouse_over) != 0;
                        entityDefine.mBorderColor_MouseOver = parseInt ( (element.@border_color_on_mouse_over).substr (2), 16);
                        entityDefine.mBorderThickness_MouseOver = parseInt (element.@border_thickness_on_mouse_over);
                        entityDefine.mBorderTransparency_MouseOver = parseInt (element.@border_opacity_on_mouse_over);
                     }
                  }
                  
                  entityDefine.mHalfWidth = parseFloat (element.@half_width);
                  entityDefine.mHalfHeight = parseFloat (element.@half_height);
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
               {
                  entityDefine.mRadius = parseFloat (element.@radius);
                  
                  if (worldDefine.mVersion >= 0x0105)
                  {
                     entityDefine.mInteractiveZones = parseInt (element.@interactive_zones, 2);
                     
                     entityDefine.mInteractiveConditions = parseInt (element.@interactive_conditions, 2);
                  }
                  else
                  {
                     // mIsInteractive is removed from v1.05.
                     // in FillMissedFieldsInWorldDefine (), mIsInteractive will be converted to mInteractiveZones
                     entityDefine.mIsInteractive = parseInt (element.@is_interactive) != 0;
                  }
                  
                  entityDefine.mInitialGravityAcceleration = parseFloat (element.@initial_gravity_acceleration);
                  entityDefine.mInitialGravityAngle = parseFloat (element.@initial_gravity_angle);
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     entityDefine.mMaximalGravityAcceleration = parseFloat (element.@maximal_gravity_acceleration);
                  }
               }
            }
         }
         //>> from v1.58
         else if (Define.IsShapeEntity (entityDefine.mEntityType))
         {
            if (entityDefine.mEntityType == Define.EntityType_ShapeImageModule)
            {
               Xml2ShapePhysicsProperties (entityDefine, element, worldDefine);
               
               entityDefine.mModuleIndex = parseInt (element.@module_index);
            }
            else if (entityDefine.mEntityType == Define.EntityType_ShapeImageModuleButton)
            {
               Xml2ShapePhysicsProperties (entityDefine, element, worldDefine);
               
               entityDefine.mModuleIndexUp = parseInt (element.@module_index_up);
               entityDefine.mModuleIndexOver = parseInt (element.@module_index_over);
               entityDefine.mModuleIndexDown = parseInt (element.@module_index_down);
            }
         }
         //<<
         else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
         {
            // 
            if (worldDefine.mVersion < 0x0104)
            {
               entityDefine.mCollideConnected = ("true" == String (element.@collide_connected));
            }
            else
            {
               entityDefine.mCollideConnected = parseInt (element.@collide_connected) != 0;
            }
            
            if (worldDefine.mVersion >= 0x0102)
            {
               entityDefine.mConnectedShape1Index = parseInt (element.@connected_shape1_index);
               entityDefine.mConnectedShape2Index = parseInt (element.@connected_shape2_index);
            }
            else
            {
               // ...
            }
            
            if (worldDefine.mVersion >= 0x0108)
            {
               entityDefine.mBreakable = parseInt (element.@breakable) != 0;
            }
            
            if (entityDefine.mEntityType == Define.EntityType_JointHinge)
            {
               entityDefine.mAnchorEntityIndex = parseInt (element.@anchor_index);
               
               entityDefine.mEnableLimits = parseInt (element.@enable_limits) != 0;
               entityDefine.mLowerAngle = parseFloat (element.@lower_angle);
               entityDefine.mUpperAngle = parseFloat (element.@upper_angle);
               entityDefine.mEnableMotor = parseInt (element.@enable_motor) != 0;
               entityDefine.mMotorSpeed = parseFloat (element.@motor_speed);
               entityDefine.mBackAndForth = parseInt (element.@back_and_forth) != 0;
               
               if (worldDefine.mVersion >= 0x0104)
                  entityDefine.mMaxMotorTorque = parseFloat (element.@max_motor_torque);
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
            {
               entityDefine.mAnchor1EntityIndex = parseInt (element.@anchor1_index);
               entityDefine.mAnchor2EntityIndex = parseInt (element.@anchor2_index);
               
               entityDefine.mEnableLimits = parseInt (element.@enable_limits) != 0;
               entityDefine.mLowerTranslation = parseFloat (element.@lower_translation);
               entityDefine.mUpperTranslation = parseFloat (element.@upper_translation);
               entityDefine.mEnableMotor = parseInt (element.@enable_motor) != 0;
               entityDefine.mMotorSpeed = parseFloat (element.@motor_speed);
               entityDefine.mBackAndForth = parseInt (element.@back_and_forth) != 0;
               
               if (worldDefine.mVersion >= 0x0104)
                  entityDefine.mMaxMotorForce = parseFloat (element.@max_motor_force);
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
            {
               entityDefine.mAnchor1EntityIndex = parseInt (element.@anchor1_index);
               entityDefine.mAnchor2EntityIndex = parseInt (element.@anchor2_index);
               
               if (worldDefine.mVersion >= 0x0108)
               {
                  entityDefine.mBreakDeltaLength = parseFloat (element.@break_delta_length);
               }
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
            {
               entityDefine.mAnchor1EntityIndex = parseInt (element.@anchor1_index);
               entityDefine.mAnchor2EntityIndex = parseInt (element.@anchor2_index);
               
               entityDefine.mStaticLengthRatio = parseFloat (element.@static_length_ratio);
               //entityDefine.mFrequencyHz = parseFloat (element.@frequency_hz);
               entityDefine.mSpringType = parseFloat (element.@spring_type);
               
               entityDefine.mDampingRatio = parseFloat (element.@damping_ratio);
               
               if (worldDefine.mVersion >= 0x0108)
               {
                  entityDefine.mFrequencyDeterminedManner = parseInt (element.@frequency_determined_manner);
                  entityDefine.mFrequency = parseFloat (element.@frequency);
                  entityDefine.mSpringConstant = parseFloat (element.@spring_constant);
                  entityDefine.mBreakExtendedLength = parseFloat (element.@break_extended_length);
               }
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointWeld)
            {
               entityDefine.mAnchorEntityIndex = parseInt (element.@anchor_index);
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointDummy)
            {
               entityDefine.mAnchor1EntityIndex = parseInt (element.@anchor1_index);
               entityDefine.mAnchor2EntityIndex = parseInt (element.@anchor2_index);
            }
         }
         
         return entityDefine;
      }
      
//======================================================================================
// 
//======================================================================================
      
      public static function WorldDefine2ByteArray (worldDefine:WorldDefine):ByteArray
      {
         // from v1,03
         DataFormat2.FillMissedFieldsInWorldDefine (worldDefine);
         if (worldDefine.mVersion >= 0x0103)
         {
            DataFormat2.AdjustNumberValuesInWorldDefine (worldDefine);
         }
         
         //
         var byteArray:ByteArray = new ByteArray ();
         
         // COlor INfection
         byteArray.writeByte ("C".charCodeAt (0));
         byteArray.writeByte ("O".charCodeAt (0));
         byteArray.writeByte ("I".charCodeAt (0));
         byteArray.writeByte ("N".charCodeAt (0));
         
         // basic
         {
            // version, author
            byteArray.writeShort (worldDefine.mVersion);
            byteArray.writeUTF (worldDefine.mAuthorName);
            byteArray.writeUTF (worldDefine.mAuthorHomepage);
            
            // removed since v1.02
            if (worldDefine.mVersion < 0x0102)
            {
               // hex
               byteArray.writeByte ("H".charCodeAt (0));
               byteArray.writeByte ("E".charCodeAt (0));
               byteArray.writeByte ("X".charCodeAt (0));
            }
            
            if (worldDefine.mVersion >= 0x0102)
            {
               byteArray.writeByte (worldDefine.mShareSourceCode ? 1 : 0);
               byteArray.writeByte (worldDefine.mPermitPublishing ? 1 : 0);
            }
         }
         
         // settings
         {
            if (worldDefine.mVersion >= 0x0151)
            {
               byteArray.writeInt (worldDefine.mSettings.mViewerUiFlags);
               byteArray.writeUnsignedInt (worldDefine.mSettings.mPlayBarColor);
               byteArray.writeShort (worldDefine.mSettings.mViewportWidth);
               byteArray.writeShort (worldDefine.mSettings.mViewportHeight);
               byteArray.writeFloat (worldDefine.mSettings.mZoomScale);
            }
            
            if (worldDefine.mVersion >= 0x0104)
            {
               byteArray.writeInt (worldDefine.mSettings.mCameraCenterX);
               byteArray.writeInt (worldDefine.mSettings.mCameraCenterY);
               byteArray.writeInt (worldDefine.mSettings.mWorldLeft);
               byteArray.writeInt (worldDefine.mSettings.mWorldTop);
               byteArray.writeInt (worldDefine.mSettings.mWorldWidth);
               byteArray.writeInt (worldDefine.mSettings.mWorldHeight);
               byteArray.writeUnsignedInt (worldDefine.mSettings.mBackgroundColor);
               byteArray.writeByte (worldDefine.mSettings.mBuildBorder ? 1 : 0);
               byteArray.writeUnsignedInt (worldDefine.mSettings.mBorderColor);
            }
            
            if (worldDefine.mVersion >= 0x0106 && worldDefine.mVersion < 0x0108)
            {
               byteArray.writeInt (worldDefine.mSettings.mPhysicsShapesPotentialMaxCount);
               byteArray.writeShort (worldDefine.mSettings.mPhysicsShapesPopulationDensityLevel);
            }
            
            if (worldDefine.mVersion >= 0x0108)
            {
               byteArray.writeByte (worldDefine.mSettings.mIsInfiniteWorldSize ? 1 : 0);
               
               byteArray.writeByte (worldDefine.mSettings.mBorderAtTopLayer ? 1 : 0);
               byteArray.writeFloat (worldDefine.mSettings.mWorldBorderLeftThickness);
               byteArray.writeFloat (worldDefine.mSettings.mWorldBorderTopThickness);
               byteArray.writeFloat (worldDefine.mSettings.mWorldBorderRightThickness);
               byteArray.writeFloat (worldDefine.mSettings.mWorldBorderBottomThickness);
               
               byteArray.writeFloat (worldDefine.mSettings.mDefaultGravityAccelerationMagnitude);
               byteArray.writeFloat (worldDefine.mSettings.mDefaultGravityAccelerationAngle);
               
               byteArray.writeByte (worldDefine.mSettings.mRightHandCoordinates ? 1 : 0);
               byteArray.writeDouble (worldDefine.mSettings.mCoordinatesOriginX);
               byteArray.writeDouble (worldDefine.mSettings.mCoordinatesOriginY);
               byteArray.writeDouble (worldDefine.mSettings.mCoordinatesScale);
               
               byteArray.writeByte (worldDefine.mSettings.mIsCiRulesEnabled ? 1 : 0);
            }
            
            if (worldDefine.mVersion >= 0x0155)
            {
               byteArray.writeByte (worldDefine.mSettings.mAutoSleepingEnabled ? 1 : 0);
               byteArray.writeByte (worldDefine.mSettings.mCameraRotatingEnabled ? 1 : 0);
            }
         }
         
         // collision category
         
         if (worldDefine.mVersion >= 0x0102)
         {
            byteArray.writeShort (worldDefine.mCollisionCategoryDefines.length);
            for (var ccId:int = 0; ccId < worldDefine.mCollisionCategoryDefines.length; ++ ccId)
            {
               var ccDefine:Object = worldDefine.mCollisionCategoryDefines [ccId];
               
               byteArray.writeUTF (ccDefine.mName);
               byteArray.writeByte (ccDefine.mCollideInternally ? 1 : 0);
               byteArray.writeFloat (ccDefine.mPosX);
               byteArray.writeFloat (ccDefine.mPosY);
            }
            
            byteArray.writeShort (worldDefine.mDefaultCollisionCategoryIndex);
            
            byteArray.writeShort (worldDefine.mCollisionCategoryFriendLinkDefines.length);
            for (var pairId:int = 0; pairId < worldDefine.mCollisionCategoryFriendLinkDefines.length; ++ pairId)
            {
               var pairDefine:Object = worldDefine.mCollisionCategoryFriendLinkDefines [pairId];
               
               byteArray.writeShort (pairDefine.mCollisionCategory1Index);
               byteArray.writeShort (pairDefine.mCollisionCategory2Index);
            }
         }
         
         // custom functions
         
         if (worldDefine.mVersion >= 0x0153)
         {
            var functionId:int;
            var functionDefine:FunctionDefine;
            
            byteArray.writeShort (worldDefine.mFunctionDefines.length);
            
            for (functionId = 0; functionId < worldDefine.mFunctionDefines.length; ++ functionId)
            {
               functionDefine = worldDefine.mFunctionDefines [functionId] as FunctionDefine;
               
               TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, functionDefine, true, true, null);
            }
            
            for (functionId = 0; functionId < worldDefine.mFunctionDefines.length; ++ functionId)
            {
               functionDefine = worldDefine.mFunctionDefines [functionId] as FunctionDefine;
               
               byteArray.writeUTF (functionDefine.mName);
               byteArray.writeFloat (functionDefine.mPosX);
               byteArray.writeFloat (functionDefine.mPosY);
               
               if (worldDefine.mVersion >= 0x0156)
               {
                  byteArray.writeByte (functionDefine.mDesignDependent ? 1 : 0);
               }
               
               TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, functionDefine, true, false, worldDefine.mFunctionDefines);
            }
         }
         
         // entities ...
         
         var appearId:int;
         var createId:int;
         var vertexId:int;
         
         var i:int;
         
         var numEntities:int = worldDefine.mEntityDefines.length;
         
         byteArray.writeShort (worldDefine.mEntityDefines.length);
         
         for (createId = 0; createId < numEntities; ++ createId)
         {
            var entityDefine:Object = worldDefine.mEntityDefines [createId];
            
            byteArray.writeShort (entityDefine.mEntityType);
            if (worldDefine.mVersion >= 0x0103)
            {
               byteArray.writeDouble (entityDefine.mPosX);
               byteArray.writeDouble (entityDefine.mPosY);
            }
            else
            {
               byteArray.writeFloat (entityDefine.mPosX);
               byteArray.writeFloat (entityDefine.mPosY);
            }
            if (worldDefine.mVersion >= 0x0158)
            {
               byteArray.writeFloat (entityDefine.mScale);
               byteArray.writeByte (entityDefine.mIsFlipped ? 1 : 0);
            }
            byteArray.writeFloat (entityDefine.mRotation);
            byteArray.writeByte (entityDefine.mIsVisible ? 1 : 0);
            
            if (worldDefine.mVersion >= 0x0108)
            {
               byteArray.writeFloat (entityDefine.mAlpha);
               byteArray.writeByte (entityDefine.mIsEnabled ? 1 : 0);
            }
            
            if ( Define.IsUtilityEntity (entityDefine.mEntityType) )
            {
               // from v1.05
               if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
               {
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     byteArray.writeByte (entityDefine.mFollowedTarget);
                     byteArray.writeByte (entityDefine.mFollowingStyle);
                  }
               }
               //<<
               //>>from v1.10
               else if (entityDefine.mEntityType == Define.EntityType_UtilityPowerSource)
               {
                  byteArray.writeByte (entityDefine.mPowerSourceType);
                  byteArray.writeFloat (entityDefine.mPowerMagnitude);
                  byteArray.writeShort (entityDefine.mKeyboardEventId);
                  WriteShortArrayIntoBinFile (entityDefine.mKeyCodes, byteArray);
               }
               //<<
            }
            else if ( Define.IsLogicEntity (entityDefine.mEntityType) ) // from v1.07
            {
               if (entityDefine.mEntityType == Define.EntityType_LogicCondition)
               {
                  if (worldDefine.mVersion >= 0x0153)
                     TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mFunctionDefine, false, true, worldDefine.mFunctionDefines);
                  else
                     TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mFunctionDefine, false, false, worldDefine.mFunctionDefines);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicTask)
               {
                  WriteShortArrayIntoBinFile (entityDefine.mInputAssignerCreationIds, byteArray);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicConditionDoor)
               {
                  byteArray.writeByte (entityDefine.mIsAnd ? 1 : 0);
                  byteArray.writeByte (entityDefine.mIsNot ? 1 : 0);
                  
                  var target_values:Array = entityDefine.mInputConditionTargetValues;
                  var creation_ids:Array = entityDefine.mInputConditionEntityCreationIds;
                  var num:int = creation_ids.length;
                  if (num > target_values.length)
                     num = target_values.length;
                  
                  byteArray.writeShort (num);
                  for (i = 0; i < num; ++ i)
                  {
                     byteArray.writeShort (creation_ids [i]);
                     byteArray.writeByte (target_values [i]);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityAssigner)
               {
                  byteArray.writeByte (entityDefine.mSelectorType);
                  WriteShortArrayIntoBinFile (entityDefine.mEntityCreationIds, byteArray);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairAssigner)
               {
                  byteArray.writeByte (entityDefine.mPairingType);
                  WriteShortArrayIntoBinFile (entityDefine.mEntityCreationIds1, byteArray);
                  WriteShortArrayIntoBinFile (entityDefine.mEntityCreationIds2, byteArray);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicEventHandler)
               {
                  byteArray.writeShort (entityDefine.mEventId);
                  byteArray.writeShort (entityDefine.mInputConditionEntityCreationId);
                  byteArray.writeByte (entityDefine.mInputConditionTargetValue);
                  WriteShortArrayIntoBinFile (entityDefine.mInputAssignerCreationIds, byteArray);
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     byteArray.writeShort (entityDefine.mExternalActionEntityCreationId);
                  }
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     switch (entityDefine.mEventId)
                     {
                        case CoreEventIds.ID_OnWorldTimer:
                        case CoreEventIds.ID_OnEntityTimer:
                        case CoreEventIds.ID_OnEntityPairTimer:
                           byteArray.writeFloat (entityDefine.mRunningInterval);
                           byteArray.writeByte (entityDefine.mOnlyRunOnce ? 1 : 0);
                           
                           if (worldDefine.mVersion >= 0x0156)
                           {
                              if (entityDefine.mEventId == CoreEventIds.ID_OnEntityTimer || entityDefine.mEventId == CoreEventIds.ID_OnEntityPairTimer)
                              {
                                 TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mPreFunctionDefine, false, true, worldDefine.mFunctionDefines, false);
                                 TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mPostFunctionDefine, false, true, worldDefine.mFunctionDefines, false);
                              }
                           }
                           
                           break;
                        case CoreEventIds.ID_OnWorldKeyDown:
                        case CoreEventIds.ID_OnWorldKeyUp:
                        case CoreEventIds.ID_OnWorldKeyHold:
                           WriteShortArrayIntoBinFile (entityDefine.mKeyCodes, byteArray);
                           break;
                        default:
                           break;
                     }
                  }
                  
                  if (worldDefine.mVersion >= 0x0153)
                  {
                     TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mFunctionDefine, false, true, worldDefine.mFunctionDefines);
                  }
                  else
                  {
                     TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mFunctionDefine, false, false, worldDefine.mFunctionDefines);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicAction)
               {
                  if (worldDefine.mVersion >= 0x0153)
                     TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mFunctionDefine, false, true, worldDefine.mFunctionDefines);
                  else
                     TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mFunctionDefine, false, false, worldDefine.mFunctionDefines);
               }
               //>>from v1.56
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityFilter)
               {
                  TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mFunctionDefine, false, true, worldDefine.mFunctionDefines);
               }
               else if (entityDefine.mEntityType == Define.EntityType_LogicInputEntityPairFilter)
               {
                  TriggerFormatHelper.WriteFunctionDefineIntoBinFile (byteArray, entityDefine.mFunctionDefine, false, true, worldDefine.mFunctionDefines);
               }
               //<<  
            }
            else if ( Define.IsVectorShapeEntity (entityDefine.mEntityType) )
            {
               if (worldDefine.mVersion >= 0x0102)
               {
                  byteArray.writeByte (entityDefine.mDrawBorder);
                  byteArray.writeByte (entityDefine.mDrawBackground);
               }
               
               if (worldDefine.mVersion >= 0x0104)
               {
                  byteArray.writeUnsignedInt (entityDefine.mBorderColor);
                  byteArray.writeByte (entityDefine.mBorderThickness);
                  byteArray.writeUnsignedInt (entityDefine.mBackgroundColor);
                  byteArray.writeByte (entityDefine.mTransparency);
               }
               
               if (worldDefine.mVersion >= 0x0105)
               {
                  byteArray.writeByte (entityDefine.mBorderTransparency);
               }
               
               if ( Define.IsBasicVectorShapeEntity (entityDefine.mEntityType) )
               {
                  // ...
                  WriteShapePhysicsPropertiesAndAiType (byteArray, entityDefine, worldDefine, true);
                  
                  // ...
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                     byteArray.writeFloat (entityDefine.mRadius);
                     byteArray.writeByte (entityDefine.mAppearanceType);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        byteArray.writeByte (entityDefine.mIsRoundCorners ? 1 : 0);
                     }
                     
                     byteArray.writeFloat (entityDefine.mHalfWidth);
                     byteArray.writeFloat (entityDefine.mHalfHeight);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                  {
                     WriteLocalVerticesIntoBinFile (byteArray, entityDefine.mLocalPoints);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                  {
                     byteArray.writeByte (entityDefine.mCurveThickness);
                  
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        byteArray.writeByte (entityDefine.mIsRoundEnds ? 1 : 0);
                     }
                  
                     if (worldDefine.mVersion >= 0x0157)
                     {
                        byteArray.writeByte (entityDefine.mIsClosed ? 1 : 0);
                     }
                     
                     WriteLocalVerticesIntoBinFile (byteArray, entityDefine.mLocalPoints);
                  }
               }
               else // not physics entity
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeText 
                     || entityDefine.mEntityType == Define.EntityType_ShapeTextButton // v1.08
                     )
                  {
                     byteArray.writeUTF (entityDefine.mText);
                     byteArray.writeByte (entityDefine.mWordWrap ? 1 : 0);
                     
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        byteArray.writeByte (entityDefine.mAdaptiveBackgroundSize ? 1 : 0);
                        byteArray.writeUnsignedInt (entityDefine.mTextColor);
                        byteArray.writeShort (entityDefine.mFontSize);
                        byteArray.writeByte (entityDefine.mIsBold ? 1 : 0);
                        byteArray.writeByte (entityDefine.mIsItalic ? 1 : 0);
                     }
                     
                     if (worldDefine.mVersion >= 0x0109)
                     {
                        byteArray.writeByte (entityDefine.mTextAlign);
                        byteArray.writeByte (entityDefine.mIsUnderlined ? 1 : 0);
                     }
                     
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        if (entityDefine.mEntityType == Define.EntityType_ShapeTextButton) 
                        {
                           byteArray.writeByte (entityDefine.mUsingHandCursor ? 1 : 0);
                           
                           byteArray.writeByte (entityDefine.mDrawBackground_MouseOver ? 1 : 0);
                           byteArray.writeUnsignedInt (entityDefine.mBackgroundColor_MouseOver);
                           byteArray.writeByte (entityDefine.mBackgroundTransparency_MouseOver);
                           
                           byteArray.writeByte (entityDefine.mDrawBorder_MouseOver ? 1 : 0);
                           byteArray.writeUnsignedInt (entityDefine.mBorderColor_MouseOver);
                           byteArray.writeByte (entityDefine.mBorderThickness_MouseOver);
                           byteArray.writeByte (entityDefine.mBorderTransparency_MouseOver);
                        }
                     }
                     
                     byteArray.writeFloat (entityDefine.mHalfWidth);
                     byteArray.writeFloat (entityDefine.mHalfHeight);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                  {
                     byteArray.writeFloat (entityDefine.mRadius);
                     
                     if (worldDefine.mVersion >= 0x0105)
                     {
                        byteArray.writeByte (entityDefine.mInteractiveZones);
                        byteArray.writeShort (entityDefine.mInteractiveConditions);
                     }
                     else
                     {
                        byteArray.writeByte (entityDefine.mIsInteractive);
                     }
                     
                     byteArray.writeFloat (entityDefine.mInitialGravityAcceleration);
                     byteArray.writeShort (entityDefine.mInitialGravityAngle);
                     
                     if (worldDefine.mVersion >= 0x0108)
                     {
                        byteArray.writeFloat (entityDefine.mMaximalGravityAcceleration);
                     }
                  }
               }
            }
            //>> from v1.58
            else if (Define.IsShapeEntity (entityDefine.mEntityType))
            {
               if (entityDefine.mEntityType == Define.EntityType_ShapeImageModule)
               {
                  WriteShapePhysicsPropertiesAndAiType (byteArray, entityDefine, worldDefine, false);
                  
                  byteArray.writeShort (entityDefine.mModuleIndex);
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeImageModuleButton)
               {
                  WriteShapePhysicsPropertiesAndAiType (byteArray, entityDefine, worldDefine, false);
                  
                  byteArray.writeShort (entityDefine.mModuleIndexUp);
                  byteArray.writeShort (entityDefine.mModuleIndexOver);
                  byteArray.writeShort (entityDefine.mModuleIndexDown);
               }
            }
            //<<
            else if (Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               byteArray.writeByte (entityDefine.mCollideConnected);
               
               if (worldDefine.mVersion >= 0x0104)
               {
                  byteArray.writeShort (entityDefine.mConnectedShape1Index);
                  byteArray.writeShort (entityDefine.mConnectedShape2Index);
               }
               else if (worldDefine.mVersion >= 0x0102) // ??!! why bytes
               {
                  byteArray.writeByte (entityDefine.mConnectedShape1Index);
                  byteArray.writeByte (entityDefine.mConnectedShape2Index);
               }
               
               if (worldDefine.mVersion >= 0x0108)
               {
                  byteArray.writeByte (entityDefine.mBreakable ? 1 : 0);
               }
               
               if (entityDefine.mEntityType == Define.EntityType_JointHinge)
               {
                  byteArray.writeShort (entityDefine.mAnchorEntityIndex);
                  
                  byteArray.writeByte (entityDefine.mEnableLimits);
                  byteArray.writeFloat (entityDefine.mLowerAngle);
                  byteArray.writeFloat (entityDefine.mUpperAngle);
                  byteArray.writeByte (entityDefine.mEnableMotor);
                  byteArray.writeFloat (entityDefine.mMotorSpeed);
                  byteArray.writeByte (entityDefine.mBackAndForth);
                  
                  if (worldDefine.mVersion >= 0x0104)
                  {
                     byteArray.writeFloat (entityDefine.mMaxMotorTorque);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
               {
                  byteArray.writeShort (entityDefine.mAnchor1EntityIndex);
                  byteArray.writeShort (entityDefine.mAnchor2EntityIndex);
                  
                  byteArray.writeByte (entityDefine.mEnableLimits);
                  byteArray.writeFloat (entityDefine.mLowerTranslation);
                  byteArray.writeFloat (entityDefine.mUpperTranslation);
                  byteArray.writeByte (entityDefine.mEnableMotor);
                  byteArray.writeFloat (entityDefine.mMotorSpeed);
                  byteArray.writeByte (entityDefine.mBackAndForth);
                  
                  if (worldDefine.mVersion >= 0x0104)
                  {
                     byteArray.writeFloat (entityDefine.mMaxMotorForce);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
               {
                  byteArray.writeShort (entityDefine.mAnchor1EntityIndex);
                  byteArray.writeShort (entityDefine.mAnchor2EntityIndex);
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     byteArray.writeFloat (entityDefine.mBreakDeltaLength);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  byteArray.writeShort (entityDefine.mAnchor1EntityIndex);
                  byteArray.writeShort (entityDefine.mAnchor2EntityIndex);
                  
                  byteArray.writeFloat (entityDefine.mStaticLengthRatio);
                  //byteArray.writeFloat (entityDefine.mFrequencyHz);
                  byteArray.writeByte (entityDefine.mSpringType);
                  
                  byteArray.writeFloat (entityDefine.mDampingRatio);
                  
                  if (worldDefine.mVersion >= 0x0108)
                  {
                     byteArray.writeByte (entityDefine.mFrequencyDeterminedManner);
                     byteArray.writeFloat (entityDefine.mFrequency);
                     byteArray.writeFloat (entityDefine.mSpringConstant);
                     byteArray.writeFloat (entityDefine.mBreakExtendedLength);
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointWeld)
               {
                  byteArray.writeShort (entityDefine.mAnchorEntityIndex);
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDummy)
               {
                  byteArray.writeShort (entityDefine.mAnchor1EntityIndex);
                  byteArray.writeShort (entityDefine.mAnchor2EntityIndex);
               }
            }
         }
         
         // ...
         if (worldDefine.mVersion >= 0x0107)
         {
            WriteShortArrayIntoBinFile (worldDefine.mEntityAppearanceOrder, byteArray);
         }
         
         // ...
         
         var groupId:int;
         var brotherIDs:Array;
         
         byteArray.writeShort (worldDefine.mBrotherGroupDefines.length);
         
         for (groupId = 0; groupId < worldDefine.mBrotherGroupDefines.length; ++ groupId)
         {
            brotherIDs = worldDefine.mBrotherGroupDefines [groupId] as Array;
            
            WriteShortArrayIntoBinFile (brotherIDs, byteArray);
         }
         
         // custom variables
         if (worldDefine.mVersion >= 0x0152)
         {
            if (worldDefine.mVersion >= 0x0157)
            {
               TriggerFormatHelper.WriteVariableDefinesIntoBinFile (byteArray, worldDefine.mSessionVariableDefines, true);
            }
            
            if (worldDefine.mVersion == 0x0152)
            {
               byteArray.writeShort (1); // num global variable packages
               byteArray.writeUTF ("");//variableSpaceDefine.mName);
               byteArray.writeShort (-1);//variableSpaceDefine.mParentPackageId);
            }
            TriggerFormatHelper.WriteVariableDefinesIntoBinFile (byteArray, worldDefine.mGlobalVariableDefines, true);
            
            if (worldDefine.mVersion == 0x0152)
            {
               byteArray.writeShort (1); // num entity property packages
               byteArray.writeUTF ("");//variableSpaceDefine.mName);
               byteArray.writeShort (-1);//variableSpaceDefine.mParentPackageId);
            }
            TriggerFormatHelper.WriteVariableDefinesIntoBinFile (byteArray, worldDefine.mEntityPropertyDefines, true);
         }
         
         // modules
         
         if (worldDefine.mVersion >= 0x0158)
         {
            byteArray.writeShort (worldDefine.mImageDefines.length);
            for (var imageId:int = 0; imageId < worldDefine.mImageDefines.length; ++ imageId)
            {
               var imageDefine:Object = worldDefine.mImageDefines [imageId];
               
               byteArray.writeUTF (imageDefine.mName == null ? "" : imageDefine.mName);
               if (imageDefine.mFileData == null || imageDefine.mFileData.length == 0)
               {
                  byteArray.writeInt (0);
               }
               else
               {
                  byteArray.writeInt (imageDefine.mFileData.length);
                  byteArray.writeBytes (imageDefine.mFileData, 0, imageDefine.mFileData.length);
               }
            }

            byteArray.writeShort (worldDefine.mPureImageModuleDefines.length);
            for (var divisionId:int = 0; divisionId < worldDefine.mPureImageModuleDefines.length; ++ divisionId)
            {
               var divisionDefine:Object = worldDefine.mPureImageModuleDefines [divisionId];

               byteArray.writeShort (divisionDefine.mImageIndex);
               byteArray.writeShort (divisionDefine.mLeft);
               byteArray.writeShort (divisionDefine.mTop);
               byteArray.writeShort (divisionDefine.mRight);
               byteArray.writeShort (divisionDefine.mBottom);
            }

            byteArray.writeShort (worldDefine.mAssembledModuleDefines.length);
            for (var assembledModuleId:int = 0; assembledModuleId < worldDefine.mAssembledModuleDefines.length; ++ assembledModuleId)
            {
               var assembledModuleDefine:Object = worldDefine.mAssembledModuleDefines [assembledModuleId];

               WriteModuleInstanceDefinesIntoBinFile (byteArray, assembledModuleDefine.mModulePartDefines, false);
            }

            byteArray.writeShort (worldDefine.mSequencedModuleDefines.length);
            for (var sequencedModuleId:int = 0; sequencedModuleId < worldDefine.mSequencedModuleDefines.length; ++ sequencedModuleId)
            {
               var sequencedModuleDefine:Object = worldDefine.mSequencedModuleDefines [sequencedModuleId];

               //byteArray.writeByte (sequencedModuleDefine.mIsLooped ? 1 : 0);
               WriteModuleInstanceDefinesIntoBinFile (byteArray, sequencedModuleDefine.mModuleSequenceDefines, true);
            }
         }
         
         // ...
         return byteArray;
      }
      
      public static function WriteShapePhysicsPropertiesAndAiType (byteArray:ByteArray, entityDefine:Object, worldDefine:WorldDefine, writeAiType:Boolean):void
      {
         if (worldDefine.mVersion >= 0x0105) 
         {
            if (writeAiType)
               byteArray.writeByte (entityDefine.mAiType);
            
            byteArray.writeByte (entityDefine.mIsPhysicsEnabled);
            
            // the 2 lines are added in v1,04, and moved down from v1.05
            /////byteArray.writeShort (entityDefine.mCollisionCategoryIndex);
            /////byteArray.writeByte (entityDefine.mIsSensor)
         }
         else if (worldDefine.mVersion >= 0x0104)
         {
            // changed the order of mAiType and mCollisionCategoryIndex, 
            // add mIsPhysicsEnabled and mIsSensor
            
            if (writeAiType)
               byteArray.writeByte (entityDefine.mAiType);
            
            byteArray.writeShort (entityDefine.mCollisionCategoryIndex);
            byteArray.writeByte (entityDefine.mIsPhysicsEnabled);
            byteArray.writeByte (entityDefine.mIsSensor)
         }
         else 
         {
            if (worldDefine.mVersion >= 0x0102)
            {
               byteArray.writeShort (entityDefine.mCollisionCategoryIndex);
            }
            
            if (writeAiType)
               byteArray.writeByte (entityDefine.mAiType);
            
            //entityDefine.mIsPhysicsEnabled = true; // already set in FillMissedFieldsInWorldDefine
         }
         
         if (entityDefine.mIsPhysicsEnabled) // always true before v1.05
         {
            byteArray.writeByte (entityDefine.mIsStatic);
            byteArray.writeByte (entityDefine.mIsBullet);
            byteArray.writeFloat (entityDefine.mDensity);
            byteArray.writeFloat (entityDefine.mFriction);
            byteArray.writeFloat (entityDefine.mRestitution);
            
            if (worldDefine.mVersion >= 0x0105)
            {
               // the 2 lines are added in v1,04, and moved here from above from v1.05
               byteArray.writeShort (entityDefine.mCollisionCategoryIndex);
               byteArray.writeByte (entityDefine.mIsSensor)
               
               // ...
               byteArray.writeByte (entityDefine.mIsHollow);
            }
            
            if (worldDefine.mVersion >= 0x0108)
            {
               byteArray.writeByte (entityDefine.mBuildBorder ? 1 : 0);
               byteArray.writeByte (entityDefine.mIsSleepingAllowed ? 1 : 0);
               byteArray.writeByte (entityDefine.mIsRotationFixed) ? 1 : 0;
               byteArray.writeFloat (entityDefine.mLinearVelocityMagnitude);
               byteArray.writeFloat (entityDefine.mLinearVelocityAngle);
               byteArray.writeFloat (entityDefine.mAngularVelocity);
            }
         }
      }
         
      public static function WriteModuleInstanceDefinesIntoBinFile (byteArray:ByteArray, moduleInstanceDefines:Array, forSequencedModule:Boolean):void
      {
         byteArray.writeShort (moduleInstanceDefines.length);
         for (var miId:int = 0; miId < moduleInstanceDefines.length; ++ miId)
         {
            var moduleInstanceDefine:Object = moduleInstanceDefines [miId];
            
            byteArray.writeFloat (moduleInstanceDefine.mPosX);
            byteArray.writeFloat (moduleInstanceDefine.mPosY);
            byteArray.writeFloat (moduleInstanceDefine.mScale);
            byteArray.writeByte (moduleInstanceDefine.mIsFlipped ? 1 : 0);
            byteArray.writeFloat (moduleInstanceDefine.mRotation);
            byteArray.writeByte (moduleInstanceDefine.mVisible ? 1 : 0);
            byteArray.writeFloat (moduleInstanceDefine.mAlpha);
            
            if (forSequencedModule)
            {
               byteArray.writeFloat (moduleInstanceDefine.mModuleDuration);
            }
            
            WriteModuleInstanceDefineIntoBinFile (byteArray, moduleInstanceDefine);
         }
      }
      
      public static function WriteModuleInstanceDefineIntoBinFile (byteArray:ByteArray, moduleInstanceDefine:Object):void
      {
         byteArray.writeShort (moduleInstanceDefine.mModuleType);
         
         if (Define.IsVectorShapeEntity (moduleInstanceDefine.mModuleType))
         {
            byteArray.writeUnsignedInt (moduleInstanceDefine.mShapeAttributeBits);
            byteArray.writeUnsignedInt (moduleInstanceDefine.mShapeBodyOpacityAndColor);
            
            if (Define.IsBasicPathVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               byteArray.writeFloat (moduleInstanceDefine.mShapePathThickness);
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolyline)
               {
                  WriteLocalVerticesIntoBinFile (byteArray, moduleInstanceDefine.mPolyLocalPoints);
               }
            }
            else if (Define.IsBasicAreaVectorShapeEntity (moduleInstanceDefine.mModuleType))
            {
               byteArray.writeUnsignedInt (moduleInstanceDefine.mShapeBorderOpacityAndColor);
               byteArray.writeFloat (moduleInstanceDefine.mShapeBorderThickness);
               
               if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeCircle)
               {
                  byteArray.writeFloat (moduleInstanceDefine.mCircleRadius);
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeRectangle)
               {
                  byteArray.writeFloat (moduleInstanceDefine.mRectHalfWidth);
                  byteArray.writeFloat (moduleInstanceDefine.mRectHalfHeight);
               }
               else if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapePolygon)
               {
                  WriteLocalVerticesIntoBinFile (byteArray, moduleInstanceDefine.mPolyLocalPoints);
               }
            }
         }
         else if (Define.IsShapeEntity (moduleInstanceDefine.mModuleType))
         {
            if (moduleInstanceDefine.mModuleType == Define.EntityType_ShapeImageModule)
            {
               byteArray.writeShort (moduleInstanceDefine.mModuleIndex);
            }
         }
         else // ...
         {
         }
      }
      
      public static function WriteLocalVerticesIntoBinFile (byteArray:ByteArray, localPoints:Array):void
      {
         if (localPoints == null || localPoints.length == 0)
         {
            byteArray.writeShort (0);
         }
         else
         {
            byteArray.writeShort (localPoints.length);
            for (var vertexId:int = 0; vertexId < localPoints.length; ++ vertexId)
            {
               var point:Point = localPoints [vertexId] as Point;
               byteArray.writeFloat (point.x);
               byteArray.writeFloat (point.y);
            }
         }
      }
      
      public static function WriteShortArrayIntoBinFile (shortArray:Array, binFile:ByteArray):void
      {
         if (shortArray == null)
         {
            binFile.writeShort (0);
            return;
         }
         
         binFile.writeShort (shortArray.length);
         
         for (var i:int = 0; i < shortArray.length; ++ i)
         {
            binFile.writeShort (shortArray [i]);
         }
      }
      
      public static function WorldDefine2HexString (worldDefine:WorldDefine):String
      {
         return ByteArray2HexString (WorldDefine2ByteArray (worldDefine) );
      }
      
      public static function ByteArray2HexString (byteArray:ByteArray):String
      {
         if (byteArray == null)
            return null;
         
         var arrayLength:int = byteArray.length;
         var stringLength:int = arrayLength * 2;
         
         var hexString:String = "";
         var n1:int;
         var n2:int;
         
         for (var bi:int = 0; bi < arrayLength; ++ bi)
         {
            hexString = hexString + MakeHexStringFromByte (byteArray [bi]);
         }
         
         if (hexString.length != arrayLength * 2)
            trace ("hexString.length != arrayLength * 2");
         
         return En (hexString);
      }
      
      public static function MakeHexStringFromByte (byteValue:int):String
      {
         //if (byteValue < -128 || byteValue > 127)
         if (byteValue < 0 || byteValue > 255)
         {
            return "??";
         }
         
         var n1:int = (byteValue & 0xF0) >> 4;
         var n2:int = (byteValue & 0x0F);
         
         return DataFormat3.Value2Char (n1) + DataFormat3.Value2Char (n2);
      }
      
      public static function En (str:String):String
      {
         var enStr:String = "";
         
         var index:int = 0;
         var code:int;
         var num:int;
         while (index < str.length)
         {
            code = str.charCodeAt (index);
            num = 1;
            ++ index;
            while (num < 4 && index < str.length && str.charCodeAt (index) == code)
            {
               ++ num;
               ++ index;
            }
            
            enStr = enStr + DataFormat3.Value2Char (DataFormat3.Char2Value (code), num);
         }
         
         return enStr;
      }

//====================================================================================================================
//==================================== new playcode with base64 ======================================================
//====================================================================================================================

      public static function WorldDefine2PlayCode_Base64 (worldDefine:WorldDefine):String
      {
         var byteArray:ByteArray = WorldDefine2ByteArray (worldDefine);
         byteArray.compress ();
         return DataFormat3.EncodeByteArray2String (byteArray);
      }

   }
}
