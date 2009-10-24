
package player.entity {
   
   import player.world.World;
   
   import player.entity.JointNode;
   
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyJoint;
   
   import player.trigger.entity.EntityEventHandler;
   import player.trigger.data.ListElement_EventHandler;
   
   import common.trigger.CoreEventIds;
   
   public class EntityJoint extends Entity
   {
      internal var mJointNodeA:JointNode = null;
      internal var mJointNodeB:JointNode = null;
      
      public function EntityJoint (world:World)
      {
         super (world);
      }
      
      // used internally
      public function GetRecommendedChildIndex ():int
      {
         if (mPhysicsProxy == null)
            return -1;
         
         var body1:PhysicsProxyBody = (mPhysicsProxy as PhysicsProxyJoint).GetBody1 () as PhysicsProxyBody;
         var body2:PhysicsProxyBody = (mPhysicsProxy as PhysicsProxyJoint).GetBody2 () as PhysicsProxyBody;
         var container1:ShapeContainer = body1 == null ? null : body1.GetUserData () as ShapeContainer;
         var container2:ShapeContainer = body2 == null ? null : body2.GetUserData () as ShapeContainer;
         
         var index1:int = -1;
         var index2:int = -1;
         
         if (container1 != null && mWorld.contains (container1))
           index1 = mWorld.getChildIndex (container1);
         if (container2 != null && mWorld.contains (container2))
           index2 = mWorld.getChildIndex (container2);
         
         return index1 > index2 ? index1 : index2;
      }
      
      protected function SetJointBasicInfo (physicsProxy:PhysicsProxyJoint, shapeA:EntityShape, shapeB:EntityShape):void
      {
         mPhysicsProxy = physicsProxy;
         if (physicsProxy != null)
         {
            physicsProxy.SetUserData (this);
         }
         
         if (shapeA != null)
         {
            mJointNodeA = new JointNode (this, shapeA);
         }
         
         if (shapeB != null)
         {
            mJointNodeB = new JointNode (this, shapeB);
         }
      }
      
      override protected function DestroyInternal ():void
      {
         if (mJointNodeA != null)
         {
            mJointNodeA.NotifyBroken ();
         }
         mJointNodeA = null;
         
         if (mJointNodeB != null)
         {
            mJointNodeB.NotifyBroken ();
         }
         mJointNodeB = null;
         
         super.DestroyInternal ();
      }
      
//=============================================================
//   trigger functions
//=============================================================
      
//=============================================================
//   joint events
//=============================================================
      
      private var mBrokenEventHandlerList:ListElement_EventHandler = null;
      private var mReachLowerLimitEventHandlerList:ListElement_EventHandler = null;
      private var mReachUpperLimitEventHandlerList:ListElement_EventHandler = null;
      
      override public function RegisterEventHandler (eventId:int, eventHandler:EntityEventHandler):void
      {
         super.RegisterEventHandler (eventId, eventHandler);
         
         switch (eventId)
         {
            case CoreEventIds.ID_OnJointBroken:
               mBrokenEventHandlerList = RegisterEventHandlerToList (mBrokenEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnJointReachLowerLimit:
               mReachLowerLimitEventHandlerList = RegisterEventHandlerToList (mReachLowerLimitEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnJointReachUpperLimit:
               mReachUpperLimitEventHandlerList = RegisterEventHandlerToList (mReachUpperLimitEventHandlerList, eventHandler);
               break;
            default:
               break;
         }
      }

      final public function OnJointBroken ():void
      {
         var  list_element:ListElement_EventHandler = mBrokenEventHandlerList;
         
         mEventHandlerValueSource0.mValueObject = this;
         
         while (list_element != null)
         {
            list_element.mEventHandler.HandleEvent (mEventHandlerValueSourceList);
            
            list_element = list_element.mNextListElement;
         }
      }

      final public function OnJointReachLowerLimit ():void
      {
         var  list_element:ListElement_EventHandler = mReachLowerLimitEventHandlerList;
         
         mEventHandlerValueSource0.mValueObject = this;
         
         while (list_element != null)
         {
            list_element.mEventHandler.HandleEvent (mEventHandlerValueSourceList);
            
            list_element = list_element.mNextListElement;
         }
      }

      final public function OnJointReachUpperLimit ():void
      {
         var  list_element:ListElement_EventHandler = mReachUpperLimitEventHandlerList;
         
         mEventHandlerValueSource0.mValueObject = this;
         
         while (list_element != null)
         {
            list_element.mEventHandler.HandleEvent (mEventHandlerValueSourceList);
            
            list_element = list_element.mNextListElement;
         }
      }

      
   }
   
}
