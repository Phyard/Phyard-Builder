
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Common.b2Vec2;
   import Box2D.Common.b2Settings;
   
   //import Box2D.Collision.Shapes.b2CircleDef;
   //import Box2D.Collision.Shapes.b2PolygonDef;
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2PolygonShape;
   
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Dynamics.b2FixtureDef;
   
   import Box2D.Collision.Shapes.b2Polygon;
   
   public class PhysicsProxyShape extends PhysicsProxy
   {
      protected var _b2Fixtures:Array = new Array () // for concave polygon, there may be mroe than one shapes
      
      protected var mPhysicsProxyBody:PhysicsProxyBody;
      
      public function PhysicsProxyShape (phyEngine:PhysicsEngine, proxyBody:PhysicsProxyBody):void
      {
         super (phyEngine);
         
         mPhysicsProxyBody = proxyBody;
      }
      
      override public function Destroy ():void
      {
         for (var i:int = 0; i < _b2Fixtures.length; ++ i)
         {
            mPhysicsProxyBody._b2Body.DestroyFixture(_b2Fixtures [i] as b2Fixture);
         }
         
         _b2Fixtures.splice (0, _b2Fixtures.length);
      }
      
      public function NotifyDestroyed ():void
      {
         _b2Fixtures.splice (0, _b2Fixtures.length);
      }
      
      public function GetProxyBody ():PhysicsProxyBody
      {
         return mPhysicsProxyBody;
      }
      
//========================================================================
// 
//========================================================================
      
      public function AddCircleShape (worldPhysicsX:Number, worldPhysicsY:Number, physicsRadius:Number, params:Object = null):void
      {
         // ...
         var fixture_def:b2FixtureDef = new b2FixtureDef ();
         
         if (params != null)
         {
            fixture_def.density = params.mDensity;
            fixture_def.friction = params.mFriction;
            fixture_def.restitution = params.mRestitution;
            fixture_def.isSensor = params.mIsSensor;
         }
         else
         {
            fixture_def.density = 1.0;
            fixture_def.friction = 0.1;
            fixture_def.restitution = 0.2;
         }
         
         fixture_def.filter.maskBits  = params.mMaskBits;
         fixture_def.filter.categoryBits = params.mCategoryBits;
         fixture_def.filter.groupIndex = params.mGroupIndex;
         
         fixture_def.userData = this;
         
         var circle_shape:b2CircleShape = new b2CircleShape ();
         circle_shape.m_radius = physicsRadius;
         //circle_shape.m_p.CopyFrom (mPhysicsProxyBody._b2Body.GetLocalVector (new b2Vec2 (worldPhysicsX, worldPhysicsY)));
         circle_shape.m_p.Set (worldPhysicsX, worldPhysicsY);
         
         fixture_def.shape = circle_shape;
         
         var b2fixture:b2Fixture = mPhysicsProxyBody._b2Body.CreateFixture (fixture_def);
         _b2Fixtures.push (b2fixture);
      }
      
      public function AddPolygonShape (worldPhysicsPoints:Array, params:Object = null):void
      {
         var fixture_def:b2FixtureDef = new b2FixtureDef ();
         
         if (params != null)
         {
            fixture_def.density = params.mDensity;
            fixture_def.friction = params.mFriction;
            fixture_def.restitution = params.mRestitution;
            fixture_def.isSensor = params.mIsSensor;
         }
         else
         {
            fixture_def.density = 1.0;
            fixture_def.friction = 0.1;
            fixture_def.restitution = 0.2;
         }
         
         //>>froomv1.02
         fixture_def.filter.maskBits  = params.mMaskBits;
         fixture_def.filter.categoryBits = params.mCategoryBits;
         fixture_def.filter.groupIndex = params.mGroupIndex;
         //<<
         
         fixture_def.userData = this;
         
         //...
         var polygon_shape:b2PolygonShape;
         var local_vertices:Array;
         
         var i:int;
         var point:Point;
         var vertexId:int;
         var b2fixture:b2Fixture;
         
         //>>from v1.04
         if (params != null && params.mIsConcavePotentially)
         {
            var vertexCount:int = worldPhysicsPoints.length;
            
            var xPositions:Array = new Array (vertexCount);
            var yPositions:Array = new Array (vertexCount);
            
            for (vertexId = 0; vertexId < vertexCount; ++ vertexId) 
            {
               point = worldPhysicsPoints [vertexId] as Point;
               xPositions[vertexId] = point.x;
               yPositions[vertexId] = point.y;
            }
            
            // Create the initial poly
            var polygon:b2Polygon = new b2Polygon(xPositions, yPositions, vertexCount);
            
            var decomposedPolygons:Array = new Array ();
            var numDecomposedPolygons:int = b2Polygon.DecomposeConvex(polygon, decomposedPolygons, vertexCount - 2);
            
            for (i = 0; i < numDecomposedPolygons; ++ i) 
            {
               local_vertices = (decomposedPolygons[i] as b2Polygon).GetQuanlifiedVertices ();
               
               polygon_shape = new b2PolygonShape ();
               polygon_shape.Set (local_vertices, local_vertices.length);
               
               fixture_def.shape = polygon_shape;
               
               b2fixture = mPhysicsProxyBody._b2Body.CreateFixture (fixture_def);
               _b2Fixtures.push (b2fixture);
            }
         }
         //<<
         else
         {
            var vertice_count:int = worldPhysicsPoints.length <  b2Settings.b2_maxPolygonVertices 
                                    ? 
                                    worldPhysicsPoints.length :  b2Settings.b2_maxPolygonVertices;
            
            local_vertices = new Array (vertice_count);
            for (vertexId = 0; vertexId < vertice_count; ++ vertexId)
            {
               point = worldPhysicsPoints [vertexId] as Point;
               //local_vertices [vertexId] =  mPhysicsProxyBody._b2Body.GetLocalVector (new b2Vec2 (point.x, point.y));
               local_vertices [vertexId] =  b2Vec2.b2Vec2_From2Numbers (point.x, point.y);
            }
            
            polygon_shape = new b2PolygonShape ();
            polygon_shape.Set (local_vertices, local_vertices.length);
               
            fixture_def.shape = polygon_shape;
            
            b2fixture = mPhysicsProxyBody._b2Body.CreateFixture (fixture_def);
            _b2Fixtures.push (b2fixture);
         }
      }
      
//==============================================================================
// commands
//==============================================================================
      
      public function SetAsSensor (isSensor:Boolean):void
      {
         if (_b2Fixtures == null)
            return;
         
         var i:int;
         for (i = 0; i < _b2Fixtures.length; ++ i)
            (_b2Fixtures [i] as b2Fixture).SetSensor (isSensor);
      }
      
      public function SetBodyLinearVelocity (vx:Number, vy:Number):void
      {
         mPhysicsProxyBody.SetLinearVelocity (vx, vy);
      }
      
      public function SetBodyAngularVelocity (omega:Number):void
      {
         mPhysicsProxyBody.SetAngularVelocity (omega);
      }
      
   }
}
