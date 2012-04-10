
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
   
   import editor.world.EntityContainer;
   import editor.entity.Entity;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.Resource;
   
   import editor.trigger.FunctionDefinition;
   import editor.trigger.CodeSnippet;
   import editor.trigger.TriggerEngine;
   
   import editor.EditorContext;
   
   import common.Define;
   
   import common.trigger.ValueDefine;
   
   public class EntityInputEntityPairScriptFilter extends EntityCodeSnippetHolder implements IEntityLimiter 
   {
      public function EntityInputEntityPairScriptFilter (container:EntityContainer)
      {
         super (container);
         
         mCodeSnippet = new CodeSnippet (new FunctionDefinition (EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine (),TriggerEngine.GetEntityPairFilterFunctionDeclaration ()));
         mIconBitmap = new Resource.IconInputEntityPairScriptFilter ();
         mBackgroundColor = 0xFFC000;
      }
      
      override public function ValidateEntityLinks ():void
      {
         super.ValidateEntityLinks ();
      }
      
      override public function GetTypeName ():String
      {
         return "Entity Pair Filter";
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityInputEntityPairScriptFilter (mEntityContainer);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var entityFilter:EntityInputEntityPairScriptFilter = entity as EntityInputEntityPairScriptFilter;
      }
      
//====================================================================
//   as IEntityLimiter
//====================================================================
      
      public function IsPairLimiter ():Boolean
      {
         return true;
      }
      
//====================================================================
//   linkable
//====================================================================
      
   }
}
