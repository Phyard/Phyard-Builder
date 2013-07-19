
package editor.display.sprite {
   
   import flash.display.Sprite;
   import com.tapirgames.util.GraphicsUtil;
   
   public class GridSprite extends Sprite 
   {
      private var mSceneLeft:Number = 0;
      private var mSceneTop:Number = 0;
      private var mSceneWidth:Number = 0;
      private var mSceneHeight:Number = 0;

      private var mSceneDrawBg:Boolean = true;
      private var mSceneBgColor:uint = 0xFFFFFF;

      private var mSceneDrawBorder:Boolean = true;
      private var mSceneBorderColor:uint = 0x000000;
      private var mSceneBorderLeftThickness:Number = 0;
      private var mSceneBorderTopThickness:Number = 0;
      private var mSceneBorderRightThickness:Number = 0;
      private var mSceneBorderBottomThickness:Number = 0;

      private var mSceneCameraCenterX:Number = 0;
      private var mSceneCameraCenterY:Number = 0;
      private var mSceneScaleX:Number = 1.0;
      private var mSceneScaleY:Number = 1.0;

      private var mPanelWidth:Number = 0;
      private var mPanelHeight:Number = 0;

      private var mDrawGrid:Boolean = false;
      private var mGridColor:uint = 0xA0A0A0;
      private var mGridCellWidth:Number = 50;
      private var mGridCellHeight:Number = 50;
      
      private var mDrawCoodinateSystem:Boolean = false;
      
      public function UpdateAppearance (sceneLeft:Number, sceneTop:Number, sceneWidth:Number, sceneHeight:Number, 
                                        sceneDrawBg:Boolean, sceneBgColor:uint, 
                                        sceneDrawBorder:Boolean, sceneBorderColor:uint,
                                        sceneBorderLeftThickness:Number, sceneBorderTopThickness:Number, sceneBorderRightThickness:Number, sceneBorderBottomThickness:Number, 
                                        sceneCameraCenterX:Number, sceneCameraCenterY:Number, sceneScaleX:Number, sceneScaleY:Number,
                                        panelWidth:Number, panelHeight:Number, 
                                        drawGrid:Boolean, gridColor:uint, gridCellWidth:Number, gridCellHeight:Number,
                                        drawCoodinateSystem:Boolean
                                        ):void
      {
         if (   mSceneLeft != sceneLeft || mSceneTop != sceneTop || mSceneWidth != sceneWidth || mSceneHeight != sceneHeight
             || mSceneBorderColor != sceneBorderColor || mSceneDrawBorder != sceneDrawBorder
             || mSceneBorderLeftThickness != sceneBorderLeftThickness || mSceneBorderTopThickness != sceneBorderTopThickness || mSceneBorderRightThickness != sceneBorderRightThickness || mSceneBorderBottomThickness != sceneBorderBottomThickness
             || mSceneDrawBg != sceneDrawBg || mSceneBgColor != sceneBgColor 
             || mSceneCameraCenterX != sceneCameraCenterX || mSceneCameraCenterY != sceneCameraCenterY || mSceneScaleX != sceneScaleX || mSceneScaleY != sceneScaleY
             || mPanelWidth != panelWidth || mPanelHeight != panelHeight 
             || mDrawGrid != drawGrid || mGridColor != gridColor || mGridCellWidth != gridCellWidth || mGridCellHeight != gridCellHeight
             )
         {
            mSceneLeft = sceneLeft;
            mSceneTop = sceneTop;
            mSceneWidth = sceneWidth;
            mSceneHeight = sceneHeight;

            mSceneDrawBg = sceneDrawBg;
            mSceneBgColor = sceneBgColor;

            mSceneDrawBorder = sceneDrawBorder;
            mSceneBorderColor = sceneBorderColor;
            mSceneBorderLeftThickness = sceneBorderLeftThickness;
            mSceneBorderTopThickness = sceneBorderTopThickness;
            mSceneBorderRightThickness = sceneBorderRightThickness;
            mSceneBorderBottomThickness = sceneBorderBottomThickness;
            
            mSceneCameraCenterX = sceneCameraCenterX;
            mSceneCameraCenterY = sceneCameraCenterY;
            mSceneScaleX = sceneScaleX;
            mSceneScaleY = sceneScaleY;

            mPanelWidth = panelWidth;
            mPanelHeight = panelHeight;

            mDrawGrid = drawGrid;
            mGridColor = gridColor;
            mGridCellWidth = gridCellWidth;
            mGridCellHeight = gridCellHeight;
            
            mDrawCoodinateSystem = drawCoodinateSystem;
            
            Repaint ();
         }
      }
      
      private function Repaint ():void
      {              
         var worldViewLeft:Number   = (mSceneLeft - mSceneCameraCenterX) * mSceneScaleX + mPanelWidth  * 0.5;
         var worldViewTop:Number    = (mSceneTop  - mSceneCameraCenterY) * mSceneScaleY + mPanelHeight * 0.5;
         var worldViewRight:Number  = worldViewLeft + mSceneWidth  * mSceneScaleX;
         var worldViewBottom:Number = worldViewTop  + mSceneHeight * mSceneScaleY;
         var worldViewWidth:Number  = mSceneWidth  * mSceneScaleX;
         var worldViewHeight:Number = mSceneHeight * mSceneScaleY;
         
         var bgLeft:Number   = worldViewLeft   < 0           ? 0           : worldViewLeft;
         var bgTop:Number    = worldViewTop    < 0           ? 0           : worldViewTop;
         var bgRight:Number  = worldViewRight  > mPanelWidth  ? mPanelWidth  : worldViewRight;
         var bgBottom:Number = worldViewBottom > mPanelHeight ? mPanelHeight : worldViewBottom;
         var bgWidth :Number = bgRight - bgLeft;
         var bgHeight:Number = bgBottom - bgTop;
         
         var gridWidth:Number  = mGridCellWidth * mSceneScaleX;
         var gridHeight:Number = mGridCellHeight * mSceneScaleY;
         
         var gridX:Number;
         if (bgLeft == worldViewLeft)
            gridX = bgLeft;
         else
            gridX = bgLeft + (gridWidth - (bgLeft - worldViewLeft) % gridWidth);
         var gridY:Number;
         if (bgTop == worldViewTop)
            gridY = bgTop;
         else
            gridY = bgTop  + (gridHeight - (bgTop  - worldViewTop) % gridHeight);
         
      // paint
         
         this.graphics.clear ();
         
         if (mSceneDrawBg)
         {
            this.graphics.beginFill(mSceneBgColor);
            this.graphics.drawRect (bgLeft, bgTop, bgWidth, bgHeight);
            this.graphics.endFill ();
         }
         
         if (mDrawGrid)
         {
            this.graphics.lineStyle (1, mGridColor);
            while (gridX <= bgRight)
            {
               this.graphics.moveTo (gridX, bgTop);
               this.graphics.lineTo (gridX, bgBottom);
               gridX += gridWidth;
            }
            
            while (gridY <= bgBottom)
            {
               this.graphics.moveTo (bgLeft, gridY);
               this.graphics.lineTo (bgRight, gridY);
               gridY += gridHeight;
            }
            this.graphics.lineStyle ();
         }
         
         if (mSceneDrawBorder)
         {
            var borderThinknessL:Number = mSceneBorderLeftThickness * mSceneScaleX;
            var borderThinknessT:Number = mSceneBorderTopThickness * mSceneScaleY;
            var borderThinknessR:Number = mSceneBorderRightThickness * mSceneScaleX;
            var borderThinknessB:Number = mSceneBorderBottomThickness * mSceneScaleY;
            
            this.graphics.beginFill(mSceneBorderColor);
            this.graphics.drawRect (worldViewLeft, worldViewTop, borderThinknessL, worldViewHeight);
            this.graphics.drawRect (worldViewRight - borderThinknessR, worldViewTop, borderThinknessR, worldViewHeight);
            this.graphics.endFill ();
            
            this.graphics.beginFill(mSceneBorderColor);
            this.graphics.drawRect (worldViewLeft, worldViewTop, worldViewWidth, borderThinknessT);
            this.graphics.drawRect (worldViewLeft, worldViewBottom - borderThinknessB, worldViewWidth, borderThinknessB);
            this.graphics.endFill ();
         }
         
         if (mDrawCoodinateSystem)
         {
            var originX:Number = (0 - mSceneCameraCenterX) * mSceneScaleX + mPanelWidth  * 0.5;
            var originY:Number = (0  - mSceneCameraCenterY) * mSceneScaleY + mPanelHeight * 0.5;

            this.graphics.lineStyle (1, 0xFF0000);
            if (originX > 0 && originX < mPanelWidth)
            {
               this.graphics.moveTo (originX, 0);
               this.graphics.lineTo (originX, mPanelHeight);
            }
            
            if (originY > 0 && originY < mPanelHeight)
            {
               this.graphics.moveTo (0, originY);
               this.graphics.lineTo (mPanelWidth, originY);
            }
            this.graphics.lineStyle ();
         }
      }
   }
   
}
