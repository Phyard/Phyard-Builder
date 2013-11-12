
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
   
   public class EntityAction extends EntityCodeSnippetHolder
   {
      public function EntityAction (container:Scene)
      {
         super (container);
         
         mCodeSnippet = new CodeSnippet (new FunctionDefinition (/*EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine (), */World.GetVoidFunctionDeclaration ()));
         mIconBitmap = new Resource.IconTriggerAction ();
         mBackgroundColor = 0xFFA0A0;
      }
      
      override public function ValidateEntityLinks ():void
      {
         //mCodeSnippet.ValidateValueSourcesAndTargets ();
         super.ValidateEntityLinks ();
      }
      
      override public function GetTypeName ():String
      {
         return "Action";
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityAction (mEntityContainer);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var action:EntityAction = entity as EntityAction;
      }
      
   }
}
