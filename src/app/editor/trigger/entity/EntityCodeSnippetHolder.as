
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
   
   import editor.trigger.FunctionDefinition;
   import editor.trigger.CodeSnippet;
   
   
   
   import common.Define;
   
   public class EntityCodeSnippetHolder extends EntityIconInsider 
   {
      protected var mCodeSnippet:CodeSnippet;
      
      public function EntityCodeSnippetHolder (container:Scene)
      {
         super (container);
         
         // child class must create a valid CodeSnippet
         //mCodeSnippet = new CodeSnippet (new FunctionDefinition ());
      }
      
      public function GetCodeSnippetName ():String
      {
         return mCodeSnippet.GetName ();
      }
      
      public function SetCodeSnippetName (name:String):void
      {
         mCodeSnippet.SetName (name);
      }
      
      public function GetCodeSnippet ():CodeSnippet
      {
         return mCodeSnippet;
      }
      
      override public function ValidateEntityLinks ():void
      {
         mCodeSnippet.ValidateValueSourcesAndTargets ();
      }
      
//====================================================================
//   clone
//====================================================================
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var codeSnippetHolder:EntityCodeSnippetHolder = entity as EntityCodeSnippetHolder;
         
         codeSnippetHolder.GetCodeSnippet ().CopyCallingsFrom (mEntityContainer, true, mCodeSnippet);
      }
      
   }
}
