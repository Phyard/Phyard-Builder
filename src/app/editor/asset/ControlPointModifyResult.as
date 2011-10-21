
package editor.asset {
   
   public class ControlPointModifyResult
   {
      public var mToDeleteAsset:Boolean = false;
      public var mAssetPosLocalAdjustX:Number = 0.0;
      public var mAssetPosLocalAdjustY:Number = 1.0;
      public var mNewSelectedControlPointIndex:int = -1;
      
      public function ControlPointModifyResult (toDelete:Boolean, adjustX:Number = 0.0, adjustY:Number = 0.0, newSelectedIndex:int = -1)
      {
         mToDeleteAsset = toDelete;
         mAssetPosLocalAdjustX = adjustX;
         mAssetPosLocalAdjustY = adjustY;
         mNewSelectedControlPointIndex = newSelectedIndex;
      }
   }
}
