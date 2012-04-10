
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.EntityContainer;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import common.Define;
   
   public class SubEntitySliderAnchor extends SubEntityJointAnchor 
   {
      private var mRadius:Number = 5;
      
      public function SubEntitySliderAnchor (container:EntityContainer, mainEntity:Entity, anchorIndex:int)
      {
         super (container, mainEntity, anchorIndex);
         
         UpdateAppearance ();
      }
      
      override public function GetTypeName ():String
      {
         return "Slider Anchor";
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
         GraphicsUtil.DrawLine (this, - 3, - 3, 3, 3);
         GraphicsUtil.DrawLine (this, - 3,  3, 3, -3);
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
      
      override public function NotifySelectedChanged (selected:Boolean):void
      {
         super.NotifySelectedChanged (selected);
      }
      
      override public function SetInternalComponentsVisible (visible:Boolean):void
      {
         super.SetInternalComponentsVisible (visible);
         
         GetMainEntity ().SetInternalComponentsVisible (visible);
      }
      
   }
}
