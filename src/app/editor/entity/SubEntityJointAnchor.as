
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   public class SubEntityJointAnchor extends SubEntity 
   {
      
      public function SubEntityJointAnchor (world:World, mainEntity:Entity)
      {
         super (world, mainEntity);
      }
      
      override public function Move (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean = true):void
      {
         super.Move (offsetX, offsetY, updateSelectionProxy);
         
         GetMainEntity ().UpdateAppearance ();
      }
      
      override public function Rotate (centerX:Number, centerY:Number, dRadians:Number, updateSelectionProxy:Boolean = true):void
      {
         super.Rotate (centerX, centerY, dRadians, updateSelectionProxy);
         
         GetMainEntity ().UpdateAppearance ();
      }
      
      override public function Scale (centerX:Number, centerY:Number, ratio:Number, updateSelectionProxy:Boolean = true):void
      {
         super.Scale (centerX, centerY, ratio, updateSelectionProxy);
         
         GetMainEntity ().UpdateAppearance ();
      }
      
      
      override public function FlipHorizontally (mirrorX:Number):void
      {
         super.FlipHorizontally (mirrorX);
         
         GetMainEntity ().UpdateAppearance ();
      }
      
      override public function FlipVertically (mirrorY:Number):void
      {
         super.FlipVertically (mirrorY);
         
         GetMainEntity ().UpdateAppearance ();
      }
      
      
      
      
   }
}
