
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.EntityContainer;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   public class EntityJointDummy extends EntityJoint 
   {
      public var mAnchor1:SubEntityDummyAnchor;
      public var mAnchor2:SubEntityDummyAnchor;
      
      public function EntityJointDummy (container:EntityContainer)
      {
         super (container);
         
         mAnchor1 = new SubEntityDummyAnchor (container, this, 0);
         mEntityContainer.addChild (mAnchor1);
         mAnchor2 = new SubEntityDummyAnchor (container, this, 1);
         mEntityContainer.addChild (mAnchor2);
         
         mCollideConnected = true;
         
         SetVisible (false);
         mAnchor1.SetVisible (false);
         mAnchor2.SetVisible (false);
      }
      
      override public function GetTypeName ():String
      {
         return "Dummy Joint";
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
         
         var numSegments:int = length / 5.0;
         if ( (numSegments & 1) == 0)
            numSegments += 1;
         
         var segmentLength:Number = length / Number (numSegments);
         
         GraphicsUtil.Clear (this);
         
         var xt:Number = - length * 0.5;
         
         for (var i:int = 0; i < numSegments; ++ i)
         {
            if ( (i & 1) ==0)
            {
               GraphicsUtil.DrawLine (this, xt, 0, xt + segmentLength, 0);
            }
            
            xt += segmentLength;
         }
      }
      
      public function GetAnchor1 ():SubEntityDummyAnchor
      {
         return mAnchor1;
      }
      
      public function GetAnchor2 ():SubEntityDummyAnchor
      {
         return mAnchor2;
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityJointDummy (mEntityContainer);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, 0, 0);
         
         var dummyJoint:EntityJointDummy = entity as EntityJointDummy;
         
         var anchor1:SubEntityDummyAnchor = GetAnchor1 ();
         var anchor2:SubEntityDummyAnchor = GetAnchor2 ();
         var newAnchor1:SubEntityDummyAnchor = dummyJoint.GetAnchor1 ();
         var newAnchor2:SubEntityDummyAnchor = dummyJoint.GetAnchor2 ();
         
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
