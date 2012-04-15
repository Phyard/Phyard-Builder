package editor.display.container
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.EventPhase;
   
   import mx.managers.CursorManager;
	import mx.containers.TitleWindow;
	
	import editor.EditorContext; // project specified

	public class ResizableTitleWindow extends TitleWindow
	{
	   public static const MarginForResizing:int = 8;
	   
	   public static const ResizingMode_Left:int = 1;
	   public static const ResizingMode_Right:int = 2;
	   public static const ResizingMode_Top:int = 4;
	   public static const ResizingMode_Bottom:int = 8;
	   
	   [Embed(source="cursor_resize_BottomLeft_TopRight.gif")]
		public var IconResizeSlash:Class;
	   [Embed(source="cursor_resize_TopLeft_BottomRight.gif")]
		public var IconResizeAntiSlash:Class;
	   [Embed(source="cursor_resize_TopBottom.gif")]
		public var IconResizeVertical:Class;
	   [Embed(source="cursor_resize_LeftRight.gif")]
		public var IconResizeHorizontal:Class;
	   
	   private var mAllowedResizingModeBits:int = ResizingMode_Left | ResizingMode_Right | ResizingMode_Bottom;
	   
	   private var mResizingMode:int = 0;
	   
	   private var mResizeCursorID:int = 0;
	   private var mLastCursorIcon:Class = null;

	   private var mInDragging:Boolean = false;
	   private var mDraggingFromX:Number;
	   private var mDraggingFromY:Number;
	   
		public function ResizableTitleWindow()
		{
			super();
			
			addEventListener (Event.ENTER_FRAME, OnEnterFrame);
         
         addEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
			
         addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
         addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
         addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
         addEventListener (MouseEvent.ROLL_OVER, OnMouseMove);
         addEventListener (MouseEvent.ROLL_OUT, OnMouseOut);
		}
		
		private var mFocused:Boolean = false;
		public function SetFocused (focused:Boolean):void
		{
		   if (mFocused != focused)
		   {
		      mFocused = focused;
		      
		      if (mFocused)
		      {
      		   setStyle ("headerColors", [0x000080, 0xC0C0C0]);
      		   setStyle ("color", 0xFFFFFF);
      		   setStyle ("fontWeight", "bold");
      		}
      		else
      		{
      		   setStyle ("headerColors", null);
      		   setStyle ("color", 0x000000);
      		   setStyle ("fontWeight", "normal");
      		}
   		}
		}
		
		public function SetAllowedResizingModeBits (bits:int):void
		{
		   mAllowedResizingModeBits = bits;
		}
		
		private function OnEnterFrame (event:Event):void 
      {
         if (parent == null)
         {
            StopDragging ();
         }
         else if (mInDragging)
         {
            if (EditorContext.mIsMouseButtonHold)
            {
               var dx:Number = mouseX - mDraggingFromX;
               var dy:Number = mouseY - mDraggingFromY;
               
               if ((mResizingMode & ResizingMode_Top) != 0)
                  dy = - dy;
               else if ((mResizingMode & ResizingMode_Bottom) == 0)
                  dy = 0;
               
               if ((mResizingMode & ResizingMode_Left) != 0)
                  dx = - dx;
               else if ((mResizingMode & ResizingMode_Right) == 0)
                  dx = 0;
               
               var oldWidth:Number = width;
               var oldHeight:Number = height;
               
               var newWidth:Number = width + dx;
               var newHeight:Number = height + dy;
               
               if (newWidth < 100)
                  newWidth = 100;
               if (newHeight < 100)
                  newHeight = 100;
               if (newWidth > stage.stageWidth)
                  newWidth = stage.stageWidth;
               if (newHeight > stage.stageHeight)
                  newHeight = stage.stageHeight;
               
               width = newWidth;
               height = newHeight;
               
               dx = width - oldWidth;
               dy = height - oldHeight;
               
               if ((mResizingMode & ResizingMode_Top) != 0)
                  y -= dy;
               if ((mResizingMode & ResizingMode_Left) != 0)
                  x -= dx;

               mDraggingFromX = mouseX;
               mDraggingFromY = mouseY;
            }
            else
            {
               StopDragging ();
            }
         }
      }
      
      private function OnKeyDown (event:KeyboardEvent):void
      {
         EditorContext.GetSingleton ().OnKeyDownDefault (event.keyCode);
      }
      
      private function StopDragging ():void
      {
         mInDragging = false;
         mResizingMode = 0;
         UpdateCursor ();
      }
		
		private function OnMouseDown (event:MouseEvent):void
      {
         EditorContext.GetSingleton ().SetCurrentFocusedTitleWindow (this);
         
         UpdateResizingMode ();
         
         if (mResizingMode != 0)
         {
            mInDragging = true;
            
            mDraggingFromX = mouseX;
            mDraggingFromY = mouseY;
         }
      }
		
		private function OnMouseMove (event:MouseEvent):void
      {
         if (event.buttonDown)
         {
            if (mResizingMode != 0)
               return;
            
            if (parent == null)
            {
               mResizingMode = 0;
               
               return;
            }
            
            
         }
         else
         {
            if (mInDragging)
               StopDragging ();
            
            UpdateResizingMode ();
         }
      }
		
		private function OnMouseUp (event:MouseEvent):void
      {
         StopDragging ();
         
         UpdateResizingMode ();
      }
      
      private function OnMouseOut (event:MouseEvent):void
      {
         if (mInDragging)
            return;
         
         UpdateResizingMode ();
      }
      
      private function UpdateResizingMode ():void
      {
         RecalResizingMode ();
         
         UpdateCursor ();
      }
      
      private function UpdateCursor ():void
      {
         //trace ("mResizingMode = " + mResizingMode);
         
         var newCursorIcon:Class = null;
         
         if (mResizingMode == 0)
         {
            newCursorIcon = null;
         }
         else
         {
            if (mResizingMode == (ResizingMode_Right | ResizingMode_Bottom) || mResizingMode == (ResizingMode_Left | ResizingMode_Top))
               newCursorIcon = IconResizeAntiSlash;
            if (mResizingMode == (ResizingMode_Right | ResizingMode_Top) || mResizingMode == (ResizingMode_Left | ResizingMode_Bottom))
               newCursorIcon = IconResizeSlash;
            if (mResizingMode == ResizingMode_Right || mResizingMode == ResizingMode_Left)
               newCursorIcon = IconResizeHorizontal;
            if (mResizingMode == ResizingMode_Bottom || mResizingMode == ResizingMode_Top)
               newCursorIcon = IconResizeVertical;
         }
         
         if (newCursorIcon != mLastCursorIcon)
         {
            if (mResizeCursorID != 0)
            {
               CursorManager.removeCursor(mResizeCursorID);
               mResizeCursorID = 0;
            }
            
            if (newCursorIcon != null)
            {
               var offset:Number = (newCursorIcon == IconResizeHorizontal || newCursorIcon == IconResizeVertical) ? -12 : -8.5;
               mResizeCursorID = CursorManager.setCursor(newCursorIcon, 2, offset, offset);
            }
            
            mLastCursorIcon = newCursorIcon;
         }
      }
      
      private function RecalResizingMode ():void
      {
         mResizingMode = 0;
         
         //trace (" =============== mouseX = " + mouseX + ", mouseY = " + mouseY + ", width = " + width + ", height = " + height);
         
         if (mouseX < 0 || mouseX > width || mouseY < 0 || mouseY > height)
            return;
         
         var inLeft:Boolean = mouseX <= MarginForResizing;
         var inRight:Boolean = mouseX >= width - MarginForResizing;
         var inTop:Boolean = mouseY <= MarginForResizing;
         var inBottom:Boolean = mouseY >= height - MarginForResizing;
         
         //trace ("    inLeft = " + inLeft + ", inRight = " + inRight + ", inTop = " + inTop + ", inBottom = " + inBottom);
         
         if ((! inLeft) && (! inRight) && (! inTop) && (! inBottom))
            return;
         
         if (inRight)
            mResizingMode |= ResizingMode_Right;
         else if (inLeft)
            mResizingMode |= ResizingMode_Left;
         
         if (inBottom)
            mResizingMode |= ResizingMode_Bottom;
         else if (inTop)
            mResizingMode |= ResizingMode_Top;
         
         mResizingMode &= mAllowedResizingModeBits;
      }
	}
}
