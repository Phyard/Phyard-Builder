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
         
         mAiTypeChangeable = false;
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
            var displayHalfWidth :Number = mWorld.GetCoordinateSystem ().P2D_Length (mHalfWidth);
            var displayHalfHeight:Number = mWorld.GetCoordinateSystem ().P2D_Length (mHalfHeight);
            
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
