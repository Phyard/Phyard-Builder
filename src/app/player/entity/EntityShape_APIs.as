// all these functions assume the physics of entities are all built already.

//================================================================
// change size 
//================================================================

public static function ChangeCircleRadius (circle:EntityShapeCircle, radius:Number):void
{

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
   
   if (isPhysicsShape)
   {
      rect.RebuildShapePhysics ();
      body.OnShapeListChanged (true);
      body.NotifyMovedManually ();
      body.NotifyVelocityChangedManually ();
      body.SetSleeping (false);
      body.SynchronizeWithPhysicsProxyManually ();
      rect.SynchronizeWithPhysicsProxy ();
   }
   else if (! isPhysicsBody)
   {
      body.OnShapeListChanged (false);
      body.NotifyMovedManually ();
   }
   
   // modify joint anchor positions
   rect.ScaleJointAnchorPositions (scaleWidth, scaleHeight);
}

//================================================================
// transform 
//================================================================

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
            anotherShape.mSpecialId = sLastSpecialId;
            
            if (anotherShape.mBody.IsStatic ())
            {
               if (bTeleprotConnectedStatics)
               {
                  shapesToTeleport.push (anotherShape)
               }
            }
            else
            {
               if (bTeleportConnectedMovables)
               {
                  shapesToTeleport.push (anotherShape);
               }
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
// all these functions assume the physics of entities are all built.
   
   num = bodiesToTeleport.length;
   
   for (i = 0; i < num; ++ i)
   {
      body = bodiesToTeleport [i] as EntityBody;
      
      body.SetSleeping (false);
      
      dx = body.mPositionX - oldPositionX;
      dy = body.mPositionY - oldPositionY;
      
      body.mPositionX = targetX + dx * cos - dy * sin;
      body.mPositionY = targetY + dx * sin + dy * cos;
      body.SetRotation (body.mPhysicsRotation + deltaRotation);
      
      body.SynchronizePositionAndRotationToPhysicsProxy ();
      
   // update postion and rotation of shapes in body
      
      anotherShape = body.mShapeListHead;
      
      while (anotherShape != null)
      {
         anotherShape.SynchronizeWithPhysicsProxy ();
         anotherShape.FlagWorldCentroidSynchronized (false);
         
         anotherShape = anotherShape.mNextShapeInBody;
      }
   }
}

public function TranslateTo (targetX:Number, targetY:Number):void
{
   // todo
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
   var oldPositionX:Number = oldBody.mPositionX;
   var oldPositionY:Number = oldBody.mPositionY;
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
   var newPositionX:Number = newBody.mPositionX;
   var newPositionY:Number = newBody.mPositionY;
   var newMass:Number = newBody.GetMass ();
   var newInertia:Number = newBody.GetInertia ();
   var newMomentumX:Number = newMass * newBody.GetLinearVelocityX ();
   var newMomentumY:Number = newMass * newBody.GetLinearVelocityY ();
   var newAngularMomentum:Number = newInertia * newBody.GetAngularVelocity ();
   var newForceX:Number = newBody.GetAccForceX ();
   var newForceY:Number = newBody.GetAccForceY ();
   var newTorque:Number = newBody.GetAccTorque ();   
   
   oldBody.ClearVelocities ();

   if (oldBody.mNumPhysicsShapes > 0)
   {
      // conservation of momentum and angular momentum
      oldBody.ApplyLinearImpulse (oldMomentumX, oldMomentumY, oldPositionX, oldPositionY);
      oldBody.ApplyLinearImpulse (-newMomentumX, -newMomentumY, newPositionX, newPositionY);
      oldBody.ApplyAngularImpulse (oldAngularMomentum);
      oldBody.ApplyAngularImpulse (-newAngularMomentum);
   }
   
   oldBody.ClearPowers ();
   newBody.ClearPowers ();

   if (oldMass > 0)
   {
      oldBody.ApplyForceAtPoint (oldForceX * oldBody.GetMass () / oldMass, oldForceY * oldBody.GetMass () / oldMass, oldBody.mPositionX, oldBody.mPositionY);
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
   var discardPositionX:Number = discardedBody.mPositionX;
   var discardPositionY:Number = discardedBody.mPositionY;
   var discardMass:Number = discardedBody.GetMass ();
   var discardInertia:Number = discardedBody.GetInertia ();
   var discardMomentumX:Number = discardMass * discardedBody.GetLinearVelocityX ();
   var discardMomentumY:Number = discardMass * discardedBody.GetLinearVelocityY ();
   var discardAngularMomentum:Number = discardInertia * discardedBody.GetAngularVelocity ();
   var discardForceX:Number = discardedBody.GetAccForceX ();
   var discardForceY:Number = discardedBody.GetAccForceY ();
   var discardTorque:Number = discardedBody.GetAccTorque ();
         
   //keptBody.SynchronizeVelocityWithPhysicsProxy ();
   var keptOldPositionX:Number = keptBody.mPositionX;
   var keptOldPositionY:Number = keptBody.mPositionY;
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
   
// ..

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
      worldX = mBody.mPositionX;
      worldY = mBody.mPositionY;
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

public static function CreateParticle (world:World, posX:Number, posY:Number, velocityX:Number, velocityY:Number, density:Number, restitution:Number, lifeDuration:Number, color:uint, isVisible:Boolean, ccat:CollisionCategory):EntityShape_Particle
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
   
   // ...
   return particle;
}
