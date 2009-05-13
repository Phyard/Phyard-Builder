
package player.physics {
   import flash.utils.ByteArray;

   import Box2D.Collision.b2ContactPoint;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Dynamics.Contacts.b2ContactResult;
   import Box2D.Collision.Shapes.b2FilterData;
   
   import Box2D.Dynamics.b2ContactFilter;
   
   public class _ContactFilter extends b2ContactFilter
   {
      private var mPhysicsEngine:PhysicsEngine;
      
      private var mNumberGroups:uint = 16;
      private var mTableRowShift:uint = 4;
      private var mFriendTable:ByteArray = null;
      
      public function _ContactFilter (phyEngine:PhysicsEngine, numGroups:uint = 16)
      {
         mPhysicsEngine = phyEngine;
         
         if (numGroups <= 16)
         {
            mNumberGroups = 16;
            mTableRowShift = 4;
         }
         else if (numGroups <= 32)
         {
            mNumberGroups = 32;
            mTableRowShift = 5;
         }
         else if (numGroups <= 64)
         {
            mNumberGroups = 64;
            mTableRowShift = 6;
         }
         else if (numGroups <= 128)
         {
            mNumberGroups = 128;
            mTableRowShift = 7;
         }
         else
         {
            mNumberGroups = 16;
            mTableRowShift = 4;
            
            trace ("too many collision categoroes");
         }
         
         mFriendTable = new ByteArray ();
         mFriendTable.length = (mNumberGroups * mNumberGroups);
         for (var i:int = 0; i < mFriendTable.length; ++ i)
            mFriendTable [i] = 0;
      }
      
      public function CreateCollisionCategoryFriendLink (groupIndex1:int, groupIndex2:int):void
      {
      //trace ("groupIndex1 = " + groupIndex1 + ", groupIndex2 = " + groupIndex2 + ", mNumberGroups = " + mNumberGroups);
         if (groupIndex1 < 0)
            groupIndex1 = - groupIndex1;
         if (groupIndex2 < 0)
            groupIndex2 = - groupIndex2;
         
         mFriendTable [ (groupIndex1 << mTableRowShift) + groupIndex2 ] = 1;
         mFriendTable [ (groupIndex2 << mTableRowShift) + groupIndex1 ] = 1;
      }
      
	   /// Return true if contact calculations should be performed between these two shapes.
      /// @warning for performance reasons this is only called when the AABBs begin to overlap.
      override public virtual function ShouldCollide(shape1:b2Shape, shape2:b2Shape) : Boolean
      {
         var filter1:b2FilterData = shape1.GetFilterData();
         var filter2:b2FilterData = shape2.GetFilterData();
         
         var groupIndex1:int = filter1.groupIndex;
         var groupIndex2:int = filter2.groupIndex;
         
         if (groupIndex1 == 0 || groupIndex2 == 0)
            return true;
         
         if (groupIndex1 == groupIndex2)
            return groupIndex1 > 0;
         
         if (groupIndex1 < 0)
            groupIndex1 = - groupIndex1;
         if (groupIndex2 < 0)
            groupIndex2 = - groupIndex2;
         
         return mFriendTable [ (groupIndex1 << mTableRowShift) + groupIndex2 ] == 0;
      }
   }
 }

