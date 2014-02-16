package editor.entity.dialog {

   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.InteractiveObject;
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
   
   public class ScenePlayPanel extends UIComponent
   {
      private var mBackgroundLayer:Sprite = new Sprite ();
      
      public function ScenePlayPanel ()
      {
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         addEventListener(Event.RESIZE, OnResize);
         
         addChild (mBackgroundLayer);
      }
      
//============================================================================
//   
//============================================================================
      
      private var mDialogCallbacks:Object = null; // must not be null
      
      public function SetDialogCallbacks (callbacks:Object):void
      {
         mDialogCallbacks = callbacks;
      }
      
      //private var mDesignViewer:Viewer = null;
      
      private var mViewerParamsFromEditor:Object = null;
      
      private var mRestoreValues:Object = null;
      
      public function SetWorldViewerParams (worldBinaryData:ByteArray, currentSceneId:int, maskFieldInPlaying:Boolean, surroudingBackgroundColor:uint, callbackStopPlaying:Function):void
      {
         /*
         mDesignViewer = new Viewer ({mParamsFromEditor: {
                                         mWorldDomain: ApplicationDomain.currentDomain,  
                                         mWorldBinaryData: worldBinaryData, 
                                         mCurrentSceneId: currentSceneId, 
                                         GetViewportSize: GetViewportSize, 
                                         mStartRightNow: true, 
                                         mMaskViewerField: maskFieldInPlaying, 
                                         mBackgroundColor: surroudingBackgroundColor, 
                                         OnExitLevel: callbackStopPlaying, 
                                         
                                         //>> websocket
                                         EmbedCallContainer: EmbedCallContainer
                                         //<<
                                      }
                             });
         
         addChild (mDesignViewer);
         
         mDesignViewer.OnContainerResized ();
         */
         
         if (mRestoreValues == null)
            mRestoreValues = new Object ();
         mRestoreValues.mRenderQuality = stage.quality;
         
         mViewerParamsFromEditor = {mParamsFromEditor: {
                                         mWorldDomain: ApplicationDomain.currentDomain,  
                                         mWorldBinaryData: worldBinaryData, 
                                         mCurrentSceneId: currentSceneId, 
                                         GetViewportSize: GetViewportSize, 
                                         mStartRightNow: true, 
                                         mMaskViewerField: maskFieldInPlaying, 
                                         mBackgroundColor: surroudingBackgroundColor, 
                                         OnExitLevel: callbackStopPlaying, 
                                         
                                         //>> websocket
                                         EmbedCallContainer: EmbedCallContainer
                                         //<<
                                       }
                                    };
         
         SetNumMultiplePlayers (3);
      }
      
      public function CloseAllViewers ():void
      {
         //if (mDesignViewer != null)
         //{
         //   mDesignViewer.Destroy ();
         //   removeChild (mDesignViewer);
         //   mDesignViewer = null;
         //}
         
         SetNumMultiplePlayers (0);
         
         mDialogCallbacks = null;
         
         mViewerParamsFromEditor = null;
         
         if (mRestoreValues != null)
         {
            stage.quality = mRestoreValues.mRenderQuality;
         }
      }
      
      public function OnSelectMultiplePlayerIndex (index:int):void
      {
         SetCurrentMultiplePlayerIndex (index);
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
         // before v2.04
         //if (mDesignViewer != null)
         //   stage.focus = this;
         
         // since v2.04
         //if (mDesignViewer != null)
         // sicne v2.06
         if (GetCurrentViewer () != null)
         {
            var io:InteractiveObject = stage.focus; // may be an editable text field
            while (io != this && io != null)
            {
               io = io.parent;
            }
            if (io != this)
            {
               stage.focus = this;
            }
         }
         
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
            
            //if (mDesignViewer != null)
            //{
            //   mDesignViewer.OnContainerResized ();
            //}
            
            var designViewer:Viewer = GetCurrentViewer ();
            if (designViewer != null)
            {
               designViewer.OnContainerResized ();
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
         //switch (event.keyCode)
         //{
         //   case 70: // F
         //   case Keyboard.SPACE:
         //      if (event.ctrlKey || event.shiftKey)
         //         AdvanceOneFrame (); 
         //      
         //      break;
         //   default:
         //      break;
         //}
         
         //event.stopPropagation (); // will cause Keyboard events not triggered in playing
      }
      
//============================================================================
//   
//============================================================================
      
      public function UpdateInterface ():void
      {
         if (mDialogCallbacks == null || mDialogCallbacks.UpdateInterface == null)
            return;
         
         var designViewer:Viewer = GetCurrentViewer ();
         
         if (/*mDesignViewer*/designViewer == null)
         {
            mDialogCallbacks.UpdateInterface (null);
            return;
         }
         
         var viewerStatusInfo:Object = new Object ();
         
         var playerWorld:World = /*mDesignViewer*/designViewer.GetPlayerWorld () as World;
         
         viewerStatusInfo.mSpeedX = /*mDesignViewer*/designViewer.GetPlayingSpeedX ();
         viewerStatusInfo.mIsPlaying = /*mDesignViewer*/designViewer.IsPlaying ();
         viewerStatusInfo.mCurrentSimulationStep = playerWorld == null ? 0 : playerWorld.GetSimulatedSteps ();
         viewerStatusInfo.mFPS = /*mDesignViewer*/designViewer.GetFPS ();
         viewerStatusInfo.mShowPlayBar = /*mDesignViewer*/designViewer.IsShowPlayBar ();
         
         mDialogCallbacks.UpdateInterface (viewerStatusInfo);
      }
      
      protected function OnMousePositionChanged ():void
      {
         if (mDialogCallbacks == null || mDialogCallbacks.SetMousePosition == null)
            return;
         
         var designViewer:Viewer = GetCurrentViewer ();
         
         if (/*mDesignViewer*/designViewer == null)
         {
            mDialogCallbacks.SetMousePosition (null);
            return;
         }
         
         var playerWorld:World = /*mDesignViewer*/designViewer.GetPlayerWorld () as World;
         
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
         
         if (/*mDesignViewer*/GetCurrentViewer () != null)
         {
            /*mDesignViewer*/GetCurrentViewer ().SetMaskViewerField (mMaskViewport);
         }
      }
      
      public function SimulateSystemBack ():void
      {
         if (/*mDesignViewer*/GetCurrentViewer () != null && /*mDesignViewer*/GetCurrentViewer ().OnBackKeyDown != null)
         {
            /*mDesignViewer*/GetCurrentViewer ().OnBackKeyDown ();
         }
      }
      
      public function Restart ():void
      {
         if (/*mDesignViewer*/GetCurrentViewer () != null)
         {
            /*mDesignViewer*/GetCurrentViewer ().PlayRestart ();
         }
      }
      
      public function ChangePlayingStatus (playing:Boolean):void
      {
         if (/*mDesignViewer*/GetCurrentViewer () != null)
         {
            /*mDesignViewer*/GetCurrentViewer ().ResumeOrPause (playing);
         }
      }
      
      public function ChangeSpeedX (deltaSpeedX:int):void
      {
         if (/*mDesignViewer*/GetCurrentViewer () != null)
         {
            /*mDesignViewer*/GetCurrentViewer ().ChangeSpeedX (deltaSpeedX);
         }
      }
      
      public function AdvanceOneFrame ():void
      {
         if (/*mDesignViewer*/GetCurrentViewer () != null)
         {
            /*mDesignViewer*/GetCurrentViewer ().UpdateSingleFrame ();
         }
      }
      
      public function ClearGameSaveData (soFilename:String):void
      {
         Viewer.ClearCookie (soFilename);
      }
      
//============================================================================
//   as the Multiple Players Server
//============================================================================
      
      public static const MaxNumMultiplePlayers:int = 4;
      
      protected var mMultiplePlayerViewers:Array = new Array (MaxNumMultiplePlayers);
      protected var mNumMultiplePlayers:int = 0;
      protected var mCurrentMutiplePlayerIndex:int = -1;
      
      protected function SetNumMultiplePlayers (num:int):void
      {
         if (num < 0)
            num = 0;
         if (num > MaxNumMultiplePlayers)
            num = MaxNumMultiplePlayers;
            
         if (mCurrentMutiplePlayerIndex >= num)
            SetCurrentMultiplePlayerIndex (-1);
         
         var i:int;
         var designViewer:Viewer;
         
         if (mNumMultiplePlayers > num)
         {
            for (i = mNumMultiplePlayers - 1; i >= num; -- i)
            {
               designViewer = mMultiplePlayerViewers [i] as Viewer;
               designViewer.Destroy (i == 0);
               removeChild (designViewer);
            }
         }
         else if (mNumMultiplePlayers < num)
         {
            for (i = mNumMultiplePlayers; i < num; ++ i)
            {
               designViewer = new Viewer (mViewerParamsFromEditor);
               designViewer.SetActive (false);
               mMultiplePlayerViewers [i] = designViewer;
               addChild (designViewer);
            }
         }
         
         mNumMultiplePlayers = num;
            
         if (mCurrentMutiplePlayerIndex < 0 && num > 0)
            SetCurrentMultiplePlayerIndex (0);
         
         if (mDialogCallbacks != null && mDialogCallbacks.SetNumMultiplePlayers != null)
         {
            mDialogCallbacks.SetNumMultiplePlayers (mNumMultiplePlayers, mCurrentMutiplePlayerIndex);
         }
      }
      
      protected function SetCurrentMultiplePlayerIndex (index:int):void
      {
         if (index < 0 || index >= mNumMultiplePlayers)
            index = -1;
         
         if (mCurrentMutiplePlayerIndex != index)
         {
            var designViewer:Viewer;
            
            if (mCurrentMutiplePlayerIndex >= 0)
            {
               designViewer = mMultiplePlayerViewers [mCurrentMutiplePlayerIndex] as Viewer;
               designViewer.SetActive (false);
               //removeChild (designViewer);
            }
            
            mCurrentMutiplePlayerIndex = index;
            
            if (mCurrentMutiplePlayerIndex >= 0)
            {
               designViewer = mMultiplePlayerViewers [mCurrentMutiplePlayerIndex] as Viewer;
               designViewer.SetActive (true);
               //addChild (designViewer);
               designViewer.OnContainerResized ();
            }
         }
      }
      
      protected function GetCurrentViewer ():Viewer
      {
         return mMultiplePlayerViewers [mCurrentMutiplePlayerIndex] as Viewer;
      } 
      
//============================================================================
//   
//============================================================================
      
      // don't change this name, 
      public function ContainerCallEmbed (funcName:String, params:Object):void
      {
         //if (mViewer != null)
         //{
         //   mViewer.ContainerCallEmbed (funcName, params);
         //}
      }
      
      // don't change this name, 
      public function EmbedCallContainer (funcName:String, params:Object):void 
      {
         if (funcName == "SendGlobalSocketMessage")
         {
            var message:String = params.message;
         }
      }
   }
}
