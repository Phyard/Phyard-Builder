
public function DestroyAllBreakableShapes ():void
{
   var shape:EntityShape = mShapeListHead;
   var nextShape:EntityShape;
   var numDestroyeds:int = 0;
   while (shape != null)
   {
      nextShape = shape.mNextShapeInBody;
      
      if (shape.GetShapeAiType () == Define.ShapeAiType_Breakable)
      {
         shape.Destroy ();
         ++ numDestroyeds;
      }
      
      shape = nextShape;
   }
   
   if (numDestroyeds > 0)
   {
      OnPhysicsShapeListChanged ();
   }
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

public function ApplyLinearImpulse (worldPulseX:Number, worldPulseY:Number, worldPointX:Number, worldPointY:Number):void
{
   if (mPhysicsProxy == null)
      return;
   
   mPhysicsProxyBody.AddLinearImpulseAtPoint (worldPulseX, worldPulseY, worldPointX, worldPointY);
   
   FlagVelocitySynchronized (false);
}

public function ApplyAngularImpulse (angularImpulse:Number):void
{
   if (mPhysicsProxy == null)
      return;
   
   mPhysicsProxyBody.AddAngularImpulse (angularImpulse);
   
   FlagVelocitySynchronized (false);
}
