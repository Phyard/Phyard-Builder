
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
   
   
   
   public class InputEntitySelector_Single extends InputEntitySelector 
   {
      
      public static function ValidateSingleEntity (entities:Array):void
      {
         var entity:Entity = entities [0];
         
         if (entity == null || entity.GetCreationOrderId () < 0)
         {
            entities.length = 0;
         }
         else
         {
            entities.length = 1;
         }
      }
      
      public static function ValidateLinkedEntities (entities1:Array, entities2:Array):void
      {
         if (entities1.length < entities2.length)
            entities1.length = entities2.length;
         else if (entities1.length > entities2.length)
            entities2.length = entities1.length;
         
         var invalid1:Boolean;
         var invalid2:Boolean;
         var entity1:Entity;
         var entity2:Entity;
         
         var length:int = entities1.length;
         
         //var someRemoved:Boolean = false;
         for (var i:int = 0; i < length; ++ i)
         {
            entity1 = entities1 [i] as Entity;
            entity2 = entities2 [i] as Entity;
            
            invalid1 = (entity1 == null || entity1.GetCreationOrderId () < 0);
            invalid2 = (entity2 == null || entity2.GetCreationOrderId () < 0);
            
            if ( invalid1 ) entities1 [i] = null;
            if ( invalid2 ) entities2 [i] = null;
            
            if (invalid1 && invalid2)
            {
               entities1.splice (i, 1);
               entities2.splice (i, 1);
               //someRemoved = true;
            }
         }
         
         //return someRemoved;
      }
      
      override internal function SupportContextMenu ():Boolean
      {
         return true;
      }
      
      override internal function GetClearMenuText ():String
      {
         return "Break Link";
      }
      
      override internal function GetAppendSelectedsMenuText ():String
      {
         return "Link The Selected";
      }
      
      override protected function LinkSelectedEntities ():void
      {
         var entities:Array = mEntityContainer.GetSelectedAssets ();
         var entity:Entity;
         var mainEntity:Entity;
         
         for each (entity in entities)
         {
            mainEntity = entity.GetMainAsset () as Entity;
            if (LinkEntity (mainEntity))
               break;
         }
      }
      
//=================================================================================================
//   
//=================================================================================================
      
      protected var mTheSingleEntity:Entity = null;
      
      public function InputEntitySelector_Single (container:Scene, ownerEntity:Entity, inputId:int = 0, selectorId:int = 0, onSelectEntity:Function = null, onClearEntities:Function = null)
      {
         super (container, ownerEntity, inputId, selectorId, onSelectEntity, onClearEntities);
      }
      
      override public function UpdateAppearance ():void
      {
         super.UpdateAppearance ();
         
         var text_field:Bitmap;
         text_field = DisplayObjectUtil.CreateCacheDisplayObject (TextFieldEx.CreateTextField ("<font face='Verdana' size='8'>1</font>", false, 0xFFFFFF, 0x0));
         
         text_field.scaleX = 1.0 / mEntityContainer.GetZoomScale ();
         text_field.scaleY = 1.0 / mEntityContainer.GetZoomScale ();
         
         addChild (text_field);
         
         text_field.x = - 0.5 * text_field.width;
         text_field.y = - 0.5 * text_field.height;
      }
      
//====================================================================
//   entity links
//====================================================================
      
      public function DrawLink (canvasSprite:Sprite, entity:Entity):void
      {
         if (entity == null)
            return;
         
         var point:Point = GetWorldPosition ();
         GraphicsUtil.DrawLine (canvasSprite, point.x, point.y, entity.GetLinkPointX (), entity.GetLinkPointY (), 0x0, 0);
      }
      
      
      
   }
}
