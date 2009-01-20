
package player.entity {
   
   import flash.geom.Point;
   
   import player.world.World;
   
   import common.Define;
   
   public class EntityShape extends Entity
   {
      
      protected var mShapeContainer:ShapeContainer;
      
      protected var mIsPhysicsShape:Boolean = true;
      
      protected var mOriginalAiType:int = Define.ShapeAiType_Unkown;
      protected var mAiType:int = Define.ShapeAiType_Unkown;
      
      protected var mIsStatic:Boolean = false;
      
      public var mIsBullet:Boolean = false;
      
      private var mEntityId:int = -1;
      
      public function EntityShape (world:World, shapeContainer:ShapeContainer)
      {
         super (world);
         
         mShapeContainer = shapeContainer;
         
         mShapeContainer.addChild (this);
      }
      
      public function GetEntityId ():int
      {
         return mEntityId;
      }
      
      public function IsPhysicsShape ():Boolean
      {
         return mPhysicsProxy != null;
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
      
      public function IsStatic ():Boolean
      {
         return mIsStatic;
      }
      
      public function SetStatic (static:Boolean):void
      {
         mIsStatic = static;
      }
      
      public function SetBullet (bullet:Boolean):void
      {
         mIsBullet = bullet;
      }
      
      public function IsBullet ():Boolean
      {
         return mIsBullet;
      }
      
      public function GetParentContainer ():ShapeContainer
      {
         return mShapeContainer;
      }
      
      override public function BuildPhysicsProxy (params:Object):void
      {
         // for the initial pos and rot of shapeContainer are zeroes, so no need to translate to local values
         
         if ( params.mWorldDefine != null )
         {
            if (params.mWorldDefine.mVersion >= 0x101)
            {
               if (! isNaN (params.mEntityId))
                  mEntityId = params.mEntityId;
            }
         }
         
         visible = params.mIsVisible;
         
         SetBullet (params.mIsBullet);
         mShapeContainer.SetBullet (IsBullet ());
         
         SetStatic (params.mIsStatic);
         SetShapeAiType (params.mAiType);
      }
      
      // maybe change later
      public function GetLocalPosition ():Point
      {
         return new Point (x, y);
      }
      
      
      
   }
   
}
