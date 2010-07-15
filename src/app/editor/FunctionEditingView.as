
package editor {
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.EventPhase;
   
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   import mx.core.UIComponent;
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.controls.TextInput;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.runtime.Runtime;
   
   import editor.trigger.entity.Linkable;
   
   import editor.entity.Entity;
   
   import common.Define;
   
   public class FunctionEditingView extends UIComponent 
   {
      public var mBackgroundLayer:Sprite;
      public var mFriendLinksLayer:Sprite;
      public var mForegroundLayer:Sprite;
      
      public function FunctionEditingView ()
      {
      }
      
   }
}