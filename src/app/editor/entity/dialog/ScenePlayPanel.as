package editor.entity.dialog {

   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   import mx.core.UIComponent;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import viewer.Viewer;
   import player.world.World;
   
   public class ScenePlayPanel extends UIComponent
   {
      private var mBackgroundLayer:Sprite = new Sprite ();
      
      private var mViewer:Viewer = null;
      
      public function ScenePlayPanel ()
      {
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         addEventListener(Event.RESIZE, OnResize);
         
         addChild (mBackgroundLayer);
      }
      
//============================================================================
//   
//============================================================================
      
      public function SetWorldViewerParams (worldBinaryData:ByteArray, maskFieldInPlaying:Boolean):void
      {
         mViewer = new Viewer ({mParamsFromEditor: {
                                         mWorldDomain: ApplicationDomain.currentDomain, 
                                         mWorldBinaryData: worldBinaryData, 
                                         GetViewportSize: GetViewportSize, 
                                         mStartRightNow: true, 
                                         mMaskViewerField: maskFieldInPlaying
                                         }
                             });
         
         addChild (mViewer);
         
         mViewer.OnContainerResized ();
      }
      
      private function GetViewportSize ():Point
      {
         return new Point (mContentMaskWidth, mContentMaskHeight);
      }
      
//============================================================================
//   
//============================================================================
      
      private function OnAddedToStage (event:Event):void 
      {
         UpdateBackgroundAndContentMaskSprites ();
      }
      
      private function OnResize (event:Event):void 
      {
         UpdateBackgroundAndContentMaskSprites ();
      }
      
      private var mContentMaskSprite:Shape = null;
      private var mContentMaskWidth :Number = 0;
      private var mContentMaskHeight:Number = 0;
      
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
               mViewer.OnContainerResized ();
            }
         }
      }

   
   }
}
