
package player.entity {
   
   import player.entity.EntityShape;
   import player.entity.EntityJoint;
   
   public class JointNode
   {
      internal var mJoint:EntityJoint;
      
      internal var mShape:EntityShape;
      internal var mPrevJointNode:JointNode = null;
      internal var mNextJointNode:JointNode = null;
      
      public function JointNode (joint:EntityJoint, shape:EntityShape)
      {
         mJoint = joint;
         mShape = shape;
         
         if (mShape.mJointNodeListHead != null)
         {
            mShape.mJointNodeListHead.mPrevJointNode = this;
         }
         mNextJointNode = mShape.mJointNodeListHead;
         mShape.mJointNodeListHead = this;
      }
      
      internal function NotifyBroken ():void
      {
         if (mPrevJointNode != null)
         {
            mPrevJointNode.mNextJointNode = mNextJointNode;
         }
         else // (mShape.mJointNodeListHead == this)
         {
            mShape.mJointNodeListHead = mNextJointNode;
         }
         
         if (mNextJointNode != null)
         {
            mNextJointNode.mPrevJointNode = mPrevJointNode;
         }
         
      }
   }
   
}
