package editor.entity.dialog {

   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.EventPhase;
   
   import mx.core.UIComponent;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import viewer.Viewer;
   
   import player.world.World;
   import player.design.Global;
   
   public class ScenePlayPanel extends UIComponent
   {
      private var mBackgroundLayer:Sprite = new Sprite ();
      
      private var mDesignViewer:Viewer = null;
      
      public function ScenePlayPanel ()
      {
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         addEventListener(Event.RESIZE, OnResize);
         
         addChild (mBackgroundLayer);
      }
      
//============================================================================
//   
//============================================================================
      
      public function SetWorldViewerParams (worldBinaryData:ByteArray, currentSceneId:int, maskFieldInPlaying:Boolean, surroudingBackgroundColor:uint):void
      {
         CloseViewer ();
         
         mDesignViewer = new Viewer ({mParamsFromEditor: {
                                         mWorldDomain: ApplicationDomain.currentDomain, 
                                         mWorldBinaryData: worldBinaryData, 
                                         mCurrentSceneId: currentSceneId, 
                                         GetViewportSize: GetViewportSize, 
                                         mStartRightNow: true, 
                                         mMaskViewport: maskFieldInPlaying,
                                         mBackgroundColor: surroudingBackgroundColor
                                         }
                             });
         
         addChild (mDesignViewer);
         
         mDesignViewer.OnContainerResized ();
      }
      
      public function CloseViewer ():void
      {
         if (mDesignViewer != null)
         {
            removeChild (mDesignViewer);
            mDesignViewer = null;
         }
         
         Global.ClearAll ();
      }
      
      private function GetViewportSize ():Point
      {
         return new Point (mContentMaskWidth, mContentMaskHeight);
      }
      
//========================================================================================
// !!! 
//========================================================================================
      
      import player.WorldPlugin;
      
      private function Dummy ():void
      {
         new WorldPlugin (); // to make mxmlc include WorldPlugin, so the all player.* package, ...
      }

//============================================================================
//   
//============================================================================
      
      private var mFirstTimeAddTiStage:Boolean = true;
      
      private function OnAddedToStage (event:Event):void 
      {
         UpdateBackgroundAndContentMaskSprites ();
         
         // ...
         if (mFirstTimeAddTiStage)
         {
            mFirstTimeAddTiStage = false;
            
            addEventListener (Event.ENTER_FRAME, OnEnterFrame);
            
            addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
            addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
            addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
            
            addEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
         }
      }
      
      private function OnEnterFrame (event:Event):void 
      {
         if (mDesignViewer != null)
            stage.focus = this;
         
         UpdateInterface ();
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
            
            if (mDesignViewer != null)
            {
               mDesignViewer.OnContainerResized ();
            }
         }
      }
      
//==================================================================================
// mouse and key events
//==================================================================================
      
      public function OnMouseDown (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         //stage.focus = this;
         
         OnMousePositionChanged ();
      }
      
      public function OnMouseMove (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         //stage.focus = this;
         
         OnMousePositionChanged ();
      }
      
      public function OnMouseUp (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         //stage.focus = this;
         
         OnMousePositionChanged ();
      }
      
      public function OnKeyDown (event:KeyboardEvent):void
      {
         switch (event.keyCode)
         {
            case 70: // F
            case Keyboard.SPACE:
               if (event.ctrlKey || event.shiftKey)
                  AdvanceOneFrame (); 
               
               break;
            default:
               break;
         }
         
         //event.stopPropagation (); // will cause Keyboard events not triggered in playing
      }
      
//============================================================================
//   
//============================================================================
      
      private var mDialogCallbacks:Object = null; // must not be null
      
      public function SetDialogCallbacks (callbacks:Object):void
      {
         mDialogCallbacks = callbacks;
      }
      
      public function UpdateInterface ():void
      {
         if (mDialogCallbacks == null || mDialogCallbacks.UpdateInterface == null)
            return;
         
         if (mDesignViewer == null)
         {
            mDialogCallbacks.UpdateInterface (null);
            return;
         }
         
         var viewerStatusInfo:Object = new Object ();
         
         var playerWorld:World = mDesignViewer.GetPlayerWorld () as World;
         
         viewerStatusInfo.mSpeedX = mDesignViewer.GetPlayingSpeedX ();;
         viewerStatusInfo.mIsPlaying = mDesignViewer.IsPlaying ();
         viewerStatusInfo.mCurrentSimulationStep = playerWorld == null ? 0 : playerWorld.GetSimulatedSteps ();
         viewerStatusInfo.mFPS = mDesignViewer.GetFPS ();
         
         mDialogCallbacks.UpdateInterface (viewerStatusInfo);
      }
      
      protected function OnMousePositionChanged ():void
      {
         if (mDialogCallbacks == null || mDialogCallbacks.SetMousePosition == null)
            return;
         
         if (mDesignViewer == null)
         {
            mDialogCallbacks.SetMousePosition (null);
            return;
         }
         
         var playerWorld:World = mDesignViewer.GetPlayerWorld () as World;
         
         if (playerWorld == null)
         {
            mDialogCallbacks.SetMousePosition (null);
            return;
         }
         
         var mousePositionInfo:Object = new Object ();
         mousePositionInfo.mPixelX = playerWorld.mouseX;
         mousePositionInfo.mPixelY = playerWorld.mouseY;
         mousePositionInfo.mPhysicsX = playerWorld.GetCoordinateSystem ().D2P_PositionX (playerWorld.mouseX);
         mousePositionInfo.mPhysicsY = playerWorld.GetCoordinateSystem ().D2P_PositionY (playerWorld.mouseY);
         
         mDialogCallbacks.SetMousePosition (mousePositionInfo);
      }
      
      private var mMaskViewport:Boolean = false;
      
      public function IsMaskViewport ():Boolean
      {
         return mMaskViewport;
      }
      
      public function SetMaskViewport (mask:Boolean):void
      {
         mMaskViewport = mask;
         
         if (mDesignViewer != null)
         {
            mDesignViewer.SetMaskViewerField (mMaskViewport);
         }
      }
      
      public function Restart ():void
      {
         if (mDesignViewer != null)
         {
            mDesignViewer.PlayRestart ();
         }
      }
      
      public function ChangePlayingStatus (playing:Boolean):void
      {
         if (mDesignViewer != null)
         {
            mDesignViewer.ResumeOrPause (playing);
         }
      }
      
      public function ChangeSpeedX (deltaSpeedX:int):void
      {
         if (mDesignViewer != null)
         {
            mDesignViewer.ChangeSpeedX (deltaSpeedX);
         }
      }
      
      public function AdvanceOneFrame ():void
      {
         if (mDesignViewer != null)
         {
            mDesignViewer.UpdateSingleFrame ();
         }
      }
   }
}
