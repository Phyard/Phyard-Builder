// all these functions assume the physics of entities are all built already.

//================================================================
//
//================================================================

/*
possible actions:
- clone
- translate
- rotate
- scale
- flip
- ...
*/

public static function GetRelatedEntities (seedShape:EntityShape, bTeleportBrothers:Boolean, bTeleportConnectedMovables:Boolean, bTeleprotConnectedStatics:Boolean, bBreakEmbarrassedJoints:Boolean):Object
{
   var returnObject:Object =  new Object ();

   var shapesToTeleport:Array = new Array ();
   var bodiesToTeleport:Array = new Array ();
   var jointsToTeleport:Array = new Array ();
   var jointsToBreak:Array = new Array ();

   returnObject.mBodiesToTransform = bodiesToTeleport;
   returnObject.mShapesToTransform = shapesToTeleport;
   returnObject.mJointsToTransform = jointsToTeleport;

   // collect related entities

   var body:EntityBody;
   var shape:EntityShape;
   var anotherShape:EntityShape;
   var joint:EntityJoint;
   var anchor:SubEntityJointAnchor;

   seedShape.IncreaseLastSpecialId ();

   seedShape.mSpecialId = sLastSpecialId;
   shapesToTeleport.push (seedShape);

   if (bTeleportBrothers)
   {
      var numShapesToTeleport:int = 0;

      while (shapesToTeleport.length > numShapesToTeleport)
      {
         shape = shapesToTeleport [numShapesToTeleport];
         //shape.mSpecialId = sLastSpecialId; // now call this when add shape in list

         ++ numShapesToTeleport;

         // brothers

         body = shape.mBody;
         if (body.mSpecialId != sLastSpecialId)
         {
            body.mSpecialId = sLastSpecialId;
            bodiesToTeleport.push (body);

            anotherShape = body.mShapeListHead;

            while (anotherShape != null)
            {
               if (anotherShape.mSpecialId != sLastSpecialId)
               {
                  anotherShape.mSpecialId = sLastSpecialId;
                  shapesToTeleport.push (anotherShape)
               }

               anotherShape = anotherShape.mNextShapeInBody;
            }
         }

         // connected joints and shapes

         anchor = shape.mJointAnchorListHead;

         while (anchor != null)
         {
            joint = anchor.mJoint;

            if (joint.mSpecialId != sLastSpecialId)
            {
               joint.mSpecialId = sLastSpecialId;

               anotherShape = anchor.mAnotherJointAnchor.mShape;

               if (anotherShape == null)
               {
                  if (bBreakEmbarrassedJoints)
                  {
                     jointsToBreak.push (joint);
                  }
               }
               else if (anotherShape.mBody.IsStatic ())
               {
                  if (bTeleprotConnectedStatics)
                  {
                     if (anotherShape.mSpecialId != sLastSpecialId)
                     {
                        anotherShape.mSpecialId = sLastSpecialId;
                        shapesToTeleport.push (anotherShape);
                     }

                     jointsToTeleport.push (joint);
                  }
                  else if (bBreakEmbarrassedJoints)
                  {
                     jointsToBreak.push (joint);
                  }
               }
               else
               {
                  if (bTeleportConnectedMovables)
                  {
                     if (anotherShape.mSpecialId != sLastSpecialId)
                     {
                        anotherShape.mSpecialId = sLastSpecialId;
                        shapesToTeleport.push (anotherShape);
                     }

                     jointsToTeleport.push (joint);
                  }
                  else if (bBreakEmbarrassedJoints)
                  {
                     jointsToBreak.push (joint);
                  }
               }
            }

            anchor = anchor.mNextAnchor;
         }
      }
   }
   else if (bBreakEmbarrassedJoints)
   {
      anchor = seedShape.mJointAnchorListHead;

      while (anchor != null)
      {
         joint = anchor.mJoint;

         if (joint.mSpecialId != sLastSpecialId)
         {
            joint.mSpecialId = sLastSpecialId;
            jointsToBreak.push (joint);
         }

         anchor = anchor.mNextAnchor;
      }
   }

   // break joints

   for (var i:int = jointsToBreak.length - 1; i >= 0; -- i)
   {
      (jointsToBreak[i] as EntityJoint).Destroy ();
   }

   // ...

   return returnObject;
}

//================================================================
// clone and transform
//================================================================

private static function CreateAndPushEntityDefine (entity:Entity, entityDefineArray:Array, mapEntity2Define:Dictionary):Object
{
   var entityDefine:Object = entity.ToEntityDefine (new Object ());
   if (entityDefine != null)
   {
      entityDefine.mCloneFromEntity = entity;

      entityDefine.mAppearanceOrderId = entity.GetAppearanceId ();
      entityDefine.mCreationOrderId = entity.GetCreationId ();
      entityDefineArray.push (entityDefine);

      mapEntity2Define [entity] = entityDefine;
   }

   return entityDefine;
}

