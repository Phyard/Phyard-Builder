package player.entity {
   
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.world.World;
   
   import common.Define;
   
   public class EntityShape_CircleBomb extends EntityShapeCircle
   {
      public function EntityShape_CircleBomb (world:World)
      {
         super (world);
         
         mBallTypeDotPercent = 0.75;
      }
      
//=============================================================
//   appearance
//=============================================================
     
      override public function UpdateAppearance ():void
      {
         //mAppearanceObjectsContainer.visible = mVisible
         //mAppearanceObjectsContainer.alpha = mAlpha; 
         
         var needRebuildAppearanceObjects:Boolean = mNeedRebuildAppearanceObjects;
         
         super.UpdateAppearance ();
         
         if (needRebuildAppearanceObjects)
         {
            var displayRadius:Number = mWorld.PhysicsLength2DisplayLength (mRadius);
            
            GraphicsUtil.DrawCircle (
                     mBackgroundShape,
                     0,
                     0,
                     0.5 * displayRadius,
                     0x808080,
                     0,
                     true, // draw background
                     0x808080
                  );
         }
      }
   }
}
