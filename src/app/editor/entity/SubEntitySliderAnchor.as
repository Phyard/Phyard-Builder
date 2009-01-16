
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   public class SubEntitySliderAnchor extends SubEntityJointAnchor 
   {
      private var mRadius:Number = 5;
      
      private var mIsSecondAnchor:Boolean;
      
      public function SubEntitySliderAnchor (world:World, mainEntity:Entity, isSecond:Boolean)
      {
         super (world, mainEntity);
         
         mIsSecondAnchor = isSecond;
         
         UpdateAppearance ();
      }
      
      override public function GetTypeName ():String
      {
         return "Slider Joint Anchor";
      }
      
      override public function GetInfoText ():String
      {
         return "x: " + GetPositionX () + ", y = " + GetPositionY ();
      }
      
      override public function UpdateAppearance ():void
      {
         var borderColor:uint;
         var borderSize :int;
         var filledColor:uint = 0xFFFFFF;
         
         if ( IsSelected () )
         {
            borderColor = EditorSetting.BorderColorSelectedObject;
            borderSize  = 3;
         }
         else
         {
            borderColor = 0x0;
            borderSize  = 1;
         }
         
         alpha = 0.7;
         
         GraphicsUtil.ClearAndDrawEllipse (this, - mRadius, - mRadius, mRadius + mRadius, mRadius + mRadius, borderColor, borderSize, true, filledColor);
         GraphicsUtil.DrawLine (this, - 3, - 3, 3, 3);
         GraphicsUtil.DrawLine (this, - 3,  3, 3, -3);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mWorld.mSelectionEngine.CreateProxyCircle ();
            mSelectionProxy.SetUserData (this);
         }
         
         (mSelectionProxy as SelectionProxyCircle).RebuildCircle ( GetRotation (), GetPositionX (), GetPositionY (), mRadius );
      }
      
      override public function NotifySelectedChanged (selected:Boolean):void
      {
         super.NotifySelectedChanged (selected);
         
         //if (mIsSecondAnchor)
         //   GetMainEntity ().SetVertexControllersVisible (selected);
      }
      
      override public function SetVertexControllersVisible (visible:Boolean):void
      {
         super.SetVertexControllersVisible (visible);
         
         GetMainEntity ().SetVertexControllersVisible (visible);
      }
      
   }
}