public static function CloneShape (seedShape:EntityShape, targetX:Number, targetY:Number, bCloneBrothers:Boolean, bCloneConnectedMovables:Boolean, bCloneConnectedStatics:Boolean):EntityShape
{
   if (seedShape == null)
      return null;

   var infos:Object = GetRelatedEntities (seedShape, bCloneBrothers, bCloneConnectedMovables, bCloneConnectedStatics, false);

   var bodiesToTeleport:Array = infos.mBodiesToTransform;
   var shapesToTeleport:Array = infos.mShapesToTransform;
   var jointsToTeleport:Array = infos.mJointsToTransform;

   var world:World = seedShape.GetWorld ();

   var worldDefine:WorldDefine = new WorldDefine ();
   worldDefine.mVersion = Version.VersionNumber;
   var sceneDefine:SceneDefine = new SceneDefine ();
   worldDefine.mSceneDefines.push (sceneDefine);
   var entityDefineArray:Array = sceneDefine.mEntityDefines;

   var entityDefine:Object;
   var entity:Entity;
   var body:EntityBody;
   var shape:EntityShape;
   var joint:EntityJoint;
   var anchor:SubEntityJointAnchor;

   var i:int;
   var count:int;

   // create entity defines for shapes

   var mapEntity2Define:Dictionary = new Dictionary ();

   count = shapesToTeleport.length;
   for (i = 0; i < count; ++ i)
   {
      shape = shapesToTeleport [i] as EntityShape;
      entityDefine = CreateAndPushEntityDefine (shape, entityDefineArray, mapEntity2Define);
   }

   // create entity defines for joints and anchors

   count = jointsToTeleport.length;
   for (i = 0; i < count; ++ i)
   {
      joint = jointsToTeleport [i] as EntityJoint;
      entityDefine = CreateAndPushEntityDefine (joint, entityDefineArray, mapEntity2Define);

      anchor = joint.GetAnchor1 ();
      entityDefine = CreateAndPushEntityDefine (anchor, entityDefineArray, mapEntity2Define);

      anchor = joint.GetAnchor2 ();
      entityDefine = CreateAndPushEntityDefine (anchor, entityDefineArray, mapEntity2Define);
   }

   // reset creation ids and positions

   var deltaX:Number = world.GetCoordinateSystem ().P2D_LinearDeltaX (targetX - seedShape.GetPositionX ());
   var deltaY:Number = world.GetCoordinateSystem ().P2D_LinearDeltaY (targetY - seedShape.GetPositionY ());

   count = entityDefineArray.length;
   entityDefineArray.sortOn ("mCreationOrderId", Array.NUMERIC);
   for (i = 0; i < count; ++ i)
   {
      entityDefine = entityDefineArray [i] as Object;
      entityDefine.mCreationOrderId = i;
      entityDefine.mPosX += deltaX;
      entityDefine.mPosY += deltaY;
   }

   // create appearance order array

   var entityDefinesSortByAppearanceId:Array = entityDefineArray.concat ();
   entityDefinesSortByAppearanceId.sortOn ("mAppearanceOrderId", Array.NUMERIC);
   var appearanceOrderArray:Array = sceneDefine.mEntityAppearanceOrder;
   for (i = 0; i < count; ++ i)
   {
      entityDefine = entityDefinesSortByAppearanceId [i] as Object;
      appearanceOrderArray.push (entityDefine.mCreationOrderId);
   }

   // create brother groups array

   var brotherGroupDefines:Array = sceneDefine.mBrotherGroupDefines;
   count = bodiesToTeleport.length;
   for (i = 0; i < count; ++ i)
   {
      body = bodiesToTeleport [i] as EntityBody;

      var brotherShapeCreationOrderIds:Array = new Array ();
      shape = body.mShapeListHead;
      while (shape != null)
      {
         entityDefine = mapEntity2Define [shape] as Object;
         if (entityDefine != null)
         {
            brotherShapeCreationOrderIds.push (entityDefine.mCreationOrderId);
         }

         shape = shape.mNextShapeInBody;
      }

      if (brotherShapeCreationOrderIds.length > 1)
      {
         brotherGroupDefines.push (brotherShapeCreationOrderIds);
      }
   }

   // set entity reference ids

   var anchorIndex1:int;
   var anchorIndex2:int;
   var shapeIndex1:int;
   var shapeIndex2:int;

   count = jointsToTeleport.length;
   for (i = 0; i < count; ++ i)
   {
      joint = jointsToTeleport [i] as EntityJoint;

      anchor = joint.GetAnchor1 ();
      anchorIndex1 = (mapEntity2Define [anchor] as Object).mCreationOrderId;

      shape = anchor.GetShape ();
      shapeIndex1 = shape == null ? Define.EntityId_None : (mapEntity2Define [shape] as Object).mCreationOrderId;

      anchor = joint.GetAnchor2 ();
      anchorIndex2 = (mapEntity2Define [anchor] as Object).mCreationOrderId;

      shape = anchor.GetShape ();
      shapeIndex2 = shape == null ? Define.EntityId_None : (mapEntity2Define [shape] as Object).mCreationOrderId;

      entityDefine = mapEntity2Define [joint];
      entityDefine.mAnchor1EntityIndex = anchorIndex1;
      entityDefine.mAnchor2EntityIndex = anchorIndex2;
      entityDefine.mConnectedShape1Index = shapeIndex1;
      entityDefine.mConnectedShape2Index = shapeIndex2;
   }

   // do some init jobs

   var worldEntityList:EntityList = world.GetEntityList ();
   var worldEntityBodyList:EntityList = world.GetEntityBodyList ();

   worldEntityList.MarkLastTail ();
   worldEntityBodyList.MarkLastTail ();

   DataFormat2.WorldDefine2PlayerWorld (worldDefine, world);

   world.BuildEntityPhysics (true);
   var clonedEntities:Array = worldEntityList.GetEntitiesFromLastMarkedTail ();

   worldEntityList.UnmarkLastTail ();
   worldEntityBodyList.UnmarkLastTail ();

   // bug! OnCreated and InitEntities may call clone APIs, which then call EntityList.MarkLastTail (),
   //which will make nest MarkLastTail, ..., then bugs.

   //world.RegisterEventHandlersForRuntimeCreatedEntities (true);
   //world.GetEntityList ().OnCreated (true);
   //if (world.ShouldInitRuntimeCteatedEntitiesManually ())
   //{
   //   world.RegisterEventHandlersForRuntimeCreatedEntities (false);
   //   world.GetEntityList ().InitEntities (true);
   //}
   world.RegisterEventHandlersForRuntimeCreatedEntities (true, clonedEntities);
   EntityList.OnCreated_RuntimeCreatedEntities (clonedEntities);
   if (world.ShouldInitRuntimeCteatedEntitiesManually ())
   {
      world.RegisterEventHandlersForRuntimeCreatedEntities (false, clonedEntities);
      EntityList.InitEntities_RuntimeCreatedEntities (clonedEntities);
   }


   // clone runtime infos
   // for joints only now. maybe it is better to put runtime infos in entityDefines

   count = jointsToTeleport.length;
   for (i = 0; i < count; ++ i)
   {
      joint = jointsToTeleport [i] as EntityJoint;
      entityDefine = mapEntity2Define [joint];

      //entity = entityDefine.mEntity; // the cloned one
      entity = entityDefine.mLoadingTimeInfos.mEntity; // the cloned one

      (entity as EntityJoint).CopyRuntimeInfosFrom (joint)
   }

   // return

   entityDefine = mapEntity2Define [seedShape];
   if (entityDefine == null)
      return null;

   //return entityDefine.mEntity as EntityShape;
   return entityDefine.mLoadingTimeInfos.mEntity as EntityShape;
}

//================================================================
// transform
//================================================================

