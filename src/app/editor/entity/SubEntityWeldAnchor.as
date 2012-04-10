
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.EntityContainer;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import common.Define;
   
   public class SubEntityWeldAnchor extends SubEntityJointAnchor 
   {
      private var mRadius:Number = 5;
      
      public function SubEntityWeldAnchor (container:EntityContainer, mainEntity:Entity)
      {
         super (container, mainEntity, 0);
         
         UpdateAppearance ();
      }
      
      override public function GetTypeName ():String
      {
         return "Weld Anchor";
      }
      
      override public function UpdateAppearance ():void
      {
         var borderColor:uint;
         var borderSize :int;
         var filledColor:uint = 0xFFFFFF;
         
         if ( IsSelected () )
         {
            borderColor = Define.BorderColorSelectedObject;
            borderSize  = 3;
         }
         else
         {
            borderColor = 0x0;
            borderSize  = 1;
         }
         
         GraphicsUtil.ClearAndDrawEllipse (this, - mRadius, - mRadius, mRadius + mRadius, mRadius + mRadius, borderColor, borderSize, true, filledColor);
         var xy:Number = mRadius * Math.cos (Math.PI / 4.0);
         GraphicsUtil.DrawLine (this, - xy, - xy,   xy, xy, 0x0, 1);
         GraphicsUtil.DrawLine (this, - xy,   xy, xy, -xy, 0x0, 1);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mEntityContainer.mSelectionEngine.CreateProxyCircle ();
            mSelectionProxy.SetUserData (this);
         }
         
         (mSelectionProxy as SelectionProxyCircle).RebuildCircle (GetPositionX (), GetPositionY (), mRadius, GetRotation ());
      }
      
      
//====================================================================
//   flip
//====================================================================
      
      override public function FlipHorizontally (mirrorX:Number, updateSelectionProxy:Boolean = true):void
      {
         super.FlipHorizontally (mirrorX, updateSelectionProxy);
         
         GetMainEntity ().FlipHorizontally (mirrorX);
      }
      
      override public function FlipVertically (mirrorY:Number, updateSelectionProxy:Boolean = true):void
      {
         super.FlipVertically (mirrorY, updateSelectionProxy);
         
         GetMainEntity ().FlipVertically (mirrorY);
      }
      
   }
}
