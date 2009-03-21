
package editor.selection {
   
   import flash.geom.Point;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.Math.*;
   
   
   public class SelectionProxy 
   {
      public var mSelectionEngine:SelectionEngine; // used within package
      
      public var mUserData:Object = null; // used within package
      
      public var _b2Body:b2Body = null; // used within package
      
      protected var mSelectable:Boolean = true;
      
      public function SelectionProxy (selEngine:SelectionEngine):void
      {
         mSelectionEngine = selEngine;
      }
      
      public function SetUserData (userData:Object):void
      {
         mUserData = userData;
      }
      
      public function SetSelectable (selectable:Boolean):void
      {
         mSelectable = selectable;
         
         if (_b2Body == null)
            return;
         
      //
         var shape:b2Shape = _b2Body.m_shapeList;
         
         while (shape != null)
         {
            shape.m_filter.groupIndex = mSelectable ? 0 : -1;
            
            shape = shape.m_next;
         }
      }
      
      public function IsSelectable ():Boolean
      {
         return mSelectable;
      }
      
      protected function Rebuild_b2Body (rotation:Number, pointX:Number, pointY:Number):void
      {
      //
         if (_b2Body != null)
            mSelectionEngine._b2World.DestroyBody (_b2Body);
         
      //
         var bodyDef:b2BodyDef = new b2BodyDef ();
         bodyDef.position.Set (pointX, pointY);
         bodyDef.angle = rotation;
         _b2Body = mSelectionEngine._b2World.CreateBody (bodyDef);
         
         _b2Body.SetUserData (this);
      }
      
      public function GetProxyShapesCount ():int
      {
         if (_b2Body == null)
            return 0;
         else
            return _b2Body.m_shapeCount;
      }
      
      public function Destroy ():void
      {
         if (_b2Body != null);
            mSelectionEngine._b2World.DestroyBody (_b2Body);
      }
      
      public function ContainsPoint (pointX:Number, pointY:Number):Boolean
      {
         if (_b2Body == null)
            return false;
         
      //
         var shape:b2Shape = _b2Body.m_shapeList;
         
         while (shape != null)
         {
            if ( shape.TestPoint(_b2Body.GetXForm(), new b2Vec2 (pointX, pointY)) )
               return true;
            
            shape = shape.m_next;
         }
         
         return false;
      }
      
//==========================================================================
// append shapes
//==========================================================================
      
      public function Rebuild (rotation:Number = 0, centerX:Number = 0, centerY:Number = 0):void
      {
      //
         Rebuild_b2Body (rotation, centerX, centerY);
      }
      
      public function CreateCircleZone (localX:Number, localY:Number, radius:Number):void
      {
      //trace ("------------------- circle");
      //
         var circleDef:b2CircleDef = new b2CircleDef ();
         circleDef.localPosition.Set(localX, localY);
         circleDef.radius = radius;
         circleDef.filter.groupIndex = IsSelectable () ? 0 : -1;
         _b2Body.CreateShape (circleDef);
      }
      
      public function CreateConvexPolygonZone (localPoints:Array):void
      {
      //trace ("------------------- rect");
      //
         var vertexCount:uint = localPoints.length;
         if (vertexCount > b2Settings.b2_maxPolygonVertices)
            vertexCount = b2Settings.b2_maxPolygonVertices;
         
      //
         var polygonDef:b2PolygonDef = new b2PolygonDef ();
         polygonDef.vertexCount = vertexCount;
         polygonDef.filter.groupIndex = IsSelectable () ? 0 : -1;
         for (var i:int = 0; i < vertexCount; ++ i)
         {
            polygonDef.vertices [i].Set (localPoints [i].x, localPoints [i].y);
         }
         
         _b2Body.CreateShape (polygonDef);
      }
      
      public function CreateConcavePolygonZone (localPoints:Array):void
      {
      //trace ("------------------- polygon");
         var vertexCount:uint = localPoints.length;
         
         if (vertexCount < 3)
            return;
         
         var xPositions:Array = new Array (vertexCount);
         var yPositions:Array = new Array (vertexCount);
         
         var i:int;
         
         for (i = 0; i < localPoints.length; ++ i) 
         {
            xPositions[i] = localPoints[i].x;
            yPositions[i] = localPoints[i].y;
         }
         
         // Create the initial poly
         var polygon:b2Polygon = new b2Polygon(xPositions, yPositions, vertexCount);
         
         var decomposedPolygons:Array = new Array ();
         var numDecomposedPolygons:int = b2Polygon.DecomposeConvex(polygon, decomposedPolygons, vertexCount - 2);
         
         for (i = 0; i < numDecomposedPolygons; ++ i) 
         {
            var polygonDef:b2PolygonDef = new b2PolygonDef();
            
            polygonDef.filter.groupIndex = IsSelectable () ? 0 : -1;
            
            decomposedPolygons[i].AddTo(polygonDef);
            
            _b2Body.CreateShape (polygonDef);
         }
      }
      
      public function CreateLineSegmentZone (localX1:Number, localY1:Number, localX2:Number, localY2:Number, thinkness:Number = 1):void
      {
         var dx:Number = localX2 - localX1;
         var dy:Number = localY2 - localY1;
         var rot:Number = Math.atan2 (dy, dx);
         rot += Math.PI * 0.5;
         
         thinkness *= 0.5;
         dx = thinkness * Math.cos (rot);
         dy = thinkness * Math.sin (rot);
         
         var p1:Point = new Point (localX1 + dx, localY1 + dy);
         var p2:Point = new Point (localX1 - dx, localY1 - dy);
         var p3:Point = new Point (localX2 - dx, localY2 - dy);
         var p4:Point = new Point (localX2 + dx, localY2 + dy);
         
         CreateConvexPolygonZone ([p1, p2, p3, p4]);
      }
      
   }
}