public static function Teleport (seedShape:EntityShape, deltaX:Number, deltaY:Number, deltaRotation:Number, bTeleportConnectedMovables:Boolean, bTeleprotConnectedStatics:Boolean, bBreakEmbarrassedJoints:Boolean):void
{
   Rotate (seedShape, seedShape.GetPositionX (), seedShape.GetPositionY (), deltaRotation, bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints, false);
   Translate (seedShape, deltaX, deltaY, bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints);
}

public static function Translate (seedShape:EntityShape, deltaX:Number, deltaY:Number, bTeleportConnectedMovables:Boolean, bTeleprotConnectedStatics:Boolean, bBreakEmbarrassedJoints:Boolean):void
{
   if (deltaX == 0 && deltaY == 0)
      return;

//...

   var infos:Object = GetRelatedEntities (seedShape, true, bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints);

   var bodiesToTeleport:Array = infos.mBodiesToTransform;
   var shapesToTeleport:Array = infos.mShapesToTransform;
   var jointsToTeleport:Array = infos.mJointsToTransform;

// ...

   var num:int = bodiesToTeleport.length;

   for (var i:int = 0; i < num; ++ i)
   {
      var body:EntityBody = bodiesToTeleport [i] as EntityBody;
      //body.mPositionX += deltaX;
      //body.mPositionY += deltaY;
      body.SetPositionX (body.GetPositionX () + deltaX);
      body.SetPositionY (body.GetPositionY () + deltaY);

      if (body.mNumPhysicsShapes > 0)
      {
         body.NotifyMovedManually ();
         body.SetSleeping (false);
         body.SynchronizePositionAndRotationToPhysicsProxy ();
      }

      // ...

      var shape:EntityShape = body.mShapeListHead;

      while (shape != null)
      {
         shape.SynchronizeWithPhysicsProxy ();

         shape = shape.mNextShapeInBody;
      }
   }
}

public static function Rotate (seedShape:EntityShape, fixedPointX:Number, fixedPointY:Number, deltaRotation:Number, bTeleportConnectedMovables:Boolean, bTeleprotConnectedStatics:Boolean, bBreakEmbarrassedJoints:Boolean, rotateVelocity:Boolean):void
{
   if (deltaRotation == 0)
      return;

// ...

   var infos:Object = GetRelatedEntities (seedShape, true, bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints);

   var bodiesToTeleport:Array = infos.mBodiesToTransform;
   var shapesToTeleport:Array = infos.mShapesToTransform;
   var jointsToTeleport:Array = infos.mJointsToTransform;

// ...

   var deltaRotationInTwoPI:Number = deltaRotation % Define.kPI_x_2;
   var cos:Number = Math.cos (deltaRotationInTwoPI);
   var sin:Number = Math.sin (deltaRotationInTwoPI);

   var num:int = bodiesToTeleport.length;

   for (var i:int = 0; i < num; ++ i)
   {
      var body:EntityBody = bodiesToTeleport [i] as EntityBody;

      var dx:Number = body.GetPositionX () - fixedPointX;
      var dy:Number = body.GetPositionY () - fixedPointY;

      //body.mPositionX = fixedPointX + dx * cos - dy * sin;
      //body.mPositionY = fixedPointY + dx * sin + dy * cos;
      //body.SetRotation (body.mPhysicsRotation + deltaRotation);
      body.SetPositionX (fixedPointX + dx * cos - dy * sin);
      body.SetPositionY (fixedPointY + dx * sin + dy * cos);
      body.SetRotation (body.GetRotation () + deltaRotation);
      if (rotateVelocity)
      {
         var vx:Number = body.GetLinearVelocityX ();
         var vy:Number = body.GetLinearVelocityY ();
         body.SetLinearVelocity (vx * cos - vy * sin, vx * sin + vy * cos);
      }

      if (body.mNumPhysicsShapes > 0)
      {
         //body.SynchronizeWithPhysicsProxyManually (); // essential?
            // bug! should not call this. This will make the changes roll back
            // If to call this, must call body.SynchronizePositionAndRotationToPhysicsProxy firstly

         //todo: add an option "Modify Velocity?". Velocity are not changed defaultly.
         //var vx:Number = body.GetLinearVelocityX ();
         //var vy:Number = body.GetLinearVelocityY ();
         //body.SetLinearVelocity (vx * cos - vy * sin, vx * sin + vy * cos); // will call body.NotifyVelocityChangedManually ();

         body.NotifyVelocityChangedManually (); // shapes' velocity changed
         body.NotifyMovedManually ();
         body.SetSleeping (false);
         body.SynchronizePositionAndRotationToPhysicsProxy ();
      }

      // ...

      var shape:EntityShape = body.mShapeListHead;

      while (shape != null)
      {
         shape.SynchronizeWithPhysicsProxy ();

         shape = shape.mNextShapeInBody;
      }
   }
}

// for flip and scale, because box2d doesn't suppor flip and scale for b2Body, 
// shape.mLocalCentroid is changed after clipping, so the handling is some different. 

