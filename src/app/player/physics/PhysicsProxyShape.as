
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2Settings;
   
   import Box2D.Collision.Shapes.b2CircleDef;
   import Box2D.Collision.Shapes.b2PolygonDef;
   
   
   
   import Box2D.Collision.Shapes.b2Polygon;
   
   public class PhysicsProxyShape extends PhysicsProxy
   {
      //protected var _b2Shape:b2Shape = null;
      protected var _b2Shapes:Array = new Array; // for concave polygon, there may be mroe than one b2Shapes
            
      protected var mPhysicsProxyBody:PhysicsProxyBody;
      
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
      
      public function AddCircleShape (worldPhysicsX:Number, worldPhysicsY:Number, physicsRadius:Number, params:Object = null):void
      {
         var circleDef:b2CircleDef = new b2CircleDef ();
         circleDef.localPosition.SetV(mPhysicsProxyBody._b2Body.GetLocalVector (new b2Vec2 (worldPhysicsX, worldPhysicsY)));
         circleDef.radius = physicsRadius;
         
         if (params != null)
         {
            circleDef.density = params.mDensity;
            circleDef.friction = params.mFriction;
            circleDef.restitution = params.mRestitution;
            circleDef.isSensor = params.mIsSensor;
         }
         else
         {
            circleDef.density = 1.0;
            circleDef.friction = 0.1;
            circleDef.restitution = 0.2;
         }
         
         //>>froomv1.02
         circleDef.filter.maskBits  = params.mMaskBits;
         circleDef.filter.categoryBits = params.mCategoryBits;
         circleDef.filter.groupIndex = params.mGroupIndex;
         //<<
         
         //_b2Shape = mPhysicsProxyBody._b2Body.CreateShape (circleDef);
         //_b2Shape.SetUserData (this);
         var b2shape:b2Shape = mPhysicsProxyBody._b2Body.CreateShape (circleDef);
         b2shape.SetUserData (this);
         
         _b2Shapes.push (b2shape);
      }
      
      public function AddPolygonShape (worldPhysicsPoints:Array, params:Object = null):void
      {
         var polygonDef:b2PolygonDef = new b2PolygonDef ();
         
         if (params != null)
         {
            polygonDef.density = params.mDensity;
            polygonDef.friction = params.mFriction;
            polygonDef.restitution = params.mRestitution;
            polygonDef.isSensor = params.mIsSensor;
         }
         else
         {
            polygonDef.density = 1.0;
            polygonDef.friction = 0.1;
            polygonDef.restitution = 0.2;
         }
         
         //>>froomv1.02
         polygonDef.filter.maskBits  = params.mMaskBits;
         polygonDef.filter.categoryBits = params.mCategoryBits;
         polygonDef.filter.groupIndex = params.mGroupIndex;
         //<<
         
         var vertexId:int;
         var b2shape:b2Shape;
         
         //>>from v1.04
         if (params != null && params.mIsConcavePotentially)
         {
            var vertexCount:int = worldPhysicsPoints.length;
            
            var xPositions:Array = new Array (vertexCount);
            var yPositions:Array = new Array (vertexCount);
            
            for (vertexId = 0; vertexId < vertexCount; ++ vertexId) 
            {
               xPositions[vertexId] = worldPhysicsPoints[vertexId].x;
               yPositions[vertexId] = worldPhysicsPoints[vertexId].y;
            }
            
            // Create the initial poly
            var polygon:b2Polygon = new b2Polygon(xPositions, yPositions, vertexCount);
            
            var decomposedPolygons:Array = new Array ();
            var numDecomposedPolygons:int = b2Polygon.DecomposeConvex(polygon, decomposedPolygons, vertexCount - 2);
            
            for (var i:int = 0; i < numDecomposedPolygons; ++ i) 
            {
               var newPolygonDef:b2PolygonDef = new b2PolygonDef();
               
               newPolygonDef.density = polygonDef.density;
               newPolygonDef.friction = polygonDef.friction;
               newPolygonDef.restitution = polygonDef.restitution;
               newPolygonDef.isSensor = polygonDef.isSensor;
               
               newPolygonDef.filter.maskBits = polygonDef.filter.maskBits;
               newPolygonDef.filter.categoryBits = polygonDef.filter.categoryBits;
               newPolygonDef.filter.groupIndex = polygonDef.filter.groupIndex;
               
               decomposedPolygons[i].AddTo(newPolygonDef);
               
               b2shape = mPhysicsProxyBody._b2Body.CreateShape (newPolygonDef);
               b2shape.SetUserData (this);
               
               _b2Shapes.push (b2shape);
            }
         }
         //<<
         else
         {
            polygonDef.vertexCount = worldPhysicsPoints.length;
            if (polygonDef.vertexCount > b2Settings.b2_maxPolygonVertices)
               polygonDef.vertexCount = b2Settings.b2_maxPolygonVertices;
            
            for (vertexId = 0; vertexId < polygonDef.vertexCount; ++ vertexId)
            {
               var point:Point = worldPhysicsPoints [vertexId] as Point;
               var vertex:b2Vec2 = new b2Vec2 (point.x, point.y);
               polygonDef.vertices [vertexId].SetV ( mPhysicsProxyBody._b2Body.GetLocalVector (vertex) );
            }
            
            //_b2Shape = mPhysicsProxyBody._b2Body.CreateShape (polygonDef);
            //_b2Shape.SetUserData (this);
            b2shape = mPhysicsProxyBody._b2Body.CreateShape (polygonDef);
            b2shape.SetUserData (this);
            
            _b2Shapes.push (b2shape);
         }
      }
   }
   
}
