package player.entity {
   
   import player.world.World;   
   
   import player.physics.PhysicsEngine;
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   
   // There will many shapes glued with a body, either the shapes are physics or not.
   // 
   // In simulation, all shapes glued will syncronize their position and rotation with the body.
   // 
   // When a new physics shape ia added or removed, the body will be rebuilt.
   // 
   // When rebuilding, the body will destroy the physics proxy firstly then rebuild it again (This is a safe but not oprimized implementation). 
   // Before destroying the physics proxy, all shapes will save their status firstly. The save info includs:
   // - global postion
   // - global rotation
   // - global velocity (for physics shapes)
   // 
   // When (re)building a body, the initial rotation is 0. For other values:. 
   // - If there is no physics shapes glued. 
   //   - the initial position is (0, 0), 
   //   - the rotation is 0.
   // - If there is only one physics shape glued with the body: 
   //   - the initial positon of the body set as the body of the position of the shape
   //   - the initial rotation of the body set as the body of the rotation of the shape
   //   - the initial velocity is assigned with the initial velocity of that shape
   //   - the initial angular velocity is assigned with the initial angular velocity of that shape
   //   - linear and angular dampings are assigned with values of that shape
   //   - allowSleep, IsBullet, fixRotation, isStatic: all ffrom the values of that shape
   // - If there are more than one physics shapes: 
   //   - the initial positon of the body set as the average positon of all shapes (the wweight is 1.0 for all shapes)
   //   - the initial rotation of the body set as 0
   //   - the inital velocity of each physics shspe will be converted to a step force and a step torque and apply the force and torque to the body.
   //   - the inital angular velocity of each physics shspe will be a step torque and apply the torque to the body.
   //   - linear and angular dampings are assigned with max values of all physics shapes
   //   - allowSleep is false if any physicsShape.allowSleep is false;
   //     IsBullet is true if any physicsShape.IsBullet is true;
   //     fixRotation is true if any physicsShape.fixRotation is true;
   //     isStatic is true if any physicsShape.isStatic is true;
   
   // int box2d, it is legal the postion of the EntityBody and the centroid are different.
   // but in this soft, then must be the same.
   
   public class EntityBody extends Entity
   {
      include "EntityBody_APIs.as";
      
//=============================================================
//   
//=============================================================
      
      public function EntityBody (world:World)
      {
         super (world);
      }
      
//=============================================================
//   destroy
//=============================================================
      
      override protected function DestroyInternal ():void
      {
         while (mShapeListHead != null)
         {
            mShapeListHead.Destroy ();
         }
      }
      
//=============================================================
//   shape list
//=============================================================
      
      // the shapes glued together
      // the order of shapes should not bring random factors to the system
      internal var mShapeListHead:EntityShape = null;
      internal var mPhysicsShapeListHead:EntityShape = null;
      
      internal var mNumShapes:int = 0;
      internal var mNumPhysicsShapes:int = 0;
      
      public function GetNumPhysicsShapes ():int
      {
         return mNumPhysicsShapes;
      }
      
      public function GetNumShapes ():int
      {
         return mNumShapes;
      }
      
      // to add a shape in the body, use EntityShape.SetBody (theBody), don't call AddShape directly
      internal function AddShape (shape:EntityShape):void
      {
         if (shape.mBody != null)
         {
            if (shape.mBody == this)
               return;
            
            shape.mBody.RemoveShape (shape);
         }
         
         shape.mBody = this;
         
         shape.mNextShapeInBody = mShapeListHead;
         if (mShapeListHead != null)
            mShapeListHead.mPrevShapeInBody = shape;
         mShapeListHead = shape;
         
         if (shape.IsPhysicsShape ())
         {
            shape.mNextPhysicsShapeInBody = mPhysicsShapeListHead;
            if (mPhysicsShapeListHead != null)
               mPhysicsShapeListHead.mPrevPhysicsShapeInBody = shape;
            mPhysicsShapeListHead = shape;
            
            ++ mNumPhysicsShapes;
         }
         
         ++ mNumShapes;
      }
      
      // to remove a shape in the body, use EntityShape.SetBody (null), don't call RemoveShape directly
      internal function RemoveShape (shape:EntityShape):void
      {
         if (shape.mBody != this)
            return;
         
         var prev:EntityShape = shape.mPrevShapeInBody;
         var next:EntityShape = shape.mNextShapeInBody;
         shape.mPrevShapeInBody = null;
         shape.mNextShapeInBody = null;
         
         if (prev!= null)
            prev.mNextShapeInBody = next;
         else // shape == mShapeListHead
            mShapeListHead = next;
         
         if (next != null)
            next.mPrevShapeInBody = prev;
         
         // ...
         
         // comment off, for the reason see EntityShape.SetPhysicsEnabled ()
         //if (shape.IsPhysicsShape ()) 
         {
            prev = shape.mPrevPhysicsShapeInBody;
            next = shape.mNextPhysicsShapeInBody;
            shape.mPrevPhysicsShapeInBody = null;
            shape.mNextPhysicsShapeInBody = null;
            
            if (prev != null)
               prev.mNextPhysicsShapeInBody = next;
            else // shape == mPhysicsShapeListHead
               mPhysicsShapeListHead = next;
               
            
            if (next != null)
               next.mPrevPhysicsShapeInBody = prev;
            
            -- mNumPhysicsShapes;
         }
         
         -- mNumShapes;
         
         shape.mBody = null;
      }
      
      public function OnPhysicsShapeListChanged (physicsListChanged:Boolean = true):void
      {
         if (mShapeListHead == null)
         {
            Destroy ();
         }
         else 
         {
            if (mPhysicsProxy != null)
            {
               if (mPhysicsShapeListHead == null)
               {
                  DestroyPhysicsProxy ();
               }
               else if (physicsListChanged)
               {
                  UpdateBodyPhysicsProperties ();
                  mPhysicsProxyBody.SetSleeping (false);
               }
            }
            
            CoincideWithCentroid ();
         }
      }
      
//=============================================================
//   postion, rotation
//=============================================================
      
      internal var mCosRotation:Number = 1.0;
      internal var mSinRotation:Number = 0.0;
      private var mLastRotation:Number = 0.0;
      
      // EntityBody.Update () will never be called. SynchronizeWithPhysicsProxy will do what Update () should do.
      override public function SynchronizeWithPhysicsProxy ():void
      {
         if (mShapeListHead == null)
         {
            Destroy ();
         }
         else if (mPhysicsProxy != null)
         {
            if (mPhysicsShapeListHead == null)
            {
               DestroyPhysicsProxy ();
            }
            else
            {
               mPositionX = mPhysicsProxyBody.GetPositionX ();
               mPositionY = mPhysicsProxyBody.GetPositionY ();
               mRotation  = mPhysicsProxyBody.GetRotation ();
               
               UpdateSinCos ();
            }
         }
      }
      
      internal function UpdateSinCos ():void
      {
         if (mRotation != mLastRotation)
         {
            mLastRotation = mRotation;
            
            mCosRotation = Math.cos (mRotation);
            mSinRotation = Math.sin (mRotation);
         }
      }
      
      internal function SynchronizePositionAndRotationToPhysicsProxy ():void
      {
         UpdateSinCos ();
         
         if (mPhysicsProxy != null)
         {
            mPhysicsProxyBody.SetPositionAndRotation (mPositionX, mPositionY, mRotation);
         }
      }
      
//=============================================================
//   mass, inertia
//=============================================================
      
      internal function GetMass ():Number
      {
         if (mPhysicsProxy == null)
            return 0.0;
         else
            return mPhysicsProxyBody.GetMass ();
      }
      
      internal function GetInertia ():Number
      {
         if (mPhysicsProxy == null)
            return 0.0;
         else
            return mPhysicsProxyBody.GetInertia ();
      }
      
//=============================================================
//   velocity
//=============================================================
      
      // for judging if this condition is evaluated already in current step.
      private var mLastVelocityUpdatedStep:int = -1;
      
      internal var mLinearVelocityX:Number = 0.0;
      internal var mLinearVelocityY:Number = 0.0;
      internal var mAngularVelocity:Number = 0.0;
      
      internal function SynchronizeVelocityWithPhysicsProxy ():void
      {
         var worldSimulateSteps:int = mWorld.GetSimulatedSteps ();
         if (mLastVelocityUpdatedStep < worldSimulateSteps)
         {
            mLastVelocityUpdatedStep = worldSimulateSteps;
            
            if (mPhysicsProxy == null)
            {
               mLinearVelocityX = 0.0;
               mLinearVelocityY = 0.0;
               mAngularVelocity = 0.0;
            }
            else
            {
               mLinearVelocityX = mPhysicsProxyBody.GetLinearVelocityX ();
               mLinearVelocityY = mPhysicsProxyBody.GetLinearVelocityY ();
               mAngularVelocity = mPhysicsProxyBody.GetAngularVelocity ();
            }
         }
      }
      
//=============================================================
//   physics proxy
//=============================================================
      
      internal var mPhysicsProxyBody:PhysicsProxyBody = null;
      
      internal function TracePhysicsInfo ():void
      {
         if (mPhysicsProxy == null)
            return;
         
         //trace ("--------------------- body info");
         //trace ("rotation: " + mPhysicsProxyBody.GetRotation () * Define.kRadians2Degrees);
         //trace ("vx: " + mPhysicsProxyBody.GetLinearVelocityX ());
         //trace ("vy: " + mPhysicsProxyBody.GetLinearVelocityY ());
      }
      
      override public function DestroyPhysicsProxy ():void
      {
         var shape:EntityShape = mShapeListHead;
         
         while (shape != null)
         {
            shape.DestroyPhysicsProxy ();
            
            shape = shape.mNextShapeInBody;
         }
         
         super.DestroyPhysicsProxy ();
         
         mPhysicsProxyBody = null;
      }
      
      internal function GetPhysicsProxyBody ():PhysicsProxyBody
      {
         if (mPhysicsProxy == null)
            return null;
         else
            return mPhysicsProxyBody;
      }
      
      public function RebuildBodyPhysics ():void
      {
         if (mPhysicsProxy != null)
            return;
         
         mPhysicsProxy = mPhysicsProxyBody = new PhysicsProxyBody (mWorld.GetPhysicsEngine (), this);
         //mPhysicsProxyBody.SetUserData (this);
         mPhysicsProxyBody.SetAutoUpdateMass (false);
      }
      
      public function UpdateBodyPhysicsProperties ():void
      {
         if (mPhysicsProxy == null)
            return;
         
         var is_static:Boolean = false;
         var is_bullet:Boolean = false;
         var allow_sleeping:Boolean = true;
         var fix_rotation:Boolean = false;
         
         var shape:EntityShape = mPhysicsShapeListHead;
         
         while (shape != null)
         {
            if (shape.IsStatic ())
               is_static = true;
            if (shape.IsBullet ())
               is_bullet = true;
            if (! shape.IsSleepingAllowed ())
               allow_sleeping = false;
            if (shape.IsRotationFixed ())
               fix_rotation = true;
            
            shape = shape.mNextPhysicsShapeInBody;
         }
         
         mPhysicsProxyBody.SetStatic (is_static);
         mPhysicsProxyBody.SetAsBullet (is_bullet);
         mPhysicsProxyBody.SetAllowSleeping (allow_sleeping);
         mPhysicsProxyBody.SetFixRotation (fix_rotation);
         mPhysicsProxyBody.ResetMass ();
      }
      
      public function UpdateMass ():void
      {
         if (mPhysicsProxy == null)
            return;
         
         mPhysicsProxyBody.ResetMass ();
      }
      
      public function CoincideWithCentroid ():void
      {
         var newX:Number;
         var newY:Number;
         var shape:EntityShape;
         
         if (mPhysicsProxy == null)
         {
            newX = 0.0;
            newY = 0.0;
            var n:int = 0;
            
            var nonVisualX:Number = 0.0;
            var nonVisualY:Number = 0.0;
            var numNonVisuals:int = 0;
            
            shape = mShapeListHead;
            while (shape != null)
            {
               if (shape.IsVisualShape ())
               {
                  newX += shape.mPositionX;
                  newY += shape.mPositionY;
                  ++ n;
               }
               else
               {
                  nonVisualX += shape.mPositionX;
                  nonVisualY += shape.mPositionY;
                  ++ numNonVisuals;
               }
               
               shape = shape.mNextShapeInBody;
            }
            
            if (n > 0)
            {
               newX /= n;
               newY /= n;
            }
            else if (numNonVisuals > 0)
            {
               newX = nonVisualX / numNonVisuals;
               newY = nonVisualY / numNonVisuals;
            }
         }
         else
         {
            mPhysicsProxyBody.CoincideWithCentroid ();
            
            newX = mPhysicsProxyBody.GetPositionX ();
            newY = mPhysicsProxyBody.GetPositionY ();
         }
         
         if (newX == mPositionX && newY == mPositionY)
            return;
         
         //var dx:Number = mPositionX - newX
         //var dy:Number = mPositionY - newY;
         //var abs_dx:Number = Math.abs (dx);
         //var abs_dy:Number = Math.abs (dy);
         
         mPositionX = newX;
         mPositionY = newY;
         
         shape = mShapeListHead;
         while (shape != null)
         {
            shape.UpdatelLocalPosition ();
            shape.UpdateMassAndInertiaAndCentroid ();
            
            shape = shape.mNextShapeInBody;
         }
      }
      
      public function AddShapeMomentums ():void
      {
         var shape:EntityShape = mPhysicsShapeListHead;
         
         while (shape != null)
         {
            shape.UpdateWorldCentroid (); // UpdateVelocityAndWorldCentroid will clear shape velocity
            shape.AddMomentumToBody ();
            
            shape = shape.mNextPhysicsShapeInBody;
         }
      }

//=============================================================
//   shape list
//=============================================================

      public function IsStatic ():Boolean
      {
         if (mPhysicsProxy == null)
            return true;
         
         return mPhysicsProxyBody.IsStatic ();
      }
      
      public function IsSleeping ():Boolean
      {
         if (mPhysicsProxy == null)
            return false;
         
         return mPhysicsProxyBody.IsSleeping ();
      }
      
      public function SetSleeping (sleeping:Boolean):void
      {
         if (mPhysicsProxy == null)
            return;
         
         mPhysicsProxyBody.SetSleeping (sleeping);
      }

   }
}
