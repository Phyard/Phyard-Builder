
package editor.trigger.entity {
   
   import flash.display.Sprite;
   import flash.display.Bitmap;
   
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import editor.asset.Asset;
   
   import editor.entity.Scene;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyCircle;
   
   import editor.entity.Entity;
   
   
   
   public class InputEntityAssigner_Any extends InputEntityAssigner 
   {
      public function InputEntityAssigner_Any (container:Scene, ownerEntity:Entity)
      {
         super (container, ownerEntity);
      }
      
      override public function UpdateAppearance ():void
      {
         super.UpdateAppearance ();
         
         var text_field:Bitmap;
         text_field = DisplayObjectUtil.CreateCacheDisplayObject (TextFieldEx.CreateTextField ("<font face='Verdana' size='8'>A</font>", false, 0xFFFFFF, 0x0));
         
         text_field.scaleX = 1.0 / mEntityContainer.GetZoomScale ();
         text_field.scaleY = 1.0 / mEntityContainer.GetZoomScale ();
         
         addChild (text_field);
         
         text_field.x = - 0.5 * text_field.width;
         text_field.y = - 0.5 * text_field.height;
      }
      
//======================================================
// 
//======================================================
      
      override public function IsEntitySelectable ():Boolean
      {
         return false;
      }
      
//====================================================================
//   linkable
//====================================================================
      
      override public function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int
      {
         return -1;
      }
      
      override public function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean
      {
         return false;
      }
      
      override public function TryToCreateLink (fromManagerDisplayX:Number, fromManagerDisplayY:Number, toAsset:Asset, toManagerDisplayX:Number, toManagerDisplayY:Number):Boolean
      {
         return false;
      }
      
   }
}
