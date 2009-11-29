package Box2D.Collision.Shapes 
{
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Vec2;
	import Box2D.Dynamics.b2BodyDef;
	
	/**
	* ...
	* @author Eric Jordan ( converted to as3 by mike.cann@gmail.com )
	*/
	public class b2Polygon 
	{
		public static const maxVerticesPerPolygon : int = b2Settings.b2_maxPolygonVertices;
		public static const FLT_EPSILON : Number = b2Settings.b2_epsilon;
		public var x : Array; //vertex arrays
		public var y : Array;
		public var nVertices : int;
		
		public var area : Number;
		public var areaIsSet : Boolean;
					
		public function b2Polygon(_x:Array, _y:Array, nVert : int) 
		{
			nVertices = nVert;
			x = [];
			y = [];
			
			for (var i : int = 0; i < nVertices; ++i)
			{
				x[i] = _x[i];
				y[i] = _y[i];
			}
			areaIsSet = false;
		}
						
		/*
		 * Check if the lines a0->a1 and b0->b1 cross.
		 * If they do, intersectionPoint will be filled
		 * with the point of crossing.
		 *
		 * Grazing lines should not return true.
		 */
		public function intersect(a0:b2Vec2, a1:b2Vec2, b0:b2Vec2, b1:b2Vec2) : b2Vec2
		{

			var x1 : Number = a0.x; var y1 : Number = a0.y;
			var x2 : Number = a1.x; var y2 : Number = a1.y;
			var x3 : Number = b0.x; var y3 : Number = b0.y;
			var x4 : Number = b1.x; var y4 : Number = b1.y;
			
			//AABB early exit
			if (Math.max(x1,x2) < Math.min(x3,x4) || Math.max(x3,x4) < Math.min(x1,x2) ) return null;
			if (Math.max(y1,y2) < Math.min(y3,y4) || Math.max(y3,y4) < Math.min(y1,y2) ) return null;
			
			var ua : Number = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3));
			var ub : Number  = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3));
			var denom : Number  = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1);
			
			if (Math.abs(denom) < FLT_EPSILON) 
			{
				//Lines are too close to parallel to call
				return null;
			}
			
			ua /= denom;
			ub /= denom;
			
			if ((0 < ua) && (ua < 1) && (0 < ub) && (ub < 1)) 
			{
				var intersectionPoint : b2Vec2 = new b2Vec2();
				
				//if (intersectionPoint){
					intersectionPoint.x = (x1 + ua * (x2 - x1));
					intersectionPoint.y = (y1 + ua * (y2 - y1));
				//}
				//printf("%f, %f -> %f, %f crosses %f, %f -> %f, %f\n",x1,y1,x2,y2,x3,y3,x4,y4);
				return intersectionPoint;
			}
			
			return null;
		}

		public function intersect_b(a0:uint, a1:uint, b0:uint, b1:uint) : b2Vec2
		{

			var intersectionPoint : b2Vec2 = new b2Vec2();
			
			var x1 : Number = x[a0]; var y1 : Number = y[a0];
			var x2 : Number = x[a1]; var y2 : Number = y[a1];
			var x3 : Number = x[b0]; var y3 : Number = y[b0];
			var x4 : Number = x[b1]; var y4 : Number = y[b1];
			
			var ua : Number = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3));
			var ub : Number  = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3));
			var denom : Number  = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1);
			
			if (Math.abs(denom) < FLT_EPSILON) 
			{
				//Lines are too close to parallel to call
				return null;
			}
			
			ua /= denom;
			ub /= denom;
			
			if ((0 < ua) && (ua < 1) && (0 < ub) && (ub < 1)) 
			{
				//if (intersectionPoint){
					intersectionPoint.x = (x1 + ua * (x2 - x1));
					intersectionPoint.y = (y1 + ua * (y2 - y1));
				//}
				//printf("%f, %f -> %f, %f crosses %f, %f -> %f, %f\n",x1,y1,x2,y2,x3,y3,x4,y4);
				return intersectionPoint;
			}
			
			return null;
		}
      
      public function CheckSelfIntersects ():Boolean
      {
         if (nVertices <= 3)
            return false;
         
         var i:int;
         var j:int;
         var b2:int;
         for (i = 0; i < nVertices - 1; ++ i)
         {
            for (j = i + 2; j < nVertices; ++ j)
            {
               b2 = (j + 1) % nVertices;
               if (b2 == 0 && i == 0)
                  continue;
               if ( intersect_b (i, i + 1, j, b2) )
                  return true;
            }
         }
         
         return false;
      }
		
		public function GetArea() : Number
		{
			// TODO: fix up the areaIsSet caching so that it can be used
			//if (areaIsSet) return area;
			area = 0.0;
			
			//First do wraparound
			area += x[nVertices-1]*y[0]-x[0]*y[nVertices-1];
			for (var i : int=0; i<nVertices-1; ++i){
				area += x[i]*y[i+1]-x[i+1]*y[i];
			}
			area *= .5;
			areaIsSet = true;
			return area;
		}
		
		public function IsCCW() :Boolean
		{
			return (GetArea() > 0.0);
		}
		
		public function MergeParallelEdges(tolerance:Number) : void
		{
			if (nVertices <= 3) return; //Can't do anything useful here to a triangle
			var mergeMe : Array = []; //bool* mergeMe = new bool[nVertices];			
			var newNVertices : int = nVertices;
			var i : int;
			
			for (i = 0; i < nVertices; ++i) {
				var lower : int = (i == 0) ? (nVertices - 1) : (i - 1);
				var middle : int = i;
				var upper : int = (i == nVertices - 1) ? (0) : (i + 1);
				var dx0 : Number = x[middle] - x[lower];
				var dy0 : Number  = y[middle] - y[lower];
				var dx1 : Number  = x[upper] - x[middle];
				var dy1 : Number  = y[upper] - y[middle];
				var norm0 : Number  = Math.sqrt(dx0*dx0+dy0*dy0);
				var norm1 : Number  = Math.sqrt(dx1*dx1+dy1*dy1);
				if ( (!(norm0 > 0.0 && norm1 > 0.0) && newNVertices > 3) ) {
					//Merge identical points
					mergeMe[i] = true;
					--newNVertices;
				}
				dx0 /= norm0; dy0 /= norm0;
				dx1 /= norm1; dy1 /= norm1;
				var cross : Number = dx0 * dy1 - dx1 * dy0;
				var dot : Number = dx0 * dx1 + dy0 * dy1;
				if (Math.abs(cross) < tolerance && dot > 0 && newNVertices > 3) {
					mergeMe[i] = true;
					--newNVertices;
				} else {
					mergeMe[i] = false;
				}
			}
			
			if (newNVertices == nVertices || newNVertices == 0) { return; }
			
			var newx : Array = [];
			var newy : Array = [];
			var currIndex : int = 0;
			
			for (i = 0; i < nVertices; ++i) 
			{
				if (mergeMe[i] || newNVertices == 0 || currIndex == newNVertices) continue;
				//b2Settings.b2Assert(currIndex < newNVertices);
				newx[currIndex] = x[i];
				newy[currIndex] = y[i];
				++currIndex;
			}			
		
			x = newx;
			y = newy;
			nVertices = newNVertices;		
		}
		
		public function GetVertexVecs() :  Array
		{
			var out : Array = []
			for (var i : int = 0; i < nVertices; ++i) 
			{
				//out[i] = new b2Vec2(x[i], y[i]);
				out[i] = b2Vec2.b2Vec2_From2Numbers (x[i], y[i]);
			}
			return out;
		}
		
		public function Set(p:b2Polygon) :void
		{
			if (nVertices != p.nVertices)
			{
				nVertices = p.nVertices;
				x = [];
				y = [];
			}
			
			for (var i : int = 0; i < nVertices; ++i) 
			{
				x[i] = p.x[i];
				y[i] = p.y[i];
			}
			areaIsSet = false;
		}
		
		/*
		 * Assuming the polygon is simple, checks if it is convex.
		 */
		public function IsConvex() : Boolean
		{
			var isPositive : Boolean = false;
			
			for (var i:int= 0; i < nVertices; ++i) 
			{
				var lower : int = (i == 0) ? (nVertices - 1) : (i - 1);
				var middle : int  = i;
				var upper : int  = (i == nVertices - 1) ? (0) : (i + 1);
				var dx0 : Number = x[middle] - x[lower];
				var dy0 : Number = y[middle] - y[lower];
				var dx1 : Number = x[upper] - x[middle];
				var dy1 : Number = y[upper] - y[middle];
				var cross : Number = dx0 * dy1 - dx1 * dy0;
				// Cross product should have same sign
				// for each vertex if poly is convex.
				var newIsP : Boolean = (cross >= 0) ? true : false;
				if (i == 0) {
					isPositive = newIsP;
				}
				else if (isPositive != newIsP) {
					return false;
				}
			}
			return true;
		}
		
		/*
		* Pulled from b2Shape.cpp, assertions removed
		*/
		public static function PolyCentroid(vs:Array, count:int):b2Vec2
		{
			//var c:b2Vec2 = new b2Vec2 (0, 0);
			var c:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (0.0, 0.0);
			var area : Number = 0.0;

			var inv3 : Number = 1.0 / 3.0;
			//var pRef:b2Vec2 = new b2Vec2(0.0, 0.0);
			var pRef:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (0.0, 0.0);
			for (var i:int = 0; i < count; ++i)
			{
				// Triangle vertices.
				var p1:b2Vec2 = pRef;
				var p2:b2Vec2 = vs[i];
				var p3:b2Vec2 = i + 1 < count ? vs[i+1] : vs[0];

				//var e1:b2Vec2 = new b2Vec2 (p2.x - p1.x, p2.y - p1.y);
				//var e2:b2Vec2 = new b2Vec2 (p3.x - p1.x, p3.y - p1.y);
				var e1:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (p2.x - p1.x, p2.y - p1.y);
				var e2:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (p3.x - p1.x, p3.y - p1.y);

				var D : Number = e1.x * e2.y - e1.y * e2.x; //b2Math.b2Cross2(e1, e2);

				var triangleArea : Number = 0.5 * D;
				area += triangleArea;

				// Area weighted centroid
				c.x += triangleArea * inv3 * (p1.x + p2.x + p3.x);
				c.y += triangleArea * inv3 * (p1.y + p2.y + p3.y);
			}

			// Centroid
			c.x *= 1.0 / area;
			c.y *= 1.0 / area;
			return c;
		}
		
		/*
		 * Tries to add a triangle to the polygon. Returns null if it can't connect
		 * properly, otherwise returns a pointer to the new Polygon. Assumes bitwise
		 * equality of joined vertex positions.
		 *
		 * Remember to delete the pointer afterwards.
		 * Todo: Make this return a b2Polygon instead
		 * of a pointer to a heap-allocated one.
		 */
		public function Add(t:b2Triangle) : b2Polygon
		{
				// First, find vertices that connect
				var firstP : int = -1;
				var firstT : int = -1;
				var secondP : int = -1;
				var secondT : int = -1;
				var i : int;
				
				for (i = 0; i < nVertices; i++) 
				{
					if (t.x[0] == x[i] && t.y[0] == y[i]) {
						if (firstP == -1) {
							firstP = i;
							firstT = 0;
						}
						else {
							secondP = i;
							secondT = 0;
						}
					}
					else if (t.x[1] == x[i] && t.y[1] == y[i]) {
						if (firstP == -1) {
							firstP = i;
							firstT = 1;
						}
						else {
							secondP = i;
							secondT = 1;
						}
					}
					else if (t.x[2] == x[i] && t.y[2] == y[i]) {
						if (firstP == -1) {
							firstP = i;
							firstT = 2;
						}
						else {
							secondP = i;
							secondT = 2;
						}
					}
					else {
					}
				}
				// Fix ordering if first should be last vertex of poly
				if (firstP == 0 && secondP == nVertices - 1) {
					firstP = nVertices - 1;
					secondP = 0;
				}
				
				// Didn't find it
				if (secondP == -1)
					return null;
				
				// Find tip index on triangle
				var tipT : int = 0;
				if (tipT == firstT || tipT == secondT)
					tipT = 1;
				if (tipT == firstT || tipT == secondT)
					tipT = 2;
				
				var newx : Array = [];
				var newy : Array = [];
				var currOut : int = 0;
				
				for (i = 0; i < nVertices; i++) 
				{
					newx[currOut] = x[i];
					newy[currOut] = y[i];
					
					if (i == firstP) 
					{
						++currOut;
						newx[currOut] = t.x[tipT];
						newy[currOut] = t.y[tipT];
					}
					++currOut;
				}
				
				var result : b2Polygon = new b2Polygon(newx, newy, nVertices+1);

				return result;
		}
		
		/**
		 * Adds this polygon to a PolyDef.
		 */
		 /*
		public function AddTo(pd:b2PolygonDef) :void
		{
			var vecs : Array = GetVertexVecs();
			
			b2Settings.b2Assert(nVertices <= b2Settings.b2_maxPolygonVertices);
			
			var offset:int = 0;
			for (var i : int = 0; i < nVertices; ++i) 
			{
				//Omit identical neighbors (including wraparound)
				var ind:int = i - offset;
				if (vecs[i].x==vecs[remainder(i+1,nVertices)].x &&
					vecs[i].y==vecs[remainder(i+1,nVertices)].y){
						offset++;
						continue;
				}
				//pd.vertices[i] = vecs[i]; // bug
				pd.vertices[ind] = vecs[i];
			}
			
			pd.vertexCount = nVertices;
		}
		*/
		public function GetQuanlifiedVertices () :Array
		{
			var quanlifiedVertices:Array = new Array ();
			
			var vecs : Array = GetVertexVecs();
			
			//b2Settings.b2Assert(nVertices <= b2Settings.b2_maxPolygonVertices);
			
			var offset:int = 0;
			for (var i : int = 0; i < nVertices; ++i) 
			{
				//Omit identical neighbors (including wraparound)
				var ind:int = i - offset;
				if (vecs[i].x==vecs[remainder(i+1,nVertices)].x &&
					vecs[i].y==vecs[remainder(i+1,nVertices)].y){
						offset++;
						continue;
				}
				//pd.vertices[i] = vecs[i]; // bug
				//pd.vertices[ind] = vecs[i];
				quanlifiedVertices.push ( (vecs[i] as b2Vec2).Clone ());
			}
			
			//pd.vertexCount = nVertices;
			return quanlifiedVertices;
		}
			/**
		 * Triangulates a polygon using simple ear-clipping algorithm. Returns
		 * size of Triangle array unless the polygon can't be triangulated.
		 * This should only happen if the polygon self-intersects,
		 * though it will not _always_ return null for a bad polygon - it is the
		 * caller's responsibility to check for self-intersection, and if it
		 * doesn't, it should at least check that the return value is non-null
		 * before using. You're warned!
		 *
		 * Triangles may be degenerate, especially if you have identical points
		 * in the input to the algorithm.  Check this before you use them.
		 *
		 * This is totally unoptimized, so for large polygons it should not be part
		 * of the simulation loop.
		 *
		 * Returns:
		 * -1 if algorithm fails (self-intersection most likely)
		 * 0 if there are not enough vertices to triangulate anything.
		 * vNum - 2 if triangulation was successful.
		 *
		 * results will be filled with results - ear clipping always creates vNum - 2
		 * triangles, so an array of this size should be allocated by the user.
		 */
		
		public static function TriangulatePolygon(xv:Array, yv:Array, vNum:int, results:Array) : int
		{
			if (vNum < 3)
				return 0;
			
			var buffer : Array = [];
			var bufferSize : int = 0;
			var xrem : Array = [];
			var yrem : Array  = [];
			var i : int;
			
			for (i = 0; i < vNum; ++i) 
			{
				xrem[i] = xv[i];
				yrem[i] = yv[i];
			}
			
			var xremLength :int = vNum;
			
			while (vNum > 3) 
			{
				// Find an ear
				var earIndex : int = -1;
				for ( i = 0; i < vNum; ++i) 
				{
					if (IsEar(i, xrem, yrem, vNum)) {
						earIndex = i;
						break;
					}
				}
				
				// If we still haven't found an ear, we're screwed.
				// The user did Something Bad, so return -1.
				// This will probably crash their program, since
				// they won't bother to check the return value.
				// At this we shall laugh, heartily and with great gusto.
				if (earIndex == -1)
					return -1;
				
				// Clip off the ear:
				// - remove the ear tip from the list
				
				// Opt note: actually creates a new list, maybe
				// this should be done in-place instead. A linked
				// list would be even better to avoid array-fu.
				--vNum;
				var newx : Array = [];
				var newy : Array  = [];
				var currDest : int = 0;
				for (i = 0; i < vNum; ++i)
				{
					if (currDest == earIndex) ++currDest;
					newx[i] = xrem[currDest];
					newy[i] = yrem[currDest];
					++currDest;
				}
				
				// - add the clipped triangle to the triangle list
				var under : int = (earIndex == 0) ? (vNum) : (earIndex - 1);
				var over : int = (earIndex == vNum) ? 0 : (earIndex + 1);
				toAdd = new b2Triangle(xrem[earIndex], yrem[earIndex], xrem[over], yrem[over], xrem[under], yrem[under]);
				buffer[bufferSize] = new b2Triangle();
				buffer[bufferSize].Set(toAdd);
				++bufferSize;
					
				xrem = newx;
				yrem = newy;
			}
			
			var toAdd : b2Triangle = new b2Triangle(xrem[1], yrem[1], xrem[2], yrem[2],  xrem[0], yrem[0]);
			buffer[bufferSize] = new b2Triangle();
			buffer[bufferSize].Set(toAdd);
			++bufferSize;
							
			//b2Settings.b2Assert(bufferSize == xremLength-2);
			
			for (i = 0; i < bufferSize; i++) 
			{
				results[i] = new b2Triangle();
				results[i].Set(buffer[i]);
			}
						
			return bufferSize;
		}
		
		/**
		 * Turns a list of triangles into a list of convex polygons. Very simple
		 * method - start with a seed triangle, keep adding triangles to it until
		 * you can't add any more without making the polygon non-convex.
		 *
		 * Returns an integer telling how many polygons were created.  Will fill
		 * polys array up to polysLength entries, which may be smaller or larger
		 * than the return value.
		 * 
		 * Takes O(N*P) where P is the number of resultant polygons, N is triangle
		 * count.
		 * 
		 * The final polygon list will not necessarily be minimal, though in
		 * practice it works fairly well.
		 */
		public static function PolygonizeTriangles(triangulated : Array, triangulatedLength:int, polys:Array, polysLength:int) : int 
		{
				var polyIndex : int = 0;
				var i:int;
				
				if (triangulatedLength == 0) {
					return 0;
				}
				else 
				{
					var covered : Array = [];
					for (i = 0; i < triangulatedLength; ++i) 
					{
						covered[i] = 0;
						//Check here for degenerate triangles
						if ( ( (triangulated[i].x[0] == triangulated[i].x[1]) && (triangulated[i].y[0] == triangulated[i].y[1]) )
							 || ( (triangulated[i].x[1] == triangulated[i].x[2]) && (triangulated[i].y[1] == triangulated[i].y[2]) )
							 || ( (triangulated[i].x[0] == triangulated[i].x[2]) && (triangulated[i].y[0] == triangulated[i].y[2]) ) ) {
							covered[i] = 1;
						}
					}
					
					var notDone : Boolean = true;
					while (notDone) 
					{
						var currTri : int = -1;
						for (i = 0; i < triangulatedLength; ++i) {
							if (covered[i])
								continue;
							currTri = i;
							break;
						}
						if (currTri == -1) {
							notDone = false;
						}
						else {
							var poly : b2Polygon = new b2Polygon(triangulated[currTri].x, triangulated[currTri].y, 3);
							covered[currTri] = 1;
							var index:int = 0;
							for (i = 0; i < 2 * triangulatedLength; ++i, ++ index) {
								while (index >= triangulatedLength) index -= triangulatedLength;
								if (covered[index]) {
									continue;
								}
								var newP : b2Polygon = poly.Add(triangulated[index]);
								if (!newP) {
									continue;
								}
								if (newP.nVertices > b2Polygon.maxVerticesPerPolygon) {							
									newP = null;
									continue;
								}
								if (newP.IsConvex()) {
									poly.Set(newP);							
									newP = null;
									covered[index] = 1;
								} else {							
									newP = null;
								}
							}
							if (polyIndex < polysLength){
								poly.MergeParallelEdges(b2Settings.b2_angularSlop);
								//If identical points are present, a triangle gets
								//borked by the MergeParallelEdges function, hence
								//the vertex number check
								if (poly.nVertices >= 3)
								{
									polys[polyIndex] = new b2Polygon([],[],0);
									polys[polyIndex].Set(poly);
									
								}
								//else printf("Skipping corrupt poly\n");
							}
							if (poly.nVertices >= 3) polyIndex++; //Must be outside (polyIndex < polysLength) test
						}
							//printf("MEMCHECK: %d\n",_CrtCheckMemory());
					}					
				}
				return polyIndex;
		}
		
		/**
		 * Checks if vertex i is the tip of an ear in polygon defined by xv[] and
		 * yv[]
		 */
		public static function IsEar(i:int, xv:Array, yv:Array, xvLength:int) : Boolean
		{
			var dx0:Number, dy0:Number, dx1:Number, dy1:Number;
			dx0 = dy0 = dx1 = dy1 = 0;
			if (i >= xvLength || i < 0 || xvLength < 3) {
				return false;
			}
			var upper : int = i + 1;
			var lower : int = i - 1;
			if (i == 0) {
				dx0 = xv[0] - xv[xvLength - 1];
				dy0 = yv[0] - yv[xvLength - 1];
				dx1 = xv[1] - xv[0];
				dy1 = yv[1] - yv[0];
				lower = xvLength - 1;
			}
			else if (i == xvLength - 1) {
				dx0 = xv[i] - xv[i - 1];
				dy0 = yv[i] - yv[i - 1];
				dx1 = xv[0] - xv[i];
				dy1 = yv[0] - yv[i];
				upper = 0;
			}
			else {
				dx0 = xv[i] - xv[i - 1];
				dy0 = yv[i] - yv[i - 1];
				dx1 = xv[i + 1] - xv[i];
				dy1 = yv[i + 1] - yv[i];
			}
			var cross : Number = dx0 * dy1 - dx1 * dy0;
			if (cross > 0)
				return false;
			var myTri : b2Triangle = new b2Triangle(xv[i], yv[i], xv[upper], yv[upper], xv[lower], yv[lower]);
			
			for (var j : int = 0; j < xvLength; ++j) 
			{
				if (j == i || j == lower || j == upper)
					continue;
				if (myTri.IsInside(xv[j], yv[j]))
					return false;
			}
			return true;
		}
		
		
		public static function ReversePolygon(_x:Array, _y:Array, n:int) : void
		{
				if (n == 1)
					return;
				var low : int = 0;
				var high : int = n - 1;
				while (low < high) 
				{
					var buffer : Number = _x[low];
					_x[low] = _x[high];
					_x[high] = buffer;
					buffer = _y[low];
					_y[low] = _y[high];
					_y[high] = buffer;
					++low;
					--high;
				}
		}
		
		/**
		 * Decomposes a non-convex polygon into a number of convex polygons, up
		 * to maxPolys (remaining pieces are thrown out, but the total number
		 * is returned, so the return value can be greater than maxPolys).
		 *
		 * Each resulting polygon will have no more than maxVerticesPerPolygon
		 * vertices (set to b2MaxPolyVertices by default, though you can change
		 * this).
		 * 
		 * Returns -1 if operation fails (usually due to self-intersection of
		 * polygon).
		*/
		public static function DecomposeConvex(p : b2Polygon, results:Array, maxPolys : int) : int
		{
				if (p.nVertices < 3) return 0;
            
            if (p.CheckSelfIntersects ())
            {
               //trace ("SelfIntersects");
               return -1;
				}
            
				var triangulated :Array = [];
				var nTri : int;
				
				if (p.IsCCW()) {
					//printf("It is ccw");
					var tempP : b2Polygon = new b2Polygon([0],[0],0);
					tempP.Set(p);
					ReversePolygon(tempP.x, tempP.y, tempP.nVertices);
					nTri = TriangulatePolygon(tempP.x, tempP.y, tempP.nVertices, triangulated);			
		//			ReversePolygon(p->x, p->y, p->nVertices); //reset orientation
				} else {
					//printf("It is not ccw");
					nTri = TriangulatePolygon(p.x, p.y, p.nVertices, triangulated);
				}
				if (nTri < 1) {
					//trace("Failed triangulation.  Dumping polygon:");
					//p.print();
					//Still no luck?  Oh well...
					return -1;
				}
				var nPolys :int = PolygonizeTriangles(triangulated, nTri, results, maxPolys);			
				return nPolys;
		}
		 
		
		
		/**
		 * Decomposes a polygon into convex polygons and adds all pieces to a b2BodyDef
		 * using a prototype b2PolyDef. All fields of the prototype are used for every
		 * shape except the vertices (friction, restitution, density, etc).
		 * 
		 * If you want finer control, you'll have to add everything by hand.
		 * 
		 * This is the simplest method to add a complicated polygon to a body.
		 *
		 * Until Box2D's b2BodyDef behavior changes, this method returns a pointer to
		 * a heap-allocated array of b2PolyDefs, which must be deleted by the user
		 * after the b2BodyDef is added to the world.
		 */
      /*
		public static function DecomposeConvexAndAddTo(p:b2Polygon, bd:b2BodyDef, prototype:b2PolyDef) : void
		{
			if (p.nVertices < 3) return;
			
			var decomposed : Array = [];
			var nPolys : int = DecomposeConvex(p, decomposed, p.nVertices - 2);

			var pdarray : Array = [];
			
			for (var i : int = 0; i < nPolys; ++i) 
			{
				var toAdd : b2PolyDef = new b2PolyDef();
				
			
				 //Hmm, shouldn't have to do all this...
				 toAdd.type = prototype.type;
				 toAdd.localPosition = prototype.localPosition;
				 toAdd.localRotation = prototype.localRotation;
				 toAdd.friction = prototype.friction;
				 toAdd.restitution = prototype.restitution;
				 toAdd.density = prototype.density;
				 toAdd.userData = prototype.userData;
				 toAdd.categoryBits = prototype.categoryBits;
				 toAdd.maskBits = prototype.maskBits;
				 toAdd.groupIndex = prototype.groupIndex;				 
				 //decomposed[i].print();
				 
				 
				decomposed[i].AddTo(toAdd);
				bd.AddShape(toAdd);
			}
		}		
		*/
		
		public static function remainder(x:int, modulus:int):int{
			var rem:int = x % modulus;
			while (rem < 0){
				rem += modulus;
			}
			return rem;
		}
		
	}
	
	
	
}