
package player.physics {

   import Box2D.Collision.b2ContactPoint;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Dynamics.Contacts.b2ContactResult;

   import Box2D.Dynamics.b2ContactListener;
   
   public class _ContactListener extends b2ContactListener
   {
      private var mPhysicsEngine:PhysicsEngine;
      
      public function _ContactListener (phyEngine:PhysicsEngine)
      {
         mPhysicsEngine = phyEngine;
      }
      
      private var mNumPoints:int = 0;
      private var mNumPoints_Add:int;
      private var mNumPoints_Persist:int;
      private var mNumPoints_Remove:int;
      
      public function Reset ():void
      {
         //trace ("------------ mNumPoints = " + mNumPoints + " | " + (mNumPoints_Persist + mNumPoints_Add - mNumPoints_Remove));
         //trace ("mNumPoints_Add = " + mNumPoints_Add);
         //trace ("mNumPoints_Persist = " + mNumPoints_Persist);
         //trace ("mNumPoints_Remove = " + mNumPoints_Remove);
         
         mNumPoints_Add = 0;
         mNumPoints_Persist = 0;
         mNumPoints_Remove = 0;
      }
      
      /// Called when a contact point is added. This includes the geometry
      /// and the forces.
      override public function Add(point:b2ContactPoint) : void
      {
         //mNumPoints_Add ++;
         //mNumPoints ++;
         
         if (mPhysicsEngine._OnShapeContactStarted != null)
            mPhysicsEngine._OnShapeContactStarted (point.shape1.GetUserData () as PhysicsProxyShape, point.shape2.GetUserData () as PhysicsProxyShape);
      }
      
      /// Called when a contact point persists. This includes the geometry
      /// and the forces.
      override public function Persist(point:b2ContactPoint) : void
      {
         //mNumPoints_Persist ++;
         
         if (mPhysicsEngine._OnShapeContactContinued != null)
            mPhysicsEngine._OnShapeContactContinued (point.shape1.GetUserData () as PhysicsProxyShape, point.shape2.GetUserData () as PhysicsProxyShape);
      }
      
      /// Called when a contact point is removed. This includes the last
      /// computed geometry and forces.
      override public function Remove(point:b2ContactPoint) : void
      {
         //mNumPoints_Remove ++;
         //mNumPoints --;
         
         if (mPhysicsEngine._OnShapeContactFinished == null)
            mPhysicsEngine._OnShapeContactFinished (point.shape1.GetUserData () as PhysicsProxyShape, point.shape2.GetUserData () as PhysicsProxyShape);
      }
      
      /// Called after a contact point is solved.
      override public function Result(point:b2ContactResult) : void
      {
         if (mPhysicsEngine._OnShapeContactResult == null)
            mPhysicsEngine._OnShapeContactResult (point.shape1.GetUserData () as PhysicsProxyShape, point.shape2.GetUserData () as PhysicsProxyShape);
      }
   }
 }

