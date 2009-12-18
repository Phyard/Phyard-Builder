package common
{
   import flash.geom.Point;
   
   import common.trigger.ValueTypeDefine;
   
   public class CoordinateSystem
   {
//=========================================================================
//
//=========================================================================
      
      private var mIsRightHand:Boolean = false;

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

//=========================================================================
//
//=========================================================================

      public function CoordinateSystem (originOffsetDisplayX:Number, originOffsetDisplayY:Number, displayToPhysicsScale:Number, rightHand:Boolean)
      {
         mOffsetX_Display2Physics = originOffsetDisplayX;
         mOffsetY_Display2Physics = originOffsetDisplayY;
         
         mLengthScale_Display2Physics = displayToPhysicsScale;
         
         mIsRightHand = rightHand;
         
      // more values ...
         
         mLengthScale_Physics2Display = 1.0 / displayToPhysicsScale;
         
         mLengthScale_Display2Physics_2 = mLengthScale_Display2Physics * mLengthScale_Display2Physics;
         mLengthScale_Physics2Display_2 = 1.0 / mLengthScale_Display2Physics_2;
         
         mLengthScale_Display2Physics_3 = mLengthScale_Display2Physics_2 * mLengthScale_Display2Physics;
         mLengthScale_Physics2Display_3 = 1.0 / mLengthScale_Display2Physics_3;
         
         mLengthScale_Display2Physics_4 = mLengthScale_Display2Physics_3 * mLengthScale_Display2Physics;
         mLengthScale_Physics2Display_4 = 1.0 / mLengthScale_Display2Physics_4;
      }
      
      public function IsRightHand ():Boolean
      {
         return mIsRightHand;
      }
      
      public function GetOriginX ():Number
      {
         return mOffsetX_Display2Physics;
      }
      
      public function GetOriginY ():Number
      {
         return mOffsetY_Display2Physics;
      }
      
      public function GetScale ():Number
      {
         return mLengthScale_Display2Physics;
      }
      
//=======================================================
// 
//=======================================================
      
      public function DisplayPosition2PhysicsPoint (dx:Number, dy:Number):Point
      {
         if (mIsRightHand)
         {
            return new Point (
               (dx - mOffsetX_Display2Physics) * mLengthScale_Display2Physics,
               (mOffsetY_Display2Physics - dy) * mLengthScale_Display2Physics
               );
         }
         else
         {
            return new Point (
               (dx - mOffsetX_Display2Physics) * mLengthScale_Display2Physics,
               (dy - mOffsetY_Display2Physics) * mLengthScale_Display2Physics
               );
         }
      }

      public function PhysicsPosition2DisplayPoint  (px:Number, py:Number):Point
      {
         if (mIsRightHand)
         {
            return new Point (
               px * mLengthScale_Physics2Display + mOffsetX_Display2Physics,
               - py * mLengthScale_Physics2Display + mOffsetY_Display2Physics
               );
         }
         else
         {
            return new Point (
               px * mLengthScale_Physics2Display + mOffsetX_Display2Physics,
               py * mLengthScale_Physics2Display + mOffsetY_Display2Physics
               );
         }
      }

      public function DisplayVector2PhysicsVector (dvx:Number, dvy:Number):Point
      {
         if (mIsRightHand)
         {
            return new Point (
               dvx * mLengthScale_Display2Physics,
               - dvy * mLengthScale_Display2Physics
               );
         }
         else
         {
            return new Point (
               dvx * mLengthScale_Display2Physics,
               dvy * mLengthScale_Display2Physics
               );
         }
      }

      public function PhysicsVector2DisplayVector (pvx:Number, pvy:Number):Point
      {
         if (mIsRightHand)
         {
            return new Point (
               pvx * mLengthScale_Physics2Display,
               - pvy * mLengthScale_Physics2Display
               );
         }
         else
         {
            return new Point (
               pvx * mLengthScale_Physics2Display,
               pvy * mLengthScale_Physics2Display
               );
         }
      }

//==================================================================
// 
//==================================================================

// position, rotation

      public function D2P_PositionX (displayPositionX:Number):Number
      {
         return (displayPositionX - mOffsetX_Display2Physics) * mLengthScale_Display2Physics;
      }

      public function P2D_PositionX (physicsPositionX:Number):Number
      {
         return physicsPositionX * mLengthScale_Physics2Display + mOffsetX_Display2Physics;
      }

      public function D2P_PositionY (displayPositionY:Number):Number
      {
         if (mIsRightHand)
            return (mOffsetY_Display2Physics - displayPositionY) * mLengthScale_Display2Physics;
         else
            return (displayPositionY - mOffsetY_Display2Physics) * mLengthScale_Display2Physics;
      }

      public function P2D_PositionY (physicsPositionY:Number):Number
      {
         if (mIsRightHand)
            return - physicsPositionY * mLengthScale_Physics2Display + mOffsetY_Display2Physics;
         else
            return physicsPositionY * mLengthScale_Physics2Display + mOffsetY_Display2Physics;
      }

      public function D2P_Rotation (rotation:Number):Number
      {
         if (mIsRightHand)
            return Define.kPI_x_2 - rotation;else
            return rotation;
      }

      public function P2D_Rotation (rotation:Number):Number
      {
         if (mIsRightHand)
            return Define.kPI_x_2 - rotation;
         else
            return rotation;
      }

// length, aera

      public function D2P_Length (dl:Number):Number
      {
         return dl * mLengthScale_Display2Physics;
      }

      public function P2D_Length (pl:Number):Number
      {
         return pl * mLengthScale_Physics2Display;
      }

      public function D2P_Area (da:Number):Number
      {
         return da * mLengthScale_Display2Physics_2;
      }

      public function P2D_Area (pa:Number):Number
      {
         return pa * mLengthScale_Physics2Display_2;
      }

// linear / angular velocity

      public function D2P_LinearVelocityX (dvx:Number):Number
      {
         return dvx * mLengthScale_Display2Physics;
      }

      public function P2D_LinearVelocityX (pvx:Number):Number
      {
         return pvx * mLengthScale_Physics2Display;
      }

      public function D2P_LinearVelocityY (dvy:Number):Number
      {
         if (mIsRightHand)
            return - dvy * mLengthScale_Display2Physics;
         else
            return dvy * mLengthScale_Display2Physics;
      }

      public function P2D_LinearVelocityY (pvy:Number):Number
      {
         if (mIsRightHand)
            return - pvy * mLengthScale_Physics2Display;
         else
            return pvy * mLengthScale_Physics2Display;
      }

      public function D2P_LinearVelocityMagnitude (dl:Number):Number
      {
         return dl * mLengthScale_Display2Physics;
      }

      public function P2D_LinearVelocityMagnitude (pl:Number):Number
      {
         return pl * mLengthScale_Physics2Display;
      }

      public function D2P_AngularVelocity (da:Number):Number
      {
         if (mIsRightHand)
            return Define.kPI_x_2 - da;
         else
            return da;
      }

      public function P2D_AngularVelocity (pa:Number):Number
      {
         if (mIsRightHand)
            return Define.kPI_x_2 - pa;
         else
            return pa;
      }

// linear / angular acceleration

      public function D2P_LinearAccelerationX (dl:Number):Number
      {
         return dl * mLengthScale_Display2Physics;
      }

      public function P2D_LinearAccelerationX (pl:Number):Number
      {
         return pl * mLengthScale_Physics2Display;
      }

      public function D2P_LinearAccelerationY (dl:Number):Number
      {
         if (mIsRightHand)
            return - dl * mLengthScale_Display2Physics;
         else
            return dl * mLengthScale_Display2Physics;
      }

      public function P2D_LinearAccelerationY (pl:Number):Number
      {
         if (mIsRightHand)
            return - pl * mLengthScale_Physics2Display;
         else
            return pl * mLengthScale_Physics2Display;
      }

      public function D2P_LinearAccelerationMagnitude (dl:Number):Number
      {
         return dl * mLengthScale_Display2Physics;
      }

      public function P2D_LinearAccelerationMagnitude (pl:Number):Number
      {
         return pl * mLengthScale_Physics2Display;
      }

      public function D2P_AngularAcceleration (daa:Number):Number
      {
         if (mIsRightHand)
            return Define.kPI_x_2 - daa;
         else
            return daa;
      }

      public function P2D_AngularAcceleration (paa:Number):Number
      {
         if (mIsRightHand)
            return Define.kPI_x_2 - paa;
         else
            return paa;
      }

// mass, interia

      public function D2P_Mass (dm:Number):Number
      {
         return dm * mLengthScale_Display2Physics_2;
      }

      public function P2D_Mass (pm:Number):Number
      {
         return pm * mLengthScale_Physics2Display_2;
      }

      public function D2P_Interia (di:Number):Number
      {
         return di * mLengthScale_Display2Physics_4;
      }

      public function P2D_Interia (pi:Number):Number
      {
         return pi * mLengthScale_Physics2Display_4;
      }

// force, torque

      public function D2P_ForceX (df:Number):Number
      {
         return df * mLengthScale_Display2Physics_3;
      }

      public function P2D_ForceX (pf:Number):Number
      {
         return pf * mLengthScale_Physics2Display_3;
      }

      public function D2P_ForceY (df:Number):Number
      {
         if (mIsRightHand)
            return - df * mLengthScale_Display2Physics_3;
         else
            return df * mLengthScale_Display2Physics_3;
      }

      public function P2D_ForceY (pf:Number):Number
      {
         if (mIsRightHand)
            return - pf * mLengthScale_Physics2Display_3;
         else
            return pf * mLengthScale_Physics2Display_3;
      }

      public function D2P_ForceMagnitude (df:Number):Number
      {
         return df * mLengthScale_Display2Physics_3;
      }

      public function P2D_ForceMagnitude (pf:Number):Number
      {
         return pf * mLengthScale_Physics2Display_3;
      }

      public function D2P_Torque (dt:Number):Number
      {
         return dt * mLengthScale_Display2Physics_4;
      }

      public function P2D_Torque (pt:Number):Number
      {
         return pt * mLengthScale_Physics2Display_4;
      }
      
// momentum
      
      public function P2D_MomentumX (pm:Number):Number
      {
         return pm * mLengthScale_Physics2Display_3;
      }

      public function D2P_MomentumX (dm:Number):Number
      {
         return dm * mLengthScale_Display2Physics_3;
      }

      public function P2D_MomentumY (pm:Number):Number
      {
         if (mIsRightHand)
            return - pm * mLengthScale_Physics2Display_3;
         else
            return pm * mLengthScale_Physics2Display_3;
      }

      public function D2P_MomentumY (dm:Number):Number
      {
         if (mIsRightHand)
            return - dm * mLengthScale_Display2Physics_3;
         else
            return dm * mLengthScale_Display2Physics_3;
      }

      public function P2D_MomentumMagnitude (pm:Number):Number
      {
         return pm * mLengthScale_Physics2Display_3;
      }

      public function D2P_MomentumMagnitude (dm:Number):Number
      {
         return dm * mLengthScale_Display2Physics_3;
      }

      public function D2P_AngularMomentum (dam:Number):Number
      {
         if (mIsRightHand)
            return - dam;
         else
            return dam;
      }

      public function P2D_AngularMomentum (pam:Number):Number
      {
         if (mIsRightHand)
            return - pam;
         else
            return pam;
      }

      public function P2D_ImpulseX (pm:Number):Number
      {
         return pm * mLengthScale_Physics2Display_3;
      }

      public function D2P_ImpulseX (dm:Number):Number
      {
         return dm * mLengthScale_Display2Physics_3;
      }

      public function P2D_ImpulseY (pm:Number):Number
      {
         if (mIsRightHand)
            return - pm * mLengthScale_Physics2Display_3;
         else
            return pm * mLengthScale_Physics2Display_3;
      }

      public function D2P_ImpulseY (dm:Number):Number
      {
         if (mIsRightHand)
            return - dm * mLengthScale_Display2Physics_3;
         else
            return dm * mLengthScale_Display2Physics_3;
      }

      public function P2D_ImpulseMagnitude (pm:Number):Number
      {
         return pm * mLengthScale_Physics2Display_3;
      }

      public function D2P_ImpulseMagnitude (dm:Number):Number
      {
         return dm * mLengthScale_Display2Physics_3;
      }

      public function D2P_AngularImpulse (dam:Number):Number
      {
         if (mIsRightHand)
            return -dam;
         else
            return dam;
      }

      public function P2D_AngularImpulse (pam:Number):Number
      {
         if (mIsRightHand)
            return - pam;
         else
            return pam;
      }

//==================================================================
// 
//==================================================================

      public function P2D (directValue:Number, numberUsage:int):Number
      {
         switch (numberUsage)
         {
            case ValueTypeDefine.NumberTypeUsage_PositionX:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_PositionY:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_Rotation:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_Length:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_Area:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_LinearVelocityX:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_LinearVelocityY:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_LinearVelocityMagnitude:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_AngularVelocity:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_LinearAccelerationX:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_LinearAccelerationY:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_LinearAccelerationMagnitude:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_AngularAcceleration:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_Mass:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_Inertia:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_ForceX:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_ForceY:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_ForceMagnitude:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_Torque:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_MomentumX:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_MomentumY:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_MomentumMagnitude:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_AngularMomentum:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_ImpulseX:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_ImpulseY:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_ImpulseMagnitude:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_AngularImpulse:
               directValue = P2D_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_General:
            default:
               break;
         }
         
         return directValue;
      }

      public function D2P (directValue:Number, numberUsage:int):Number
      {
         switch (numberUsage)
         {
            case ValueTypeDefine.NumberTypeUsage_PositionX:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_PositionY:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_Rotation:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_Length:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_Area:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_LinearVelocityX:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_LinearVelocityY:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_LinearVelocityMagnitude:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_AngularVelocity:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_LinearAccelerationX:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_LinearAccelerationY:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_LinearAccelerationMagnitude:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_AngularAcceleration:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_Mass:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_Inertia:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_ForceX:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_ForceY:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_ForceMagnitude:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_Torque:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_MomentumX:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_MomentumY:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_MomentumMagnitude:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_AngularMomentum:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_ImpulseX:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_ImpulseY:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_ImpulseMagnitude:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_AngularImpulse:
               directValue = D2P_PositionX (directValue);
               break;
            case ValueTypeDefine.NumberTypeUsage_General:
            default:
               break;
         }
         
         return directValue;
      }
   }
}
