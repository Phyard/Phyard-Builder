
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import common.Define;
   
   public class SubEntityDistanceAnchor extends SubEntityJointAnchor 
   {
      private var mRadius:Number = 3;
      
      public function SubEntityDistanceAnchor (container:Scene, mainEntity:Entity, anchorIndex:int)
      {
         super (container, mainEntity, anchorIndex);
         
         UpdateAppearance ();
      }
      
      override public function GetTypeName ():String
      {
         return "Distance Anchor";
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
         
         //GraphicsUtil.ClearAndDrawEllipse (this, - mRadius, - mRadius, mRadius + mRadius, mRadius + mRadius, borderColor, borderSize, true, filledColor);
         GraphicsUtil.ClearAndDrawCircle (this, 0, 0, mRadius, borderColor, borderSize, true, filledColor);
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
      
      
   }
}
