
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import common.Define;
   
   public class SubEntityJointAnchor extends WorldSubEntity 
   {
      public function SubEntityJointAnchor (world:World, mainEntity:Entity, anchorIndex:int)
      {
         super (world, mainEntity, anchorIndex);
      }
      
      public function GetAnchorIndex ():int
      {
         //return mAnchorIndex;
         return GetSubIndex ();
      }
      
      override public function Move (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean = true):void
      {
         super.Move (offsetX, offsetY, updateSelectionProxy);
         
         (GetMainEntity () as EntityJoint).NotifyAnchorPositionChanged ();
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
      
      
      override public function FlipHorizontally (mirrorX:Number, updateSelectionProxy:Boolean = true):void
      {
         super.FlipHorizontally (mirrorX, updateSelectionProxy);
         
         GetMainEntity ().UpdateAppearance ();
      }
      
      override public function FlipVertically (mirrorY:Number, updateSelectionProxy:Boolean = true):void
      {
         super.FlipVertically (mirrorY, updateSelectionProxy);
         
         GetMainEntity ().UpdateAppearance ();
      }
      
      
      
   }
}
