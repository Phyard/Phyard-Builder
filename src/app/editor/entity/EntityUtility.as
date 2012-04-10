
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.EntityContainer;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   
   
   import common.Define;
   
   public class EntityUtility extends Entity 
   {
      public function EntityUtility (container:EntityContainer)
      {
         super (container);
      }
      
      override public function IsUtilityEntity ():Boolean
      {
         return true;
      }
      
   }
}
