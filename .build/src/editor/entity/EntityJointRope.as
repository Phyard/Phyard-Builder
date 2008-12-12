
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   public class EntityJointRope extends Entity 
   {
      
      public var mAnchor1:SubEntityRopeAnchor;
      public var mAnchor2:SubEntityRopeAnchor;
      
      public function EntityJointRope (world:World)
      {
         super (world);
         
         mAnchor1 = new SubEntityRopeAnchor (world, this);
         world.addChild (mAnchor1);
         mAnchor2 = new SubEntityRopeAnchor (world, this);
         world.addChild (mAnchor2);
      }
      
      override public function Destroy ():void
      {
         mWorld.DestroyEntity (mAnchor1);
         mWorld.DestroyEntity (mAnchor1);
         
         super.Destroy ();
      }
      
      override public function UpdateAppearance ():void
      {
         alpha = 0.7;
         
         var x1:Number = mAnchor1.x;
         var y1:Number = mAnchor1.y;
         var x2:Number = mAnchor2.x;
         var y2:Number = mAnchor2.y;
         
         GraphicsUtil.ClearAndDrawLine (this, x1, y1, x2, y2);
      }
      
      public function GetAnchor1 ():SubEntityRopeAnchor
      {
         return mAnchor1;
      }
      
      public function GetAnchor2 ():SubEntityRopeAnchor
      {
         return mAnchor2;
      }
      
      
      
   }
}
