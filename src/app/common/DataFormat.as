
package common {
   
   import flash.utils.ByteArray;
   import flash.geom.Point;
   
   import editor.world.World;
   import editor.entity.Entity;
   import editor.entity.EntityShape
   import editor.entity.EntityShapeCircle;
   import editor.entity.EntityShapeRectangle;
   import editor.entity.EntityShapePolygon;
   import editor.entity.EntityShapePolyline;
   import editor.entity.EntityShapeText;
   import editor.entity.EntityShapeGravityController;
   import editor.entity.EntityUtilityCamera;
   import editor.entity.EntityJoint;
   import editor.entity.EntityJointHinge;
   import editor.entity.EntityJointSlider;
   import editor.entity.EntityJointDistance;
   import editor.entity.SubEntityJointAnchor;
   import editor.entity.EntityUtility;
   import editor.entity.EntityUtilityCamera;
   
   public class DataFormat
   {
      
      
      
//===========================================================================
// 
//===========================================================================
      
      // create a world define from a editor world.
      // the created word define can be used to create either a player world or a editor world
      
      public static function EditorWorld2WorldDefine (editorWorld:editor.world.World):WorldDefine
      {
         if (editorWorld == null)
            return null;
         
         var worldDefine:WorldDefine = new WorldDefine ();
         
         // basic
         {
            worldDefine.mVersion = Config.VersionNumber;
            
            worldDefine.mAuthorName = editorWorld.GetAuthorName ();
            worldDefine.mAuthorHomepage = editorWorld.GetAuthorHomepage ();
            
            //>>from v1.02
            worldDefine.mShareSourceCode = editorWorld.IsShareSourceCode ();
            worldDefine.mPermitPublishing = editorWorld.IsPermitPublishing ();
         }
         
         // settings
         {
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
         }
         
         var entityId:int;
         var editorEntity:editor.entity.Entity;
         
         for (entityId = 0; entityId < editorWorld.numChildren; ++ entityId)
         {
            var child:Object = editorWorld.getChildAt (entityId);
            editorEntity = child as Entity;
            
            var entityDefine:Object = new Object ();
            
            entityDefine.mEntityType = Define.EntityType_Unkonwn; // default
            
            entityDefine.mPosX = editorEntity.GetPositionX ();
            entityDefine.mPosY = editorEntity.GetPositionY ();
            entityDefine.mRotation = editorEntity.GetRotation ();
            entityDefine.mIsVisible = editorEntity.IsVisible ();
            
            if (editorEntity is editor.entity.EntityUtility)
            {
               //>>from v1.05
                if (editorEntity is editor.entity.EntityUtilityCamera)
               {
                  entityDefine.mEntityType = Define.EntityType_UtilityCamera;
               }
               //<<
            }
            else if (editorEntity is editor.entity.EntityShape)
            {
               var shape:editor.entity.EntityShape = editorEntity as editor.entity.EntityShape;
               
               //>>from v1.02
               entityDefine.mDrawBorder = shape.IsDrawBorder ();
               entityDefine.mDrawBackground = shape.IsDrawBackground ();
               //<<
               
               //>>from v1.04
               entityDefine.mBorderColor = shape.GetBorderColor ();
               entityDefine.mBorderThickness = shape.GetBorderThickness ();
               entityDefine.mBackgroundColor =shape.GetFilledColor ();
               entityDefine.mTransparency = shape.GetTransparency ();
               //<<
               
               //>>from v1.05
               entityDefine.mBorderTransparency = shape.GetBorderTransparency ();
               //<<
               
               if (shape.IsBasicShapeEntity ())
               {
                  //>> move up from v1.04
                  entityDefine.mAiType = shape.GetAiType ();
                  //<<
                  
                  //>>from v1.04
                  entityDefine.mIsPhysicsEnabled = shape.IsPhysicsEnabled ();
                  /////entityDefine.mIsSensor = shape.mIsSensor; // move down from v1.05
                  //<<
                  
                  //if (entityDefine.mIsPhysicsEnabled)  // always true before v1.04
                  {
                     //>>from v1.02
                     entityDefine.mCollisionCategoryIndex = shape.GetCollisionCategoryIndex ();
                     //<<
                     
                     //>> removed here, move up from v1.04
                     /////entityDefine.mAiType = Define.GetShapeAiType ( shape.GetFilledColor ()); // move up from v1.04
                     //<<
                     
                     entityDefine.mIsStatic = shape.IsStatic ();
                     entityDefine.mIsBullet = shape.mIsBullet;
                     entityDefine.mDensity = shape.mDensity;
                     entityDefine.mFriction = shape.mFriction;
                     entityDefine.mRestitution = shape.mRestitution;
                     
                     // add in v1,04, move here from above from v1.05
                     entityDefine.mIsSensor = shape.mIsSensor;
                     
                     //>>from v1.05
                     entityDefine.mIsHollow = shape.IsHollow ();
                     //<<
                  }
                  
                  if (child is editor.entity.EntityShapeCircle)
                  {
                     entityDefine.mEntityType = Define.EntityType_ShapeCircle;
                     
                     entityDefine.mRadius = (shape as editor.entity.EntityShapeCircle).GetRadius ();
                     
                     entityDefine.mAppearanceType = (shape as editor.entity.EntityShapeCircle).GetAppearanceType ();
                  }
                  else if (child is editor.entity.EntityShapeRectangle)
                  {
                     entityDefine.mEntityType = Define.EntityType_ShapeRectangle;
                     
                     entityDefine.mHalfWidth = (shape as editor.entity.EntityShapeRectangle).GetHalfWidth ();
                     entityDefine.mHalfHeight = (shape as editor.entity.EntityShapeRectangle).GetHalfHeight ();
                  }
                  //>>from v1.04
                  else if (child is editor.entity.EntityShapePolygon)
                  {
                     entityDefine.mEntityType = Define.EntityType_ShapePolygon;
                     
                     entityDefine.mLocalPoints = (shape as editor.entity.EntityShapePolygon).GetLocalVertexPoints ();
                  }
                  //<<
                  //>>from v1.05
                  else if (child is editor.entity.EntityShapePolyline)
                  {
                     entityDefine.mEntityType = Define.EntityType_ShapePolyline;
                     
                     entityDefine.mCurveThickness = (shape as editor.entity.EntityShapePolyline).GetCurveThickness ();
                     
                     entityDefine.mLocalPoints = (shape as editor.entity.EntityShapePolyline).GetLocalVertexPoints ();
                  }
                  //<<
               }
               else // not physics entity
               {
                  //>>from v1.02
                  if (child is editor.entity.EntityShapeText)
                  {
                     entityDefine.mEntityType = Define.EntityType_ShapeText;
                     
                     entityDefine.mText = (shape as EntityShapeText).GetText ();
                     entityDefine.mAutofitWidth = (shape as EntityShapeText).IsAutofitWidth ();
                     
                     entityDefine.mHalfWidth = (shape as editor.entity.EntityShapeRectangle).GetHalfWidth ();
                     entityDefine.mHalfHeight = (shape as editor.entity.EntityShapeRectangle).GetHalfHeight ();
                  }
                  else if (child is editor.entity.EntityShapeGravityController)
                  {
                     entityDefine.mEntityType = Define.EntityType_ShapeGravityController;
                     
                     entityDefine.mRadius = (shape as editor.entity.EntityShapeCircle).GetRadius ();
                     
                     // removed from v1.05
                     /////entityDefine.mIsInteractive = (shape as editor.entity.EntityShapeGravityController).IsInteractive ();
                     
                     // added in v1,05
                     entityDefine.mInteractiveZones = (shape as editor.entity.EntityShapeGravityController).GetInteractiveZones ();
                     entityDefine.mInteractiveConditions = (shape as editor.entity.EntityShapeGravityController).mInteractiveConditions;
                     
                     // ...
                     entityDefine.mInitialGravityAcceleration = (shape as editor.entity.EntityShapeGravityController).GetInitialGravityAcceleration ();
                     entityDefine.mInitialGravityAngle = (shape as editor.entity.EntityShapeGravityController).GetInitialGravityAngle ();
                  }
                  //<<
               }
            }
            else if (editorEntity is editor.entity.EntityJoint)
            {
               var joint:editor.entity.EntityJoint = (editorEntity as editor.entity.EntityJoint);
               
               entityDefine.mCollideConnected = joint.mCollideConnected;
               
               //>>from v1.02
               entityDefine.mConnectedShape1Index = joint.GetConnectedShape1Index ();
               entityDefine.mConnectedShape2Index = joint.GetConnectedShape2Index ();
               //<<
               
               if (child is editor.entity.EntityJointHinge)
               {
                  var hinge:editor.entity.EntityJointHinge = child as editor.entity.EntityJointHinge;
                  
                  entityDefine.mEntityType = Define.EntityType_JointHinge;
                  entityDefine.mAnchorEntityIndex = editorWorld.getChildIndex ( hinge.GetAnchor () );
                  
                  entityDefine.mEnableLimits = hinge.IsLimitsEnabled ();
                  entityDefine.mLowerAngle = hinge.GetLowerLimit ();
                  entityDefine.mUpperAngle = hinge.GetUpperLimit ();
                  entityDefine.mEnableMotor = hinge.mEnableMotor;
                  entityDefine.mMotorSpeed = hinge.mMotorSpeed;
                  entityDefine.mBackAndForth = hinge.mBackAndForth;
                  
                  //>>from v1.04
                  entityDefine.mMaxMotorTorque = hinge.mMaxMotorTorque;
                  //<<
               }
               else if (child is editor.entity.EntityJointSlider)
               {
                  var slider:editor.entity.EntityJointSlider = child as editor.entity.EntityJointSlider;
                  
                  entityDefine.mEntityType = Define.EntityType_JointSlider;
                  entityDefine.mAnchor1EntityIndex = editorWorld.getChildIndex ( slider.GetAnchor1 () );
                  entityDefine.mAnchor2EntityIndex = editorWorld.getChildIndex ( slider.GetAnchor2 () );
                  
                  entityDefine.mEnableLimits = slider.IsLimitsEnabled ();
                  entityDefine.mLowerTranslation = slider.GetLowerLimit ();
                  entityDefine.mUpperTranslation = slider.GetUpperLimit ();
                  entityDefine.mEnableMotor = slider.mEnableMotor;
                  entityDefine.mMotorSpeed = slider.mMotorSpeed;
                  entityDefine.mBackAndForth = slider.mBackAndForth;
                  
                  //>>from v1.04
                  entityDefine.mMaxMotorForce = slider.mMaxMotorForce;
                  //<<
               }
               else if (child is editor.entity.EntityJointDistance)
               {
                  var distanceJoint:editor.entity.EntityJointDistance = child as editor.entity.EntityJointDistance;
                  
                  entityDefine.mEntityType = Define.EntityType_JointDistance;
                  entityDefine.mAnchor1EntityIndex = editorWorld.getChildIndex ( distanceJoint.GetAnchor1 () );
                  entityDefine.mAnchor2EntityIndex = editorWorld.getChildIndex ( distanceJoint.GetAnchor2 () );
               }
               else if (child is editor.entity.EntityJointSpring)
               {
                  var spring:editor.entity.EntityJointSpring = child as editor.entity.EntityJointSpring;
                  
                  entityDefine.mEntityType = Define.EntityType_JointSpring;
                  entityDefine.mAnchor1EntityIndex = editorWorld.getChildIndex ( spring.GetAnchor1 () );
                  entityDefine.mAnchor2EntityIndex = editorWorld.getChildIndex ( spring.GetAnchor2 () );
                  
                  entityDefine.mStaticLengthRatio = spring.GetStaticLengthRatio ();
                  //entityDefine.mFrequencyHz = spring.GetFrequencyHz ();
                  entityDefine.mSpringType = spring.GetSpringType ();
                  entityDefine.mDampingRatio = spring.mDampingRatio;
               }
            }
            else if (editorEntity is editor.entity.SubEntityJointAnchor)
            {
               entityDefine.mEntityType = Define.SubEntityType_JointAnchor;
            }
            
            worldDefine.mEntityDefines.push (entityDefine);
         }
         
         var brotherGroupArray:Array = editorWorld.GetBrotherGroups ();
         var groupId:int;
         var brotherGroup:Array;
         
         for (groupId = 0; groupId < brotherGroupArray.length; ++ groupId)
         {
            brotherGroup = brotherGroupArray [groupId] as Array;
            
            if (brotherGroup == null)
            {
               trace ("brotherGroup == null");
               continue;
            }
            if (brotherGroup.length  < 2)
            {
               trace ("brotherGroup.length  < 2");
               continue;
            }
            
            var brotherIDs:Array = new Array (brotherGroup.length);
            for (entityId = 0; entityId < brotherGroup.length; ++ entityId)
            {
               editorEntity = brotherGroup [entityId] as editor.entity.Entity;
               brotherIDs [entityId] = editorWorld.getChildIndex (editorEntity);
            }
            worldDefine.mBrotherGroupDefines.push (brotherIDs);
         }
         
         //>>fromv1.02
         // collision category
         {
            var ccList:Array = editorWorld.GetCollisionCategoryList ();
            var ccFriendPairs:Array = editorWorld.GetCollisionCategoryFriendPairs ();
            
            for (var ccId:int = 0; ccId < ccList.length; ++ ccId)
            {
               var collisionCategory:editor.entity.EntityCollisionCategory = ccList [ccId].mCategory as editor.entity.EntityCollisionCategory;
               
               var ccDefine:Object = new Object ();
               
               ccDefine.mName = collisionCategory.GetCategoryName ();
               ccDefine.mCollideInternally = collisionCategory.IsCollideInternally ();
               ccDefine.mPosX = collisionCategory.GetPositionX ();
               ccDefine.mPosY = collisionCategory.GetPositionY ();
               
               worldDefine.mCollisionCategoryDefines.push (ccDefine);
            }
            
            worldDefine.mDefaultCollisionCategoryIndex = editorWorld.GetCollisionCategoryIndex (editorWorld.GetDefaultCollisionCategory ());
            
            for (var pairId:int = 0; pairId < ccFriendPairs.length; ++ pairId)
            {
               var friendPair:Object = ccFriendPairs [pairId];
               
               var pairDefine:Object = new Object ();
               
               pairDefine.mCollisionCategory1Index = editorWorld.GetCollisionCategoryIndex (friendPair.mCategory1);
               pairDefine.mCollisionCategory2Index = editorWorld.GetCollisionCategoryIndex (friendPair.mCategory2);
               
               worldDefine.mCollisionCategoryFriendLinkDefines.push (pairDefine);
            }
         }
         //<<
         
         return worldDefine;
      }
      
      public static function WorldDefine2EditorWorld (worldDefine:WorldDefine, adjustPrecisionsInWorldDefine:Boolean = true, editorWorld:editor.world.World = null):editor.world.World
      {
         // from v1,03
         DataFormat2.FillMissedFieldsInWorldDefine (worldDefine);
         if (adjustPrecisionsInWorldDefine)
            DataFormat2.AdjustNumberValuesInWorldDefine (worldDefine);
         
         //
         if (editorWorld == null)
         {
            editorWorld = new editor.world.World ();
            
            // basic
            {
               editorWorld.SetAuthorName (worldDefine.mAuthorName);
               editorWorld.SetAuthorHomepage (worldDefine.mAuthorHomepage);
               
               editorWorld.SetShareSourceCode (worldDefine.mShareSourceCode);
               editorWorld.SetPermitPublishing (worldDefine.mPermitPublishing);
            }
            
            // settins
            {
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
            }
         }
         
         // collision category
         
         var beginningCollisionCategoryIndex:int = editorWorld.GetNumCollisionCategories ();
         
         if (worldDefine.mVersion >= 0x0102)
         {
            var collisionCategory:editor.entity.EntityCollisionCategory;
            
            for (var ccId:int = 0; ccId < worldDefine.mCollisionCategoryDefines.length; ++ ccId)
            {
               var ccDefine:Object = worldDefine.mCollisionCategoryDefines [ccId];
               
               collisionCategory = editorWorld.CreateEntityCollisionCategory (ccDefine.mName);
               collisionCategory.SetCollideInternally (ccDefine.mCollideInternally);
               
               collisionCategory.SetPosition (ccDefine.mPosX, ccDefine.mPosY);
               
               collisionCategory.UpdateAppearance ();
               collisionCategory.UpdateSelectionProxy ();
            }
            
            collisionCategory = editorWorld.GetCollisionCategoryByIndex (worldDefine.mDefaultCollisionCategoryIndex);
            if (collisionCategory != null)
               collisionCategory.SetDefaultCategory (true);
            
            for (var pairId:int = 0; pairId < worldDefine.mCollisionCategoryFriendLinkDefines.length; ++ pairId)
            {
               var pairDefine:Object = worldDefine.mCollisionCategoryFriendLinkDefines [pairId];
               
               //editorWorld.CreateEntityCollisionCategoryFriendLink (pairDefine.mCollisionCategory1Index, pairDefine.mCollisionCategory2Index);
               editorWorld.CreateEntityCollisionCategoryFriendLink (beginningCollisionCategoryIndex + pairDefine.mCollisionCategory1Index, 
                                                                    beginningCollisionCategoryIndex + pairDefine.mCollisionCategory2Index);
            }
         }
         
         // entities
         
         var beginningEntityIndex:int = editorWorld.numChildren;
         
         var entityId:int;
         var entityDefine:Object;
         var entity:editor.entity.Entity;
         var shape:editor.entity.EntityShape;
         var anchorDefine:Object;
         var joint:editor.entity.EntityJoint;
         var utility:editor.entity.EntityUtility;
         
         for (entityId = 0; entityId < worldDefine.mEntityDefines.length; ++ entityId)
         {
            entityDefine = worldDefine.mEntityDefines [entityId];
            
            entity = null;
            
            if ( Define.IsUtilityEntity (entityDefine.mEntityType) )
            {
               utility = null;
               
               //>>from v1.05
               if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
               {
                  var camera:editor.entity.EntityUtilityCamera = editorWorld.CreateEntityUtilityCamera ();
                  
                  entity = utility = camera;
               }
               //<<
            }
            else if ( Define.IsShapeEntity (entityDefine.mEntityType) )
            {
               shape = null;
               
               if ( Define.IsBasicShapeEntity (entityDefine.mEntityType) )
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                     var circle:editor.entity.EntityShapeCircle = editorWorld.CreateEntityShapeCircle ();
                     circle.SetAppearanceType (entityDefine.mAppearanceType);
                     circle.SetRadius (entityDefine.mRadius);
                     
                     entity = shape = circle;
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     var rect:editor.entity.EntityShapeRectangle = editorWorld.CreateEntityShapeRectangle ();
                     rect.SetHalfWidth (entityDefine.mHalfWidth);
                     rect.SetHalfHeight (entityDefine.mHalfHeight);
                     
                     entity = shape = rect;
                  }
                  //>> from v1.04
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                  {
                     var polygon:editor.entity.EntityShapePolygon = editorWorld.CreateEntityShapePolygon ();
                        polygon.SetPosition (entityDefine.mPosX, entityDefine.mPosY);
                        polygon.SetRotation (entityDefine.mRotation);
                     polygon.SetLocalVertexPoints (entityDefine.mLocalPoints);
                     
                     entity = shape = polygon;
                  }
                  //<<
                  //>>from v1.05
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                  {
                     var polyline:editor.entity.EntityShapePolyline = editorWorld.CreateEntityShapePolyline ();
                        polyline.SetPosition (entityDefine.mPosX, entityDefine.mPosY);
                        polyline.SetRotation (entityDefine.mRotation);
                     polyline.SetLocalVertexPoints (entityDefine.mLocalPoints);
                     
                     polyline.SetCurveThickness (entityDefine.mCurveThickness);
                     
                     entity = shape = polyline;
                  }
                  //<<
                  
                  if (shape != null)
                  {
                     shape.SetAiType (entityDefine.mAiType);
                     
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
                     }
                  }
               }
               else // not physics shape
               {
                  //>> v1.02
                  if (entityDefine.mEntityType == Define.EntityType_ShapeText)
                  {
                     var text:editor.entity.EntityShapeText = editorWorld.CreateEntityShapeText ();
                     text.SetText (entityDefine.mText);
                     text.SetAutofitWidth (entityDefine.mAutofitWidth);
                     
                     text.SetHalfWidth (entityDefine.mHalfWidth);
                     text.SetHalfHeight (entityDefine.mHalfHeight);
                     
                     entity = shape = text;
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                  {
                     var gController:editor.entity.EntityShapeGravityController = editorWorld.CreateEntityShapeGravityController ();
                     
                     gController.SetRadius (entityDefine.mRadius)
                     
                     // removed from v1.05
                     /////gController.SetInteractive (entityDefine.mIsInteractive)
                     
                     // added in v1.05
                     gController.SetInteractiveZones (entityDefine.mInteractiveZones);
                     gController.mInteractiveConditions = entityDefine.mInteractiveConditions
                     
                     // ...
                     gController.SetInitialGravityAcceleration (entityDefine.mInitialGravityAcceleration)
                     gController.SetInitialGravityAngle (entityDefine.mInitialGravityAngle)
                     
                     entity = shape = gController;
                  }
                  //<<
               }
               
               if (shape != null)
               {
                  //>>v1.02
                  shape.SetDrawBorder (entityDefine.mDrawBorder);
                  shape.SetDrawBackground (entityDefine.mDrawBackground);
                  //<<
                  
                  //>>from v1.04
                  shape.SetBorderColor (entityDefine.mBorderColor);
                  shape.SetBorderThickness (entityDefine.mBorderThickness);
                  shape.SetFilledColor (entityDefine.mBackgroundColor);
                  shape.SetTransparency (entityDefine.mTransparency);
                  //<<
                  
                  //>>from v1.05
                  shape.SetBorderTransparency (entityDefine.mBorderTransparency);
                  //<<
               }
            }
            else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               joint = null;
               
               if (entityDefine.mEntityType == Define.EntityType_JointHinge)
               {
                  var hinge:editor.entity.EntityJointHinge = editorWorld.CreateEntityJointHinge ();
                  
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchorEntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (hinge.GetAnchor ());
                  anchorDefine.mEntity = hinge.GetAnchor ();
                  
                  hinge.SetLimitsEnabled (entityDefine.mEnableLimits);
                  hinge.SetLimits (entityDefine.mLowerAngle, entityDefine.mUpperAngle);
                  hinge.mEnableMotor = entityDefine.mEnableMotor;
                  hinge.mMotorSpeed = entityDefine.mMotorSpeed;
                  hinge.mBackAndForth = entityDefine.mBackAndForth;
                  
                  //>>v1.04
                  hinge.mMaxMotorTorque = entityDefine.mMaxMotorTorque;
                  //<<
                  
                  entity = joint = hinge;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
               {
                  var slider:editor.entity.EntityJointSlider = editorWorld.CreateEntityJointSlider ();
                  
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
                  slider.mMaxMotorForce = entityDefine.mMaxMotorForce;
                  //<<
                  
                  entity = joint = slider;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
               {
                  var disJoint:editor.entity.EntityJointDistance = editorWorld.CreateEntityJointDistance ();
                  
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor1EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (disJoint.GetAnchor1 ());
                  anchorDefine.mEntity = disJoint.GetAnchor1 ();
                  anchorDefine = worldDefine.mEntityDefines [entityDefine.mAnchor2EntityIndex];
                  //anchorDefine.mNewIndex = editorWorld.getChildIndex (disJoint.GetAnchor2 ());
                  anchorDefine.mEntity = disJoint.GetAnchor2 ();
                  
                  entity = joint = disJoint;
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  var spring:editor.entity.EntityJointSpring = editorWorld.CreateEntityJointSpring ();
                  
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
                  
                  entity = joint = spring;
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
               entity.SetRotation (entityDefine.mRotation);
               entity.SetVisible (entityDefine.mIsVisible);
               
               entity.UpdateAppearance ();
               entity.UpdateSelectionProxy ();
            }
         }
         
         // re add child, to make the order correct
         while (editorWorld.numChildren > beginningEntityIndex)
            editorWorld.removeChildAt (beginningEntityIndex);
         
         for (entityId = 0; entityId < worldDefine.mEntityDefines.length; ++ entityId)
         {
            entityDefine = worldDefine.mEntityDefines [entityId];
            editorWorld.addChild (entityDefine.mEntity);
         }
         
         // modify
         for (entityId = 0; entityId < worldDefine.mEntityDefines.length; ++ entityId)
         {
            entityDefine = worldDefine.mEntityDefines [entityId];
            
            if ( Define.IsJointAnchorEntity (entityDefine.mEntityType) )
            {
               //trace ("entityDefine.mPosX = " + entityDefine.mPosX + ", entityDefine.mPosY = " + entityDefine.mPosY);
               
               //entity = editorWorld.getChildAt (entityDefine.mNewIndex) as editor.entity.Entity;
               entity = entityDefine.mEntity as editor.entity.Entity;
               entity.SetPosition (entityDefine.mPosX, entityDefine.mPosY);
               entity.SetRotation (entityDefine.mRotation);
               entity.SetVisible (entityDefine.mIsVisible);
               
               entity.UpdateAppearance ();
               entity.UpdateSelectionProxy ();
               
               entity.GetMainEntity ().UpdateAppearance ();
               
               //editorWorld.addChildAt (entity, entityId);
            }
            else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               joint = entityDefine.mEntity as editor.entity.EntityJoint;
               
               // from v1.02
               if (entityDefine.mConnectedShape1Index >= 0)
                  joint.SetConnectedShape1Index (int(entityDefine.mConnectedShape1Index) + beginningEntityIndex);
               else
                  joint.SetConnectedShape1Index (entityDefine.mConnectedShape1Index);
               
               if (entityDefine.mConnectedShape2Index >= 0)
                  joint.SetConnectedShape2Index (int(entityDefine.mConnectedShape2Index) + beginningEntityIndex);
               else
                  joint.SetConnectedShape2Index (entityDefine.mConnectedShape2Index);
               //<<
            }
         }
         
         var groupId:int;
         var brotherIds:Array;
         var entities:Array;
         
         for (groupId = 0; groupId < worldDefine.mBrotherGroupDefines.length; ++ groupId)
         {
            brotherIds = worldDefine.mBrotherGroupDefines [groupId] as Array;
            
            for (entityId = 0; entityId < brotherIds.length; ++ entityId)
            {
               entityDefine = worldDefine.mEntityDefines [brotherIds [entityId]];
               
               //if ( Define.IsJointAnchorEntity (entityDefine.mEntityType) )
               //{
               //   //brotherIds [entityId] = entityDefine.mNewIndex;
               //   brotherIds [entityId] = editorWorld.getChildIndex (entityDefine.mEntity);
               //}
               //else
               {
                  brotherIds [entityId] = brotherIds [entityId] + beginningEntityIndex;
               }
            }
            
            editorWorld.GlueEntitiesByIndices (brotherIds);
         }
        
         return editorWorld;
      }
      
      public static function Xml2WorldDefine (worldXml:XML):WorldDefine
      {
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
               if (element.@name == "camera_center_x")
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
               else
                  trace ("Unkown setting: " + element.@name);
            }
         }
         
         var entityId:int;
         
         for each (element in worldXml.Entities.Entity)
         {
            var entityDefine:Object = XmlElement2EntityDefine (element, worldDefine);
            
            worldDefine.mEntityDefines.push (entityDefine);
         }
         
         // ...
         
         var groupId:int;
         var brotherGroup:Array;
         
         for each (element in worldXml.BrotherGroups.BrotherGroup)
         {
            var numBrothers:int = parseInt (element.@num_brothers);
            var indicesStr:String = element.@brother_indices;
            var indexStrArray:Array = indicesStr.split (/,/);
            
            var brotherIDs:Array = new Array (indexStrArray.length);
            for (entityId = 0; entityId < indexStrArray.length; ++ entityId)
            {
               brotherIDs [entityId] = parseInt (indexStrArray [entityId]);
            }
            
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
         
         return worldDefine;
      }
      
      public static function XmlElement2EntityDefine (element:XML, worldDefine:WorldDefine):Object
      {
         var elementLocalVertex:XML;
         
         var entityDefine:Object = new Object ();
         
         entityDefine.mEntityType = parseInt (element.@entity_type);
         entityDefine.mPosX = parseFloat (element.@x);
         entityDefine.mPosY = parseFloat (element.@y);
         entityDefine.mRotation = parseFloat (element.@r);
         entityDefine.mIsVisible = parseInt (element.@visible) != 0;
         
         if ( Define.IsUtilityEntity (entityDefine.mEntityType) ) // from v1.05
         {
            if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
            {
            }
         }
         else if ( Define.IsShapeEntity (entityDefine.mEntityType) )
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
               entityDefine.mTransparency = parseInt (element.@transparency);
            }
            
            if (worldDefine.mVersion >= 0x0105)
            {
               entityDefine.mBorderTransparency = parseInt (element.@border_transparency);
            }
            
            if ( Define.IsBasicShapeEntity (entityDefine.mEntityType) )
            {
               entityDefine.mAiType = parseInt (element.@ai_type);
               
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
               }
               
               if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
               {
                  entityDefine.mRadius = parseFloat (element.@radius);
                  entityDefine.mAppearanceType = parseInt (element.@appearance_type);
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
               {
                  entityDefine.mHalfWidth = parseFloat (element.@half_width);
                  entityDefine.mHalfHeight = parseFloat (element.@half_height);
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
               {
                  entityDefine.mLocalPoints = new Array ();
                  for each (elementLocalVertex in element.LocalVertices.Vertex)
                  {
                     entityDefine.mLocalPoints.push (new Point (parseFloat (elementLocalVertex.@x), parseFloat (elementLocalVertex.@y)));
                  }
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
               {
                  entityDefine.mCurveThickness = parseInt (element.@curve_thickness);
                  
                  entityDefine.mLocalPoints = new Array ();
                  
                  for each (elementLocalVertex in element.LocalVertices.Vertex)
                  {
                     entityDefine.mLocalPoints.push (new Point (parseFloat (elementLocalVertex.@x), parseFloat (elementLocalVertex.@y)));
                  }
               }
            }
            else
            {
               if (entityDefine.mEntityType == Define.EntityType_ShapeText)
               {
                  entityDefine.mText = element.@text;
                  entityDefine.mAutofitWidth = parseInt (element.@autofit_width) != 0;
                  
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
               }
            }
         }
         else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
         {
            entityDefine.mCollideConnected = parseInt (element.@collide_connected) != 0;
            
            if (worldDefine.mVersion >= 0x0102)
            {
               entityDefine.mConnectedShape1Index = parseInt (element.@connected_shape1_index);
               entityDefine.mConnectedShape2Index = parseInt (element.@connected_shape2_index);
            }
            else
            {
               // ...
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
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
            {
               entityDefine.mAnchor1EntityIndex = parseInt (element.@anchor1_index);
               entityDefine.mAnchor2EntityIndex = parseInt (element.@anchor2_index);
               
               entityDefine.mStaticLengthRatio = parseFloat (element.@static_length_ratio);
               //entityDefine.mFrequencyHz = parseFloat (element.@frequency_hz);
               entityDefine.mSpringType = parseFloat (element.@spring_type);
               
               entityDefine.mDampingRatio = parseFloat (element.@damping_ratio);
            }
         }
         
         return entityDefine;
      }
      
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
         }
         
         // collision category
         
         if (worldDefine.mVersion >= 0x0102)
         {
            byteArray.writeShort (worldDefine.mCollisionCategoryDefines.length);
            for (var ccId:int = 0; ccId < worldDefine.mCollisionCategoryDefines.length; ++ ccId)
            {
               var ccDefine:Object = worldDefine.mCollisionCategoryDefines [ccId];
               
               byteArray.writeUTF (ccDefine.mName);
               byteArray.writeByte (ccDefine.mCollideInternally);
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
         
         // entities
         var entityId:int;
         var vertexId:int;
         
         byteArray.writeShort (worldDefine.mEntityDefines.length);
         
         for (entityId = 0; entityId < worldDefine.mEntityDefines.length; ++ entityId)
         {
            var entityDefine:Object = worldDefine.mEntityDefines [entityId];
            
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
            byteArray.writeFloat (entityDefine.mRotation);
            byteArray.writeByte (entityDefine.mIsVisible);
            
            if ( Define.IsUtilityEntity (entityDefine.mEntityType) ) // from v1.05
            {
               if (entityDefine.mEntityType == Define.EntityType_UtilityCamera)
               {
               }
            }
            else if ( Define.IsShapeEntity (entityDefine.mEntityType) )
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
               
               if ( Define.IsBasicShapeEntity (entityDefine.mEntityType) )
               {
                  if (worldDefine.mVersion >= 0x0105) 
                  {
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
                  }
                  
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                     byteArray.writeFloat (entityDefine.mRadius);
                     byteArray.writeByte (entityDefine.mAppearanceType);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     byteArray.writeFloat (entityDefine.mHalfWidth);
                     byteArray.writeFloat (entityDefine.mHalfHeight);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolygon)
                  {
                     byteArray.writeShort (entityDefine.mLocalPoints.length);
                     for (vertexId = 0; vertexId < entityDefine.mLocalPoints.length; ++ vertexId)
                     {
                        byteArray.writeFloat (entityDefine.mLocalPoints [vertexId].x);
                        byteArray.writeFloat (entityDefine.mLocalPoints [vertexId].y);
                     }
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapePolyline)
                  {
                     byteArray.writeByte (entityDefine.mCurveThickness);
                     
                     byteArray.writeShort (entityDefine.mLocalPoints.length);
                     for (vertexId = 0; vertexId < entityDefine.mLocalPoints.length; ++ vertexId)
                     {
                        byteArray.writeFloat (entityDefine.mLocalPoints [vertexId].x);
                        byteArray.writeFloat (entityDefine.mLocalPoints [vertexId].y);
                     }
                  }
               }
               else // not physics entity
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeText)
                  {
                     byteArray.writeUTF (entityDefine.mText);
                     byteArray.writeByte (entityDefine.mAutofitWidth);
                     
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
                  }
               }
            }
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
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  byteArray.writeShort (entityDefine.mAnchor1EntityIndex);
                  byteArray.writeShort (entityDefine.mAnchor2EntityIndex);
                  
                  byteArray.writeFloat (entityDefine.mStaticLengthRatio);
                  //byteArray.writeFloat (entityDefine.mFrequencyHz);
                  byteArray.writeByte (entityDefine.mSpringType);
                  
                  byteArray.writeFloat (entityDefine.mDampingRatio);
               }
            }
         }
         
         // ...
         
         var groupId:int;
         var brotherIDs:Array;
         
         byteArray.writeShort (worldDefine.mBrotherGroupDefines.length);
         
         for (groupId = 0; groupId < worldDefine.mBrotherGroupDefines.length; ++ groupId)
         {
            brotherIDs = worldDefine.mBrotherGroupDefines [groupId] as Array;
            
            byteArray.writeShort (brotherIDs.length);
            
            for (entityId = 0; entityId < brotherIDs.length; ++ entityId)
            {
               byteArray.writeShort (brotherIDs [entityId]);
            }
         }
         
         return byteArray;
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
         
         return DataFormat2.Value2Char (n1) + DataFormat2.Value2Char (n2);
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
            
            enStr = enStr + DataFormat2.Value2Char (DataFormat2.Char2Value (code), num);
         }
         
         return enStr;
      }
      
   }
   
}