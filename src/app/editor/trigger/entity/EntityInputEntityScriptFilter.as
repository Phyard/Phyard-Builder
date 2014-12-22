
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
   
   import editor.entity.Scene;
   import editor.entity.Entity;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.Resource;
   
   import editor.trigger.FunctionDefinition;
   import editor.trigger.CodeSnippet;
   
   import editor.EditorContext;
   
   import common.Define;
   
   import common.trigger.ValueDefine;
   
   public class EntityInputEntityScriptFilter extends EntityCodeSnippetHolder implements IEntitySelector 
   {
      public function EntityInputEntityScriptFilter (container:Scene)
      {
         super (container);
         
         mCodeSnippet = new CodeSnippet (new FunctionDefinition (/*EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine (), */World.GetEntityFilterFunctionDeclaration ()));
         mIconBitmap = new Resource.IconInputEntityScriptFilter ();
         mBackgroundColor = 0xFFC000;
      }
      
      override public function ValidateEntityLinks ():void
      {
         //mCodeSnippet.ValidateValueSourcesAndTargets ();
         super.ValidateEntityLinks ();
      }
      
      override public function GetTypeName ():String
      {
         return "Entity Filter";
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityInputEntityScriptFilter (mEntityContainer);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var entityFilter:EntityInputEntityScriptFilter = entity as EntityInputEntityScriptFilter;
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
