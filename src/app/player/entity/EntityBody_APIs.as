
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

public function ApplyForceAtPoint (forceX:Number, forceY:Number, pointX:Number, pointY:Number):void
{
   if (mPhysicsProxy == null)
      return;
   
   mPhysicsProxyBody.AddForceAtPoint (forceX, forceY, pointX, pointY);
}

public function ApplyTorque (torque:Number):void
{
   if (mPhysicsProxy == null)
      return;
   
   mPhysicsProxyBody.AddTorque (torque);
}
