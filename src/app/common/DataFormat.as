
package common {
   
   import flash.utils.ByteArray;
   
   import editor.world.World;
   import editor.entity.Entity;
   import editor.entity.EntityShape
   import editor.entity.EntityShapeCircle;
   import editor.entity.EntityShapeRectangle;
   import editor.entity.EntityShapeText;
   import editor.entity.EntityJoint;
   import editor.entity.EntityJointHinge;
   import editor.entity.EntityJointSlider;
   import editor.entity.EntityJointDistance;
   import editor.entity.SubEntityJointAnchor;
   
   import player.world.World;
   import player.entity.ShapeContainer;
   
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
         worldDefine.mVersion = Config.VersionNumber;
         
         worldDefine.mAuthorName = editorWorld.GetAuthorName ();
         worldDefine.mAuthorHomepage = editorWorld.GetAuthorHomepage ();
         
         //>>from v1.02
         worldDefine.mShareSourceCode = editorWorld.IsShareSourceCode ();
         worldDefine.mPermitPublishing = editorWorld.IsPermitPublishing ();
         //<<
         
         var entityId:int;
         var editorEntity:editor.entity.Entity;
         
         for (entityId = 0; entityId < editorWorld.numChildren; ++ entityId)
         {
            var child:Object = editorWorld.getChildAt (entityId);
            
            var entityDefine:Object = new Object ();
            
            entityDefine.mPosX = (child as Entity).GetPositionX ();
            entityDefine.mPosY = (child as Entity).GetPositionY ();
            entityDefine.mRotation = (child as Entity).GetRotation ();
            entityDefine.mIsVisible = (child as Entity).IsVisible ();
            
            if (child is editor.entity.EntityShape)
            {
               var shape:editor.entity.EntityShape = child as editor.entity.EntityShape;
               
               //>>from v1.02
               entityDefine.mDrawBorder = shape.IsDrawBorder ();
               entityDefine.mDrawBackground = shape.IsDrawBackground ();
               //<<
               
               if (shape.IsPhysicsEntity ())
               {
                  //>>from v1.02
                  entityDefine.mCollisionCategoryIndex = shape.GetCollisionCategoryIndex ();
                  //<<
               
                  entityDefine.mAiType = Define.GetShapeAiType ( shape.GetFilledColor ());
                  
                  entityDefine.mIsStatic = shape.IsStatic ();
                  entityDefine.mIsBullet = shape.mIsBullet;
                  entityDefine.mDensity = shape.mDensity;
                  entityDefine.mFriction = shape.mFriction;
                  entityDefine.mRestitution = shape.mRestitution;
                  
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
                     
                     entityDefine.mIsInteractive = (shape as editor.entity.EntityShapeGravityController).IsInteractive ();
                     entityDefine.mInitialGravityAcceleration = (shape as editor.entity.EntityShapeGravityController).GetInitialGravityAcceleration ();
                     entityDefine.mInitialGravityAngle = (shape as editor.entity.EntityShapeGravityController).GetInitialGravityAngle ();
                  }
                  //<<
               }
            }
            else if (child is editor.entity.EntityJoint)
            {
               var joint:editor.entity.EntityJoint = (child as editor.entity.EntityJoint);
               
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
            else if (child is editor.entity.SubEntityJointAnchor)
            {
               entityDefine.mEntityType = Define.SubEntityType_JointAnchor;
            }
            else
            {
               entityDefine.mEntityType = Define.EntityType_Unkonwn;
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
      
      public static function WorldDefine2EditorWorld (worldDefine:WorldDefine):editor.world.World
      {
         // from v1,03
         DataFormat2.AdjustNumberValuesInWorldDefine (worldDefine);
         
         //
         var editorWorld:editor.world.World = new editor.world.World ();
         
         editorWorld.SetAuthorName (worldDefine.mAuthorName);
         editorWorld.SetAuthorHomepage (worldDefine.mAuthorHomepage);
         
         if (worldDefine.mVersion >= 0x0102)
         {
            editorWorld.SetShareSourceCode (worldDefine.mShareSourceCode);
            editorWorld.SetPermitPublishing (worldDefine.mPermitPublishing);
         }
         else
         {
            // default
         }
         
         // collision category
         
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
               
               editorWorld.CreateEntityCollisionCategoryFriendLink (pairDefine.mCollisionCategory1Index, pairDefine.mCollisionCategory2Index);
            }
         }
         
         // entities
         
         var entityId:int;
         var entityDefine:Object;
         var entity:editor.entity.Entity;
         var shape:editor.entity.EntityShape;
         var anchorDefine:Object;
         var joint:editor.entity.EntityJoint;
         
         for (entityId = 0; entityId < worldDefine.mEntityDefines.length; ++ entityId)
         {
            entityDefine = worldDefine.mEntityDefines [entityId];
            
            entity = null;
            
            if ( Define.IsShapeEntity (entityDefine.mEntityType) )
            {
               shape = null;
               
               if ( Define.IsPhysicsShapeEntity (entityDefine.mEntityType) )
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                     var circle:editor.entity.EntityShapeCircle = editorWorld.CreateEntityShapeCircle ();
                     circle.SetFilledColor (Define.GetShapeFilledColor (entityDefine.mAiType));
                     circle.SetAppearanceType (entityDefine.mAppearanceType);
                     circle.SetRadius (entityDefine.mRadius);
                     
                     entity = shape = circle;
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     var rect:editor.entity.EntityShapeRectangle = editorWorld.CreateEntityShapeRectangle ();
                     rect.SetFilledColor (Define.GetShapeFilledColor (entityDefine.mAiType));
                     rect.SetHalfWidth (entityDefine.mHalfWidth);
                     rect.SetHalfHeight (entityDefine.mHalfHeight);
                     
                     entity = shape = rect;
                  }
                  
                  shape.SetStatic (entityDefine.mIsStatic);
                  shape.mIsBullet = entityDefine.IsBullet;
                  shape.mDensity = entityDefine.mDensity;
                  shape.mFriction = entityDefine.mFriction;
                  shape.mRestitution = entityDefine.mRestitution;
                  
                  if (worldDefine.mVersion >= 0x0102)
                  {
                     shape.SetCollisionCategoryIndex (entityDefine.mCollisionCategoryIndex);
                  }
                  else
                  {
                     shape.SetCollisionCategoryIndex (Define.CollisionCategoryId_HiddenCategory);
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
                     
                     gController.SetInteractive (entityDefine.mIsInteractive)
                     gController.SetInitialGravityAcceleration (entityDefine.mInitialGravityAcceleration)
                     gController.SetInitialGravityAngle (entityDefine.mInitialGravityAngle)
                     
                     entity = shape = gController;
                  }
                  //<<
               }
               
               if (worldDefine.mVersion >= 0x0102)
               {
                  shape.SetDrawBorder (entityDefine.mDrawBorder);
                  shape.SetDrawBackground (entityDefine.mDrawBackground);
               }
               else
               {
                  shape.SetDrawBorder ( (! entityDefine.mIsStatic) || Define.IsBreakableShape (entityDefine.mAiType) );
                  shape.SetDrawBackground (true);
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
         
         // re add child
         while (editorWorld.numChildren > 0)
            editorWorld.removeChildAt (0);
         
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
               
               if (worldDefine.mVersion >= 0x0102)
               {
                  joint.SetConnectedShape1Index (entityDefine.mConnectedShape1Index);
                  joint.SetConnectedShape2Index (entityDefine.mConnectedShape2Index);
               }
               else
               {
                  // default
               }
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
               
               if ( Define.IsJointAnchorEntity (entityDefine.mEntityType) )
               {
                  //brotherIds [entityId] = entityDefine.mNewIndex;
                  brotherIds [entityId] = editorWorld.getChildIndex (entityDefine.mEntity);
               }
            }
            
            editorWorld.GlueEntitiesByIndices (brotherIds);
         }
        
         return editorWorld;
      }
      
      public static function Xml2WorldDefine (worldXml:XML):WorldDefine
      {
         var worldDefine:WorldDefine = new WorldDefine ();
         
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
         
        var element:XML;
         
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
         var entityDefine:Object = new Object ();
         
         entityDefine.mEntityType = parseInt (element.@entity_type);
         entityDefine.mPosX = parseFloat (element.@x);
         entityDefine.mPosY = parseFloat (element.@y);
         entityDefine.mRotation = parseFloat (element.@r);
         entityDefine.mIsVisible = parseInt (element.@visible) != 0;
         
         if ( Define.IsShapeEntity (entityDefine.mEntityType) )
         {
            if (worldDefine.mVersion >= 0x0102)
            {
               entityDefine.mDrawBorder = parseInt (element.@draw_border) != 0;
               entityDefine.mDrawBackground = parseInt (element.@draw_background) != 0;
            }
            
            if ( Define.IsPhysicsShapeEntity (entityDefine.mEntityType) )
            {
               if (worldDefine.mVersion >= 0x0102)
               {
                  entityDefine.mCollisionCategoryIndex = element.@collision_category_index;
               }
               
               entityDefine.mAiType = parseInt (element.@ai_type);
               
               entityDefine.mIsStatic = parseInt (element.@is_static) != 0;
               entityDefine.mIsBullet = parseInt (element.@is_bullet) != 0;
               entityDefine.mDensity = parseFloat (element.@density);
               entityDefine.mFriction = parseFloat (element.@friction);
               entityDefine.mRestitution = parseFloat (element.@restitution);
               
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
                  
                  entityDefine.mIsInteractive = parseInt (element.@autofit_width) != 0;
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
         
         // version, author
         byteArray.writeShort (worldDefine.mVersion);
         byteArray.writeUTF (worldDefine.mAuthorName);
         byteArray.writeUTF (worldDefine.mAuthorHomepage);
         
         if (worldDefine.mVersion >= 0x0102)
         {
            byteArray.writeByte (worldDefine.mShareSourceCode ? 1 : 0);
            byteArray.writeByte (worldDefine.mPermitPublishing ? 1 : 0);
         }
         
         // removed since v1.02
         if (worldDefine.mVersion < 0x0102)
         {
            // hex
            byteArray.writeByte ("H".charCodeAt (0));
            byteArray.writeByte ("E".charCodeAt (0));
            byteArray.writeByte ("X".charCodeAt (0));
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
            
            if ( Define.IsShapeEntity (entityDefine.mEntityType) )
            {
               if (worldDefine.mVersion >= 0x0102)
               {
                  byteArray.writeByte (entityDefine.mDrawBorder);
                  byteArray.writeByte (entityDefine.mDrawBackground);
               }
               
               if ( Define.IsPhysicsShapeEntity (entityDefine.mEntityType) )
               {
                  if (worldDefine.mVersion >= 0x0102)
                  {
                     byteArray.writeShort (entityDefine.mCollisionCategoryIndex);
                  }
                  
                  byteArray.writeByte (entityDefine.mAiType);
                  byteArray.writeByte (entityDefine.mIsStatic);
                  byteArray.writeByte (entityDefine.mIsBullet);
                  byteArray.writeFloat (entityDefine.mDensity);
                  byteArray.writeFloat (entityDefine.mFriction);
                  byteArray.writeFloat (entityDefine.mRestitution);
                  
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
                     
                     byteArray.writeByte (entityDefine.mIsInteractive);
                     byteArray.writeFloat (entityDefine.mInitialGravityAcceleration);
                     byteArray.writeShort (entityDefine.mInitialGravityAngle);
                  }
               }
            }
            else if (Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               byteArray.writeByte (entityDefine.mCollideConnected);
               
               if (worldDefine.mVersion >= 0x0102)
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