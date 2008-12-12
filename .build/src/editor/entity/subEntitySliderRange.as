
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   public class SubEntitySliderRangeEndPoint extends SubEntity 
   {
      private var mHalfHeight:Number = 3;
      
      public function SubEntitySliderRange (world:World, mainEntity:Entity)
      {
         super (world, mainEntity);
         
         UpdateAppearance ();
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
         GraphicsUtil.DrawLine (this, -3, -3, 3,  3);
         GraphicsUtil.DrawLine (this, -3,  3, 3, -3);
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
      
      override public function Move (offsetX:Number, offsetY:Number):void
      {
         super.Move (offsetX, offsetY);
         
         GetMainEntity ().UpdateAppearance ();
      }
      
      
      
   }
}


