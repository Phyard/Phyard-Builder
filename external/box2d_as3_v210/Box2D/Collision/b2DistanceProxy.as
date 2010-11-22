package Box2D.Collision
{
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2EdgeShape;
	import Box2D.Collision.Shapes.b2LoopShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	
	/// A distance proxy is used by the GJK algorithm.
	/// It encapsulates any shape.
	public class b2DistanceProxy
	{
		public function Clone ():b2DistanceProxy
		{
			var clone:b2DistanceProxy = new b2DistanceProxy ();
			clone.CopyFrom (this);
			
			return clone;
		}
		
		public function CopyFrom (another:b2DistanceProxy):void
		{
			m_vertices = another.m_vertices;
			m_count = another.m_count;
			m_radius = another.m_radius;
		}
		
		public function b2DistanceProxy () {m_vertices = null; m_count = 0; m_radius = 0.0;}

		/// Initialize the proxy using the given shape. The shape
		/// must remain in scope while the proxy is in use.
		//void Set(const b2Shape* shape);

		/// Get the supporting vertex index in the given direction.
		//int32 GetSupport(const b2Vec2& d) const;

		/// Get the supporting vertex in the given direction.
		//const b2Vec2& GetSupportVertex(const b2Vec2& d) const;

		/// Get the vertex count.
		//int32 GetVertexCount() const;

		/// Get a vertex by index. Used by b2Distance.
		//const b2Vec2& GetVertex(int32 index) const;

		//b2Vec2 m_buffer[2];;
		//const b2Vec2* m_vertices;
		public var m_buffer:Array = new Array (new b2Vec2 (), new b2Vec2 ());
		public var m_vertices:Array;
		public var m_count:int;
		public var m_radius:Number;
		
		
		
		public function GetVertexCount():int
		{
			return m_count;
		}

		public function GetVertex(index:int):b2Vec2
		{
			//b2Assert(0 <= index && index < m_count);
			return m_vertices[index];
		}

		public function GetSupport(d:b2Vec2):int
		{
			var bestIndex:int = 0;
			var bestValue:Number = b2Math.b2Dot2 (m_vertices[0], d);
			for (var i:int = 1; i < m_count; ++i)
			{
				var value:Number = b2Math.b2Dot2(m_vertices[i], d);
				if (value > bestValue)
				{
					bestIndex = i;
					bestValue = value;
				}
			}

			return bestIndex;
		}

		public function GetSupportVertex(d:b2Vec2):b2Vec2
		{
			var bestIndex:int = 0;
			var bestValue:Number = b2Math.b2Dot2 (m_vertices[0], d);
			for (var i:int = 1; i < m_count; ++i)
			{
				var value:Number = b2Math.b2Dot2(m_vertices[i], d);
				if (value > bestValue)
				{
					bestIndex = i;
					bestValue = value;
				}
			}

			return m_vertices[bestIndex];
		}

		public function Set(shape:b2Shape, index:int):void
		{
			switch (shape.GetType())
			{
			case b2Shape.e_circle:
				{
					var circle:b2CircleShape = shape as b2CircleShape;
					//m_vertices = &circle->m_p;
					m_vertices = [circle.m_p];
					m_count = 1;
					m_radius = circle.m_radius;
				}
				break;

			case b2Shape.e_polygon:
				{
					var polygon:b2PolygonShape = shape as b2PolygonShape;
					m_vertices = polygon.m_vertices;
					m_count = polygon.m_vertexCount;
					m_radius = polygon.m_radius;
				}
				break;

			case b2Shape.e_loop:
				{
					var  loop:b2LoopShape = shape as b2LoopShape;
					//b2Assert(0 <= index && index < loop->GetCount());

					//m_buffer[0] = loop->GetVertex(index);
					loop.GetVertexOutput(index, m_buffer[0] as b2Vec2);
					if (index + 1 < loop.GetCount())
					{
						//m_buffer[1] = loop->GetVertex(index + 1);
						loop.GetVertexOutput(index + 1, m_buffer[1] as b2Vec2);
					}
					else
					{
						//m_buffer[1] = loop->GetVertex(0);
						loop.GetVertexOutput(0, m_buffer[1] as b2Vec2);
					}

					m_vertices = m_buffer;
					m_count = 2;
					m_radius = loop.m_radius;
				}
				break;

			case b2Shape.e_edge:
				{
					var edge:b2EdgeShape = shape as b2EdgeShape;
					//m_vertices = edge.m_vertex1;
					m_vertices = [edge.m_vertex1, edge.m_vertex2,edge. m_vertex0, edge.m_vertex3];
					m_count = 2;
					m_radius = edge.m_radius;
				}
				break;

			default:
				//b2Assert(false);
				break;
			}
		}

	} // class
} // package
