
package Box2D.Dynamics
{
	public class b2Color
	{
	   //public function b2Color() {}
	   public function b2Color(ri:Number = 0.0, gi:Number = 0.0, bi:Number = 0.0) { r = ri; g = gi; b = bi; }
	   public function Set(ri:Number, gi:Number, bi:Number):void { r = ri; g = gi; b = bi; }
	   public var r:Number, g:Number, b:Number;
	} // class
} // package