// todo: need SetRotation intelligently. Use entity.GetRotationOffset ()
public static function Flip (seedShape:EntityShape, pointX:Number, pointY:Number, normalX:Number, normalY:Number,
                  bTeleportConnectedMovables:Boolean, bTeleprotConnectedStatics:Boolean, bBreakEmbarrassedJoints:Boolean,
                  flipVelocity:Boolean):void
{
   var normalXX:Number = normalX * normalX;
   var normalYY:Number = normalY * normalY;
   var normalLength:Number = Math.sqrt (normalXX + normalYY);

   if (normalLength < Define.kFloatEpsilon)
      return;

// ...

   var infos:Object = GetRelatedEntities (seedShape, true, bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints);

   var bodiesToTeleport:Array = infos.mBodiesToTransform;
   var shapesToTeleport:Array = infos.mShapesToTransform;
   var jointsToTeleport:Array = infos.mJointsToTransform;

// ...

   var doubleLineAngle:Number = 2.0 * Math.atan2 (normalY, normalX);

   normalX /= normalLength;
   normalY /= normalLength;
   var normalXX2:Number = 2.0 * normalX * normalX;
   var normalYY2:Number = 2.0 * normalY * normalY;
   var normalXY2:Number = 2.0 * normalX * normalY;
   
// ...

   var numBodies:int = bodiesToTeleport.length;

   for (var i:int = 0; i < numBodies; ++ i)
   {
      var body:EntityBody = bodiesToTeleport [i] as EntityBody;

      //...

      var offsetX:Number = body.GetPositionX () - pointX;
      var offsetY:Number = body.GetPositionY () - pointY;

      body.SetPositionX (body.GetPositionX () - normalXX2 * offsetX - normalXY2 * offsetY);
      body.SetPositionY (body.GetPositionY () - normalXY2 * offsetX - normalYY2 * offsetY);
      //body.SetRotation (body.mPhysicsRotation + doubleLineAngle); // wrong. should rotate shapes instead
      body.SynchronizePositionAndRotationToPhysicsProxy ();
      if (body.mNumPhysicsShapes > 0)
      {
         if (flipVelocity)
         {
            var bodyVx:Number = body.GetLinearVelocityX ();
            var bodyVy:Number = body.GetLinearVelocityY ();
            var bodyAngularVelocity:Number = body.GetAngularVelocity ();
            
            body.SetAngularVelocity (- bodyAngularVelocity);
            body.SetLinearVelocity (bodyVx - normalXX2 * bodyVx - normalXY2 * bodyVy,
                                    bodyVy - normalXY2 * bodyVx - normalYY2 * bodyVy);
         }
         
         body.NotifyVelocityChangedManually (); // shapes' velocity changed
         body.NotifyMovedManually ();
         body.SetSleeping (false);
      }

      //...

      var shape:EntityShape = body.mShapeListHead;

      while (shape != null)
      {
         offsetX = shape.GetPositionX () - pointX;
         offsetY = shape.GetPositionY () - pointY;
   
         shape.SetPositionX (shape.GetPositionX () - normalXX2 * offsetX - normalXY2 * offsetY);
         shape.SetPositionY (shape.GetPositionY () - normalXY2 * offsetX - normalYY2 * offsetY);
         shape.SetFlipped (! shape.IsFlipped ());
         shape.SetRotation (shape.GetRotation () + (shape.IsFlipped () ? - doubleLineAngle : doubleLineAngle));
         
         shape.UpdatelLocalTransform ();
         
         if (shape.IsPhysicsShape ())
         {
            //>> an optimization to avoid calling body.CoincideWithCentroid
            shape.SynchronizeCentroidFromShapeSpaceToBodySpace ();
            //<<
         
            shape.RebuildShapePhysics ();
         }

         //shape.SynchronizeWithPhysicsProxy (); // may be not essential? Yes, calling only ApplyTransformOnAppearanceObjectsContainer is ok.
         shape.ApplyTransformOnAppearanceObjectsContainer ();
         
         shape.NotifyJointAnchorLocalPositionsChanged ();
         
         shape = shape.mNextShapeInBody;
      }
   }
   
   // joint
   var numJoints:int = jointsToTeleport.length;
   for (var j:int = 0; j < numJoints; ++ j)
   {
      var joint:EntityJoint = jointsToTeleport [j] as EntityJoint;
      joint.OnFlipped (pointX, pointY, normalXX2, normalYY2, normalXY2);
   }
}

// for scale, there are more to do than rotate and flip.
// same as flip, shape.mLocalCentroid is changed, but different with flip,
// the mass of the area and path shapes are changed, especially they are changed differently:
// - for area shapes, the ratio is scaleRatio * scaleRatio
// - for path shapes, the ratio is scaleRatio
// so we can't simplly call SynchronizeCentroidFromShapeSpaceToBodySpace + ScaleMass (scaleRatio * scaleRatio).
// a fill slow body.OnShapeListChanged calling is needed.

public static function Scale (seedShape:EntityShape, scaleRatio:Number, fixedPointX:Number, fixedPointY:Number,
                              bTeleportConnectedMovables:Boolean, bTeleprotConnectedStatics:Boolean, bBreakEmbarrassedJoints:Boolean,
                              conserveMomentum:Boolean):void
{
   if (scaleRatio == 1.0)
      return;

   if (scaleRatio < Define.kFloatEpsilon) // may cause many problems. Negative values are also not allowed.
      return;

// ...

   var infos:Object = GetRelatedEntities (seedShape, true, bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints);

   var bodiesToTeleport:Array = infos.mBodiesToTransform;
   var shapesToTeleport:Array = infos.mShapesToTransform;
   var jointsToTeleport:Array = infos.mJointsToTransform;
   
// ...

   var num:int = bodiesToTeleport.length;

   for (var i:int = 0; i < num; ++ i)
   {
      var body:EntityBody = bodiesToTeleport [i] as EntityBody;
      
      var offsetX:Number;
      var offsetY:Number;

      // ...
      
      var shape:EntityShape = body.mShapeListHead;
      while (shape != null)
      {
         offsetX = shape.GetPositionX () - fixedPointX;
         offsetY = shape.GetPositionY () - fixedPointY;
   
         shape.SetPositionX (fixedPointX + scaleRatio * offsetX);
         shape.SetPositionY (fixedPointY + scaleRatio * offsetY);
         shape.SetScale (scaleRatio * shape.GetScale ());
         
         shape.UpdatelLocalTransform (); 
            // although this will be called in the following body.OnShapeListChanged,
            // but the next line shape.RebuildShapePhysics needs a corrent local transform.
         
         if (shape.IsPhysicsShape ())
            shape.RebuildShapePhysics (); // body.OnShapeListChanged needs this be bone firstly.

         //shape.SynchronizeWithPhysicsProxy (); // may be not essential? Yes, calling only ApplyTransformOnAppearanceObjectsContainer is ok.
         shape.ApplyTransformOnAppearanceObjectsContainer ();
         
         shape.NotifyJointAnchorLocalPositionsChanged ();
         
         shape = shape.mNextShapeInBody;
      }

      //...

      var oldVx:Number = body.GetLinearVelocityX ();
      var oldVy:Number = body.GetLinearVelocityY ();
      var oldAngularVelocity:Number = body.GetAngularVelocity ();
      var oldMass:Number = body.GetMass ();
      var oldInertia:Number = body.GetInertia ();
      
      // the centroid of body and shapes may be all changed.
      body.OnShapeListChanged (true); // this function is slow but safe.

      if (body.mNumPhysicsShapes > 0)
      {
         body.NotifyVelocityChangedManually ();
         body.NotifyMovedManually ();
         body.SetSleeping (false);
         body.SynchronizeWithPhysicsProxyManually ();
         
         if (conserveMomentum)
         {  
            var newMass:Number = body.GetMass ();
            var newInertia:Number = body.GetInertia ();
            
            if (Math.abs (oldMass) >= Define.kFloatEpsilon) // so newInertia is also not a small value
            {
               body.SetAngularVelocity (oldInertia * oldAngularVelocity / newInertia);
               var massRatio:Number = oldMass / newMass;
               body.SetLinearVelocity (massRatio * oldVx, massRatio * oldVy);
            }
         }
      }
   }
   
   // joint
   var numJoints:int = jointsToTeleport.length;
   for (var j:int = 0; j < numJoints; ++ j)
   {
      var joint:EntityJoint = jointsToTeleport [j] as EntityJoint;
      joint.OnScaled (scaleRatio);
   }
}

