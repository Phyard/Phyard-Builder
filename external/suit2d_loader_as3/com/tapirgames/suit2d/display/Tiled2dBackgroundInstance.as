package com.tapirgames.suit2d.display {
   
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   import flash.utils.ByteArray;
   
   import com.tapirgames.suit2d.loader.Sprite2dFile;
   import com.tapirgames.suit2d.loader.Tiled2dBackground;
   import com.tapirgames.suit2d.loader.ModuleRef;
   import com.tapirgames.suit2d.loader.Tiled2dModule;
   
   
   public class Tiled2dBackgroundInstance extends Sprite
   {
      private var mSprite2dFile:Sprite2dFile;
      private var mTiled2dBackground:Tiled2dBackground;
      
      private var mPresentRegion:Rectangle = new Rectangle ();
      
      private var mVisibleLayersCount:uint;
      
      private var mGridVisible:Boolean = false;
      private var mGridColor:int = 0x808080;
      
      public function Tiled2dBackgroundInstance (sprite2dFile:Sprite2dFile, backgroundIndex:uint)
      {
         mSprite2dFile        = sprite2dFile;
         mTiled2dBackground   = sprite2dFile.GetTiled2dBackground (backgroundIndex);
         
         mVisibleLayersCount  = mTiled2dBackground.mTiled2dLayers.length;
      }
      
      public function SetVisibleLayersCount (count:uint):void
      {
         if (count > mTiled2dBackground.mTiled2dLayers.length)
            count = mTiled2dBackground.mTiled2dLayers.length;
         
         mVisibleLayersCount = count;
      }
      
      public function SetGridColor (color:int):void
      {
         mGridColor = color;
      }
      
      public function SetGridVisible (visible:Boolean):void
      {
         mGridVisible = visible;
      }
      
      public function GetPhysicalInfoFromLayer (layerID:uint):Object
      {
         if (layerID >= mTiled2dBackground.mTiled2dLayers.length)
            return null;
         
         var cellRows:int   = mTiled2dBackground.mCellRows;
         var cellCols:int   = mTiled2dBackground.mCellCols;
         var cellWidth:int  = mTiled2dBackground.mCellWidth;
         var cellHeight:int = mTiled2dBackground.mCellHeight;
         var moduleRefs:Array = mTiled2dBackground.mTiled2dLayers [layerID];
         
         var data:ByteArray = new ByteArray ();
         data.length = cellRows * cellCols;
         
         var phyInfo:Object = new Object ();
         phyInfo.mCellRows = cellRows;
         phyInfo.mCellCols = cellCols;
         phyInfo.mCellWidth = cellWidth;
         phyInfo.mCellHeight = cellHeight;
         phyInfo.mCellValues = data;
         
         
         var cellIndex:int = 0;
         
         for (var row:int = 0; row < cellRows; ++ row)
         {
            for (var col:int = 0; col < cellCols; ++ col)
            {
               var phyValue:int = -1;
               var moduleRef:ModuleRef = moduleRefs [cellIndex];
               if (moduleRef != null)
               {
                  var tiled2dModule:Tiled2dModule = moduleRef.mModule as Tiled2dModule;
                  
                  if (tiled2dModule != null)
                  {
                     phyValue = tiled2dModule.mIndex;
                  }
               }
               
               data [cellIndex] = (phyValue < 0 ? 0 : phyValue);
               
               ++ cellIndex;
            }
         }
         
         return phyInfo;
      }
      
      // currently, only static backgrounds are supported
      public function SetPresentRegion (newVisibleRegion:Rectangle):void
      {
         var cellRows:int   = mTiled2dBackground.mCellRows;
         var cellCols:int   = mTiled2dBackground.mCellCols;
         var cellWidth:int  = mTiled2dBackground.mCellWidth;
         var cellHeight:int = mTiled2dBackground.mCellHeight;
         
         var newStartRow:uint = 0;
         var newStartCol:uint = 0;
         var newEndRow:uint   = cellRows;
         var newEndCol:uint   = cellCols;
         
         var oldStartRow:uint = mPresentRegion.x / cellHeight;
         var oldStartCol:uint = mPresentRegion.y / cellWidth;
         var oldEndRow:uint   = (mPresentRegion.y + mPresentRegion.height) / cellWidth;
         var oldEndCol:uint   = (mPresentRegion.x + mPresentRegion.width ) / cellHeight;
         
         mPresentRegion.x = 0;
         mPresentRegion.y = 0;
         mPresentRegion.width  = cellCols * cellWidth;
         mPresentRegion.height = cellRows * cellHeight;
         
         if ( newStartRow == oldStartRow && newStartCol == oldStartCol
             && newEndRow == oldEndRow   && newEndCol   == oldEndCol )
         {
            return;
         }
         
         // now, all aera will be present
         trace ("rebuild tiled background ... ");
         trace ("old = (" + oldStartRow + ", " + oldStartCol + ", " + oldEndRow + ", " + oldEndCol + ")");
         trace ("new = (" + newStartRow + ", " + newStartCol + ", " + newEndRow + ", " + newEndCol + ")");
         while (numChildren > 0)
            removeChildAt (0);
         
         
         var row:int;
         var col:int;
         var x:int;
         var y:int
         
         graphics.clear ();
         if (mGridVisible)
         {
            graphics.lineStyle(1, mGridColor);
            
            var totalWidth :int = cellWidth  * cellCols;
            var totalHeight:int = cellHeight * cellRows;
            
            y = 0;
            for (row = 0; row <= cellRows; ++ row)
            {
               graphics.moveTo (0, y);
               graphics.lineTo (totalWidth, y);
               y += cellHeight;
            }
            
            x = 0;
            for (col = 0; col < cellCols; ++ col)
            {
               graphics.moveTo (x, 0);
               graphics.lineTo (x, totalHeight);
               x += cellWidth;
            }
         }
         
         for (var layerID:int = 0; layerID < mVisibleLayersCount; ++ layerID)
         {
            var moduleRefs:Array = mTiled2dBackground.mTiled2dLayers [layerID];
            var cellIndex:int = 0;
            
            y = 0;
            
            for (row = 0; row < cellRows; ++ row)
            {
               x = 0;
               
               
               for (col = 0; col < cellCols; ++ col)
               {
                  var moduleRef:ModuleRef = moduleRefs [cellIndex ++];
                  if (moduleRef != null)
                  {
                     var tiled2dModule:Tiled2dModule = moduleRef.mModule as Tiled2dModule;
                     
                     if (tiled2dModule != null)
                     {
                        if (tiled2dModule.mModuleRef.mModule != null)
                        {
                           var flipX:Boolean = moduleRef.mFlipX != tiled2dModule.mModuleRef.mFlipX;
                           var flipY:Boolean = moduleRef.mFlipY != tiled2dModule.mModuleRef.mFlipY;
                           var posX:int = flipX ? x + cellWidth : x;
                           var posY:int = flipY ? y + cellHeight : y;
                           tiled2dModule.mModuleRef.mModule.Render (this, posX, posY, flipX, flipY);
                        }
                     }
                  }
                  
                  x += cellWidth;
               }
               
               y += cellHeight;
            }
         }
      }
   }
}