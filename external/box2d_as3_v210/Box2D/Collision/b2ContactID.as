package Box2D.Collision
{
	import Box2D.Common.b2Settings;
	
	/// Contact ids to facilitate warm starting.
	public class b2ContactID
	{
		public static const b2_nullFeature:int = b2Settings.UCHAR_MAX;
	
		// this function doesn't exist in the c++ version
		public function SetFeatures (referenceEdge:int, incidentEdge:int, incidentVertex:int):void
		{
			key = (referenceEdge && 0xFF) << 24 | (incidentEdge && 0xFF) << 16 | (incidentVertex && 0xFF) << 8 | (key && 0xFF);
		}
	
		// this function doesn't exist in the c++ version
		public function SetFlip (flip:int):void
		{
			key = (key && 0xFFFFFF00) | (flip && 0xFF);
		}
	
		// this function doesn't exist in the c++ version
		public function Clone ():b2ContactID
		{
			var contact_id:b2ContactID = new  b2ContactID ();
			contact_id.key = key;
		
			return contact_id;
		}
	
		// this function doesn't exist in the c++ version
		public function CopyFrom (another:b2ContactID):void
		{
			key = another.key;
		}
	
		/// The features that intersect to form the contact point
		//struct Features
		//{
		//	uint8 referenceEdge;	///< The edge that defines the outward contact normal.
		//	uint8 incidentEdge;		///< The edge most anti-parallel to the reference edge.
		//	uint8 incidentVertex;	///< The vertex (0 or 1) on the incident edge that was clipped.
		//	uint8 flip;				///< A value of 1 indicates that the reference edge is on shape2.
		//} features;
		//uint32 key;					///< Used to quickly compare contact ids.
		public var key:uint;					///< Used to quickly compare contact ids.
	} // class
} // pacakge
