
package player.entity {
   
   import player.world.World;
   
   import common.Define;
   
   public class EntityShape extends Entity
   {
      
      protected var mShapeContainer:ShapeContainer;
      
      protected var mIsPhysicsShape:Boolean = true;
      
      protected var mAiType:int = Define.ShapeAiType_Unkown;
      
      protected var mIsStatic:Boolean = false;
      
      public var mIsBullet:Boolean = false;
      
      public function EntityShape (world:World, shapeContainer:ShapeContainer)
      {
         super (world);
         
         mShapeContainer = shapeContainer;
      }
      
      public function SetShapeAiType (aiType:int):void
      {
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
         
         visible = params.mIsVisible;
         
         SetBullet (params.mIsBullet);
         mShapeContainer.SetBullet (IsBullet ());
         
         SetStatic (params.mIsStatic);
         SetShapeAiType (params.mAiType);
      }
      
   }
   
}
