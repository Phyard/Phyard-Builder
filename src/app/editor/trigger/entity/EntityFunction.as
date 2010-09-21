
package editor.trigger.entity {
   
   import flash.display.Sprite;
   import flash.geom.Point;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.util.TextUtil;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.entity.Entity;
   
   import editor.world.FunctionManager;
   
   import editor.selection.SelectionProxy;
   
   import editor.trigger.entity.Linkable;
   
   import editor.trigger.FunctionDefinition;
   import editor.trigger.CodeSnippet;
   import editor.trigger.TriggerEngine;
   import editor.trigger.FunctionDeclaration;
   import editor.trigger.FunctionDeclaration_Custom;
   
   import editor.runtime.Runtime;
   
   import common.Define;
   
   public class EntityFunction extends Entity
   {
      protected var mFunctionManager:FunctionManager;
      protected var mFunctionId:int = -1;
      
      protected var mCodeSnippet:CodeSnippet;
      protected var mFunctionDeclaration:FunctionDeclaration_Custom;
      protected var mFunctionDefinition:FunctionDefinition;
      
      private var mHalfWidth:Number;
      private var mHalfHeight:Number;
      
      private var mHalfTextWidth:Number;
      private var mHalfTextHeight:Number;
      
      protected var mContextMenuItem_BreakAllLinks:ContextMenuItem;
      
      public function EntityFunction (fm:FunctionManager)
      {
         super (fm);
         
         mFunctionManager = fm;
         
         mouseChildren = false;
         
         mFunctionDeclaration = new FunctionDeclaration_Custom (mName);
         mFunctionDefinition = new FunctionDefinition (Runtime.GetCurrentWorld ().GetTriggerEngine (), mFunctionDeclaration);
         mCodeSnippet = new CodeSnippet (mFunctionDefinition);
      }
      
      override public function Destroy ():void
      {
         mFunctionDeclaration.SetID (-1);
         mFunctionDeclaration.NotifyRemoved ();
         
         super.Destroy ();
      }
      
      public function SetFunctionIndex (functionId:int):void
      {
         mFunctionId = functionId;
         
         mFunctionDeclaration.SetID (mFunctionId);
      }
      
      public function GetFunctionIndex ():int
      {
         return mFunctionId;
      }
      
      override public function ToCodeString ():String
      {
         return "Function#" + mCreationOrderId;
      }
      
      override public function GetTypeName ():String
      {
         return "Function";
      }
      
      public function GetFunctionName ():String
      {
         return GetName ();
      }
      
      public function SetFunctionName (newName:String, checkValidity:Boolean = true):void
      {
         if (checkValidity)
         {
            mFunctionManager.ChangeFunctionName (newName, GetName ());
         }
         else
         {
            SetName (newName);
            
            mFunctionDeclaration.SetName (newName);
            mFunctionDeclaration.ParseAllCallingTextSegments ();
         }
      }
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         var ccName:String = GetName ();
         
         ccName = TextUtil.GetHtmlEscapedText (ccName);
         
         var textField:TextFieldEx = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>&lt;" + GetFunctionIndex () + "&gt; " + ccName + "</font>", false, 0xFFFFFF, 0x0);
            
         addChild (textField);
         
         textField.x = - textField.width * 0.5;
         textField.y = - textField.height * 0.5;
         
         var borderColor:uint;
         var borderSize :int;
         
         if ( IsSelected () )
         {
            borderColor = Define.BorderColorSelectedObject;
            borderSize  = 3;
         }
         else
         {
            borderColor = 0x0;
            borderSize = 1;
         }
         
         mHalfTextWidth = 0.5 * textField.width + 2;
         mHalfTextHeight = 0.5 * textField.height + 1;
         
         mHalfWidth = mHalfTextWidth;// + 15;
         mHalfHeight = mHalfTextHeight;
         
         GraphicsUtil.ClearAndDrawRect (this, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, -1, true, true ? 0xC0FFC0 : 0xFFD0D0);
         GraphicsUtil.DrawRect (this, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, borderSize, false);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mFunctionManager.mSelectionEngine.CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
         }
         
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle ( GetRotation (), GetPositionX (), GetPositionY (), mHalfWidth, mHalfHeight);
      }
      
   //=======================================================================================
   // code snippet
   //=======================================================================================
      
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
      
      public function ValidateEntityLinks ():void
      {
         //mCodeSnippet.ValidateValueSourcesAndTargets ();
      }
      
      public function GetFunctionDeclaration ():FunctionDeclaration_Custom
      {
         return mFunctionDeclaration;
      }
      
   //====================================================================
   //   clone
   //====================================================================
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var codeSnippetHolder:EntityCodeSnippetHolder = entity as EntityCodeSnippetHolder;
         
         codeSnippetHolder.GetCodeSnippet ().CopyCallingsFrom (mCodeSnippet);
      }
      
      
   }
}
