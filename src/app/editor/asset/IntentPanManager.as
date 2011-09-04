package editor.asset {

   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;

   public class IntentPanManager extends Intent
   {
      protected var mAssetManagerPanel:AssetManagerPanel;
      
      public function IntentPanManager (assetManagerPanel:AssetManagerPanel)
      {
         mAssetManagerPanel = assetManagerPanel;
      }
      
      protected var mLastX:Number;
      protected var mLastY:Number;
      protected var mCurrentX:Number;
      protected var mCurrentY:Number;
      
   //================================================================
   // override 
   //================================================================
      
      override protected function OnMouseDownInternal (managerX:Number, managerY:Number):void
      {
         var point:Point = mAssetManagerPanel.ManagerToView (new Point (managerX, managerY));
         
         mLastX = point.x;
         mLastY = point.y;
      }
      
      override protected function OnMouseMoveInternal (managerX:Number, managerY:Number, isHold:Boolean):void
      {
         if (isHold)
         {
            var point:Point = mAssetManagerPanel.ManagerToView (new Point (managerX, managerY));
            
            mCurrentX = point.x;
            mCurrentY = point.y;
            
            Process ();
         
            mLastX = mCurrentX;
            mLastY = mCurrentY;
         }
         else
         {
            Terminate (true);
         }
      }
      
      override protected function OnMouseUpInternal (managerX:Number, managerY:Number):void
      {
         var point:Point = mAssetManagerPanel.ManagerToView (new Point (managerX, managerY));
         
         mCurrentX = point.x;
         mCurrentY = point.y;
         
         Process ();
         
         Terminate (false);
      }
      
   //================================================================
   // to override 
   //================================================================
   
      protected function Process ():void
      {
         var dx:Number = mCurrentX - mLastX;
         var dy:Number = mCurrentY - mLastY;
         
         mAssetManagerPanel.MoveManager (dx, dy);
      }

   }
   
}
