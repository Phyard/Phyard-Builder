
package editor.trigger.entity {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import editor.entity.Scene;
   import editor.entity.Entity;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.Resource;
   
   import editor.trigger.FunctionDefinition;
   import editor.trigger.CodeSnippet;
   
   import common.Define;
   
   import common.trigger.ValueDefine;
   
   public class EntityInputEntityRegionSelector extends EntityIconInsider implements IEntitySelector 
   {
      public function EntityInputEntityRegionSelector (container:Scene)
      {
         super (container);
         
         mIconBitmap = new Resource.IconInputEntityRegionSelector ();
         mBackgroundColor = 0xFFC000;
      }
      
      override public function ValidateEntityLinks ():void
      {
      }
      
      override public function GetTypeName ():String
      {
         return "Entity Region Selector";
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityInputEntityRegionSelector (mEntityContainer);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var entityFilter:EntityInputEntityRegionSelector = entity as EntityInputEntityRegionSelector;
      }
      
//====================================================================
//   as IEntitySelector
//====================================================================
      
      public function IsPairSelector ():Boolean
      {
         return false;
      }
      
//====================================================================
//   linkable
//====================================================================
      
   }
}
