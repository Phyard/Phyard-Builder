
package editor.trigger.entity {
   
   import flash.display.Sprite;
   import flash.display.Bitmap;
   
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import editor.entity.Scene;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyCircle;
   
   import editor.entity.Entity;
   
   
   
   import common.Define;
   
   public class InputEntityAssigner_Many extends InputEntityAssigner 
   {
      public static function ValidateLinkedEntities (entities:Array):void
      {
         EntityLogic.ValidateLinkedEntities (entities);
      }
      
//=================================================================================================
//   
//=================================================================================================
      
      protected var mManyEntities:Array = new Array ();
      
      public function InputEntityAssigner_Many (container:Scene, ownerEntity:Entity, inputId:int = 0, selectorId:int = 0, onSelectEntity:Function = null, onClearEntities:Function = null)
      {
         super (container, ownerEntity, inputId, selectorId, onSelectEntity, onClearEntities);
      }
      
      override public function UpdateAppearance ():void
      {
         super.UpdateAppearance ();
         
         var text_field:Bitmap;
         text_field = DisplayObjectUtil.CreateCacheDisplayObject (TextFieldEx.CreateTextField ("<font face='Verdana' size='8'>m</font>", false, 0xFFFFFF, 0x0));
         
         text_field.scaleX = 1.0 / mEntityContainer.GetZoomScale ();
         text_field.scaleY = 1.0 / mEntityContainer.GetZoomScale ();
         
         addChild (text_field);
         
         text_field.x = - 0.5 * text_field.width;
         text_field.y = - 0.5 * text_field.height;
      }
      
      override internal function SupportContextMenu ():Boolean
      {
         return true;
      }
      
      override internal function GetClearMenuText ():String
      {
         return "Break Link(s)";
      }
      
      override internal function GetAppendSelectedsMenuText ():String
      {
         return "Link Selected(s)";
      }
      
      override protected function LinkSelectedEntities ():void
      {
         var entities:Array = mEntityContainer.GetSelectedAssets ();
         var entity:Entity;
         
         var mainEntities:Array = new Array ();
         var mainEntity:Entity;
         
         for each (entity in entities)
         {
            mainEntity = entity.GetMainAsset () as Entity;
            if (mainEntities.indexOf (mainEntity) < 0)
            {
               mainEntities.push (mainEntity);
            }
         }
         
         for each (mainEntity in mainEntities)
         {
            LinkEntity (mainEntity);
         }
      }
      
//====================================================================
//   entity links
//====================================================================
      
      public function DrawLinks (canvasSprite:Sprite, entityArray:Array):void
      {
         if (entityArray == null)
            return;
         
         var entity:Entity;
         var point:Point;
         
         for (var i:int = 0; i < entityArray.length; ++ i)
         {
            entity = entityArray [i] as Entity;
            
            if (entity != null)
            {
               point = GetWorldPosition ();
               GraphicsUtil.DrawLine (canvasSprite, point.x, point.y, entity.GetLinkPointX (), entity.GetLinkPointY (), GetOwnerEntity ().GetAssetManager ().GetLinkLineColor (), 0);
            }
         }
      }
      
      
   }
}