//================================================================
// change size (different with scale)
//================================================================

public static function ChangeBorderThickness (shape:EntityShape, thickness:Number):void
{
   if (thickness < 0 || thickness == shape.GetBorderThickness ())
      return;

   var body:EntityBody = shape.GetBody ();

   var isPhysicsBody:Boolean = body.mNumPhysicsShapes > 0;
   var isPhysicsShape:Boolean = shape.IsPhysicsShape ();

   shape.SetBorderThickness (thickness);

   OnShapeGeometryChanged (body, isPhysicsBody, shape, isPhysicsShape);
}

public static function ChangeCurveThickness (shape:EntityShapePolyline, thickness:Number):void
{
   if (thickness < 0 || thickness == shape.GetCurveThickness ())
      return;

   var body:EntityBody = shape.GetBody ();

   var isPhysicsBody:Boolean = body.mNumPhysicsShapes > 0;
   var isPhysicsShape:Boolean = shape.IsPhysicsShape ();

   shape.SetCurveThickness (thickness);

   OnShapeGeometryChanged (body, isPhysicsBody, shape, isPhysicsShape);
}

public static function ChangeCircleRadius (circle:EntityShapeCircle, radius:Number):void
{
   if (radius <= 0 || radius == circle.GetRadius ())
      return;

   var body:EntityBody = circle.GetBody ();

   var isPhysicsBody:Boolean = body.mNumPhysicsShapes > 0;
   var isPhysicsShape:Boolean = circle.IsPhysicsShape ();

   var scaleRadius:Number =  radius / circle.GetRadius ();

   circle.SetRadius (radius);

   OnShapeGeometryChanged (body, isPhysicsBody, circle, isPhysicsShape);

   // modify joint anchor positions
   circle.ScaleJointAnchorPositions (scaleRadius, scaleRadius);
}

public static function ChangeRectangleSize (rect:EntityShapeRectangle, width:Number, height:Number):void
{
   if (width <= 0 || height <= 0)
      return;

   var body:EntityBody = rect.GetBody ();

   var isPhysicsBody:Boolean = body.mNumPhysicsShapes > 0;
   var isPhysicsShape:Boolean = rect.IsPhysicsShape ();

   var scaleWidth:Number =  0.5 * width / rect.GetHalfWidth ();
   var scaleHeight:Number =  0.5 * height / rect.GetHalfHeight ();

   rect.SetHalfWidth (width * 0.5);
   rect.SetHalfHeight (height * 0.5);

   OnShapeGeometryChanged (body, isPhysicsBody, rect, isPhysicsShape);

   // modify joint anchor positions
   rect.ScaleJointAnchorPositions (scaleWidth, scaleHeight);
}

//public static function ModifyPolyShapeVertex (polyShape:EntityShapePolyShape, vertexIndex:int, newLocalPosX:Number, newLocalPosY:Number, isInsert:Boolean):void
//{
//   if (isNaN (vertexIndex) || isNaN (newLocalPosX) || isNaN (newLocalPosY))
//      return;
//
//   var body:EntityBody = polyShape.GetBody ();
//
//   var isPhysicsBody:Boolean = body.mNumPhysicsShapes > 0;
//   var isPhysicsShape:Boolean = polyShape.IsPhysicsShape ();
//
//   polyShape.ModifyLocalVertex (vertexIndex, newLocalPosX, newLocalPosY, isInsert);
//
//   OnShapeGeometryChanged (body, isPhysicsBody, polyShape, isPhysicsShape);
//}
//
//public static function DeletePolyShapeVertex (polyShape:EntityShapePolyShape, vertexIndex:int):void
//{
//   if (isNaN (vertexIndex))
//      return;
//
//   polyShape.DeleteVertex (vertexIndex);
//}

public static function ModifyPolyShapeVertexPositions (polyShape:EntityShapePolyShape, xyValues:Array, inWorldSpace:Boolean):void
{
   var body:EntityBody = polyShape.GetBody ();

   var isPhysicsBody:Boolean = body.mNumPhysicsShapes > 0;
   var isPhysicsShape:Boolean = polyShape.IsPhysicsShape ();

   polyShape.SetVertexPositions (xyValues, inWorldSpace);

   OnShapeGeometryChanged (body, isPhysicsBody, polyShape, isPhysicsShape);
}

// isPhysicsShape and isPhysicsBody should not retrieved from the input params
private static function OnShapeGeometryChanged (body:EntityBody, isPhysicsBody:Boolean, shape:EntityShape, isPhysicsShape:Boolean):void
{
   if (isPhysicsShape)
   {
      shape.RebuildShapePhysics ();
      body.OnShapeListChanged (true);
      body.NotifyMovedManually ();
      body.NotifyVelocityChangedManually ();
      body.SetSleeping (false);
      body.SynchronizeWithPhysicsProxyManually ();
      shape.SynchronizeWithPhysicsProxy ();
   }
   else if (! isPhysicsBody)
   {
      body.OnShapeListChanged (false);
      body.NotifyMovedManually ();
   }
}

//================================================================
// mass
//================================================================

public function ChangeDensity (newDensity:Number):void
{
   var body:EntityBody = this.GetBody ();

   var isPhysicsBody:Boolean = body.mNumPhysicsShapes > 0;
   var isPhysicsShape:Boolean = this.IsPhysicsShape ();

   mDensity = newDensity;

   OnShapeGeometryChanged (body, isPhysicsBody, this, isPhysicsShape);
}

//================================================================
// detach / attach (glue)
//================================================================

