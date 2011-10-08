package editor.asset {

   import flash.geom.Point;

   public class IntentTaps extends Intent
   {
      protected var mAssetManagerPanel:AssetManagerPanel;
      
      protected var mReleaseToTap:Boolean = true; // false for press to tap. Subclass can change this value
      protected var mCallbackOnTap:Function;
      protected var mCallbackOnMove:Function;
      protected var mCallbackOnCancel:Function;
      
      public function IntentTaps (assetManagerPanel:AssetManagerPanel, callbackOnTap:Function = null, callbaclOnMove:Function = null, callbackOnCancel:Function = null)
      {
         mAssetManagerPanel = assetManagerPanel;
         
         mCallbackOnTap = callbackOnTap;
         mCallbackOnMove = callbaclOnMove;
         mCallbackOnCancel = callbackOnCancel;
      }
      
      //protected var mStarted:Boolean = false;
      protected var mPoints:Array = null; //new Array (); // null means "mStarted == false"
      
   //================================================================
   // 
   //================================================================

      protected function AddNewTapPoint (managerX:Number, managerY:Number, released:Boolean):void
      {
         if (mPoints == null)
         {
            mPoints = new Array ();
         }
         
         if (mReleaseToTap == released)
         {
            var finished:Boolean = false;
            
            if (mPoints.length > 0)
            {
               var lastPoint:Point = mPoints [0] as Point;
               
               var lastPointInView:Point    = mAssetManagerPanel.ManagerToView (lastPoint);
               var currentPointInView:Point = mAssetManagerPanel.ManagerToView (new Point (managerX, managerY));
               var dx:Number = currentPointInView.x - lastPointInView.x;
               var dy:Number = currentPointInView.y - lastPointInView.y;
               
               finished = Math.sqrt (dx * dx + dy * dy) <= 2.0;
            }
            
            if (! finished)
            {
               mPoints.push (new Point (managerX, managerY));
            }
            
            if (mCallbackOnTap != null)
            {
               mCallbackOnTap (mPoints.concat (), finished);
            }
         }
      }
      
   //================================================================
   // override 
   //================================================================
      
      override protected function OnMouseDownInternal (managerX:Number, managerY:Number):void
      {
         AddNewTapPoint (managerX, managerY, false);
      }
      
      override protected function OnMouseMoveInternal (managerX:Number, managerY:Number, isHold:Boolean):void
      {
         if (mPoints == null)
            return;
         
         if (mCallbackOnMove != null)
         {
            mCallbackOnMove (mPoints.concat (), managerX, managerY, isHold);
         }
      }
      
      override protected function OnMouseUpInternal (managerX:Number, managerY:Number):void
      {
         AddNewTapPoint (managerX, managerY, true);
      }
      
      override protected function TerminateInternal (passively:Boolean):void
      {
         if (passively && mCallbackOnCancel != null)
         {
            mCallbackOnCancel ();
         }
      }

   }
   
}
