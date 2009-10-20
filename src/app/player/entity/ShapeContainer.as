
package player.entity {
   
   import flash.geom.Point;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyBody;
   
   import common.Define;
   
   // to rename to ElementContainer
   public class ShapeContainer extends Entity
   {
      private var mIsBullet:Boolean = false;
      
      public function ShapeContainer (world:World)
      {
         super (world);
      }
      
      override protected function UpdateInternal (dt:Number):void
      {
         if (mPhysicsProxy != null)
         {
            var point:Point = GetPosition ();
            
            x = point.x;
            y = point.y;
            
            SetRotation ((mPhysicsProxy as PhysicsProxyBody).GetRotation ());
         }
         
         for (var i:int = 0; i < numChildren; ++ i)
         {
            var object:Object = getChildAt (i);
            if (object is Entity)
               (object as Entity).Update (dt);
         }
      }
      
      override protected function DestroyInternal ():void
      {
         var entity:Entity;
         
         while (numChildren > 0)
         {
            entity = getChildAt (0) as Entity;
            if (entity != null)
            {
               entity.Destroy ();
            }
            
            removeChildAt (0);
         }
         
         super.DestroyInternal ();
      }
      
      public function SetBullet (bullet:Boolean):void
      {
         mIsBullet = bullet;
         
         if (mPhysicsProxy != null)
            (mPhysicsProxy as PhysicsProxyBody).SetBullet (mIsBullet);
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         if (params.mContainsPhysicsShapes && mPhysicsProxy == null)
         {
            // 
            mPhysicsProxy = mWorld.mPhysicsEngine.CreateProxyBody (params.mPosX, params.mPosY, 0, params.mIsStatic, params);
            
            mPhysicsProxy.SetUserData (this);
            
            (mPhysicsProxy as PhysicsProxyBody).SetBullet (mIsBullet);
         }
         
         x = params.mPosX;
         y = params.mPosY;
      }
      
      public function ContainsPhysicShapeEntities ():Boolean
      {
         for (var i:int = 0; i < numChildren; ++ i)
         {
            var entity:Entity = getChildAt (i) as Entity;
            
            if ( entity.IsPhysicsShapeEntity () )
               return true;
         }
         
         return false;
      }
      
      public function GetPosition ():Point
      {
         var point:Point;
         if (mPhysicsProxy != null)
         {
            point = (mPhysicsProxy as PhysicsProxyBody).GetPosition ();
            mWorld.mPhysicsEngine._PhysicsPoint2DisplayPoint (point);
         }
         else
            point = new Point (x, y);
         
         return point;
      }
      
      public function UpdateMass ():void
      {
         if (mPhysicsProxy == null)
            return;
         
         var isStatic:Boolean = false;
         
         for (var i:int = 0; i < numChildren; ++ i)
         {
            var shape:EntityShape = getChildAt (i) as EntityShape;
            if (shape != null)
            {
               if ( shape.IsStatic () )
               {
                  isStatic = true;
                  break;
               }
            }
         }
         
        (mPhysicsProxy as PhysicsProxyBody).UpdateMass (isStatic);
      }
      
      public function GetMaxChildEntityIdInEditor ():int
      {
         var maxEntityId:int = -1;
         for (var j:int = 0; j < numChildren; ++ j)
         {
            var shape:EntityShape = getChildAt (j) as EntityShape;
            if (shape != null)
            {
               var shapeLayerId:int = shape.GetEntityIndexInEditor ();
               
               if (shapeLayerId > maxEntityId)
                  maxEntityId = shapeLayerId;
            }
         }
         
         return maxEntityId;
      }
      
   }
   
}