public function BreakupBrothers ():void
{
   var oldBody:EntityBody = mBody;
   var oldBodyIsPhysics:Boolean = oldBody.mNumPhysicsShapes > 0;

   var world:World = oldBody.GetWorld ();

   var newBody:EntityBody;
   var shape:EntityShape;
   var isPhysicsShape:Boolean;

   while (oldBody.mShapeListHead != null)
   {
      shape = oldBody.mShapeListHead;

      isPhysicsShape = shape.IsPhysicsShape ();

      if (isPhysicsShape)
      {
         shape.SynchronizeVelocityAndWorldCentroid ();
      }

   // crete a new body

      newBody = new EntityBody (world);
      world.RegisterEntity (newBody);

      shape.SetBody (newBody);

      if (isPhysicsShape)
      {
         shape.RebuildShapePhysics ();
         newBody.OnShapeListChanged (true);
         shape.AddSelfMomentumToBody ();
      }
      else
      {
         newBody.OnShapeListChanged (false);
      }

      shape.ReconnectJoints (); // shape may be a non-physics shape

      newBody.SynchronizeWithPhysicsProxyManually ();
   }

// ..

   oldBody.OnShapeListChanged (oldBodyIsPhysics); // destroy old body
   //oldBody.SynchronizeWithPhysicsProxyManually (); // no needs
}

public static function DetachShape (aShape:EntityShape):void
{
   if (aShape.IsTheOnlyShapeInBody ())
      return;

   var isPhysicsShape:Boolean = aShape.IsPhysicsShape ();

// remove momentums from old body

   var oldBody:EntityBody = aShape.GetBody ();

   //
   var oldPositionX:Number = oldBody.GetPositionX ();
   var oldPositionY:Number = oldBody.GetPositionY ();
   var oldMass:Number = oldBody.GetMass ();
   var oldInertia:Number = oldBody.GetInertia ();
   var oldMomentumX:Number = oldMass * oldBody.GetLinearVelocityX ();
   var oldMomentumY:Number = oldMass * oldBody.GetLinearVelocityY ();
   var oldAngularMomentum:Number = oldInertia * oldBody.GetAngularVelocity ();
   var oldForceX:Number = oldBody.GetAccForceX ();
   var oldForceY:Number = oldBody.GetAccForceY ();
   var oldTorque:Number = oldBody.GetAccTorque ();

   if (isPhysicsShape)
   {
      aShape.SynchronizeVelocityAndWorldCentroid ();
   }

// create a new body

   var world:World = aShape.GetWorld ();

   var newBody:EntityBody = new EntityBody (world);
   world.RegisterEntity (newBody);

   aShape.SetBody (newBody);

   if (isPhysicsShape)
   {
      aShape.RebuildShapePhysics ();
      newBody.OnShapeListChanged (true);
      aShape.AddSelfMomentumToBody ();
   }
   else
   {
      newBody.OnShapeListChanged (false);
   }

   aShape.ReconnectJoints (); // shape may be a non-physics shape

   newBody.SynchronizeWithPhysicsProxyManually ();

// ...

   oldBody.OnShapeListChanged (isPhysicsShape);
   oldBody.SynchronizeWithPhysicsProxyManually ();

// ...

   //
   var newPositionX:Number = newBody.GetPositionX ();
   var newPositionY:Number = newBody.GetPositionY ();
   var newMass:Number = newBody.GetMass ();
   var newInertia:Number = newBody.GetInertia ();
   //var newMomentumX:Number = newMass * newBody.GetLinearVelocityX ();
   //var newMomentumY:Number = newMass * newBody.GetLinearVelocityY ();
   //var newAngularMomentum:Number = newInertia * newBody.GetAngularVelocity ();
   var newForceX:Number = newBody.GetAccForceX ();
   var newForceY:Number = newBody.GetAccForceY ();
   //var newTorque:Number = newBody.GetAccTorque ();

   // this block is not essential. Box2d will change the velocity of the old body automatically.
   //
   //oldBody.ClearVelocities ();
   //
   //if (oldBody.mNumPhysicsShapes > 0)
   //{
   //   // conservation of momentum and angular momentum
   //   oldBody.ApplyLinearImpulse (oldMomentumX, oldMomentumY, oldPositionX, oldPositionY);
   //   oldBody.ApplyLinearImpulse (-newMomentumX, -newMomentumY, newPositionX, newPositionY);
   //   oldBody.ApplyAngularImpulse (oldAngularMomentum);
   //   oldBody.ApplyAngularImpulse (-newAngularMomentum);
   //}

   oldBody.ClearPowers ();
   newBody.ClearPowers ();

   if (oldMass > 0)
   {
      oldBody.ApplyForceAtPoint (oldForceX * oldBody.GetMass () / oldMass, oldForceY * oldBody.GetMass () / oldMass, oldBody.GetPositionX (), oldBody.GetPositionY ());
      newBody.ApplyForceAtPoint (oldForceX * newMass / oldMass, oldForceY * newMass / oldMass, newPositionX, newPositionY);
   }

   if (oldInertia > 0)
   {
      oldBody.ApplyTorque (oldTorque * oldBody.GetInertia () / oldInertia);
      newBody.ApplyTorque (oldTorque * newInertia / oldInertia);
   }
}

