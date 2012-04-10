
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.EntityContainer;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   
   
   import common.Define;
   import common.ValueAdjuster;
   import common.Config;
   
   public class EntityJointWeld extends EntityJoint 
   {
      public var mAnchor:SubEntityWeldAnchor;
      
      public function EntityJointWeld (container:EntityContainer)
      {
         super (container);
         
         mAnchor = new SubEntityWeldAnchor (container, this);
         mEntityContainer.addChild (mAnchor);
      }
      
      override public function GetTypeName ():String
      {
         return "Weld Joint";
      }
      
      override public function Destroy ():void
      {
         mEntityContainer.DestroyEntity (mAnchor);
         
         super.Destroy ();
      }
      
      override public function UpdateJointPosition ():void
      {
         SetPosition (mAnchor.x, mAnchor.y);
         SetRotation (0.0);
      }
      
      public function GetAnchor ():SubEntityWeldAnchor
      {
         return mAnchor;
      }
      
//====================================================================
//   flip
//====================================================================
      
      override public function FlipSelfHorizontally ():void
      {
         //super.FlipSelfHorizontally ();
      }
      
      override public function FlipSelfVertically ():void
      {
         //super.FlipSelfVertically ();
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityJointWeld (mEntityContainer);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, 0, 0);
         
         var weld:EntityJointWeld = entity as EntityJointWeld;
         
         var anchor:SubEntityWeldAnchor = GetAnchor ();
         var newAnchor:SubEntityWeldAnchor = weld.GetAnchor ();
         
         anchor.SetPropertiesForClonedEntity (newAnchor, displayOffsetX, displayOffsetY);
         
         newAnchor.UpdateAppearance ();
         newAnchor.UpdateSelectionProxy ();
      }
      
      override public function GetSubEntities ():Array
      {
         return [mAnchor];
      }
      
      
   }
}
