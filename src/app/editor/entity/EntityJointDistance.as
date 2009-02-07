
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   public class EntityJointDistance extends EntityJoint 
   {
      
      public var mAnchor1:SubEntityDistanceAnchor;
      public var mAnchor2:SubEntityDistanceAnchor;
      
      public function EntityJointDistance (world:World)
      {
         super (world);
         
         mAnchor1 = new SubEntityDistanceAnchor (world, this, 0);
         world.addChild (mAnchor1);
         mAnchor2 = new SubEntityDistanceAnchor (world, this, 1);
         world.addChild (mAnchor2);
         
         mCollideConnected = true;
      }
      
      override public function Destroy ():void
      {
         mWorld.DestroyEntity (mAnchor1);
         mWorld.DestroyEntity (mAnchor2);
         
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
      
      public function GetAnchor1 ():SubEntityDistanceAnchor
      {
         return mAnchor1;
      }
      
      public function GetAnchor2 ():SubEntityDistanceAnchor
      {
         return mAnchor2;
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityJointDistance (mWorld);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, 0, 0);
         
         var distanceJoint:EntityJointDistance = entity as EntityJointDistance;
         
         var anchor1:SubEntityDistanceAnchor = GetAnchor1 ();
         var anchor2:SubEntityDistanceAnchor = GetAnchor2 ();
         var newAnchor1:SubEntityDistanceAnchor = distanceJoint.GetAnchor1 ();
         var newAnchor2:SubEntityDistanceAnchor = distanceJoint.GetAnchor2 ();
         
         anchor1.SetPropertiesForClonedEntity (newAnchor1, displayOffsetX, displayOffsetY);
         anchor2.SetPropertiesForClonedEntity (newAnchor2, displayOffsetX, displayOffsetY);
         
         newAnchor1.UpdateAppearance ();
         newAnchor1.UpdateSelectionProxy ();
         newAnchor2.UpdateAppearance ();
         newAnchor2.UpdateSelectionProxy ();
         
         distanceJoint.UpdateAppearance ();
      }
      
      override public function GetSubEntities ():Array
      {
         return [mAnchor1, mAnchor2];
      }
      
      
      
   }
}
