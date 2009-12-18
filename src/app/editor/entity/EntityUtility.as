
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   
   
   import common.Define;
   
   public class EntityUtility extends WorldEntity 
   {
      public function EntityUtility (world:World)
      {
         super (world);
      }
      
      override public function IsUtilityEntity ():Boolean
      {
         return true;
      }
      
   }
}