public static function AttachTwoShapes (oneShape:EntityShape, anotherShape:EntityShape):void
{
   var anotherBody:EntityBody = anotherShape.GetBody ();

   if (anotherBody == oneBody)
      return;

// ...

   var oneBody:EntityBody = oneShape.GetBody ();

   var keptBody:EntityBody;
   var discardedBody:EntityBody;
   if (oneBody.mNumPhysicsShapes > anotherBody.mNumPhysicsShapes)
   {
      keptBody = oneBody;
      discardedBody = anotherBody;
   }
   else if (oneBody.mNumPhysicsShapes < anotherBody.mNumPhysicsShapes)
   {
      keptBody = anotherBody;
      discardedBody = oneBody;
   }
   else // if (oneBody.mNumPhysicsShapes == anotherBody.mNumPhysicsShapes)
   {
      if (oneBody.mNumShapes >= anotherBody.mNumShapes)
      {
         keptBody = oneBody;
         discardedBody = anotherBody;
      }
      else
      {
         keptBody = anotherBody;
         discardedBody = oneBody;
      }
   }

// ...

   var isDiscardedPhysicsBody:Boolean = discardedBody.mNumPhysicsShapes > 0;
   var isKeptPhysicsBody     :Boolean = keptBody.mNumPhysicsShapes > 0; // if isDiscardedPhysicsBody is true, then isKeptPhysicsBody must be true

   //discardedBody.SynchronizeVelocityWithPhysicsProxy ();
   var discardPositionX:Number = discardedBody.GetPositionX ();
   var discardPositionY:Number = discardedBody.GetPositionY ();
   var discardMass:Number = discardedBody.GetMass ();
   var discardInertia:Number = discardedBody.GetInertia ();
   var discardMomentumX:Number = discardMass * discardedBody.GetLinearVelocityX ();
   var discardMomentumY:Number = discardMass * discardedBody.GetLinearVelocityY ();
   var discardAngularMomentum:Number = discardInertia * discardedBody.GetAngularVelocity ();
   var discardForceX:Number = discardedBody.GetAccForceX ();
   var discardForceY:Number = discardedBody.GetAccForceY ();
   var discardTorque:Number = discardedBody.GetAccTorque ();

   //keptBody.SynchronizeVelocityWithPhysicsProxy ();
   var keptOldPositionX:Number = keptBody.GetPositionX ();
   var keptOldPositionY:Number = keptBody.GetPositionY ();
   var keptOldMass:Number = keptBody.GetMass ();
   var keptOldInertia:Number = keptBody.GetInertia ();
   var keptOldMomentumX:Number = keptOldMass * keptBody.GetLinearVelocityX ();
   var keptOldMomentumY:Number = keptOldMass * keptBody.GetLinearVelocityY ();
   var keptOldAngularMomentum:Number = keptOldInertia * keptBody.GetAngularVelocity ();
   var keptOldForceX:Number = keptBody.GetAccForceX ();
   var keptOldForceY:Number = keptBody.GetAccForceY ();
   var keptOldTorque:Number = keptBody.GetAccTorque ();

// ...

   var shape:EntityShape;
   var jointAnchor:SubEntityJointAnchor;
   var index:int = discardedBody.mNumShapes;
   var shapesToReconnectJoints:Array = new Array (index);
   while (discardedBody.mShapeListHead != null)
   {
      shape = discardedBody.mShapeListHead;

      shape.SetBody (keptBody);
      if (shape.IsPhysicsShape ())
         shape.RebuildShapePhysics ();

      shapesToReconnectJoints [--index] = shape;
      //shape.ReconnectJoints (); // put below now to optimize
   }

// ...

   keptBody.OnShapeListChanged (isDiscardedPhysicsBody);

   index = shapesToReconnectJoints.length;
   while (-- index >= 0)
   {
      shape = shapesToReconnectJoints [index] as EntityShape;
      shape.ReconnectJoints ();
   }

   keptBody.SynchronizeWithPhysicsProxyManually ();

// ..

   discardedBody.OnShapeListChanged (isDiscardedPhysicsBody); // this will destroy discardedBody
   //discardedBody.SynchronizeWithPhysicsProxyManually (); // no needs

// ...

   if (isDiscardedPhysicsBody) // then the kept must be also is physics body
   {
      //keptBody.SynchronizeVelocityWithPhysicsProxy (); // body position may be changed in the last calling

      //var newPositionX:Number = keptBody.mPositionX;
      //var newPositionY:Number = keptBody.mPositionY;

      // conservation of momentum and angular momentum
      keptBody.ClearVelocities ();
      keptBody.ApplyLinearImpulse (discardMomentumX, discardMomentumY, discardPositionX, discardPositionY);
      keptBody.ApplyLinearImpulse (keptOldMomentumX, keptOldMomentumY, keptOldPositionX, keptOldPositionY);
      keptBody.ApplyAngularImpulse (discardAngularMomentum);
      keptBody.ApplyAngularImpulse (keptOldAngularMomentum);

//trace ("discardMomentumX = " + discardMomentumX + ", discardMomentumY = " + discardMomentumY + ", discardAngularMomentum = " + discardAngularMomentum);
//trace ("keptOldMomentumX = " + keptOldMomentumX + ", keptOldMomentumY = " + keptOldMomentumY + ", keptOldAngularMomentum = " + keptOldAngularMomentum);

      // re-apply force and torques
      keptBody.ClearPowers ();
      keptBody.ApplyForceAtPoint (discardForceX, discardForceY, discardPositionX, discardPositionY);
      keptBody.ApplyForceAtPoint (keptOldForceX, keptOldForceY, keptOldPositionX, keptOldPositionY);
      keptBody.ApplyTorque (discardTorque);
      keptBody.ApplyTorque (keptOldTorque);

      //var deltaMomentumX:Number = discardMomentumX + keptOldMomentumX - newMomentumX;
      //var deltaMomentumY:Number = discardMomentumY + keptOldMomentumY - newMomentumY;

      //keptBody.mPhysicsProxyBody.AddLinearImpulseAtPoint (momentumX, momentumY, discardedBody.mPositionX, discardedBody.mPositionY);
      //keptBody.mPhysicsProxyBody.AddAngularImpulse (discardInertia * discardedBody.mAngularVelocity + (discardedBody.mPositionX - keptBody.mPositionX) * momentumY - (discardedBody.mPositionY - keptBody.mPositionY) * momentumX);

      //keptBody.ApplyLinearImpulse (momentumX, momentumY, discardedBody.mPositionX, discardedBody.mPositionY);
      //keptBody.ApplyAngularImpulse (discardInertia * discardedBody.mAngularVelocity + (discardedBody.mPositionX - keptBody.mPositionX) * momentumY - (discardedBody.mPositionY - keptBody.mPositionY) * momentumX);

      //
      //keptBody.SynchronizeVelocityWithPhysicsProxy ();
//trace ("newMomentumX = " + keptBody.GetMass () * keptBody.mLinearVelocityX + ", newMomentumY = " + keptBody.GetMass () * keptBody.mLinearVelocityY + ", newAngularMomentum = " + keptBody.GetInertia () * keptBody.mAngularVelocity);
   }
}

// for module shape
public static function OnShapeGeomModified (shape:EntityShape):void
{
   if (shape.IsPhysicsShape ())
      shape.RebuildShapePhysics ();
   
   shape.GetBody ().OnShapeListChanged (false);
   shape.GetBody ().SynchronizeWithPhysicsProxyManually ();
}

