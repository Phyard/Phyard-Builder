
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   public class EntityJointHinge extends Entity 
   {
      
      public var mAnchor:SubEntityHingeAnchor;
      
      public function EntityJointHinge (world:World)
      {
         super (world);
         
         mAnchor = new SubEntityHingeAnchor (world, this);
         world.addChild (mAnchor);
      }
      
      override public function Destroy ():void
      {
         mWorld.DestroyEntity (mAnchor);
         
         super.Destroy ();
      }
      
      public function GetAnchor ():SubEntityHingeAnchor
      {
         return mAnchor;
      }
      
      
      
   }
}
