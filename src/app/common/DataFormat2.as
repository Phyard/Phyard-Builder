
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
         var playerWorld:player.world.World = new player.world.World ();
         
         playerWorld.SetAuthorName (worldDefine.mAuthorName);
         playerWorld.SetAuthorHomepage (worldDefine.mAuthorHomepage);
         
         
         var entityDefineArray:Array = worldDefine.mEntityDefines;
         var brotherGroupArray:Array = worldDefine.mBrotherGroups;
         var groupId:int;
         var brotherGroup:Array;
         var entityId:int;
         var entityDefine:Object;
         var i:int;
         var shapeContainer:player.entity.ShapeContainer;
         var params:Object;
         
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
            entityDefine = entityDefineArray [entityId];
            
            if ( Define.IsPhysicsShapeEntity (entityDefine.mEntityType) )
            {
               shapeContainer = entityDefine.mShapeContainer;
               if (shapeContainer == null)
               {
                  params = new Object ();
                  params.mPosX = entityDefine.mPosX;
                  params.mPosY = entityDefine.mPosY;
                  
                  shapeContainer = playerWorld.CreateShapeContainer (params, true);
               }
               
               if (entityDefine.mEntityType == Define.EntityType_ShapeCircle)
               {
                  playerWorld.CreateEntityShapeCircle (shapeContainer, entityDefine);
               }
               else if (entityDefine.mEntityType == Define.EntityType_ShapeRectangle)
               {
                  playerWorld.CreateEntityShapeRectangle (shapeContainer, entityDefine);
               }
            }
         }
         
      // update masses
         
         playerWorld.UpdateShapeMasses (); // 
         
      // create joints
         
         for (entityId = 0; entityId < entityDefineArray.length; ++ entityId)
         {
            entityDefine = entityDefineArray [entityId];
            
            if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               //shapeContainer = entityDefine.mShapeContainer;
               
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
         
         // hex
         byteArray.readByte (); // "H".charCodeAt (0);
         byteArray.readByte (); // "E".charCodeAt (0);
         byteArray.readByte (); // "X".charCodeAt (0);
         
         // entities
         
         var numEntities:int = byteArray.readShort ();
         
         var entityId:int;
         
         for (entityId = 0; entityId < numEntities; ++ entityId)
         {
            var entityDefine:Object = new Object ();
            
            entityDefine.mEntityType = byteArray.readShort ();
            entityDefine.mPosX = byteArray.readFloat ();
            entityDefine.mPosY = byteArray.readFloat ();
            entityDefine.mRotation = byteArray.readFloat ();
            entityDefine.mIsVisible = byteArray.readByte ();
            
            if ( Define.IsPhysicsShapeEntity (entityDefine.mEntityType) )
            {
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
            
            if ( Define.IsPhysicsJointEntity (entityDefine.mEntityType) )
            {
               entityDefine.mCollideConnected = byteArray.readByte ();
               
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
            
            worldDefine.mBrotherGroups.push (brotherIDs);
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
               char = enStr.charAt (i);
               str = str + char;
               trace ("De str error. char = " + char);
            }
         }
         
         return str;
      }
      
   }
   
}