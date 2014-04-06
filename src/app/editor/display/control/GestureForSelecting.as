
package editor.display.control {
   
   import flash.events.Event;
   import flash.events.EventPhase;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import mx.core.UIComponent;
   
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.Resource;
   
   import common.GestureIDs;

   public class GestureForSelecting extends UIComponent 
   {
      private static var sGestureBitmapClasses:Array = null;
      private static var sGestureBitmapClasses_Selected:Array = null;
      private static var sGestureRegionAndAngles:Array = null;
      
      private static function InitStaticData ():void
      {
         if (sGestureBitmapClasses_Selected != null)
            return;
         
         sGestureBitmapClasses = new Array (GestureIDs.kNumGestures);
         sGestureBitmapClasses_Selected = new Array (GestureIDs.kNumGestures);
         
      // ...
         
         sGestureBitmapClasses          [GestureIDs.Line0] = Resource.Gesture_Line000;
         sGestureBitmapClasses_Selected [GestureIDs.Line0] = Resource.Gesture_Line000_Selected;
         sGestureBitmapClasses          [GestureIDs.Line45] = Resource.Gesture_Line045;
         sGestureBitmapClasses_Selected [GestureIDs.Line45] = Resource.Gesture_Line045_Selected;
         sGestureBitmapClasses          [GestureIDs.Line90] = Resource.Gesture_Line000;
         sGestureBitmapClasses_Selected [GestureIDs.Line90] = Resource.Gesture_Line000_Selected;
         sGestureBitmapClasses          [GestureIDs.Line135] = Resource.Gesture_Line045;
         sGestureBitmapClasses_Selected [GestureIDs.Line135] = Resource.Gesture_Line045_Selected;
         sGestureBitmapClasses          [GestureIDs.Line180] = Resource.Gesture_Line000;
         sGestureBitmapClasses_Selected [GestureIDs.Line180] = Resource.Gesture_Line000_Selected;
         sGestureBitmapClasses          [GestureIDs.Line225] = Resource.Gesture_Line045;
         sGestureBitmapClasses_Selected [GestureIDs.Line225] = Resource.Gesture_Line045_Selected;
         sGestureBitmapClasses          [GestureIDs.Line270] = Resource.Gesture_Line000;
         sGestureBitmapClasses_Selected [GestureIDs.Line270] = Resource.Gesture_Line000_Selected;
         sGestureBitmapClasses          [GestureIDs.Line315] = Resource.Gesture_Line045;
         sGestureBitmapClasses_Selected [GestureIDs.Line315] = Resource.Gesture_Line045_Selected;
         
         sGestureBitmapClasses          [GestureIDs.LineArrow0] = Resource.Gesture_LineArrow000;
         sGestureBitmapClasses_Selected [GestureIDs.LineArrow0] = Resource.Gesture_LineArrow000_Selected;
         sGestureBitmapClasses          [GestureIDs.LineArrow45] = Resource.Gesture_LineArrow045;
         sGestureBitmapClasses_Selected [GestureIDs.LineArrow45] = Resource.Gesture_LineArrow045_Selected;
         sGestureBitmapClasses          [GestureIDs.LineArrow90] = Resource.Gesture_LineArrow000;
         sGestureBitmapClasses_Selected [GestureIDs.LineArrow90] = Resource.Gesture_LineArrow000_Selected;
         sGestureBitmapClasses          [GestureIDs.LineArrow135] = Resource.Gesture_LineArrow045;
         sGestureBitmapClasses_Selected [GestureIDs.LineArrow135] = Resource.Gesture_LineArrow045_Selected;
         sGestureBitmapClasses          [GestureIDs.LineArrow180] = Resource.Gesture_LineArrow000;
         sGestureBitmapClasses_Selected [GestureIDs.LineArrow180] = Resource.Gesture_LineArrow000_Selected;
         sGestureBitmapClasses          [GestureIDs.LineArrow225] = Resource.Gesture_LineArrow045;
         sGestureBitmapClasses_Selected [GestureIDs.LineArrow225] = Resource.Gesture_LineArrow045_Selected;
         sGestureBitmapClasses          [GestureIDs.LineArrow270] = Resource.Gesture_LineArrow000;
         sGestureBitmapClasses_Selected [GestureIDs.LineArrow270] = Resource.Gesture_LineArrow000_Selected;
         sGestureBitmapClasses          [GestureIDs.LineArrow315] = Resource.Gesture_LineArrow045;
         sGestureBitmapClasses_Selected [GestureIDs.LineArrow315] = Resource.Gesture_LineArrow045_Selected;
         
         sGestureBitmapClasses          [GestureIDs.Arrow0] = Resource.Gesture_Arrow000;
         sGestureBitmapClasses_Selected [GestureIDs.Arrow0] = Resource.Gesture_Arrow000_Selected;
         sGestureBitmapClasses          [GestureIDs.Arrow45] = Resource.Gesture_Arrow045;
         sGestureBitmapClasses_Selected [GestureIDs.Arrow45] = Resource.Gesture_Arrow045_Selected;
         sGestureBitmapClasses          [GestureIDs.Arrow90] = Resource.Gesture_Arrow000;
         sGestureBitmapClasses_Selected [GestureIDs.Arrow90] = Resource.Gesture_Arrow000_Selected;
         sGestureBitmapClasses          [GestureIDs.Arrow135] = Resource.Gesture_Arrow045;
         sGestureBitmapClasses_Selected [GestureIDs.Arrow135] = Resource.Gesture_Arrow045_Selected;
         sGestureBitmapClasses          [GestureIDs.Arrow180] = Resource.Gesture_Arrow000;
         sGestureBitmapClasses_Selected [GestureIDs.Arrow180] = Resource.Gesture_Arrow000_Selected;
         sGestureBitmapClasses          [GestureIDs.Arrow225] = Resource.Gesture_Arrow045;
         sGestureBitmapClasses_Selected [GestureIDs.Arrow225] = Resource.Gesture_Arrow045_Selected;
         sGestureBitmapClasses          [GestureIDs.Arrow270] = Resource.Gesture_Arrow000;
         sGestureBitmapClasses_Selected [GestureIDs.Arrow270] = Resource.Gesture_Arrow000_Selected;
         sGestureBitmapClasses          [GestureIDs.Arrow315] = Resource.Gesture_Arrow045;
         sGestureBitmapClasses_Selected [GestureIDs.Arrow315] = Resource.Gesture_Arrow045_Selected;
         
         sGestureBitmapClasses          [GestureIDs.Pool0] = Resource.Gesture_Pool000;
         sGestureBitmapClasses_Selected [GestureIDs.Pool0] = Resource.Gesture_Pool000_Selected;
         sGestureBitmapClasses          [GestureIDs.Pool90] = Resource.Gesture_Pool000;
         sGestureBitmapClasses_Selected [GestureIDs.Pool90] = Resource.Gesture_Pool000_Selected;
         sGestureBitmapClasses          [GestureIDs.Pool180] = Resource.Gesture_Pool000;
         sGestureBitmapClasses_Selected [GestureIDs.Pool180] = Resource.Gesture_Pool000_Selected;
         sGestureBitmapClasses          [GestureIDs.Pool270] = Resource.Gesture_Pool000;
         sGestureBitmapClasses_Selected [GestureIDs.Pool270] = Resource.Gesture_Pool000_Selected;
         
         sGestureBitmapClasses          [GestureIDs.Wave0] = Resource.Gesture_Wave000;
         sGestureBitmapClasses_Selected [GestureIDs.Wave0] = Resource.Gesture_Wave000_Selected;
         sGestureBitmapClasses          [GestureIDs.Wave90] = Resource.Gesture_Wave000;
         sGestureBitmapClasses_Selected [GestureIDs.Wave90] = Resource.Gesture_Wave000_Selected;
         sGestureBitmapClasses          [GestureIDs.Wave180] = Resource.Gesture_Wave000;
         sGestureBitmapClasses_Selected [GestureIDs.Wave180] = Resource.Gesture_Wave000_Selected;
         sGestureBitmapClasses          [GestureIDs.Wave270] = Resource.Gesture_Wave000;
         sGestureBitmapClasses_Selected [GestureIDs.Wave270] = Resource.Gesture_Wave000_Selected;
         
         sGestureBitmapClasses          [GestureIDs.ZigzagZ]        = Resource.Gesture_ZigzagZ;
         sGestureBitmapClasses_Selected [GestureIDs.ZigzagZ]        = Resource.Gesture_ZigzagZ_Selected;
         sGestureBitmapClasses          [GestureIDs.ZigzagN]        = Resource.Gesture_ZigzagZ;
         sGestureBitmapClasses_Selected [GestureIDs.ZigzagN]        = Resource.Gesture_ZigzagZ_Selected;
         sGestureBitmapClasses          [GestureIDs.ZigzagS]        = Resource.Gesture_ZigzagS;
         sGestureBitmapClasses_Selected [GestureIDs.ZigzagS]        = Resource.Gesture_ZigzagS_Selected;
         sGestureBitmapClasses          [GestureIDs.ZigzagLighting] = Resource.Gesture_ZigzagS;
         sGestureBitmapClasses_Selected [GestureIDs.ZigzagLighting] = Resource.Gesture_ZigzagS_Selected;
         
         sGestureBitmapClasses          [GestureIDs.LongPress]        = Resource.Gesture_LongPress;
         sGestureBitmapClasses_Selected [GestureIDs.LongPress]        = Resource.Gesture_LongPress_Selected;
         
         sGestureBitmapClasses          [GestureIDs.Circle]        = Resource.Gesture_Circle;
         sGestureBitmapClasses_Selected [GestureIDs.Circle]        = Resource.Gesture_Circle_Selected;
         
         sGestureBitmapClasses          [GestureIDs.Triangle]        = Resource.Gesture_Triangle;
         sGestureBitmapClasses_Selected [GestureIDs.Triangle]        = Resource.Gesture_Triangle_Selected;
         
         sGestureBitmapClasses          [GestureIDs.FivePointStar]        = Resource.Gesture_FivePointStar;
         sGestureBitmapClasses_Selected [GestureIDs.FivePointStar]        = Resource.Gesture_FivePointStar_Selected;
         
      // ...
         
         sGestureRegionAndAngles = new Array (GestureIDs.kNumGestures);
         
         sGestureRegionAndAngles [GestureIDs.Line0  ] = [-160, - 90, 36, 36,   0];
         sGestureRegionAndAngles [GestureIDs.Line45 ] = [-160, - 50, 36, 36,   0];
         sGestureRegionAndAngles [GestureIDs.Line90 ] = [-200, - 50, 36, 36,  90];
         sGestureRegionAndAngles [GestureIDs.Line135] = [-240, - 50, 36, 36,  90];
         sGestureRegionAndAngles [GestureIDs.Line180] = [-240, - 90, 36, 36, 180];
         sGestureRegionAndAngles [GestureIDs.Line225] = [-240, -130, 36, 36, 180];
         sGestureRegionAndAngles [GestureIDs.Line270] = [-200, -130, 36, 36, 270];
         sGestureRegionAndAngles [GestureIDs.Line315] = [-160, -130, 36, 36, 270];
         
         sGestureRegionAndAngles [GestureIDs.LineArrow0  ] = [  20, - 90, 36, 36,   0];
         sGestureRegionAndAngles [GestureIDs.LineArrow45 ] = [  20, - 50, 36, 36,   0];
         sGestureRegionAndAngles [GestureIDs.LineArrow90 ] = [- 20, - 50, 36, 36,  90];
         sGestureRegionAndAngles [GestureIDs.LineArrow135] = [- 60, - 50, 36, 36,  90];
         sGestureRegionAndAngles [GestureIDs.LineArrow180] = [- 60, - 90, 36, 36, 180];
         sGestureRegionAndAngles [GestureIDs.LineArrow225] = [- 60, -130, 36, 36, 180];
         sGestureRegionAndAngles [GestureIDs.LineArrow270] = [- 20, -130, 36, 36, 270];
         sGestureRegionAndAngles [GestureIDs.LineArrow315] = [  20, -130, 36, 36, 270];
         
         sGestureRegionAndAngles [GestureIDs.Arrow0  ] = [ 200, - 90, 36, 36,   0];
         sGestureRegionAndAngles [GestureIDs.Arrow45 ] = [ 200, - 50, 36, 36,   0];
         sGestureRegionAndAngles [GestureIDs.Arrow90 ] = [ 160, - 50, 36, 36,  90];
         sGestureRegionAndAngles [GestureIDs.Arrow135] = [ 120, - 50, 36, 36,  90];
         sGestureRegionAndAngles [GestureIDs.Arrow180] = [ 120, - 90, 36, 36, 180];
         sGestureRegionAndAngles [GestureIDs.Arrow225] = [ 120, -130, 36, 36, 180];
         sGestureRegionAndAngles [GestureIDs.Arrow270] = [ 160, -130, 36, 36, 270];
         sGestureRegionAndAngles [GestureIDs.Arrow315] = [ 200, -130, 36, 36, 270];
         
         sGestureRegionAndAngles [GestureIDs.Pool0  ] = [-160,   40, 36, 36,   0];
         sGestureRegionAndAngles [GestureIDs.Pool90 ] = [-200,   80, 36, 36,  90];
         sGestureRegionAndAngles [GestureIDs.Pool180] = [-240,   40, 36, 36, 180];
         sGestureRegionAndAngles [GestureIDs.Pool270] = [-200,    0, 36, 36, 270];
         
         sGestureRegionAndAngles [GestureIDs.Wave0  ] = [  20,   40, 36, 36,   0];
         sGestureRegionAndAngles [GestureIDs.Wave90 ] = [ -20,   80, 36, 36,  90];
         sGestureRegionAndAngles [GestureIDs.Wave180] = [ -60,   40, 36, 36, 180];
         sGestureRegionAndAngles [GestureIDs.Wave270] = [ -20,    0, 36, 36, 270];
         
         sGestureRegionAndAngles [GestureIDs.ZigzagZ       ] = [ 200,   40, 36, 36,   0];
         sGestureRegionAndAngles [GestureIDs.ZigzagN       ] = [ 160,   80, 36, 36,  90];
         sGestureRegionAndAngles [GestureIDs.ZigzagS       ] = [ 120,   40, 36, 36,   0];
         sGestureRegionAndAngles [GestureIDs.ZigzagLighting] = [ 160,    0, 36, 36,  90];
         
         sGestureRegionAndAngles [GestureIDs.LongPress     ] = [ -200,  130, 36, 36,   0];
         sGestureRegionAndAngles [GestureIDs.Circle        ] = [ - 80,  130, 36, 36,   0];
         sGestureRegionAndAngles [GestureIDs.Triangle      ] = [   40,  130, 36, 36,   0];
         sGestureRegionAndAngles [GestureIDs.FivePointStar ] = [  160,  130, 36, 36,   0];     
         
      // ...
         
         var minX:Number = 10000;
         var maxX:Number = -10000;
         var minY:Number = 10000;
         var maxY:Number = -10000;
         
         for (var i:int = 0; i < GestureIDs.kNumGestures; ++ i)
         {
            var region:Array = sGestureRegionAndAngles [i];
            
            if (region != null)
            {
               var left:int = region [0];
               var top:int = region [1];
               var right:int = left + region [2];
               var bottom:int = top + region [3];
               
               if (left < minX)
                  minX = left;
               if (top < minY)
                  minY = top;
               if (right > maxX)
                  maxX = right;
               if (bottom > maxY)
                  maxY = bottom;
            }
         }
         
         sShiftX = - minX;
         sShiftY = - minY;
         sWholeWidth  = maxX - minX;
         sWholeHeight = maxY - minY;
      }
      
      private static var sShiftX:int = 0;
      private static var sShiftY:int = 0;
      private static var sWholeWidth:int = 0;
      private static var sWholeHeight:int = 0;
      
   // ...
      
      private var mSelectedGestureBitmaps:Array = new Array (GestureIDs.kNumGestures);
      
   // ...
      
      private var mSelectedGestureIDs:Array = new Array ();
      
      public function GestureForSelecting  ()
      {
         if (sGestureBitmapClasses_Selected == null)
            InitStaticData ();
         
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         
         //alpha = 0.3;
         
         // ...
         
         for (var gestureId:int = 0; gestureId < GestureIDs.kNumGestures; ++ gestureId)
         {
            if (sGestureBitmapClasses [gestureId] != null)
            {
               var bitmap:Bitmap = new sGestureBitmapClasses [gestureId] ();
               addChild (bitmap);
               var region:Array = sGestureRegionAndAngles [gestureId];
               var radian:Number = region [4] * Math.PI / 180.0;
               var cos:Number = Math.cos (radian);
               var sin:Number = Math.sin (radian);
               bitmap.x = sShiftX + region [0] + 0.5 * (region [2] - cos * region [2] + sin * region [3]);
               bitmap.y = sShiftY + region [1] + 0.5 * (region [3] - sin * region [2] - cos * region [3]);
               bitmap.rotation = region [4];
            }
         }
      }
      
      override protected function measure ():void
      {
         measuredWidth = sWholeWidth;
         measuredHeight = sWholeHeight;
      }
      
      private function OnAddedToStage (event:Event):void 
      {
         addEventListener (Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
         addEventListener (MouseEvent.CLICK, OnMouseClick);
      }
      
      private function OnRemovedFromStage (event:Event):void 
      {
         removeEventListener (MouseEvent.CLICK, OnMouseClick);
         removeEventListener (Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
         removeEventListener (MouseEvent.CLICK, OnMouseClick);
      }
      
      public function get selectedGestureIDs ():Array
      {
         return mSelectedGestureIDs;
      }
      
      public function RebuildAppearance ():void
      {
         var i:int = 0;
         var gestureId:int;
         var bitmap:Bitmap;
         var region:Array;
         
         for (gestureId = 0; gestureId < GestureIDs.kNumGestures; ++ gestureId)
         {
            if (mSelectedGestureBitmaps [gestureId] != null)
               mSelectedGestureBitmaps [gestureId].visible = false;
         }
         
         for (i = 0; i < mSelectedGestureIDs.length; ++ i)
         {
            gestureId = mSelectedGestureIDs [i];
            if (mSelectedGestureBitmaps [gestureId] == null && sGestureBitmapClasses_Selected [gestureId] != null)
            {
               bitmap = new sGestureBitmapClasses_Selected [gestureId] ();
               mSelectedGestureBitmaps [gestureId] = bitmap;
               addChild (bitmap);
               region = sGestureRegionAndAngles [gestureId];
               var radian:Number = region [4] * Math.PI / 180.0;
               var cos:Number = Math.cos (radian);
               var sin:Number = Math.sin (radian);
               bitmap.x = sShiftX + region [0] + 0.5 * (region [2] - cos * region [2] + sin * region [3]);
               bitmap.y = sShiftY + region [1] + 0.5 * (region [3] - sin * region [2] - cos * region [3]);
               bitmap.rotation = region [4];
            }
            
            if (mSelectedGestureBitmaps [gestureId] != null)
               mSelectedGestureBitmaps [gestureId].visible = true;
         }
      }
      
      public function set selectedGestureIDs (gestureIDs:Array):void
      {
         var i:int = 0;
         var gestureId:int;
         
         mSelectedGestureIDs.splice (0, mSelectedGestureIDs.length);
         
         for (i = 0; i < gestureIDs.length; ++ i)
         {
            gestureId = int (gestureIDs [i]);
            if (gestureId >= 0 && gestureId < GestureIDs.kNumGestures && mSelectedGestureIDs.indexOf (gestureId) < 0)
            {
               mSelectedGestureIDs.push (gestureId);
            }
         }
         
         RebuildAppearance ();
      }
      
      private function OnMouseClick (event:MouseEvent):void
      {
         //if (event.eventPhase != EventPhase.BUBBLING_PHASE)
         //   return;
         
         var point:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, this, new Point (event.localX, event.localY) );
         var px:Number = point.x - sShiftX;
         var py:Number = point.y - sShiftY;
         
         var gestureId:int = -1;
         var region:Array;
         var left:Number;
         var right:Number;
         var top:Number;
         var bottom:Number;
         
         for (var i:int = 0; i < GestureIDs.kNumGestures; ++ i)
         {
            region = sGestureRegionAndAngles [i];
            if (region == null)
               continue;
            
            left   = region [0];
            right  = region [2] + left;
            top    = region [1];
            bottom = region [3] + top;
            
            if (px > left && px < right && py > top && py < bottom)
            {
               gestureId = i;
               break;
            }
         }
         
//trace ("px = " + px + ", py = " + py + ", gestureId = " + gestureId);
         if (gestureId >= 0)
         {
            var index:int = mSelectedGestureIDs.indexOf (gestureId);
            if (index < 0)
               mSelectedGestureIDs.push (gestureId);
            else
               mSelectedGestureIDs.splice (index, 1);
            
            RebuildAppearance ();
         }
      }
   }
}