//public function DetachFromBrothers ():void
//{
//   DetachShape (this);
//}
//
//public function AttachWith (anotherShape:EntityShape):void
//{
//   AttachTwoShapes (this, anotherShape);
//}
//
//public function DetachThenAttachWith (anotherShape:EntityShape):void
//{
//   DetachShape (this);
//   AttachTwoShapes (this, anotherShape);
//}
//
//public function BreakupBrothers ():void
//{
//   var oldBody:EntityBody = mBody;
//
//   while (oldBody.mNumShapes > 1)
//   {
//      DetachShape (oldBody.mShapeListHead);
//   }
//}
//
//public function DetachThenAttachWith (anotherShape:EntityShape):void
//{
//   var anotherBody:EntityBody = anotherShape.GetBody ();
//
//   if (anotherBody == mBody)
//      return;
//
//   var isPhysicsShape:Boolean = IsPhysicsShape ();
//
//   var oldBody:EntityBody = mBody;
//
//   SynchronizeVelocityAndWorldCentroid ();
//
//   SetBody (anotherBody);
//   if (isPhysicsShape)
//      RebuildShapePhysics ();
//
//// ...
//
//   var jointAnchor:SubEntityJointAnchor = mJointAnchorListHead;
//   while (jointAnchor != null)
//   {
//      jointAnchor.mJoint.GetPhysicsProxyJoint ().ReconncetShape (this, jointAnchor.mAnchorIndex == 0);
//
//      jointAnchor = jointAnchor.mNextAnchor;
//   }
//
//// ..
//
//   // now anotherBody == mBody
//   anotherBody.OnShapeListChanged ();
//
//   if (isPhysicsShape)
//      AddSelfMomentumToBody ();
//
//// ...
//
//   oldBody.OnShapeListChanged ();
//}

//================================================================
// connections
//================================================================

public function BreakAllJoints ():void
{
   while (mJointAnchorListHead != null)
   {
      mJointAnchorListHead.mJoint.Destroy ();
   }
}

public function BreakAllJointsOfBrothers ():void
{
   //todo
}

public function BreakAllJointsOfIsland ():void
{
   //todo
}

//================================================================
// power
//================================================================

// AddMomentumByLinearVelocity
public function AddLinearMomentum (valueX:Number, valueY:Number, valueIsVelocity:Boolean = false, onBodyCenter:Boolean = false):void
{
   var worldX:Number;
   var worldY:Number;

   //>>> before v1.56
   //if (onBodyCenter)
   //{
   //   if (mBody.mNumPhysicsShapes == 0)
   //      return;
   //}
   //else
   //{
   //   if (mPhysicsProxy == null)
   //      return;
   //
   //   //mBody.mNumPhysicsShapes > 0
   //}
   //<<<

   //>>> from v1.56
   if (mBody.mNumPhysicsShapes == 0)
      return;
   //<<<

   if (onBodyCenter || IsTheOnlyPhysicsShapeInBody ())
   {
      worldX = mBody.GetPositionX ();
      worldY = mBody.GetPositionY ();
   }
   else
   {
      SynchronizeWorldCentroid ();
      worldX = mWorldCentroidX;
      worldY = mWorldCentroidY;
   }

   var momentumX:Number;
   var momentumY:Number;

   if (valueIsVelocity)
   {
      // mMass is possible zero for many reasons
      var mass:Number = onBodyCenter ? mBody.GetMass () : mMass;

      momentumX = mass * valueX;
      momentumY = mass * valueY;
   }
   else
   {
      momentumX = valueX;
      momentumY = valueY;
   }

   if (momentumX != 0.0 || momentumY != 0.0)
   {
      mBody.ApplyLinearImpulse (momentumX, momentumY, worldX, worldY);
   }
}

// todo: 搴旇鍍廇ddLinearMomentum涓�牱鍔犱竴涓猳nBodyCenter鍙傛暟銆�// - 闇�璋冪敤AddLinearMomentum鏉ュ仛閫傚綋璋冩暣.
public function AddAngularMomentum (value:Number, valueIsVelocity:Boolean = false):void
{
   // non-physics will also be valid
   //if (mPhysicsProxy == null)
   //   return;

   if (mBody.mNumPhysicsShapes == 0)
      return;

   var momentum:Number;

   if (valueIsVelocity)
   {
      momentum = mInertia * value;
   }
   else
   {
      momentum = value;
   }

   if (momentum != 0.0)
   {
      mBody.ApplyAngularImpulse (momentum);
   }
}

//================================================================
// misc
//================================================================

public static function CreateParticle (world:World, createFrondOfEntity:Entity, posX:Number, posY:Number, velocityX:Number, velocityY:Number, density:Number, restitution:Number, lifeDuration:Number, color:uint, isVisible:Boolean, ccat:CollisionCategory):EntityShape_Particle
{
   var body:EntityBody = new EntityBody (world);
   world.RegisterEntity (body);

   var particle:EntityShape_Particle = new EntityShape_Particle (world, lifeDuration);
   world.RegisterEntity (particle);

   particle.InitCustomPropertyValues (); // fixed in v1.56

   particle.SetPositionX (posX);
   particle.SetPositionY (posY);
   particle.SetLinearVelocityX (velocityX);
   particle.SetLinearVelocityY (velocityY);
   particle.SetDensity (density);
   particle.SetRestitution (restitution);
   particle.SetFilledColor (color);
   particle.SetVisible (isVisible);
   particle.SetBody (body);
   particle.SetCollisionCategory (ccat);

   particle.RebuildShapePhysics ();

   body.OnShapeListChanged (true);
   body.AddShapeMomentums ();

   body.SynchronizeWithPhysicsProxyManually ();
   particle.SynchronizeWithPhysicsProxy ();

   //...
   if (createFrondOfEntity != null)
   {
      particle.AdjustAppearanceOrder (createFrondOfEntity, true);
   }

   // for efficiency, currently, event handlers are not registered on particles

   // NOTE: EntityShape_Particle class overrides RegisterEventHandler function with a blank one.

   // world.RegisterEventHandlersForEntity (true, particle);
   // particle.OnCreated ();
   // if (world.ShouldInitRuntimeCteatedEntitiesManually ())
   // {
   //    world.RegisterEventHandlersForEntity (false, particle);
   //    particle.Initialize ();
   // }

   // ...
   return particle;
}
