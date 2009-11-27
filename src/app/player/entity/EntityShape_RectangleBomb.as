package player.entity {
   
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.world.World;
   
   import common.Define;
   
   public class EntityShape_RectangleBomb extends EntityShapeRectangle
   {
      public function EntityShape_RectangleBomb (world:World)
      {
         super (world);
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
            var displayHalfWidth :Number = mWorld.PhysicsLength2DisplayLength (mHalfWidth);
            var displayHalfHeight:Number = mWorld.PhysicsLength2DisplayLength (mHalfHeight);
            
            GraphicsUtil.DrawRect (
                     mBackgroundShape,
                     - 0.5 * displayHalfWidth,
                     - 0.5 * displayHalfHeight,
                     displayHalfWidth,
                     displayHalfHeight,
                     0x808080,
                     0, //
                     true, // draw background
                     0x808080
                  );
         }
      }
   }
}
