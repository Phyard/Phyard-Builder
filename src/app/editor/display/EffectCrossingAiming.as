package editor.display {
   
   import flash.display.Sprite;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.entity.Entity;
   
   public class EffectCrossingAiming extends EditingEffect 
   {
      private var mAimedEntity:Entity;
      private var mRadius:Number;
      
      public function EffectCrossingAiming (aimedEntity:Entity)
      {
         mAimedEntity = aimedEntity;
         
         mRadius = 60.0;
      }
      
      override public function Update ():void
      {
         if (mAimedEntity == null || mAimedEntity.parent == null || mRadius <= 0.0)
         {
            parent.removeChild (this);
            return;
         }
         
         var point:Point = DisplayObjectUtil.LocalToLocal (mAimedEntity.parent, parent, new Point (mAimedEntity.GetLinkPointX (), mAimedEntity.GetLinkPointY ()) );
         
         x = point.x;
         y = point.y;
         
         GraphicsUtil.Clear (this);
         GraphicsUtil.DrawCircle (this,0, 0, mRadius, 0x00FF00, 0);
         GraphicsUtil.DrawLine (this, -mRadius - 5, 0, mRadius + 5, 0, 0x00FF00, 0);
         GraphicsUtil.DrawLine (this, 0, -mRadius - 5, 0, mRadius + 5, 0x00FF00, 0);
         
         mRadius -= 2.0;
      }
   }
   
}