
package editor.display.sprite {
   
   import flash.display.Sprite;
   import com.tapirgames.util.GraphicsUtil;
   
   public class BackgroundSprite extends Sprite 
   {
      private var mSceneLeft:Number = 0;
      private var mSceneTop:Number = 0;
      private var mSceneWidth:Number = 0;
      private var mSceneHeight:Number = 0;
      private var mSceneBorderLeftThickness:Number = 0;
      private var mSceneBorderTopThickness:Number = 0;
      private var mSceneBorderRightThickness:Number = 0;
      private var mSceneBorderBottomThickness:Number = 0;
      private var mSceneBgColor:uint = 0xFFFFFF;
      private var mSceneBorderColor:uint = 0x000000;
      private var mSceneDrawBorder:Boolean = true;
      private var mSceneCameraCenterX:Number = 0;
      private var mSceneCameraCenterY:Number = 0;
      private var mSceneScaleX:Number = 1.0;
      private var mSceneScaleY:Number = 1.0;
      private var mPanelWidth:Number = 0;
      private var mPanelHeight:Number = 0;
      private var mBackgroundGridCellWidth:Number = 50;
      private var mBackgroundGridCellHeight:Number = 50;
      
      public function UpdateAppearance (sceneLeft:Number, sceneTop:Number, sceneWidth:Number, sceneHeight:Number, 
                                        sceneBorderLeftThickness:Number, sceneBorderTopThickness:Number, sceneBorderRightThickness:Number, sceneBorderBottomThickness:Number, 
                                        sceneBgColor:uint, sceneBorderColor:uint, sceneDrawBorder:Boolean,
                                        sceneCameraCenterX:Number, sceneCameraCenterY:Number, sceneScaleX:Number, sceneScaleY:Number,
                                        panelWidth:Number, panelHeight:Number, backgroundGridCellWidth:Number, backgroundGridCellHeight:Number):void
      {
         if (   mSceneLeft != sceneLeft || mSceneTop != sceneTop || mSceneWidth != sceneWidth || mSceneHeight != sceneHeight
             || mSceneBorderLeftThickness != sceneBorderLeftThickness || mSceneBorderTopThickness != sceneBorderTopThickness || mSceneBorderRightThickness != sceneBorderRightThickness || mSceneBorderBottomThickness != sceneBorderBottomThickness
             || mSceneBgColor != sceneBgColor || mSceneBorderColor != sceneBorderColor || mSceneDrawBorder != sceneDrawBorder
             || mSceneCameraCenterX != sceneCameraCenterX || mSceneCameraCenterY != sceneCameraCenterY || mSceneScaleX != sceneScaleX || mSceneScaleY != sceneScaleY
             || mPanelWidth != panelWidth || mPanelHeight != panelHeight || mBackgroundGridCellWidth != backgroundGridCellWidth || mBackgroundGridCellHeight != backgroundGridCellHeight
             )
         {
            mSceneLeft = sceneLeft;
            mSceneTop = sceneTop;
            mSceneWidth = sceneWidth;
            mSceneHeight = sceneHeight;
            mSceneBorderLeftThickness = sceneBorderLeftThickness;
            mSceneBorderTopThickness = sceneBorderTopThickness;
            mSceneBorderRightThickness = sceneBorderRightThickness;
            mSceneBorderBottomThickness = sceneBorderBottomThickness;
            mSceneBgColor = sceneBgColor;
            mSceneBorderColor = sceneBorderColor;
            mSceneDrawBorder = sceneDrawBorder;
            mSceneCameraCenterX = sceneCameraCenterX;
            mSceneCameraCenterY = sceneCameraCenterY;
            mSceneScaleX = sceneScaleX;
            mSceneScaleY = sceneScaleY;
            mPanelWidth = panelWidth;
            mPanelHeight = panelHeight;
            mBackgroundGridCellWidth = backgroundGridCellWidth;
            mBackgroundGridCellHeight = backgroundGridCellHeight;
            
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
         
         var gridWidth:Number  = mBackgroundGridCellWidth * mSceneScaleX;
         var gridHeight:Number = mBackgroundGridCellHeight * mSceneScaleY;
         
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
         
         this.graphics.beginFill(mSceneBgColor);
         this.graphics.drawRect (bgLeft, bgTop, bgWidth, bgHeight);
         this.graphics.endFill ();
         
         this.graphics.lineStyle (1, 0xA0A0A0);
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
      }
   }
   
}
