package player.entity {
   
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;

   import flash.geom.Point;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   
   public class EntityShapePolyShape extends EntityShape
   {
      public function EntityShapePolyShape (world:World)
      {
         super (world);
      }

//=============================================================
//   data
//=============================================================

      protected var mLocalPoints:Array = null;
      protected var mLocalDisplayPoints:Array = null;

      public function GetVertexPointsCount ():int
      {
         if (mLocalPoints == null)
            return 0;
         else
            return mLocalPoints.length;
      }
      
      public function GetLocalVertex (index:int):Point
      {
         if (index < 0 || index >= GetVertexPointsCount ())
            return null;
         
         return mLocalPoints [index];
      }
      
      public function SetLocalDisplayVertexPoints (points:Array):void
      {
         var i:int;
         var inputDisplayPoint:Point;
         var displayPoint:Point;
         var physicsPoint:Point;
         if (mLocalPoints == null || mLocalPoints.length != points.length)
         {
            mLocalPoints = new Array (points.length);
            mLocalDisplayPoints = new Array (points.length);
            for (i = 0; i < mLocalPoints.length; ++ i)
            {
               mLocalPoints        [i] = new Point ();
               mLocalDisplayPoints [i] = new Point ();
            }
         }
         
         for (i = 0; i < mLocalPoints.length; ++ i)
         {
            inputDisplayPoint = points [i];

            displayPoint = mLocalDisplayPoints [i];
            displayPoint.x = inputDisplayPoint.x;
            displayPoint.y = inputDisplayPoint.y;

            physicsPoint = mLocalPoints [i];
            physicsPoint.x =  mWorld.GetCoordinateSystem ().D2P_LinearDeltaX (inputDisplayPoint.x);
            physicsPoint.y =  mWorld.GetCoordinateSystem ().D2P_LinearDeltaY (inputDisplayPoint.y);
         }
      }
   }
}
