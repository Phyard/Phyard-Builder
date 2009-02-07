
package player.entity {
   
   import flash.geom.Point;
   
   import player.world.World;
   
   import common.Define;
   
   public class EntityShape extends Entity
   {
      
      protected var mShapeContainer:ShapeContainer;
      
      protected var mOriginalAiType:int = Define.ShapeAiType_Unkown;
      protected var mAiType:int = Define.ShapeAiType_Unkown;
      
      protected var mIsStatic:Boolean = false;
      
      public var mIsBullet:Boolean = false;
      
      protected var mDrawBorder:Boolean = true;
      protected var mDrawBackground:Boolean = true;
      
      public function EntityShape (world:World, shapeContainer:ShapeContainer)
      {
         super (world);
         
         mShapeContainer = shapeContainer;
         
         mShapeContainer.addChild (this);
      }
      
      override public function IsPhysicsEntity ():Boolean
      {
         return Define.IsPhysicsShapeEntity (mEntityType)
      }
      
      override public function Update (dt:Number):void
      {
         mWorld.ReportShapeStatus (mOriginalAiType, mAiType);
      }
      
      public function SetShapeAiType (aiType:int):void
      {
         if (mAiType == Define.ShapeAiType_Unkown)
            mOriginalAiType = aiType;
         
         mAiType = aiType;
         
         if (Define.IsBreakableShape (mAiType))
            alpha = 0.8;
         else
            alpha= 1.0;
      }
      
      public function GetShapeAiType ():int
      {
         return mAiType;
      }
      
      public function SetStatic (static:Boolean):void
      {
         mIsStatic = static;
      }
      
      public function IsStatic ():Boolean
      {
         return mIsStatic;
      }
      
      public function SetBullet (bullet:Boolean):void
      {
         mIsBullet = bullet;
      }
      
      public function IsBullet ():Boolean
      {
         return mIsBullet;
      }
      
      public function SetDrawBorder (drawBorder:Boolean):void
      {
         mDrawBorder = drawBorder;
      }
      
      public function IsDrawBorder ():Boolean
      {
         return mDrawBorder;
      }
      
      public function SetDrawBackground (draw:Boolean):void
      {
         mDrawBackground = draw;
      }
      
      public function IsDrawBackground ():Boolean
      {
         return mDrawBackground;
      }
      
      public function GetParentContainer ():ShapeContainer
      {
         return mShapeContainer;
      }
      
      override public function BuildFromParams (params:Object):void
      {
         super.BuildFromParams (params);
         
         visible = params.mIsVisible;
         
         SetBullet (params.mIsBullet);
         mShapeContainer.SetBullet (IsBullet ());
         
         SetStatic (params.mIsStatic);
         SetShapeAiType (params.mAiType);
         
         // >> from v1.02
         SetDrawBorder (params.mDrawBorder);
         SetDrawBackground (params.mDrawBackground);
         //<<
      }
      
      // maybe change later
      public function GetLocalPosition ():Point
      {
         return new Point (x, y);
      }
      
      
      
   }
   
}
