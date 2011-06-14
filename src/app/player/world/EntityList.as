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
      
      private var mLastMarkedTail:Entity = null;
      
      public function MarkLastTail ():void
      {
         mLastMarkedTail = mTail;
      }
      
      public function UnmarkLastTail ():void
      {
         mLastMarkedTail = null;
      }
      
      public function GetHead ():Entity
      {
         return mHead;
      }
      
      public function GetTail ():Entity
      {
         return mTail;
      }
      
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

      // since mCreationIdsToDelete_ThisStep and mCreationIdsToDelete_LastStep are added, 
      // the "mIsRemovingLocked" and "DelayUnregisterEntities" may be not essential any more.
      
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
      
      public function InitEntities (fromLastMarkedTail:Boolean = false):void
      {
         mIsRemovingLocked = true;
         
         var entity:Entity = fromLastMarkedTail ? mLastMarkedTail : mHead;
         if (entity != null)
         {
            var tail:Entity = mTail;
            
            while (true)
            {
               entity.Initialize ();
               
               if (entity == tail)
                  break;
               
               entity = entity.mNextEntity;
            }
         }
         
         mIsRemovingLocked = false;
         
         DelayUnregisterEntities ();
      }
      
      internal function SynchronizeEntitiesWithPhysicsProxies (fromLastMarkedTail:Boolean = false):void
      {
         mIsRemovingLocked = true;
         
         var entity:Entity = fromLastMarkedTail ? mLastMarkedTail : mHead;
         if (entity != null)
         {
            var tail:Entity = mTail;
            
            while (true)
            {
               entity.SynchronizeWithPhysicsProxy ();
               
               if (entity == tail)
                  break;
               
               entity = entity.mNextEntity;
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
            var tail:Entity = mTail;
            
            while (true)
            {
               entity.Update (dt);
               
               if (entity == tail)
                  break;
               
               entity = entity.mNextEntity;
            }
         }
         
         mIsRemovingLocked = false;
         
         DelayUnregisterEntities ();
      }
      
      internal function BuildShapePhysics (fromLastMarkedTail:Boolean = false):void
      {
         mIsRemovingLocked = true;
         
         var entity:Entity = fromLastMarkedTail ? mLastMarkedTail : mHead;
         if (entity != null)
         {
            var tail:Entity = mTail;
            
            while (true)
            {
               if (entity is EntityShape)
                  (entity as EntityShape).RebuildShapePhysics ();
               
               if (entity == tail)
                  break;
               
               entity = entity.mNextEntity;
            }
         }
         
         mIsRemovingLocked = false;
         
         DelayUnregisterEntities ();
      }
      
      internal function OnBodyShapeListChanged (fromLastMarkedTail:Boolean = false):void
      {
         mIsRemovingLocked = true;
         
         var entity:Entity = fromLastMarkedTail ? mLastMarkedTail : mHead;
         var body:EntityBody;
         if (entity != null)
         {
            var tail:Entity = mTail;
            
            while (true)
            {
               if (! entity.IsDestroyedAlready ())
               {
                  body = entity as EntityBody;
                  if (body != null)
                  {
                     body.OnShapeListChanged (body.GetNumPhysicsShapes () > 0);
                  }
               }
               
               if (entity == tail)
                  break;
               
               entity = entity.mNextEntity;
            }
         }
         
         mIsRemovingLocked = false;
         
         DelayUnregisterEntities ();
      }
      
      internal function AddShapeMomentums (fromLastMarkedTail:Boolean = false):void
      {
         mIsRemovingLocked = true;
         
         var entity:Entity = fromLastMarkedTail ? mLastMarkedTail : mHead;
         var body:EntityBody;
         if (entity != null)
         {
            var tail:Entity = mTail;
            
            while (true)
            {
               if (! entity.IsDestroyedAlready ())
               {
                  body = entity as EntityBody;
                  if (body != null)
                  {
                     body.AddShapeMomentums ();
                  }
               }
               
               if (entity == tail)
                  break;
               
               entity = entity.mNextEntity;
            }
         }
         
         mIsRemovingLocked = false;
         
         DelayUnregisterEntities ();
      }
      
      internal function ConfirmConnectedShapes (fromLastMarkedTail:Boolean = false):void
      {
         mIsRemovingLocked = true;
         
         var entity:Entity = fromLastMarkedTail ? mLastMarkedTail : mHead;
         if (entity != null)
         {
            var tail:Entity = mTail;
            
            while (true)
            {
               if (entity is EntityJoint)
                  (entity as EntityJoint).ConfirmConnectedShapes ();
               
               if (entity == tail)
                  break;
               
               entity = entity.mNextEntity;
            }
         }
         
         mIsRemovingLocked = false;
         
         DelayUnregisterEntities ();
      }
      
      internal function BuildJointPhysics (fromLastMarkedTail:Boolean = false):void
      {
         mIsRemovingLocked = true;
         
         var entity:Entity = fromLastMarkedTail ? mLastMarkedTail : mHead;
         if (entity != null)
         {
            var tail:Entity = mTail;
            
            while (true)
            {
               if (entity is EntityJoint)
                  (entity as EntityJoint).RebuildJointPhysics ();
               
               if (entity == tail)
                  break;
               
               entity = entity.mNextEntity;
            }
         }
         
         mIsRemovingLocked = false;
         
         DelayUnregisterEntities ();
      }
      
      internal function ResetEntitySpecialIds ():void
      {
         mIsRemovingLocked = true;
         
         var entity:Entity = mHead;
         if (entity != null)
         {
            var tail:Entity = mTail;
            
            while (true)
            {
               entity.ResetSpecialId ();
               
               if (entity == tail)
                  break;
               
               entity = entity.mNextEntity;
            }
         }
         
         mIsRemovingLocked = false;
         
         DelayUnregisterEntities ();
      }
   }
}