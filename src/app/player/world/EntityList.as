package player.world {
   
   import player.entity.Entity;
   import player.entity.EntityBody;
   import player.entity.EntityShape;
   import player.entity.EntityJoint;
   
   public class EntityList 
   {
      internal var mHead:Entity = null;
      internal var mTail:Entity = null;
      
      private var mIsRemovingLocked:Boolean = false;
      private var mNumEntitiesToDelayUnregister:int = 0;
      private var mEntitiesToDelayUnregister:Array = new Array ();
      
      internal function AddEntity (entity:Entity):void
      {
         if (entity.mEntityList != null)
         {
            entity.mEntityList.RemoveEntity (entity);
         }
         
         if (entity.mIsToRemove)
         {
            entity.mEntityListToAddIn = this;
            return;
         }
         
         entity.mEntityListToAddIn = null;
         
         if (mHead == null)
            mHead = entity;
         
         if (mTail == null)
            mTail = entity;
         else
         {
            mTail.mNextEntity = entity;
            entity.mPrevEntity = mTail;
            mTail = entity;
         }
         
         entity.mEntityList = this;
      }
      
      internal function RemoveEntity (entity:Entity):void
      {
         if (entity.mEntityList != this)
            return;
         
         if (mIsRemovingLocked)
         {
            if (! entity.mIsToRemove)
            {
               mEntitiesToDelayUnregister [mNumEntitiesToDelayUnregister ++] = entity;
               entity.mIsToRemove = true;
            }
            
            return;
         }
         
         entity.mIsToRemove = false;
         
         var prev:Entity = entity.mPrevEntity;
         var next:Entity = entity.mNextEntity;
         
         if (mHead == entity)
            mHead = next;
         
         if (mTail == entity)
            mTail = prev;
         
         if (prev != null)
         {
            prev.mNextEntity = next;
            entity.mPrevEntity = null;
         }
         
         if (next != null)
         {
            next.mPrevEntity = prev;
            entity.mNextEntity = null;
         }
         
         entity.mEntityList = null;
      }
      
      private function DelayUnregisterEntities ():void
      {
         var entity:Entity;
         for (var i:int = 0; i < mNumEntitiesToDelayUnregister; ++ i)
         {
            entity = mEntitiesToDelayUnregister [i];
            RemoveEntity (entity);
            
            if (entity.mEntityListToAddIn != null)
            {
               entity.mEntityListToAddIn.AddEntity (entity);
            }
         }
         
         mNumEntitiesToDelayUnregister = 0;
      }
      
      internal function InitEntities ():void
      {
         mIsRemovingLocked = true;
         
         trace ("--------------- InitEntities ");
         
         var entity:Entity = mHead;
         if (entity != null)
         {
            entity.Initialize ();
            
            trace ("entity [" + entity.GetCreationId () + "] = " + entity);
            
            var tail:Entity = mTail;
            
            while (entity != tail)
            {
               entity = entity.mNextEntity;
               entity.Initialize ();
               
               trace ("entity [" + entity.GetCreationId () + "] = " + entity);
            }
         }
         
         mIsRemovingLocked = false;
         
         DelayUnregisterEntities ();
      }
      
      internal function SynchronizeEntitiesWithPhysicsProxies ():void
      {
         mIsRemovingLocked = true;
         
         var entity:Entity = mHead;
         if (entity != null)
         {
            entity.SynchronizeWithPhysicsProxy ();
            
            var tail:Entity = mTail;
            
            while (entity != tail)
            {
               entity = entity.mNextEntity;
               entity.SynchronizeWithPhysicsProxy ();
            }
         }
         
         mIsRemovingLocked = false;
         
         DelayUnregisterEntities ();
      }
      
      internal function UpdateEntities (dt:Number):void
      {
         mIsRemovingLocked = true;
         
         var entity:Entity = mHead;
         if (entity != null)
         {
            entity.Update (dt);
            
            var tail:Entity = mTail;
            
            while (entity != tail)
            {
               entity = entity.mNextEntity;
               entity.Update (dt);
            }
         }
         
         mIsRemovingLocked = false;
         
         DelayUnregisterEntities ();
      }
      
      internal function BuildShapePhysics ():void
      {
         mIsRemovingLocked = true;
         
         var entity:Entity = mHead;
         if (entity != null)
         {
            if (entity is EntityShape)
               (entity as EntityShape).RebuildShapePhysics ();
            
            var tail:Entity = mTail;
            
            while (entity != tail)
            {
               entity = entity.mNextEntity;
               
               if (entity is EntityShape)
                  (entity as EntityShape).RebuildShapePhysics ();
            }
         }
         
         mIsRemovingLocked = false;
         
         DelayUnregisterEntities ();
      }
      
      internal function UpdateBodyPhysicsProperties ():void
      {
         mIsRemovingLocked = true;
         
         var entity:Entity = mHead;
         if (entity != null)
         {
            if (entity is EntityBody)
               (entity as EntityBody).UpdateBodyPhysicsProperties ();
            
            var tail:Entity = mTail;
            
            while (entity != tail)
            {
               entity = entity.mNextEntity;
               
               if (entity is EntityBody)
                  (entity as EntityBody).UpdateBodyPhysicsProperties ();
            }
         }
         
         mIsRemovingLocked = false;
         
         DelayUnregisterEntities ();
      }
      
      internal function CoincideBodiesWithCentroid ():void
      {
         mIsRemovingLocked = true;
         
         var entity:Entity = mHead;
         if (entity != null)
         {
            if (entity is EntityBody)
               (entity as EntityBody).CoincideWithCentroid ();
            
            var tail:Entity = mTail;
            
            while (entity != tail)
            {
               entity = entity.mNextEntity;
               
               if (entity is EntityBody)
                  (entity as EntityBody).CoincideWithCentroid ();
            }
         }
         
         mIsRemovingLocked = false;
         
         DelayUnregisterEntities ();
      }
      
      
      internal function ConfirmConnectedShapes ():void
      {
         mIsRemovingLocked = true;
         
         var entity:Entity = mHead;
         if (entity != null)
         {
            if (entity is EntityJoint)
               (entity as EntityJoint).ConfirmConnectedShapes ();
            
            var tail:Entity = mTail;
            
            while (entity != tail)
            {
               entity = entity.mNextEntity;
               
               if (entity is EntityJoint)
                  (entity as EntityJoint).ConfirmConnectedShapes ();
            }
         }
         
         mIsRemovingLocked = false;
         
         DelayUnregisterEntities ();
      }
      
      internal function BuildJointPhysics ():void
      {
         mIsRemovingLocked = true;
         
         var entity:Entity = mHead;
         if (entity != null)
         {
            if (entity is EntityJoint)
               (entity as EntityJoint).RebuildJointPhysics ();
            
            var tail:Entity = mTail;
            
            while (entity != tail)
            {
               entity = entity.mNextEntity;
               
               if (entity is EntityJoint)
                  (entity as EntityJoint).RebuildJointPhysics ();
            }
         }
         
         mIsRemovingLocked = false;
         
         DelayUnregisterEntities ();
      }

   }
}