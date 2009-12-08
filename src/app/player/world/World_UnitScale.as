
//=================================================================
//   
//=================================================================

private var mRightHandCoordinates:Boolean = false;

private var mLengthScale_Display2Physics:Number;
private var mLengthScale_Physics2Display:Number;

private var mOffsetX_Display2Physics:Number = 0;
private var mOffsetY_Display2Physics:Number = 0;

private var mLengthScale_Display2Physics_2:Number;
private var mLengthScale_Physics2Display_2:Number;

private var mLengthScale_Display2Physics_3:Number;
private var mLengthScale_Physics2Display_3:Number;

private var mLengthScale_Display2Physics_4:Number;
private var mLengthScale_Physics2Display_4:Number;

public function SetDisplay2PhysicsLengthScale (scale:Number):void
{
   mLengthScale_Display2Physics = scale;
   mLengthScale_Physics2Display = 1.0 / mLengthScale_Display2Physics;
   
   mLengthScale_Display2Physics_2 = scale * scale;
   mLengthScale_Physics2Display_2 = 1.0 / mLengthScale_Display2Physics_2;
   
   mLengthScale_Display2Physics_3 = scale * scale * scale;
   mLengthScale_Physics2Display_3 = 1.0 / mLengthScale_Display2Physics_3;
   
   mLengthScale_Display2Physics_4 = scale * scale * scale * scale;
   mLengthScale_Physics2Display_4 = 1.0 / mLengthScale_Display2Physics_4;
}

public function SetDisplay2PhysicsOffset (displayOffsetX:Number, displayOffsetY:Number):void
{
   mOffsetX_Display2Physics = displayOffsetX;
   mOffsetY_Display2Physics = displayOffsetY;
}

//=================================================================
//   
//=================================================================

public function CorrectRotation (rotation:Number):Number
{
   if (mRightHandCoordinates)
   {
      // todo
   }
   
   return rotation;
}

public function DisplayPosition2PhysicsPoint (dx:Number, dy:Number):Point
{
   return new Point (
      (dx - mOffsetX_Display2Physics) * mLengthScale_Display2Physics,
      (dy - mOffsetY_Display2Physics) * mLengthScale_Display2Physics
      );
}

public function PhysicsPosition2DisplayPoint  (px:Number, py:Number):Point
{
   return new Point (
      px * mLengthScale_Physics2Display + mOffsetX_Display2Physics,
      py * mLengthScale_Physics2Display + mOffsetY_Display2Physics
      );
}

public function DisplayVector2PhysicsVector (dvx:Number, dvy:Number):Point
{
   return new Point (
      dvx * mLengthScale_Display2Physics,
      dvy * mLengthScale_Display2Physics
      );
}

public function PhysicsVector2DisplayVector (pvx:Number, pvy:Number):Point
{
   return new Point (
      pvx * mLengthScale_Physics2Display,
      pvy * mLengthScale_Physics2Display
      );
}

public function DisplayX2PhysicsX (displayPositionX:Number):Number
{
   return (displayPositionX - mOffsetX_Display2Physics) * mLengthScale_Display2Physics;
}

public function DisplayY2PhysicsY (displayPositionY:Number):Number
{
   return (displayPositionY - mOffsetY_Display2Physics) * mLengthScale_Display2Physics;
}

public function PhysicsX2DisplayX (physicsPositionX:Number):Number
{
   return physicsPositionX * mLengthScale_Physics2Display + mOffsetX_Display2Physics;
}

public function PhysicsY2DisplayY (physicsPositionY:Number):Number
{
   return physicsPositionY * mLengthScale_Physics2Display + mOffsetY_Display2Physics;
}

// for length, speed, accaleration

public function DisplayLength2PhysicsLength (dl:Number):Number
{
   return dl * mLengthScale_Display2Physics;
}

public function PhysicsLength2DisplayLength (pl:Number):Number
{
   return pl * mLengthScale_Physics2Display;
}

// for area

public function DisplayArea2PhysicsArea (da:Number):Number
{
   return da * mLengthScale_Display2Physics_2;
}

public function PhysicsArea2DisplayArea (pa:Number):Number
{
   return pa * mLengthScale_Physics2Display_2;
}

// for mass

public function DisplayMass2PhysicsMass (dm:Number):Number
{
   return dm * mLengthScale_Display2Physics_2;
}

public function PhysicsMass2DisplayMass (pm:Number):Number
{
   return pm * mLengthScale_Physics2Display_2;
}

// for interia

public function DisplayInteria2PhysicsInteria (di:Number):Number
{
   return di * mLengthScale_Display2Physics_4;
}

public function PhysicsInteria2DisplayInteria (pi:Number):Number
{
   return pi * mLengthScale_Physics2Display_4;
}

// for torque

public function DisplayTorque2PhysicsTorque (dt:Number):Number
{
   return dt * mLengthScale_Display2Physics_4;
}

public function PhysicsTorque2DisplayTorque (pt:Number):Number
{
   return pt * mLengthScale_Physics2Display_4;
}

// for force, impulse

public function DisplayForce2PhysicsForce (dm:Number):Number
{
   return dm * mLengthScale_Display2Physics_3;
}

public function PhysicsForce2DisplayForce (pm:Number):Number
{
   return pm * mLengthScale_Display2Physics_3;
}
