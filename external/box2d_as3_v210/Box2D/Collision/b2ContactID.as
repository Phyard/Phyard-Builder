package Box2D.Collision
{
	import Box2D.Common.b2Settings;
	
	/// Contact ids to facilitate warm starting.
	public class b2ContactID
	{
		public static const b2_nullFeature:int = b2Settings.UCHAR_MAX;
		
		//>> hacking to optimize
		// the flip bits doesn't exist in c++.
		public static function ContactID_FromFeature (indexA:int, indexB:int, typeA:int, typeB:int):uint
		{
			return ((indexA & 0xFF) << 24) | ((indexB & 0xFF) << 16) | ((typeA & 0xF) << 12) | ((typeB & 0xF) << 4);
		}
		
		public static function ContactID_FlipFeature (feature:int):uint
		{
			return ((feature & 0xFF00F000) >> 8) | ((feature & 0x00FF00F0) << 8) | (1 & 0x00000F0F);
		}
		
		public static function ContactID_IsFlip (id:int):Boolean
		{
			return (id & 0x00000F0F) != 0;
		}
		
		public static function ContactID_IndexB (id:int):int
		{
			return (id >> 16) & 0xFF;
		}
		//<<
		
		//const uint8 b2_nullFeature = UCHAR_MAX;
		//
		///// The features that intersect to form the contact point
		///// This must be 4 bytes or less.
		//struct b2ContactFeature
		//{
		//	enum Type
		//	{
		//		e_vertex = 0,
		//		e_face = 1,
		//	};
		//	
		
		public static const b2ContactFeature_e_vertex:int = 0;
		public static const b2ContactFeature_e_face:int = 1;
		
		//	uint8 indexA;		///< Feature index on shapeA
		//	uint8 indexB;		///< Feature index on shapeB
		//	uint8 typeA;		///< The feature type on shapeA
		//	uint8 typeB;		///< The feature type on shapeB
		//};
		//
		///// Contact ids to facilitate warm starting.
		//union b2ContactID
		//{
		//	b2ContactFeature cf;
		//	uint32 key;					///< Used to quickly compare contact ids.
		//};
		
	} // class
} // pacakge
