
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Common.Math.b2Vec2;
   
   
   public class PhysicsProxyShape extends PhysicsProxy
   {
      //protected var _b2Shape:b2Shape = null;
      protected var _b2Shapes:Array = new Array; // for concave polygon, there may be mroe than one b2Shapes
            
      protected var mPhysicsProxyBody:PhysicsProxyBody;
      
      protected var _LocalPosition:b2Vec2 = new b2Vec2 ();
      
      public function PhysicsProxyShape (phyEngine:PhysicsEngine, proxyBody:PhysicsProxyBody):void
      {
         super (phyEngine);
         
         mPhysicsProxyBody = proxyBody;
      }
      
      override public function Destroy ():void
      {
         //if (_b2Shape != null)
         //   mPhysicsProxyBody._b2Body.DestroyShape(_b2Shape);
         for (var i:int = 0; i < _b2Shapes.length; ++ i)
         {
            mPhysicsProxyBody._b2Body.DestroyShape(_b2Shapes [i] as b2Shape);
         }
         
         _b2Shapes.splice (0, _b2Shapes.length);
      }
      
      public function NotifyDestroyed ():void
      {
         //_b2Shape = null;
         
         _b2Shapes.splice (0, _b2Shapes.length);
      }
      
      public function GetProxyBody ():PhysicsProxyBody
      {
         return mPhysicsProxyBody;
      }
      
      public function GetLocalPosition ():Point
      {
         var point:Point = new Point ();
         point.x = _LocalPosition.x;
         point.y = _LocalPosition.y;
         
         return point;
      }
      
   }
   
}
