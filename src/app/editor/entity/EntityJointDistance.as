
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   
   
   public class EntityJointDistance extends EntityJoint 
   {  
      public var mAnchor1:SubEntityDistanceAnchor;
      public var mAnchor2:SubEntityDistanceAnchor;
      
      protected var mBreakDeltaLength:Number = 0.00005;
      
      public function EntityJointDistance (container:Scene)
      {
         super (container);
         
         mAnchor1 = new SubEntityDistanceAnchor (container, this, 0);
         mEntityContainer.addChild (mAnchor1);
         mAnchor2 = new SubEntityDistanceAnchor (container, this, 1);
         mEntityContainer.addChild (mAnchor2);
         
         mCollideConnected = true;
      }
      
      override public function GetTypeName ():String
      {
         return "Distance Joint";
      }
      
      override public function Destroy ():void
      {
         mEntityContainer.DestroyAsset (mAnchor1);
         mEntityContainer.DestroyAsset (mAnchor2);
         
         super.Destroy ();
      }
      
      override public function UpdateJointPosition ():void
      {
         SetPosition (0.5 * (mAnchor1.x + mAnchor2.x), 0.5 * (mAnchor1.y + mAnchor2.y));
         SetRotation (Math.atan2 (mAnchor2.y - mAnchor1.y, mAnchor2.x - mAnchor1.x));
      }
      
      override public function UpdateAppearance ():void
      {
         var x1:Number = mAnchor1.x - x;
         var y1:Number = mAnchor1.y - y;
         var x2:Number = mAnchor2.x - x;
         var y2:Number = mAnchor2.y - y;
         
         var dx:Number = x2 - x1;
         var dy:Number = y2 - y1;
         
         var length:Number = Math.sqrt (dx * dx + dy * dy);
         
         GraphicsUtil.ClearAndDrawLine (this, - 0.5 * length, 0, 0.5 * length, 0);
      }
      
      public function GetAnchor1 ():SubEntityDistanceAnchor
      {
         return mAnchor1;
      }
      
      public function GetAnchor2 ():SubEntityDistanceAnchor
      {
         return mAnchor2;
      }
      
      public function SetBreakDeltaLength (dLength:Number):void
      {
         mBreakDeltaLength = dLength;
      }
      
      public function GetBreakDeltaLength ():Number
      {
         return mBreakDeltaLength;
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityJointDistance (mEntityContainer);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, 0, 0);
         
         var distanceJoint:EntityJointDistance = entity as EntityJointDistance;
         
         distanceJoint.SetBreakDeltaLength (GetBreakDeltaLength ());
         
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
      }
      
      override public function GetSubAssets ():Array
      {
         return [mAnchor1, mAnchor2];
      }
      
      
      
   }
}
