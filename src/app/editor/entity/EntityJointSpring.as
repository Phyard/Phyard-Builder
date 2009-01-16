
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   import common.Define;
   
   public class EntityJointSpring extends EntityJoint 
   {
      
      public var mAnchor1:SubEntitySpringAnchor;
      public var mAnchor2:SubEntitySpringAnchor;
      
      private var mStaticLengthRatio:Number = 1;
      private var mFrequencyHz:Number = 1;
      public var mDampingRatio:Number = 0;
      
      public function EntityJointSpring (world:World)
      {
         super (world);
         
         mAnchor1 = new SubEntitySpringAnchor (world, this);
         world.addChild (mAnchor1);
         mAnchor2 = new SubEntitySpringAnchor (world, this);
         world.addChild (mAnchor2);
         
         mCollideConnected = true;
      }
      
      override public function Destroy ():void
      {
         mWorld.DestroyEntity (mAnchor1);
         mWorld.DestroyEntity (mAnchor2);
         
         super.Destroy ();
      }
      
      public function  SetStaticLengthRatio (ratio:Number):void
      {
         mStaticLengthRatio = ratio > 0 ? ratio : 0;
         
         UpdateAppearance ();
      }
      
      public function GetStaticLengthRatio ():Number
      {
         return mStaticLengthRatio;
      }
      
      public function SetFrequencyHz (fHz:Number):void
      {
         mFrequencyHz = fHz > 0 ? fHz : 0;
         
         UpdateAppearance ();
      }
      
      public function GetCurrentLength ():Number
      {
         var dx:Number = mAnchor2.x - mAnchor1.x;
         var dy:Number = mAnchor2.y - mAnchor1.y;
         
         return Math.sqrt (dx * dx + dy * dy);
      }
      
      public function GetFrequencyHz ():Number
      {
         return mFrequencyHz;
      }
      
      override public function UpdateAppearance ():void
      {
         alpha = 0.7;
         
         var x1:Number = mAnchor1.x;
         var y1:Number = mAnchor1.y;
         var x2:Number = mAnchor2.x;
         var y2:Number = mAnchor2.y;
         
         var dx:Number = x2 - x1;
         var dy:Number = y2 - y1;
         var length:Number = Math.sqrt (dx * dx + dy * dy);
         
         var stepLen:Number = Define.SpringSegmentLength;
         if (mStaticLengthRatio < 0.5)
            stepLen *= 2;
         else if (mStaticLengthRatio > 2)
            stepLen /= 2;
         else
            stepLen /= mStaticLengthRatio 
         
         var thickness:Number = 3;
         
         var startLen:Number = 0;
         var endLen:Number = stepLen;
         var segmentId:int = 0;
         
         graphics.clear ();
         
         if (length > 0)
         {
            while (startLen < length)
            {
               if (endLen > length)
                  endLen = length;
               
               var startX:Number = x1 + startLen * dx / length;
               var startY:Number = y1 + startLen * dy / length;
               var endX:Number = x1 + endLen * dx / length;
               var endY:Number = y1 + endLen * dy / length;
               
               GraphicsUtil.DrawLine (this, startX, startY, endX, endY, (segmentId & 1) == 0 ? 0x000000 : 0x808080, thickness);
               
               ++ segmentId;
               startLen += stepLen;
               endLen += stepLen;
            }
         }
      }
      
      public function GetAnchor1 ():SubEntitySpringAnchor
      {
         return mAnchor1;
      }
      
      public function GetAnchor2 ():SubEntitySpringAnchor
      {
         return mAnchor2;
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityJointSpring (mWorld);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, 0, 0);
         
         var spring:EntityJointSpring = entity as EntityJointSpring;
         
         spring.SetStaticLengthRatio ( GetStaticLengthRatio () );
         spring.SetFrequencyHz ( GetFrequencyHz () );
         spring.mDampingRatio = mDampingRatio;
         
         var anchor1:SubEntitySpringAnchor = GetAnchor1 ();
         var anchor2:SubEntitySpringAnchor = GetAnchor2 ();
         var newAnchor1:SubEntitySpringAnchor = spring.GetAnchor1 ();
         var newAnchor2:SubEntitySpringAnchor = spring.GetAnchor2 ();
         
         anchor1.SetPropertiesForClonedEntity (newAnchor1, displayOffsetX, displayOffsetY);
         anchor2.SetPropertiesForClonedEntity (newAnchor2, displayOffsetX, displayOffsetY);
         
         newAnchor1.UpdateAppearance ();
         newAnchor1.UpdateSelectionProxy ();
         newAnchor2.UpdateAppearance ();
         newAnchor2.UpdateSelectionProxy ();
         
         spring.UpdateAppearance ();
      }
      
      override public function GetSubEntities ():Array
      {
         return [mAnchor1, mAnchor2];
      }
      
      
      
   }
}
