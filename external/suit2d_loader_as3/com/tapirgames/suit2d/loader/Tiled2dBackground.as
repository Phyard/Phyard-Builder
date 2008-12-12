package com.tapirgames.suit2d.loader {
   
   
   public class Tiled2dBackground 
   {
      public var mTiled2dLayers:Array;
      
      public var mCellRows:int;
      public var mCellCols:int;
      public var mCellWidth:int;
      public var mCellHeight:int;
      
      public function Tiled2dBackground (cellRows:int, cellCols:int, cellWidth:int, cellHeight:int, tiled2dLayers:Array)
      {
         mCellRows = cellRows;
         mCellCols = cellCols;
         mCellWidth = cellWidth;
         mCellHeight = cellHeight;
         
         mTiled2dLayers = tiled2dLayers;
      }
      
      
   }
}
