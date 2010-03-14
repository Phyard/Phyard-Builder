
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
   
   import editor.world.World;
   import editor.entity.Entity;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.runtime.Resource;
   
   import editor.trigger.FunctionDefinition;
   import editor.trigger.CodeSnippet;
   import editor.trigger.TriggerEngine;
   
   import common.Define;
   
   import common.trigger.ValueDefine;
   
   public class EntityInputEntityRegionSelector extends EntityIconInsider implements IEntityLimiter 
   {
      public function EntityInputEntityRegionSelector (world:World)
      {
         super (world);
         
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
         return new EntityInputEntityRegionSelector (mWorld);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var entityFilter:EntityInputEntityRegionSelector = entity as EntityInputEntityRegionSelector;
      }
      
//====================================================================
//   as IEntityLimiter
//====================================================================
      
      public function IsPairLimiter ():Boolean
      {
         return false;
      }
      
//====================================================================
//   linkable
//====================================================================
      
   }
}
