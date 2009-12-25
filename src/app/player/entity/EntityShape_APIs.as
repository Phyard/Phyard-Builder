
public function Teleport (targetX:Number, targetY:Number, deltaRotation:Number, bTeleportConnectedMovables:Boolean, bTeleprotConnectedStatics:Boolean, bBreakEmbarrassedJoints:Boolean):void
{
// ...
   IncreaseLastSpecialId ();
   
   var shape:EntityShape = this;
   var shapesToTeleport:Array = new Array ();
   var bodiesToTeleport:Array = new Array ();
   var jointsToTeleport:Array = new Array ();
   var jointsToBreak:Array = new Array ();
   shapesToTeleport.push (shape);
   
   var anchor:SubEntityJointAnchor;
   var anotherShape:EntityShape;
   var body:EntityBody;
   var joint:EntityJoint;
   
   var numShapesToTeleport:int = 0;
   
   var i:int;
   var num:int;
   
// collect shapes to teleport
// collect bodies of shapes to teleport
   
   while (shapesToTeleport.length > numShapesToTeleport)
   {
      shape = shapesToTeleport [numShapesToTeleport];
      shape.mSpecialId = sLastSpecialId;
      ++ numShapesToTeleport;
      
   // body
      
      body = shape.mBody;
      if (body.mSpecialId != sLastSpecialId)
      {
         body.mSpecialId = sLastSpecialId;
         bodiesToTeleport.push (body);
         
   // brother shapes
         
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
      
   // connected shapes
      
      anchor = shape.mJointAnchorListHead;
      
      while (anchor != null)
      {
         anotherShape = anchor.mAnotherJointAnchor.mShape;
         anchor = anchor.mNextAnchor;
         
         if (anotherShape != null && anotherShape.mSpecialId != sLastSpecialId)
         {
            anotherShape.mSpecialId != sLastSpecialId;
            
            if (anotherShape.mBody.IsStatic ())
            {
               if (bTeleprotConnectedStatics)
                  shapesToTeleport.push (anotherShape)
            }
            else
            {
               if (bTeleportConnectedMovables)
                  shapesToTeleport.push (anotherShape);
            }
         }
      }
   }
   
// collect joints connecting with 2 shapes to teleprot
// collect joints connecting with only one shape to teleport
   
   for (i = 0; i < numShapesToTeleport; ++ i)
   {
      shape = shapesToTeleport [i] as EntityShape;
      
   // joints
      
      anchor = shape.mJointAnchorListHead;
      
      while (anchor != null)
      {
         anotherShape = anchor.mAnotherJointAnchor.mShape;
         joint = anchor.mJoint;
         
         anchor = anchor.mNextAnchor;
         
         if (joint.mSpecialId != sLastSpecialId)
         {
            joint.mSpecialId = sLastSpecialId;
            
            if (anotherShape == null || anotherShape.mSpecialId != sLastSpecialId) // shape will teleport, anotherShape will not
            {
               jointsToBreak.push (joint);
            }
            else // both shapes will teleport
            {
               jointsToTeleport.push (joint);
            }
         }
      }
   }

// if bBreakEmbarrassedJoints is true, destroy joints connecting with only one shape to teleport,

   if (bBreakEmbarrassedJoints)
   {
      num = jointsToBreak.length;
      
      for (i = 0; i < num; ++ i)
      {
         joint = jointsToBreak [i] as EntityJoint;
         
         joint.Destroy ();
      }
   }

// move bodies to teleport

   var oldPositionX:Number = mPositionX;
   var oldPositionY:Number = mPositionY;
   var cos:Number = Math.cos (deltaRotation);
   var sin:Number = Math.sin (deltaRotation);
   var dx:Number;
   var dy:Number;
   
   num = bodiesToTeleport.length;
   
   for (i = 0; i < num; ++ i)
   {
      body = bodiesToTeleport [i] as EntityBody;
      
      dx = body.mPositionX - oldPositionX;
      dy = body.mPositionY - oldPositionY;
      
      body.mPositionX = targetX + dx * cos - dy * sin;
      body.mPositionY = targetY + dx * sin + dy * cos;
      body.mRotation += deltaRotation;
      
      body.SynchronizePositionAndRotationToPhysicsProxy ();
      
   // update postion and rotation of shapes in body
      
      anotherShape = body.mShapeListHead;
      
      while (anotherShape != null)
      {
         anotherShape.SynchronizeWithPhysicsProxy ();
         
         anotherShape = anotherShape.mNextShapeInBody;
      }
   }
}

public function MoveTo (targetX:Number, targetY:Number):void
{
   // todo
}

//================================================================
// detach / attach (glue)
// all these functions assume the physics of entities are all built.
//================================================================

public function Detach ():void
{
   var oldBody:EntityBody = mBody;
   if (oldBody.mNumShapes == 1 && oldBody.mShapeListHead == this)
      return;
   
   var isPhysicsShape:Boolean = IsPhysicsShape ();
   
// crete a new body
   
   if (isPhysicsShape)
      UpdateVelocityAndWorldCentroid ();
   
   var newBody:EntityBody = new EntityBody (mWorld);
   mWorld.RegisterEntity (newBody);
   
   SetBody (newBody);
   if (isPhysicsShape)
   {
      RebuildShapePhysics ();
   }
   
// now, the joints connected with shapes are still connect the old body (because in box2d, joints are connected with body instead of shape)
   
   var jointAnchor:SubEntityJointAnchor = mJointAnchorListHead;
   while (jointAnchor != null)
   {
      jointAnchor.mJoint.GetPhysicsProxyJoint ().ReconncetShape (this, jointAnchor.mAnchorIndex == 0);
      
      jointAnchor = jointAnchor.mNextAnchor;
   }
   
// ...
   
   // now newBody == mBody
   newBody.OnPhysicsShapeListChanged ();
   
   if (isPhysicsShape)
      AddMomentumToBody ();
   
// ..
   
   oldBody.OnPhysicsShapeListChanged ();
}

public function AttachWith (anotherShape:EntityShape):void
{
trace ("AttachWith");
   var anotherBody:EntityBody = anotherShape.GetBody ();
   
   if (anotherBody == mBody)
      return;
trace ("AttachWith 111");
   
// ...
   
   var keptBody:EntityBody;
   var discardedBody:EntityBody;
   if (mBody.mNumPhysicsShapes == anotherBody.mNumPhysicsShapes)
   {
      if (mBody.mNumShapes >= anotherBody.mNumShapes)
      {
         keptBody = mBody;
         discardedBody = anotherBody;
      }
      else
      {
         keptBody = anotherBody;
         discardedBody = mBody;
      }
   }
   else if (mBody.mNumPhysicsShapes > anotherBody.mNumPhysicsShapes)
   {
      keptBody = mBody;
      discardedBody = anotherBody;
   }
   else
   {
      keptBody = anotherBody;
      discardedBody = mBody;
   }
   
// ...
   
   var isPhysicsBody:Boolean = discardedBody.mPhysicsShapeListHead != null;
   
   discardedBody.SynchronizeVelocityWithPhysicsProxy ();
   var discardMass:Number = discardedBody.GetMass ();
   var discardInertia:Number = discardedBody.GetInertia ();
   
// ...
   
   var shape:EntityShape;
   var jointAnchor:SubEntityJointAnchor;
   while (discardedBody.mShapeListHead != null)
   {
      shape = discardedBody.mShapeListHead;
      
      shape.SetBody (keptBody);
      if (shape.IsPhysicsShape ())
         shape.RebuildShapePhysics ();
      
      jointAnchor = shape.mJointAnchorListHead;
      while (jointAnchor != null)
      {
         jointAnchor.mJoint.GetPhysicsProxyJoint ().ReconncetShape (shape, jointAnchor.mAnchorIndex == 0);
         
         jointAnchor = jointAnchor.mNextAnchor;
      }
   }
   
// ..
   
   keptBody.OnPhysicsShapeListChanged ();
   
   if (isPhysicsBody)
   {
      var momentumX:Number = discardMass * discardedBody.mLinearVelocityX;
      var momentumY:Number = discardMass * discardedBody.mLinearVelocityY;
      keptBody.mPhysicsProxyBody.AddLinearImpulseAtPoint (momentumX, momentumY, discardedBody.mPositionX, discardedBody.mPositionY);
      keptBody.mPhysicsProxyBody.AddAngularImpulse (discardInertia * discardedBody.mAngularVelocity + (discardedBody.mPositionX - keptBody.mPositionX) * momentumY - (discardedBody.mPositionY - keptBody.mPositionY) * momentumX);
   }
   
// ..
   
   discardedBody.OnPhysicsShapeListChanged ();
}

public function DetachThenAttachWith (anotherShape:EntityShape):void
{
   var anotherBody:EntityBody = anotherShape.GetBody ();
   
   if (anotherBody == mBody)
      return;
   
   var isPhysicsShape:Boolean = IsPhysicsShape ();
   
   var oldBody:EntityBody = mBody;
   
   UpdateVelocityAndWorldCentroid ();
   
   SetBody (anotherBody);
   if (isPhysicsShape)
      RebuildShapePhysics ();
   
// ...
   
   var jointAnchor:SubEntityJointAnchor = mJointAnchorListHead;
   while (jointAnchor != null)
   {
      jointAnchor.mJoint.GetPhysicsProxyJoint ().ReconncetShape (this, jointAnchor.mAnchorIndex == 0);
      
      jointAnchor = jointAnchor.mNextAnchor;
   }
   
// ..
   
   // now anotherBody == mBody
   anotherBody.OnPhysicsShapeListChanged ();
   
   if (isPhysicsShape)
      AddMomentumToBody ();
   
// ...
   
   oldBody.OnPhysicsShapeListChanged ();
}

public function BreakupBrothers ():void
{
   var oldBody:EntityBody = mBody;
   
   var newBody:EntityBody;
   var shape:EntityShape;
   var jointAnchor:SubEntityJointAnchor;
   var isPhysicsShape:Boolean;
   
   while (oldBody.mShapeListHead != null)
   {
      shape = oldBody.mShapeListHead;
      
      isPhysicsShape = shape.IsPhysicsShape ();
      
      if (isPhysicsShape)
         shape.UpdateVelocityAndWorldCentroid ();
      
      newBody = new EntityBody (mWorld);
      mWorld.RegisterEntity (newBody);
      
      shape.SetBody (newBody);
      if (isPhysicsShape)
      {
         shape.RebuildShapePhysics ();
      }
      
      jointAnchor = shape.mJointAnchorListHead;
      while (jointAnchor != null)
      {
         jointAnchor.mJoint.GetPhysicsProxyJoint ().ReconncetShape (shape, jointAnchor.mAnchorIndex == 0);
         
         jointAnchor = jointAnchor.mNextAnchor;
      }
      
      newBody.OnPhysicsShapeListChanged ();
      
      if (isPhysicsShape)
         shape.AddMomentumToBody ();
   }
   
// ..
   
   oldBody.OnPhysicsShapeListChanged ();
}

public function BreakAllJoints ():void
{
   while (mJointAnchorListHead != null)
   {
      mJointAnchorListHead.mJoint.Destroy ();
   }
}

public function BreakAllJointsOfBrothers ():void
{
   
}

public function BreakAllJointsOfIsland ():void
{
   
}

//================================================================
// misc 
//================================================================

public static function CreateParticle (world:World, posX:Number, posY:Number, velocityX:Number, velocityY:Number, density:Number, lifeDuration:Number):EntityShape_Particle
{
   var body:EntityBody = new EntityBody (world);
   world.RegisterEntity (body);
   
   var particle:EntityShape_Particle = new EntityShape_Particle (world, lifeDuration);
   world.RegisterEntity (particle);
   
   particle.SetPositionX (posX);
   particle.SetPositionY (posY);
   particle.SetLinearVelocityX (velocityX);
   particle.SetLinearVelocityY (velocityY);
   particle.SetDensity (density);
   particle.SetBody (body);
   
   particle.RebuildShapePhysics ();
   
   body.OnPhysicsShapeListChanged ();
   
   // for circle, postion == centroid
   particle.mWorldCentroidX = posX;
   particle.mWorldCentroidY = posY;
   particle.AddMomentumToBody ();
   
   // ...
   return particle;
}
