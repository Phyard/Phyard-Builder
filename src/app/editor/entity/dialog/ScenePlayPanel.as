package editor.entity.dialog {
   
   import flash.events.Event;
   
   import mx.core.UIComponent;
   
   import viewer.Viewer;
   import player.world.World;
   
   public class ScenePlayPanel extends UIComponent
   {  
      private var mViewer:Viewer = null;
      
      public function ScenePlayPanel ()
      {
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         addEventListener(Event.RESIZE, OnResize);
         
         mBackgroundLayer = new Sprite ();
         addChild (mBackgroundLayer);
      }
      
//============================================================================
//   
//============================================================================
      
      public function SetWorldViewer (viewer:Viewer):void
      {
         mViewer = viewer;
         
         addChild (mViewer);
      }
      
//============================================================================
//   
//============================================================================
      
      private function OnAddedToStage (event:Event):void 
      {
         UpdateBackgroundAndContentMaskSprites ();
      }
      
      override private function OnResize (event:Event):void 
      {
         UpdateBackgroundAndContentMaskSprites ();
      }
      
      private var mContentMaskSprite:Shape = null;
      private var mContentMaskWidth :Number = -1;
      private var mContentMaskHeight:Number = -1;
      
      protected function UpdateBackgroundAndContentMaskSprites ():void
      {
         if (parent.width != mContentMaskWidth || parent.height != mContentMaskHeight)
         {
            mContentMaskWidth  = parent.width;
            mContentMaskHeight = parent.height;
            
            if (mContentMaskSprite == null)
            {
               mContentMaskSprite = new Shape ();
               addChild (mContentMaskSprite);
               mask = mContentMaskSprite;
            }
            
            GraphicsUtil.ClearAndDrawRect (mBackgroundLayer, 0, 0, mContentMaskWidth - 1, mContentMaskHeight - 1, 0x0, 1, true, 0xFFFFFF);
            GraphicsUtil.ClearAndDrawRect (mContentMaskSprite, 0, 0, mContentMaskWidth - 1, mContentMaskHeight - 1, 0x0, 1, true);
            
            if (mViewer != null)
            {
               mViewer.SetViewportSize (mContentMaskWidth, mContentMaskHeight);
            }
         }
      }

   
   }
}
