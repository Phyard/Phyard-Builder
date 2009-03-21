
package player.entity {
   
   import flash.geom.Point;
   
   import player.world.World;
   
   import common.Define;
   
   public class EntityShape extends EntityContainerChild
   {
      protected var mOriginalAiType:int = Define.ShapeAiType_Unknown;
      protected var mAiType:int = Define.ShapeAiType_Unknown;
      
      protected var mIsStatic:Boolean = false;
      public var mIsBullet:Boolean = false;
      
      //>>from v1.02
      protected var mDrawBorder:Boolean = true;
      protected var mDrawBackground:Boolean = true;
      //<<
      
      //>> form v1.04
      protected var mBorderColor:uint = 0x0;
      protected var mBorderThickness:uint = 1;
      protected var mFilledColor:uint = 0xFFFFFF;
      protected var mTransparency:uint = 100;
      //<<
      
      //>> form v1.05
      protected var mBorderTransparency:uint = 100;
      //<<
      
      //>> form v1.04
      protected var mPhysicsEnabled:Boolean = true;
      //<<
      
      //>> form v1.05
      protected var mIsHollow:Boolean = false;
      //<<
      
      public function EntityShape (world:World, shapeContainer:ShapeContainer)
      {
         super (world, shapeContainer);
      }
      
      override public function IsPhysicsEntity ():Boolean
      {
         return Define.IsBasicShapeEntity (mEntityType) && IsPhysicsEnabled ();
      }
      
      override public function Update (dt:Number):void
      {
         mWorld.ReportShapeStatus (mOriginalAiType, mAiType);
      }
      
//==============================================================================
//
//==============================================================================
      
      public function SetShapeAiType (aiType:int):void
      {
         if (mAiType == Define.ShapeAiType_Unknown)
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
      
      public function IsPhysicsEnabled ():Boolean
      {
         return mPhysicsEnabled;
      }
      
      public function SetHollow (hollow:Boolean):void
      {
         mIsHollow = hollow;
      }
      
      public function IsHollow ():Boolean
      {
         return mIsHollow;
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
      
      public function SetDrawBackground (draw:Boolean):void
      {
         mDrawBackground = draw;
      }
      
      public function IsDrawBackground ():Boolean
      {
         if (mAiType >= 0)
            return true;
         
         return mDrawBackground;
      }
      
      public function SetFilledColor (color:uint):void
      {
         mFilledColor = color;
      }
      
      public function GetFilledColor ():uint
      {
         if (mAiType >= 0)
            return Define.GetShapeFilledColor (mAiType);
         
         return mFilledColor;
      }
      
      public function SetDrawBorder (drawBorder:Boolean):void
      {
         mDrawBorder = drawBorder;
      }
      
      public function IsDrawBorder ():Boolean
      {
         return mDrawBorder;
      }
      
      public function SetBorderColor (color:uint):void
      {
         mBorderColor = color;
      }
      
      public function GetBorderColor ():uint
      {
         if (mAiType >= 0)
            return Define.ColorObjectBorder;
         
         if (mWorld.GetVersion () < 0x0105)
         {
            if (! mDrawBorder)
               return GetFilledColor ();
         }
         
         return mBorderColor;
      }
      
      public function SetBorderThickness (thinkness:uint):void
      {
         mBorderThickness = thinkness;
      }
      
      public function GetBorderThickness ():uint
      {
         if (mWorld.GetVersion () < 0x0105)
         {
            return 1;
         }
         
         return mBorderThickness;
      }
      
      public function SetTransparency (transparency:uint):void
      {
         mTransparency = transparency;
         
         alpha = 0.01 * mTransparency;
      }
      
      public function GetTransparency ():uint
      {
         if (mAiType >= 0)
            return 100;
         
         return mTransparency;
      }
      
      public function SetBorderTransparency (transparency:uint):void
      {
         mBorderTransparency = transparency;
      }
      
      public function GetBorderTransparency ():uint
      {
         return mBorderTransparency;
      }
      
//==============================================================================
//
//==============================================================================
      
      public function GetParentContainer ():ShapeContainer
      {
         return mShapeContainer;
      }
      
      override public function BuildFromParams (params:Object):void
      {
         super.BuildFromParams (params);
         
         mPhysicsEnabled = params.mIsPhysicsEnabled;
         
         SetBullet (params.mIsBullet);
         mShapeContainer.SetBullet (IsBullet ());
         
         SetStatic (params.mIsStatic);
         SetShapeAiType (params.mAiType);
         
         // >> from v1.02
         SetDrawBorder (params.mDrawBorder);
         SetDrawBackground (params.mDrawBackground);
         //<<
         
         // >> from v1.04
         SetBorderColor (params.mBorderColor);
         SetBorderThickness (params.mBorderThickness);
         SetFilledColor (params.mBackgroundColor);
         SetTransparency (params.mTransparency);
         //<<
         
         // >> from v1.05
         SetBorderTransparency (params.mBorderTransparency);
         SetHollow (params.mIsHollow);
         //<<
      }
      
      // maybe change later
      public function GetLocalPosition ():Point
      {
         return new Point (x, y);
      }
      
      
      
   }
   
}
