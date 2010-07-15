
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
   
   public class EntityBasicCondition extends EntityCodeSnippetHolder implements ICondition 
   {
      public function EntityBasicCondition (world:World)
      {
         super (world);
         
         mCodeSnippet = new CodeSnippet (new FunctionDefinition (mWorld.GetTriggerEngine (), TriggerEngine.GetBoolFunctionDeclaration ()));
         mIconBitmap = new Resource.IconBasicCondition ();
         mBackgroundColor = 0xA0FFA0;
      }
      
      override public function ValidateEntityLinks ():void
      {
         //mCodeSnippet.ValidateValueSources ();
         super.ValidateEntityLinks ();
      }
      
      override public function GetTypeName ():String
      {
         return "Condition";
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityBasicCondition (mWorld);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var basicCondition:EntityBasicCondition = entity as EntityBasicCondition;
      }
      
//====================================================================
//   linkable
//====================================================================
      
//====================================================================
//   as EntityCondition
//====================================================================
      
      public function GetTargetValueByLinkZoneId (zoneId:int):int
      {
         return ValueDefine.BoolValue_True;
      }
      
      public function GetTargetValueZoneWorldCenter (targetValue:int):Point
      {
         return new Point (GetPositionX (), GetPositionY ());
      }
      
   }
}
