
public function Teleport (targetX:Number, targetY:Number, targetRotation:Number, bTeleportConnectedMovables:Boolean, bTeleprotConnectedStatics:Boolean):void
{
   SetPositionX (targetX);
   SetPositionY (targetY);
   SetRotation (targetRotation);
   
   RecalLocalPosition ();
   
   if (IsPhysicsShape ())
   {
      DestroyPhysicsProxy ();
         mBody.UpdateMass ();
      RebuildShapePhysics ();
         mBody.UpdateMass ();
      
      if (mBody != null)
      {
         mBody.TracePhysicsInfo ();
         
         mBody.CoincideWithCentroid ();
         
         mBody.TracePhysicsInfo ();
      }
   }
}

