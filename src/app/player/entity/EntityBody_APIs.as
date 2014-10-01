
public function DestroyAllBreakableShapes ():void
{
   var shape:EntityShape = mShapeListHead;
   var nextShape:EntityShape;
   var numDestroyeds:int = 0;
   var numDestroyedPhysicsShapes:int = 0;
   while (shape != null)
   {
      nextShape = shape.mNextShapeInBody;
      
      if (shape.GetShapeAiType () == Define.ShapeAiType_Breakable)
      {
         shape.Destroy ();
         ++ numDestroyeds;
         if (shape.IsPhysicsShape ())
         {
            ++ numDestroyedPhysicsShapes;
         }
      }
      
      shape = nextShape;
   }
   
   if (numDestroyeds > 0)
   {
      OnShapeListChanged (numDestroyedPhysicsShapes > 0);
   }
}

public function PutShapesInArray (shapes:Array):void
{
   if (shapes == null)
      return;
   
   var shape:EntityShape = mShapeListHead;
   while (shape != null)
   {
      shapes.push (ClassInstance.CreateClassInstance (CoreClassesHub.kEntityClassDefinition, shape));
      shape = shape.mNextShapeInBody;
   }
}

public function ClearPowers ():void
{
   if (mPhysicsProxy == null)
      return;
   
   mPhysicsProxyBody.ClearPowers ();
}

public function GetAccForceX ():Number
{
   return mPhysicsProxy == null ? 0.0 : mPhysicsProxyBody.GetAccForceX ();
}

public function GetAccForceY ():Number
{
   return mPhysicsProxy == null ? 0.0 : mPhysicsProxyBody.GetAccForceY ();
}

public function GetAccTorque ():Number
{
   return mPhysicsProxy == null ?  0.0 : mPhysicsProxyBody.GetAccTorque ();
}

public function ApplyForceAtPoint (worldForceX:Number, worldForceY:Number, worldPointX:Number, worldPointY:Number):void
{
   if (mPhysicsProxy == null)
      return;

   mPhysicsProxyBody.AddForceAtPoint (worldForceX, worldForceY, worldPointX, worldPointY);
}

public function ApplyTorque (torque:Number):void
{
   if (mPhysicsProxy == null)
      return;
   
   mPhysicsProxyBody.AddTorque (torque);
}

public function SetLinearVelocity (vx:Number, vy:Number):void
{
   if (mPhysicsProxy == null)
      return;
      
   mPhysicsProxyBody.SetLinearVelocity (vx, vy);
   
   //FlagVelocitySynchronized (false);
   NotifyVelocityChangedManually ();
}

public function ApplyLinearImpulse (worldPulseX:Number, worldPulseY:Number, worldPointX:Number, worldPointY:Number):void
{
   if (mPhysicsProxy == null)
      return;
   
   mPhysicsProxyBody.AddLinearImpulseAtPoint (worldPulseX, worldPulseY, worldPointX, worldPointY);
   
   //FlagVelocitySynchronized (false);
   NotifyVelocityChangedManually ();
}

public function SetAngularVelocity (av:Number):void
{
   if (mPhysicsProxy == null)
      return;
      
   mPhysicsProxyBody.SetAngularVelocity (av);
   
   //FlagVelocitySynchronized (false);
   NotifyVelocityChangedManually ();
}

public function ApplyAngularImpulse (angularImpulse:Number):void
{
   if (mPhysicsProxy == null)
      return;
   
   mPhysicsProxyBody.AddAngularImpulse (angularImpulse);
   
   //FlagVelocitySynchronized (false);
   NotifyVelocityChangedManually ();
}

public function ClearVelocities ():void
{
   if (mPhysicsProxy == null)
      return;
   
   mPhysicsProxyBody.ClearVelocities ();
   
   //FlagVelocitySynchronized (false);
   NotifyVelocityChangedManually ();
}

public function ModifyShapeStatic (shape:EntityShape, static:Boolean):void
{
   if (static == shape.IsStatic ())
      return;
   
   shape.SetStatic (static);
   
   if (mPhysicsProxy == null)
      return;
   
   var bodyIsStatic:Boolean = mPhysicsProxyBody.IsStatic ();
   
   if (static == bodyIsStatic)
      return;
   
   UpdateBodyPhysicsProperties ();
}

public function ModifyShapeRotationFixed (shape:EntityShape, fixRotation:Boolean):void
{
   if (fixRotation == shape.IsRotationFixed ())
      return;
   
   shape.SetRotationFixed (fixRotation);
   
   if (mPhysicsProxy == null)
      return;
   
   var bodyFixRoatation:Boolean = mPhysicsProxyBody.IsFixRotation ();
   
   if (fixRotation == bodyFixRoatation)
      return;
   
   UpdateBodyPhysicsProperties ();
}