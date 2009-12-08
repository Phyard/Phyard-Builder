
public function CorrectRotation (rotation:Number):Number
{
   return mCoordinateSystem.CorrectRotation (rotation);
}

public function DisplayPosition2PhysicsPoint (dx:Number, dy:Number):Point
{
   return mCoordinateSystem.DisplayPosition2PhysicsPoint (dx, dy);
}

public function PhysicsPosition2DisplayPoint  (px:Number, py:Number):Point
{
   return mCoordinateSystem.PhysicsPosition2DisplayPoint (px, py);
}

public function DisplayVector2PhysicsVector (dvx:Number, dvy:Number):Point
{
   return mCoordinateSystem.DisplayVector2PhysicsVector (dvx, dvy);
}

public function PhysicsVector2DisplayVector (pvx:Number, pvy:Number):Point
{
   return mCoordinateSystem.PhysicsVector2DisplayVector (pvx, pvy);
}

public function DisplayX2PhysicsX (displayPositionX:Number):Number
{
   return mCoordinateSystem.DisplayX2PhysicsX (displayPositionX);
}

public function DisplayY2PhysicsY (displayPositionY:Number):Number
{
   return mCoordinateSystem.DisplayY2PhysicsY (displayPositionY);
}

public function PhysicsX2DisplayX (physicsPositionX:Number):Number
{
   return mCoordinateSystem.PhysicsX2DisplayX (physicsPositionX);
}

public function PhysicsY2DisplayY (physicsPositionY:Number):Number
{
   return mCoordinateSystem.PhysicsY2DisplayY (physicsPositionY);
}

// for length, speed, accaleration

public function DisplayLength2PhysicsLength (dl:Number):Number
{
   return mCoordinateSystem.DisplayLength2PhysicsLength (dl);
}

public function PhysicsLength2DisplayLength (pl:Number):Number
{
   return mCoordinateSystem.PhysicsLength2DisplayLength (pl);
}

// for area

public function DisplayArea2PhysicsArea (da:Number):Number
{
   return mCoordinateSystem.DisplayArea2PhysicsArea (da);
}

public function PhysicsArea2DisplayArea (pa:Number):Number
{
   return mCoordinateSystem.PhysicsArea2DisplayArea (pa);
}

// for mass

public function DisplayMass2PhysicsMass (dm:Number):Number
{
   return mCoordinateSystem.DisplayMass2PhysicsMass (dm);
}

public function PhysicsMass2DisplayMass (pm:Number):Number
{
   return mCoordinateSystem.PhysicsMass2DisplayMass (pm);
}

// for interia

public function DisplayInteria2PhysicsInteria (di:Number):Number
{
   return mCoordinateSystem.DisplayInteria2PhysicsInteria (di);
}

public function PhysicsInteria2DisplayInteria (pi:Number):Number
{
   return mCoordinateSystem.PhysicsInteria2DisplayInteria (pi);
}

// for torque

public function DisplayTorque2PhysicsTorque (dt:Number):Number
{
   return mCoordinateSystem.DisplayTorque2PhysicsTorque (dt);
}

public function PhysicsTorque2DisplayTorque (pt:Number):Number
{
   return mCoordinateSystem.PhysicsTorque2DisplayTorque (pt);
}

// for force, impulse

public function DisplayForce2PhysicsForce (df:Number):Number
{
   return mCoordinateSystem.DisplayForce2PhysicsForce (df);
}

public function PhysicsForce2DisplayForce (pf:Number):Number
{
   return mCoordinateSystem.PhysicsForce2DisplayForce (pf);
}
