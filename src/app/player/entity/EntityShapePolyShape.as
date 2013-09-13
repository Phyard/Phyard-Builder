package player.entity {
   
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;

   import flash.geom.Point;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   import common.CoordinateSystem;
   
   public class EntityShapePolyShape extends EntityShape_WithBodyTexture // EntityShape
   {
      public function EntityShapePolyShape (world:World)
      {
         super (world);
      }

//=============================================================
//   
//=============================================================

      override public function ToEntityDefine (entityDefine:Object):Object
      {
         super.ToEntityDefine (entityDefine);
         
         // vertexes
         var numVertexes:int = mLocalDisplayPoints.length;
         var localDeisplayPoints:Array = new Array (numVertexes);
         for (var vId:int = 0; vId < numVertexes; ++ vId)
         {
            var point:Point = mLocalDisplayPoints [vId] as Point;
            localDeisplayPoints [vId] = new Point (point.x, point.y);
         }
         entityDefine.mLocalPoints = localDeisplayPoints;
         
         return null;
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
         
         var localPoint:Point = mLocalPoints [index] as Point;
         return new Point (localPoint.x, localPoint.y);
      }
      
      public function GetVertexPositions (inWorldSpace:Boolean):Array
      {
         if (mLocalPoints == null)
            return null;
         
         var numPoints:int = mLocalPoints.length;
         
         var returnValues:Array = new Array (numPoints + numPoints);
         var index:int = 0;
         var localPoint:Point;
         
         for (var vertexId:int = 0; vertexId < numPoints; ++ vertexId)
         {
            localPoint = mLocalPoints [vertexId] as Point;
            
            returnValues [index ++] = localPoint.x;
            returnValues [index ++] = localPoint.y;
         }
         
         if (inWorldSpace)
         {
            var numValues:int = returnValues.length;
            var index2:int = 0;
            var worldPoint:Point = new Point ();
            
            index = 0;
            while (index < numValues)
            {
               LocalPoint2WorldPoint (returnValues [index ++], returnValues [index ++], worldPoint);
               
               returnValues [index2 ++] = worldPoint.x;
               returnValues [index2 ++] = worldPoint.y;
            }
         }
         
         return returnValues;
      }
      
      // called by API, physics values, either in local or world space
      public function SetVertexPositions (xyValues:Array, inWorldSpace:Boolean):void
      {
         CreateVertexArrays (xyValues == null ? -1 : xyValues.length / 2);
         
         // ...
         
         var vertexCount:int = GetVertexPointsCount ();
         var index:int = 0;
         var vertexId:int;
         var localPoint:Point;
         
         if (inWorldSpace)
         {
            for (vertexId = 0; vertexId < vertexCount; ++ vertexId)
            {
               localPoint = mLocalPoints [vertexId] as Point;
               WorldPoint2LocalPoint (xyValues [index ++], xyValues [index ++], localPoint);
            }
         }
         else
         {
            for (vertexId = 0; vertexId < vertexCount; ++ vertexId)
            {
               localPoint = mLocalPoints [vertexId] as Point;
               
               localPoint.x = xyValues [index ++];
               localPoint.y = xyValues [index ++];
            }
         }

         // ...
         
         var coorinateSyatem:CoordinateSystem = mWorld.GetCoordinateSystem ();
         var displayPoint:Point;
         
         for (vertexId = 0; vertexId < vertexCount; ++ vertexId)
         {
            localPoint = mLocalPoints [vertexId] as Point;
            
            displayPoint = mLocalDisplayPoints [vertexId];
            displayPoint.x = coorinateSyatem.P2D_LinearDeltaX (localPoint.x);
            displayPoint.y = coorinateSyatem.P2D_LinearDeltaY (localPoint.y);
         }
         
         return;
      }
      
      //public function ModifyLocalVertex (vertexIndex:int, localPhysicsX:Number, localPhysicsY:Number, isInsert:Boolean):void
      //{
      //   if (vertexIndex < 0)
      //      return;
      //   
      //   if (isInsert)
      //   {
      //      if (mLocalPoints == null) // so mLocalDisplayPoints is also null
      //      {
      //         if (vertexIndex > 0)
      //            return;
      //         
      //         mLocalPoints = new Array ();
      //         mLocalDisplayPoints = new Array ();
      //      }
      //      else if (vertexIndex > GetVertexPointsCount ())
      //      {
      //         return;
      //      }
      //      
      //      mLocalPoints.push (new Point (localPhysicsX, localPhysicsY));
      //      mLocalDisplayPoints.push (new Point (mWorld.GetCoordinateSystem ().P2D_LinearDeltaX (localPhysicsX),
      //                                           mWorld.GetCoordinateSystem ().P2D_LinearDeltaY (localPhysicsY)));
      //   }
      //   else
      //   {
      //      if (vertexIndex >= GetVertexPointsCount ())
      //         return;
      //      
      //      var physicsPoint:Point = mLocalPoints [vertexIndex];
      //      physicsPoint.x = localPhysicsX;
      //      physicsPoint.y = localPhysicsY;
      //      
      //      var displayPoint:Point = mLocalDisplayPoints [vertexIndex];
      //      displayPoint.x =  mWorld.GetCoordinateSystem ().P2D_LinearDeltaX (localPhysicsX);
      //      displayPoint.y =  mWorld.GetCoordinateSystem ().P2D_LinearDeltaY (localPhysicsY);
      //   }
      //   
      //   // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
      //   DelayUpdateAppearance ();
      //}
      //
      //public function DeleteVertex (vertexIndex:int):void
      //{
      //   if (vertexIndex < 0 || vertexIndex >= GetVertexPointsCount ())
      //      return;
      //   
      //   mLocalPoints.splice (vertexIndex, 1);
      //   mLocalDisplayPoints.splice (vertexIndex, 1);
      //   
      //   // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
      //   DelayUpdateAppearance ();
      //}
      
      protected function CreateVertexArrays (vertexCount:int):void
      {  
         // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
         DelayUpdateAppearance (); 
         
         if (vertexCount < 0)
         {
            mLocalPoints = null;
            mLocalDisplayPoints = null;
         
            return;
         }
         
         if (mLocalPoints == null || mLocalPoints.length != vertexCount)
         {
            mLocalPoints        = new Array (vertexCount);
            mLocalDisplayPoints = new Array (vertexCount);
            for (var vertexId:int = 0; vertexId < vertexCount; ++ vertexId)
            {
               mLocalPoints        [vertexId] = new Point ();
               mLocalDisplayPoints [vertexId] = new Point ();
            }
         }
      }
      
      public function SetLocalDisplayVertexPoints (points:Array):void
      {
         CreateVertexArrays (points == null ? -1 : points.length);
         
         var coorinateSyatem:CoordinateSystem = mWorld.GetCoordinateSystem ();
         
         var inputDisplayPoint:Point;
         var displayPoint:Point;
         var physicsPoint:Point;

         var vertexCount:int = GetVertexPointsCount ();
         for (var vertexId:int = 0; vertexId < vertexCount; ++ vertexId)
         {
            inputDisplayPoint = points [vertexId];

            displayPoint = mLocalDisplayPoints [vertexId];
            displayPoint.x = inputDisplayPoint.x;
            displayPoint.y = inputDisplayPoint.y;

            physicsPoint = mLocalPoints [vertexId];
            physicsPoint.x = coorinateSyatem.D2P_LinearDeltaX (inputDisplayPoint.x);
            physicsPoint.y = coorinateSyatem.D2P_LinearDeltaY (inputDisplayPoint.y);
         }
      }
   }
}
