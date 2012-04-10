
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.asset.Asset;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import common.Define;
   
   public class SubEntityJointAnchor extends Entity 
   {
      protected var mMainEntity:Entity;
      
      protected var mSubIndex:int = -1;
      
      public function SubEntityJointAnchor (container:Scene, mainEntity:Entity, anchorIndex:int)
      {
         super (container);
         
         mMainEntity = mainEntity;
         
         mSubIndex = anchorIndex;
      }
      
//====================================================================
//   when clone and delete, we need the main entity
//====================================================================
      
      override public function GetMainAsset ():Asset
      {
         return mMainEntity;
      }
      
      override public function GetSubIndex ():int
      {
         return mSubIndex;
      }
      
//====================================================================
//   transform
//====================================================================
      
      override public function MoveTo (targetX:Number, targetY:Number, intentionDone:Boolean = true):void
      {
         super.MoveTo (targetX, targetY, intentionDone);
         (GetMainAsset () as EntityJoint).NotifyAnchorPositionChanged ();
      }
      
      override public function RotatePositionByCosSin (centerX:Number, centerY:Number, cos:Number, sin:Number, intentionDone:Boolean = true):void
      {
         super.RotatePositionByCosSin (centerX, centerY, cos, sin, intentionDone);
         (GetMainAsset () as EntityJoint).NotifyAnchorPositionChanged ();
      }

      override public function RotateSelf (deltaRotation:Number, intentionDone:Boolean = true):void
      {
      }
      
      override public function ScalePosition (centerX:Number, centerY:Number, s:Number, intentionDone:Boolean = true):void
      {
         super.ScalePosition (centerX, centerY, s, intentionDone);
         (GetMainAsset () as EntityJoint).NotifyAnchorPositionChanged ();
      }
      
      override public function ScaleSelfTo (targetScale:Number, intentionDone:Boolean = true):void
      {
      }
      
      override public function FlipPosition (planeX:Number, intentionDone:Boolean = true):void
      {
         super.FlipPosition (planeX, intentionDone);
         (GetMainAsset () as EntityJoint).NotifyAnchorPositionChanged ();
      }
      
      override public function FlipSelf (intentionDone:Boolean = true):void
      {
      }
      
//====================================================================
//   when clone and delete, we need the main entity
//====================================================================
      
      override public function GetVisibleAlphaForEditing ():Number
      {
         return 0.70;
      }
      
      public function GetAnchorIndex ():int
      {
         //return mAnchorIndex;
         return GetSubIndex ();
      }
      
   }
}
