package beziercurves.utils {
	public class BrushType {
		public static const REGULAR:String = "regular";
		public static const BRUSH1:String = "brush1";
		public static const BRUSH2:String = "brush2";
		public static const BRUSH3:String = "brush3";		public static const BRUSH4:String = "brush4";
		/**
		 * BrushType is a static class, you cannot instanciate it
		 */
		public function BrushType()	{
			throw new Error("BrushType is a static class, you cannot instanciate it.");
		}
	}
}