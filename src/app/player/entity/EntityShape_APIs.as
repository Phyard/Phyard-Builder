
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
// 
//================================================================

public function AddLinearImpulseAtPoint (worldLinearImpulse:Number, worldX:Number, worldY:Number):void
{
   if (mPhysicsProxy != null)
   {
      mBody.mPhysicsProxyBody.AddImpulse (worldLinearImpulse, worldX, worldY);
   }
}

public function AddForceImpulseAtPoint (worldForceX:Number, worldForceY:Number, worldX:Number, worldY:Number):void
{
   if (mPhysicsProxy != null)
   {
      mBody.mPhysicsProxyBody.AddForce (worldLinearImpulse, worldX, worldY);
   }
}

public function AddAngularImpulse (angularImpulse:Number):void
{
   if (mPhysicsProxy != null)
   {
      mBody.mPhysicsProxyBody.AddAngularImpulse (angularImpulse);
   }
}

public function AddTorque (torque:Number):void
{
   if (mPhysicsProxy != null)
   {
      mBody.mPhysicsProxyBody.AddTorque(torque);
   }
}

//================================================================
// 
//================================================================

public function Detach ():void
{
   var oldBody = mBody;
   SetBody (null);
   oldBody.OnBodyPhysicsShapeListChanged ();
   
   var newBody:EntityBody = new EntityBody ();
   RegisterEntity (newBody);
   
   SetBody (body);
   
   // now newBody == mBody
   newBody.RebuildBodyPhysics ();
   RebuildShapePhysics ();
   
   newBody.OnBodyPhysicsShapeListChanged ();
}

public function AttachWith (anotherShape:EntityShape):void
{
}

public function DetachThenAttachWith (anotherShape:EntityShape):void
{
   var newBody:EntityBody = shape.GetBody ();
   if (shape.GetBody () == mBody)
      return;
   
   var oldBody = mBody;
   SetBody (null);
   oldBody.OnBodyPhysicsShapeListChanged ();
   
   SetBody (newBody);
   
   // now newBody == mBody
   newBody.RebuildBodyPhysics (); // it is possible newBody has not built phyiscs yet.
   RebuildShapePhysics ();
   
   newBody.OnBodyPhysicsShapeListChanged ();
}
