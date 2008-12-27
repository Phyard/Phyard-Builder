
package common {
   
   import flash.utils.ByteArray;
   
   import editor.world.World;
   import editor.entity.Entity;
   import editor.entity.EntityShape
   import editor.entity.EntityShapeCircle;
   import editor.entity.EntityShapeRectangle;
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
         worldDefine.mVersion = 0x1000;
         
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
            else if (child is editor.entity.EntityJoint)
            {
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
                  entityDefine.mEntityType = Define.EntityType_JointDistance;
                  entityDefine.mAnchor1EntityIndex = editorWorld.getChildIndex ( (child as editor.entity.EntityJointDistance).GetAnchor1 () );
                  entityDefine.mAnchor2EntityIndex = editorWorld.getChildIndex ( (child as editor.entity.EntityJointDistance).GetAnchor2 () );
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
            worldDefine.mBrotherGroups.push (brotherIDs);
         }
         
         return worldDefine;
      }
      
      
      
      
      public static function WorldDefine2EditorWorld (worldDefine:WorldDefine):editor.world.World
      {
         return null;
      }
      
      
      public static function WorldDefine2PlayerWorld (worldDefine:WorldDefine):player.world.World
      {
         var playerWorld:player.world.World = new player.world.World ();
         
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
      
      
      public static function WorldDefine2Xml (worldDefine:WorldDefine):XML
      {
         return null;
      }
      
      public static function Xml2WorldDefine (xml:XML):WorldDefine
      {
         return null;
      }
      
      public static function WorldDefine2ByteArray (worldDefine:WorldDefine):ByteArray
      {
         return null;
      }
      
      public static function ByteArray2WorldDefine (byteArray:ByteArray):WorldDefine
      {
         return null;
      }
      
      
      
   }
   
}