
package common {
   
   import flash.utils.ByteArray;
   
   import player.world.World;
   import player.entity.ShapeContainer;
   
   public class DataFormat2
   {
      
      
      
//===========================================================================
// 
//===========================================================================
      
      public static function WorldDefine2PlayerWorld (worldDefine:WorldDefine):player.world.World
      {
         // from v1,03
         if (worldDefine.mVersion >= 0x0103)
         {
            DataFormat2.AdjustNumberValuesInWorldDefine (worldDefine);
         }
         
         //
         var playerWorld:player.world.World = new player.world.World (worldDefine.mVersion);
         
         playerWorld.SetAuthorName (worldDefine.mAuthorName);
         playerWorld.SetAuthorHomepage (worldDefine.mAuthorHomepage);
         
         if (worldDefine.mVersion >= 0x0102)
         {
            playerWorld.SetShareSourceCode (worldDefine.mShareSourceCode);
            playerWorld.SetPermitPublishing (worldDefine.mPermitPublishing);
         }
         else
         {
            // default
         }
         
         // collision category
         
         if (worldDefine.mVersion >= 0x0102)
         {
            for (var ccId:int = 0; ccId < worldDefine.mCollisionCategoryDefines.length; ++ ccId)
            {
               var ccDefine:Object = worldDefine.mCollisionCategoryDefines [ccId];
               
               playerWorld.CreateCollisionCategory (ccDefine);
            }
            
            for (var pairId:int = 0; pairId < worldDefine.mCollisionCategoryFriendLinkDefines.length; ++ pairId)
            {
               var pairDefine:Object = worldDefine.mCollisionCategoryFriendLinkDefines [pairId];
               
               playerWorld.CreateCollisionCategoryFriendLink (pairDefine.mCollisionCategory1Index, pairDefine.mCollisionCategory2Index);
            }
         }
         
         var entityDefineArray:Array = worldDefine.mEntityDefines;
         var brotherGroupArray:Array = worldDefine.mBrotherGroupDefines;
         var groupId:int;
         var brotherGroup:Array;
         var entityId:int;
         var entityDefine:Object;
         var i:int;
         var shapeContainer:player.entity.ShapeContainer;
         var params:Object;
         var entity:player.entity.Entity;
         var shape:player.entity.EntityShape;
         
      // crete shape containers
         
         for (groupId = 0; groupId < brotherGroupArray.length; ++ groupId)
         {
            brotherGroup = brotherGroupArray [groupId] as Array;
            
            var numPhyShapes:int = 0;
            var centerX:Number = 0;
            var centerY:Number = 0;
            for (i = 0; i < brotherGroup.length; ++ i)
            {
               entityId = brotherGroup [i];
               entityDefine = entityDefineArray [entityId];
               
               if ( Define.IsPhysicsShapeEntity (entityDefine.mEntityType) )
               {
                  numPhyShapes ++;
                  centerX += entityDefine.mPosX;
                  centerY += entityDefine.mPosY;
               }
            }
            
            if ( numPhyShapes == 0)
               continue;
            
            params = new Object ();
            params.mContainsPhysicsShapes = true;
            params.mWorldDefine = worldDefine;
            params.mPosX = centerX / numPhyShapes;
            params.mPosY = centerY / numPhyShapes;
            
            shapeContainer = playerWorld.CreateShapeContainer (params, true);
            
            for (i = 0; i < brotherGroup.length; ++ i)
            {
               entityId = brotherGroup [i];
               entityDefine = entityDefineArray [entityId];
               
               entityDefine.mShapeContainer = shapeContainer;
            }
         }
         
         
      // create shapes
         
         for (entityId = 0; entityId < entityDefineArray.length; ++ entityId)
         {
            entity = null;
            
            entityDefine = entityDefineArray [entityId];
            
            // >> starts from version 1.01
            entityDefine.mWorldDefine = worldDefine;
            entityDefine.mEntityId = entityId;
            // <<
            
            if ( Define.IsShapeEntity (entityDefine.mEntityType) )
            {
               shape = null;
               
               shapeContainer = entityDefine.mShapeContainer;
               if (shapeContainer == null)
               {
                  params = new Object ();
                  params.mContainsPhysicsShapes = Define.IsPhysicsShapeEntity (entityDefine.mEntityType);
                  params.mWorldDefine = worldDefine;
                  params.mPosX = entityDefine.mPosX;
                  params.mPosY = entityDefine.mPosY;
                  
                  shapeContainer = playerWorld.CreateShapeContainer (params, true);
               }
               
               if (worldDefine.mVersion >= 0x0102)
               {
                  // already set
               }
               else
               {
                  entityDefine.mDrawBorder = (! entityDefine.mIsStatic || Define.IsBreakableShape (entityDefine.mAiType));
                  entityDefine.mDrawBackground = true;
               }
               
               if ( Define.IsPhysicsShapeEntity (entityDefine.mEntityType) )
               {
                  if (worldDefine.mVersion >= 0x0102)
                  {
                     // already set
                  }
                  else
                  {
                     entityDefine.mCollisionCategoryIndex = Define.CollisionCategoryId_HiddenCategory;
                  }
                  
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                     entity = shape = playerWorld.CreateEntityShapeCircle (shapeContainer, entityDefine);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     entity = shape = playerWorld.CreateEntityShapeRectangle (shapeContainer, entityDefine);
                  }
               }
               else // not physics shape
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeText)
                  {
                     entityDefine.mAiType = Define.ShapeAiType_Unkown;
                     entityDefine.mIsStatic = false;
                     entityDefine.mIsBullet = false;
                     entityDefine.mDensity = 1.0;
                     entityDefine.mFriction = 0.1;
                     entityDefine.mRestitution = 0.2;
                     
                     entity = shape = playerWorld.CreateEntityShapeText (shapeContainer, entityDefine);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                  {
                     entityDefine.mAiType = Define.ShapeAiType_Unkown;
                     entityDefine.mIsStatic = false;
                     entityDefine.mIsBullet = false;
                     entityDefine.mDensity = 1.0;
                     entityDefine.mFriction = 0.1;
                     entityDefine.mRestitution = 0.2;
                     entityDefine.mAppearanceType = Define.CircleAppearanceType_Ball;
                     
                     entity = shape = playerWorld.CreateEntityShapeGravityController (shapeContainer, entityDefine);
                  }
               }
            }
            
            if (entity != null)
            {
               entityDefine.mEntity = entity;
            }
         }
         
      // update z-order and masses
         
         playerWorld.UpdateShapeLayers ();
         playerWorld.UpdateShapeMasses (); // 
         
      // create joints
         
         for (entityId = 0; entityId < entityDefineArray.length; ++ entityId)
         {
            entityDefine = entityDefineArray [entityId];
            
            if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               if (worldDefine.mVersion >= 0x0102)
               {
                  if  (entityDefine.mConnectedShape1Index == Define.EntityId_Ground)
                     entityDefine.mConnectedShape1 = playerWorld.GetPhysicsEngine ();
                  else if (entityDefine.mConnectedShape1Index >= 0)
                  {
                     shape = worldDefine.mEntityDefines [entityDefine.mConnectedShape1Index].mEntity as player.entity.EntityShape;
                     entityDefine.mConnectedShape1 = shape.GetPhysicsProxy ();
                  }
                  else
                     entityDefine.mConnectedShape1 = null;
                     
                  if  (entityDefine.mConnectedShape2Index == Define.EntityId_Ground)
                     entityDefine.mConnectedShape2 = playerWorld.GetPhysicsEngine ();
                  else if (entityDefine.mConnectedShape2Index >= 0)
                  {
                     shape = worldDefine.mEntityDefines [entityDefine.mConnectedShape2Index].mEntity as player.entity.EntityShape;
                     entityDefine.mConnectedShape2 = shape.GetPhysicsProxy ();
                  }
                  else
                     entityDefine.mConnectedShape2 = null;
               }
               else
               {
                  entityDefine.mConnectedShape1 = null; // auto
                  entityDefine.mConnectedShape2 = null; // auto
               }
               
               if (entityDefine.mEntityType == Define.EntityType_JointHinge)
               {
                  entityDefine.mAnchorParams = entityDefineArray [entityDefine.mAnchorEntityIndex];
                  
                  playerWorld.CreateEntityJointHinge (entityDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
               {
                  entityDefine.mAnchor1Params = entityDefineArray [entityDefine.mAnchor1EntityIndex];
                  entityDefine.mAnchor2Params = entityDefineArray [entityDefine.mAnchor2EntityIndex];
                  
                  playerWorld.CreateEntityJointSlider (entityDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
               {
                  entityDefine.mAnchor1Params = entityDefineArray [entityDefine.mAnchor1EntityIndex];
                  entityDefine.mAnchor2Params = entityDefineArray [entityDefine.mAnchor2EntityIndex];
                  
                  playerWorld.CreateEntityJointDistance (entityDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  entityDefine.mAnchor1Params = entityDefineArray [entityDefine.mAnchor1EntityIndex];
                  entityDefine.mAnchor2Params = entityDefineArray [entityDefine.mAnchor2EntityIndex];
                  
                  playerWorld.CreateEntityJointSpring (entityDefine);
               }
            }
         }
         
         return playerWorld;
      }
      
      public static function ByteArray2WorldDefine (byteArray:ByteArray):WorldDefine
      {
         var worldDefine:WorldDefine = new WorldDefine ();
         
         // COlor INfection
         byteArray.readByte (); // "C".charCodeAt (0);
         byteArray.readByte (); // "O".charCodeAt (0);
         byteArray.readByte (); // "I".charCodeAt (0);
         byteArray.readByte (); // "N".charCodeAt (0);
         
         // version
         worldDefine.mVersion = byteArray.readShort ();
         worldDefine.mAuthorName = byteArray.readUTF ();
         worldDefine.mAuthorHomepage = byteArray.readUTF ();
         
         if (worldDefine.mVersion >= 0x0102)
         {
            worldDefine.mShareSourceCode = byteArray.readByte () != 0;
            worldDefine.mPermitPublishing = byteArray.readByte () != 0;
         }
         
         if (worldDefine.mVersion < 0x0102)
         {
            // the 3 bytes are removed since v1.02
            // hex
            byteArray.readByte (); // "H".charCodeAt (0);
            byteArray.readByte (); // "E".charCodeAt (0);
            byteArray.readByte (); // "X".charCodeAt (0);
         }
         
         // collision category
         
         if (worldDefine.mVersion >= 0x0102)
         {
            var numCategories:int = byteArray.readShort ();
            for (var ccId:int = 0; ccId < numCategories; ++ ccId)
            {
               var ccDefine:Object = new Object ();
               
               ccDefine.mName = byteArray.readUTF ();
               ccDefine.mCollideInternally = byteArray.readByte ();
               ccDefine.mPosX = byteArray.readFloat ();
               ccDefine.mPosY = byteArray.readFloat ();
               
               worldDefine.mCollisionCategoryDefines.push (ccDefine);
            }
            
            worldDefine.mDefaultCollisionCategoryIndex = byteArray.readShort ();
            
            var numPairs:int = byteArray.readShort ();
            for (var pairId:int = 0; pairId < numPairs; ++ pairId)
            {
               var pairDefine:Object = new Object ();
               pairDefine.mCollisionCategory1Index = byteArray.readShort ();
               pairDefine.mCollisionCategory2Index = byteArray.readShort ();
               
               worldDefine.mCollisionCategoryFriendLinkDefines.push (pairDefine);
            }
         }
         
         // entities
         
         var numEntities:int = byteArray.readShort ();
         
         var entityId:int;
         
         for (entityId = 0; entityId < numEntities; ++ entityId)
         {
            var entityDefine:Object = new Object ();
            
            entityDefine.mEntityType = byteArray.readShort ();
            if (worldDefine.mVersion >= 0x0103)
            {
               entityDefine.mPosX = byteArray.readDouble ();
               entityDefine.mPosY = byteArray.readDouble ();
            }
            else
            {
               entityDefine.mPosX = byteArray.readFloat ();
               entityDefine.mPosY = byteArray.readFloat ();
            }
            entityDefine.mRotation = byteArray.readFloat ();
            entityDefine.mIsVisible = byteArray.readByte ();
            
            if ( Define.IsShapeEntity (entityDefine.mEntityType) )
            {
               if (worldDefine.mVersion >= 0x0102)
               {
                  entityDefine.mDrawBorder = byteArray.readByte ();
                  entityDefine.mDrawBackground = byteArray.readByte ();
               }
               
               if ( Define.IsPhysicsShapeEntity (entityDefine.mEntityType) )
               {
                  if (worldDefine.mVersion >= 0x0102)
                  {
                     entityDefine.mCollisionCategoryIndex = byteArray.readShort ();
                  }
                  
                  entityDefine.mAiType = byteArray.readByte ();
                  entityDefine.mIsStatic = byteArray.readByte ();
                  entityDefine.mIsBullet = byteArray.readByte ();
                  entityDefine.mDensity = byteArray.readFloat ();
                  entityDefine.mFriction = byteArray.readFloat ();
                  entityDefine.mRestitution = byteArray.readFloat ();
                  
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                     entityDefine.mRadius = byteArray.readFloat ();
                     entityDefine.mAppearanceType = byteArray.readByte ();
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     entityDefine.mHalfWidth = byteArray.readFloat ();
                     entityDefine.mHalfHeight = byteArray.readFloat ();
                  }
               }
               else // not physis shape
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeText)
                  {
                     entityDefine.mText = byteArray.readUTF ();
                     entityDefine.mAutofitWidth = byteArray.readByte ();
                     
                     entityDefine.mHalfWidth = byteArray.readFloat ();
                     entityDefine.mHalfHeight = byteArray.readFloat ();
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                  {
                     entityDefine.mRadius = byteArray.readFloat ();
                     
                     entityDefine.mIsInteractive = byteArray.readByte ();
                     entityDefine.mInitialGravityAcceleration = byteArray.readFloat ();
                     entityDefine.mInitialGravityAngle = byteArray.readShort ();
                  }
               }
            }
            else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               entityDefine.mCollideConnected = byteArray.readByte ();
               
               if (worldDefine.mVersion >= 0x0102)
               {
                  entityDefine.mConnectedShape1Index = byteArray.readByte ();
                  entityDefine.mConnectedShape2Index = byteArray.readByte ();
               }
               
               if (entityDefine.mEntityType == Define.EntityType_JointHinge)
               {
                  entityDefine.mAnchorEntityIndex = byteArray.readShort ();
                  
                  entityDefine.mEnableLimits = byteArray.readByte ();
                  entityDefine.mLowerAngle = byteArray.readFloat ();
                  entityDefine.mUpperAngle = byteArray.readFloat ();
                  entityDefine.mEnableMotor = byteArray.readByte ();
                  entityDefine.mMotorSpeed = byteArray.readFloat ();
                  entityDefine.mBackAndForth = byteArray.readByte ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
               {
                  entityDefine.mAnchor1EntityIndex = byteArray.readShort ();
                  entityDefine.mAnchor2EntityIndex = byteArray.readShort ();
                  
                  entityDefine.mEnableLimits = byteArray.readByte ();
                  entityDefine.mLowerTranslation = byteArray.readFloat ();
                  entityDefine.mUpperTranslation = byteArray.readFloat ();
                  entityDefine.mEnableMotor = byteArray.readByte ();
                  entityDefine.mMotorSpeed = byteArray.readFloat ();
                  entityDefine.mBackAndForth = byteArray.readByte ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
               {
                  entityDefine.mAnchor1EntityIndex = byteArray.readShort ();
                  entityDefine.mAnchor2EntityIndex = byteArray.readShort ();
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  entityDefine.mAnchor1EntityIndex = byteArray.readShort ();
                  entityDefine.mAnchor2EntityIndex = byteArray.readShort ();
                  
                  entityDefine.mStaticLengthRatio = byteArray.readFloat ();
                  //entityDefine.mFrequencyHz = byteArray.readFloat ();
                  entityDefine.mSpringType = byteArray.readByte ();
                  
                  entityDefine.mDampingRatio = byteArray.readFloat ();
               }
            }
            
            worldDefine.mEntityDefines.push (entityDefine);
         }
         
         // ...
         
         var numGroups:int = byteArray.readShort ();
         var numEntityIds:int;
         
         var groupId:int;
         
         for (groupId = 0; groupId < numGroups; ++ groupId)
         {
            var brotherIDs:Array = new Array ();
            
            numEntityIds = byteArray.readShort ();
            
            for (entityId = 0; entityId < numEntityIds; ++ entityId)
            {
               brotherIDs.push (byteArray.readShort ());
            }
            
            worldDefine.mBrotherGroupDefines.push (brotherIDs);
         }
         
         
         
         return worldDefine;
      }
      
      public static function HexString2WorldDefine (hexString:String):WorldDefine
      {
         return ByteArray2WorldDefine ( HexString2ByteArray (hexString) );
      }
      
      public static function HexString2ByteArray (hexString:String):ByteArray
      {
         if (hexString == null)
            return null;
         
         hexString = De (hexString);
         
         var byteArray:ByteArray = new ByteArray ();
         byteArray.length = hexString.length / 2;
         
         var index:int = 0;
         
         for (var ci:int = 0; ci < hexString.length; ci += 2)
         {
            byteArray [index ++] = ParseByteFromHexString (hexString.substr (ci, 2));
         }
         
         return byteArray;
      }
      
      public static function ParseByteFromHexString (hexString:String):int
      {
         if (hexString == null || hexString.length != 2)
            return NaN;
         
         var byteValue:int = parseInt (hexString, 16);
         //if ( isNaN (byteValue))
         //{
         //   byteValue -= 128;
         //}
         
         return byteValue;
      }
      
      public static const Value2CharTable:String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,.";
      
      public static function Value2Char (value:int, num:uint = 1):String
      {
         if (value < 0 || value >= 16 || num > 4 || num <= 0)
            return "?";
         
         return Value2CharTable.charAt (value + (num - 1) * 16);
      }
      
      public static var Char2ValueTable:Array = null;
      
      public static function Char2Value (charCode:int):int
      {
         if (Char2ValueTable == null)
         {
            Char2ValueTable = new Array (128);
            for (var i:int = 0; i < Char2ValueTable.length; ++ i)
               Char2ValueTable [i] = -1;
            for (var k:int = 0; k < Value2CharTable.length; ++ k)
               Char2ValueTable [Value2CharTable.charCodeAt (k)] = k;
         }
         
         if (charCode < 0 || charCode >= Char2ValueTable.length)
            return -1;
         
         return Char2ValueTable [charCode];
      }
      
      public static function De (enStr:String):String
      {
         var str:String = "";
         
         var char:String;
         var value:int;
         var num:int;
         for (var i:int = 0; i < enStr.length; ++ i)
         {
            value = Char2Value (enStr.charCodeAt (i));
            
            if (value >= 0 && value < 64)
            {
               num = ( (value & 0x3F) >> 4 ) + 1;
               value = value & 0xF;
               
               char =  Value2Char (value);
               for (var k:int = 0; k < num; ++ k)
                  str = str + char;
            }
            else
            {
               trace ("De str error! pos = " + i + ", value = " + value + ", char = " +  enStr.charAt (i));
               break;
            }
         }
         
         return str;
      }
      
//====================================================================================
//   
//====================================================================================
      
      public static function WorldDefine2Xml (worldDefine:WorldDefine):XML
      {
         // from v1,03
         DataFormat2.AdjustNumberValuesInWorldDefine (worldDefine);
         
         // ...
         var xml:XML = <World />;
         
         xml.@app_id  = "COIN";
         xml.@version = int(worldDefine.mVersion).toString (16);
         xml.@author_name = worldDefine.mAuthorName;
         xml.@author_homepage = worldDefine.mAuthorHomepage;
         
         if (worldDefine.mVersion >= 0x0102)
         {
            xml.@share_source_code = worldDefine.mShareSourceCode ? 1 : 0;
            xml.@permit_publishing = worldDefine.mPermitPublishing ? 1 : 0;
         }
         
         var element:Object;
         
         xml.Entities = <Entities />
         
         // entities
         var entityId:int;
         
         for (entityId = 0; entityId < worldDefine.mEntityDefines.length; ++ entityId)
         {
            var entityDefine:Object = worldDefine.mEntityDefines [entityId];
            element = EntityDefine2XmlElement (entityDefine, worldDefine);
            
            xml.Entities.appendChild (element);
         }
         
         // ...
         
         xml.BrotherGroups = <BrotherGroups />
         
         var groupId:int;
         var brotherIDs:Array;
         var idsStr:String;
         
         for (groupId = 0; groupId < worldDefine.mBrotherGroupDefines.length; ++ groupId)
         {
            brotherIDs = worldDefine.mBrotherGroupDefines [groupId];
            
            idsStr = "";
            for (entityId = 0; entityId < brotherIDs.length; ++ entityId)
            {
               if (entityId != 0)
                  idsStr += ",";
               idsStr += brotherIDs [entityId];
            }
            
            element = <BrotherGroup />;
            element.@num_brothers = brotherIDs.length;
            element.@brother_indices = idsStr;
            xml.BrotherGroups.appendChild (element);
         }
         
         // collision category
         
         if (worldDefine.mVersion >= 0x0102)
         {
            xml.CollisionCategories = <CollisionCategories />
            
            for (var ccId:int = 0; ccId < worldDefine.mCollisionCategoryDefines.length; ++ ccId)
            {
               var ccDefine:Object = worldDefine.mCollisionCategoryDefines [ccId];
               
               element = <CollisionCategory />;
               element.@name = ccDefine.mName;
               element.@collide_internally = ccDefine.mCollideInternally ? 1 : 0;
               element.@x = ccDefine.mPosX;
               element.@y = ccDefine.mPosY;
               
               xml.CollisionCategories.appendChild (element);
            }
            
            xml.CollisionCategories.@default_category_index = worldDefine.mDefaultCollisionCategoryIndex;
            
            xml.CollisionCategoryFriendPairs = <CollisionCategoryFriendPairs />
            
            for (var pairId:int = 0; pairId < worldDefine.mCollisionCategoryFriendLinkDefines.length; ++ pairId)
            {
               var pairDefine:Object = worldDefine.mCollisionCategoryFriendLinkDefines [pairId];
               
               element = <CollisionCategoryFriendPair />;
               element.@category1_index = pairDefine.mCollisionCategory1Index;
               element.@category2_index = pairDefine.mCollisionCategory2Index;
               xml.CollisionCategoryFriendPairs.appendChild (element);
            }
         }
         
         return xml;
      }
      
      public static function EntityDefine2XmlElement (entityDefine:Object, worldDefine:WorldDefine):Object
      {
         var element:Object = <Entity />;
         element.@entity_type = entityDefine.mEntityType;
         element.@x = entityDefine.mPosX;
         element.@y = entityDefine.mPosY;
         element.@r = entityDefine.mRotation;
         element.@visible = entityDefine.mIsVisible ? 1 : 0;
         
         if ( Define.IsShapeEntity (entityDefine.mEntityType) )
         {
            if (worldDefine.mVersion >= 0x0102)
            {
               element.@draw_border = entityDefine.mDrawBorder ? 1 : 0;
               element.@draw_background = entityDefine.mDrawBackground ? 1 : 0;
            }
            
            if ( Define.IsPhysicsShapeEntity (entityDefine.mEntityType) )
            {
               if (worldDefine.mVersion >= 0x0102)
               {
                  element.@collision_category_index = entityDefine.mCollisionCategoryIndex;
               }
               
               element.@ai_type = entityDefine.mAiType;
               element.@is_static = entityDefine.mIsStatic ? 1 : 0;
               element.@is_bullet = entityDefine.mIsBullet ? 1 : 0;
               element.@density = entityDefine.mDensity;
               element.@friction = entityDefine.mFriction;
               element.@restitution = entityDefine.mRestitution;
               
               if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
               {
                  element.@radius = entityDefine.mRadius;
                  element.@appearance_type = entityDefine.mAppearanceType;
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
               {
                  element.@half_width = entityDefine.mHalfWidth;
                  element.@half_height = entityDefine.mHalfHeight;
               }
            }
            else // not physics shape
            {
               if (entityDefine.mEntityType == Define.EntityType_ShapeText)
               {
                  element.@text = entityDefine.mText;
                  element.@autofit_width = entityDefine.mAutofitWidth ? 1 : 0;
                  
                  element.@half_width = entityDefine.mHalfWidth;
                  element.@half_height = entityDefine.mHalfHeight;
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
               {
                  element.@radius = entityDefine.mRadius;
                  
                  element.@interactive = entityDefine.mIsInteractive ? 1 : 0;
                  element.@initial_gravity_acceleration = entityDefine.mInitialGravityAcceleration;
                  element.@initial_gravity_angle = entityDefine.mInitialGravityAngle;
               }
            }
         }
         else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
         {
            element.@collide_connected = entityDefine.mCollideConnected ? 1 : 0;
            
            if (worldDefine.mVersion >= 0x0102)
            {
               element.@connected_shape1_index = entityDefine.mConnectedShape1Index;
               element.@connected_shape2_index = entityDefine.mConnectedShape2Index;
            }
            
            if (entityDefine.mEntityType == Define.EntityType_JointHinge)
            {
               element.@anchor_index = entityDefine.mAnchorEntityIndex;
               
               element.@enable_limits = entityDefine.mEnableLimits ? 1 : 0;
               element.@lower_angle = entityDefine.mLowerAngle;
               element.@upper_angle = entityDefine.mUpperAngle;
               element.@enable_motor = entityDefine.mEnableMotor ? 1 : 0;
               element.@motor_speed = entityDefine.mMotorSpeed;
               element.@back_and_forth = entityDefine.mBackAndForth ? 1 : 0;
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
            {
               element.@anchor1_index = entityDefine.mAnchor1EntityIndex;
               element.@anchor2_index = entityDefine.mAnchor2EntityIndex;
               
               element.@enable_limits = entityDefine.mEnableLimits ? 1 : 0;
               element.@lower_translation = entityDefine.mLowerTranslation;
               element.@upper_translation = entityDefine.mUpperTranslation;
               element.@enable_motor = entityDefine.mEnableMotor ? 1 : 0;
               element.@motor_speed = entityDefine.mMotorSpeed;
               element.@back_and_forth = entityDefine.mBackAndForth ? 1: 0;
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
            {
               element.@anchor1_index = entityDefine.mAnchor1EntityIndex;
               element.@anchor2_index = entityDefine.mAnchor2EntityIndex;
            }
            else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
            {
               element.@anchor1_index = entityDefine.mAnchor1EntityIndex;
               element.@anchor2_index = entityDefine.mAnchor2EntityIndex;
               
               element.@static_length_ratio = entityDefine.mStaticLengthRatio;
               //element.@frequency_hz = entityDefine.mFrequencyHz;
               element.@spring_type = entityDefine.mSpringType;
               
               element.@damping_ratio = entityDefine.mDampingRatio;
            }
         }
         
         return element;
      }
      
//====================================================================================
//   
//====================================================================================
      
      // 
      public static function AdjustNumberValuesInWorldDefine (worldDefine:WorldDefine):void
      {
         if (worldDefine.mVersion >= 0x0102)
         {
            var numCategories:int = worldDefine.mCollisionCategoryDefines.length;
            for (var ccId:int = 0; ccId < numCategories; ++ ccId)
            {
               var ccDefine:Object = worldDefine.mCollisionCategoryDefines [ccId];
               
               ccDefine.mPosX = ValueAdjuster.Number2Precision (ccDefine.mPosX, 6);
               ccDefine.mPosY = ValueAdjuster.Number2Precision (ccDefine.mPosY, 6);
            }
         }
         
         // entities
         
         var numEntities:int = worldDefine.mEntityDefines.length;
         
         var entityId:int;
         
         for (entityId = 0; entityId < numEntities; ++ entityId)
         {
            var entityDefine:Object = worldDefine.mEntityDefines [entityId];
            
            entityDefine.mPosX = ValueAdjuster.Number2Precision (entityDefine.mPosX, 12);
            entityDefine.mPosY = ValueAdjuster.Number2Precision (entityDefine.mPosY, 12);
            entityDefine.mRotation = ValueAdjuster.Number2Precision (entityDefine.mRotation, 6);
            
            if ( Define.IsShapeEntity (entityDefine.mEntityType) )
            {
               if ( Define.IsPhysicsShapeEntity (entityDefine.mEntityType) )
               {
                  entityDefine.mDensity = ValueAdjuster.Number2Precision (entityDefine.mDensity, 6);
                  entityDefine.mFriction = ValueAdjuster.Number2Precision (entityDefine.mFriction, 6);
                  entityDefine.mRestitution = ValueAdjuster.Number2Precision (entityDefine.mRestitution, 6);
                  
                  if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
                  {
                     entityDefine.mRadius = ValueAdjuster.Number2Precision (entityDefine.mRadius, 6);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
                  {
                     entityDefine.mHalfWidth = ValueAdjuster.Number2Precision (entityDefine.mHalfWidth, 6);
                     entityDefine.mHalfHeight = ValueAdjuster.Number2Precision (entityDefine.mHalfHeight, 6);
                  }
               }
               else // not physis shape
               {
                  if (entityDefine.mEntityType == Define.EntityType_ShapeText)
                  {
                     entityDefine.mHalfWidth = ValueAdjuster.Number2Precision (entityDefine.mHalfWidth, 6);
                     entityDefine.mHalfHeight = ValueAdjuster.Number2Precision (entityDefine.mHalfHeight, 6);
                  }
                  else if (entityDefine.mEntityType == Define.EntityType_ShapeGravityController)
                  {
                     entityDefine.mRadius = ValueAdjuster.Number2Precision (entityDefine.mRadius, 6);
                     
                     entityDefine.mInitialGravityAcceleration = ValueAdjuster.Number2Precision (entityDefine.mInitialGravityAcceleration, 6);
                  }
               }
            }
            else if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               if (entityDefine.mEntityType == Define.EntityType_JointHinge)
               {
                  entityDefine.mLowerAngle = ValueAdjuster.Number2Precision (entityDefine.mLowerAngle, 6);
                  entityDefine.mUpperAngle = ValueAdjuster.Number2Precision (entityDefine.mUpperAngle, 6);
                  entityDefine.mMotorSpeed = ValueAdjuster.Number2Precision (entityDefine.mMotorSpeed, 6);
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSlider)
               {
                  entityDefine.mLowerTranslation = ValueAdjuster.Number2Precision (entityDefine.mLowerTranslation, 6);
                  entityDefine.mUpperTranslation = ValueAdjuster.Number2Precision (entityDefine.mUpperTranslation, 6);
                  entityDefine.mMotorSpeed = ValueAdjuster.Number2Precision (entityDefine.mMotorSpeed, 6);
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointDistance)
               {
               }
               else if (entityDefine.mEntityType == Define.EntityType_JointSpring)
               {
                  entityDefine.mStaticLengthRatio = ValueAdjuster.Number2Precision (entityDefine.mStaticLengthRatio, 6);
                  
                  entityDefine.mDampingRatio = ValueAdjuster.Number2Precision (entityDefine.mDampingRatio, 6);
               }
            }
         }
      }
      
      
      
   }
   
}