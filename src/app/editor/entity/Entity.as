
package editor.entity {
   
   import flash.display.Sprite;
   
   import flash.system.Capabilities;
   
   import com.tapirgames.display.TextFieldEx;
   
   import editor.world.EntityContainer;
   
   import editor.selection.SelectionProxy;
   
   import editor.core.EditorObject;
   
   import editor.asset.Asset;
   
   import common.Define;
   import common.ValueAdjuster;
   import common.Transform2D;
   
   //todo: extends from Asset (or merge Asset and EditorObject)
   public class Entity extends Asset //EditorObject// Sprite
   {
      protected var mEntityContainer:EntityContainer;
      
      protected var mIsEnabled:Boolean = true;
      
      public function Entity (container:EntityContainer)
      {
         super (container);
         
         mEntityContainer = container;
      }
      
      public function IsUtilityEntity ():Boolean
      {
         return false;
      }
      
      override public function GetDefaultName ():String
      {
         return GetTypeName ();
      }
      
      override public function ToCodeString ():String
      {
         return "Entity#" + GetCreationOrderId ();
      }
      
//======================================================
// 
//======================================================
      
      override public function Destroy ():void
      {
         SetInternalComponentsVisible (false);
         
         RemoveIdText ();
         
         super.Destroy ();
      }
      
      //public function SetSelectable (selectable:Boolean):void
      //{
      //   if (mSelectionProxy != null)
      //      mSelectionProxy.SetSelectable (selectable);
      //}
      
      override public function GetTypeName ():String
      {
         return "Entity";
      }
      
      override public function GetInfoText ():String
      {
         return     "x = " + ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_PositionX (GetPositionX ()), 6) 
                + ", y = " + ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_PositionY (GetPositionY ()), 6) 
                + ", angle = " + ValueAdjuster.Number2Precision ((mEntityContainer.GetCoordinateSystem ().D2P_RotationRadians (GetRotation ()) * Define.kRadians2Degrees), 6);
      }
      
      public function GetPhysicsShapesCount ():uint
      {
         return 0;
      }
      
//======================================================
// visible, alpha, active
//======================================================
      
      public function SetEnabled (enabled:Boolean):void
      {
         mIsEnabled = enabled;
      }
      
      public function IsEnabled ():Boolean
      {
         return mIsEnabled;
      }
      
//====================================================================
//   clone
//====================================================================
      
      public function IsClonedable ():Boolean
      {
         return true;
      }
      
      public final function Clone (displayOffsetX:Number, displayOffsetY:Number):Entity
      {
         var entity:Entity = CreateCloneShell ();
         
         if (entity != null)
         {
            SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
            
            entity.UpdateAppearance ();
            entity.UpdateSelectionProxy ();
         }
         
         return entity;
      }
      
      // to override
      protected function CreateCloneShell ():Entity
      {
         return null;
      }
      
      // to override
      public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         entity.SetPosition ( GetPositionX () + displayOffsetX, GetPositionY () + displayOffsetY );
         entity.SetRotation ( GetRotation () );
         entity.SetVisible ( IsVisible () );
         entity.SetAlpha ( GetAlpha () );
         entity.SetEnabled ( IsEnabled () );
         entity.SetScale ( GetScale () );
         entity.SetFlipped ( IsFlipped () );
      }
      
//====================================================================
//   vertex control points
//====================================================================
      
      private var mVertexControllersVisible:Boolean = false;
      
      public function GetVertexControllerIndex (vertexController:VertexController):int
      {
         return -1;
      }
      
      public function GetVertexControllerByIndex (index:int):VertexController
      {
         return null;
      }
      
      public function SetInternalComponentsVisible (visible:Boolean):void
      {
         mVertexControllersVisible = visible;
      }
      
      public function AreInternalComponentsVisible ():Boolean
      {
         return mVertexControllersVisible;
      }
      
      public function OnBeginMovingVertexController (movingVertexController:VertexController):void
      {
      }
      
      public function OnMovingVertexController (movingVertexController:VertexController, offsetX:Number, offsetY:Number):void
      {
      }
      
      public function OnEndMovingVertexController (movingVertexController:VertexController):void
      {
      }
      
      public function OnVertexControllerSelectedChanged (movingVertexController:VertexController, selected:Boolean):void
      {
      }
      
      // if the vertext is not deleted, return it, otherwise, return null
      public function RemoveVertexController(vertexController:VertexController):VertexController
      {
         return vertexController;
      }
      
      // the returned VertexController is not the inserted one but the new one for beforeVertexController
      public function InsertVertexController(beforeVertexController:VertexController):VertexController
      {
         return beforeVertexController;
      }
      
//====================================================================
//   selected
//====================================================================
      
      public function OnWorldZoomScaleChanged ():void
      {
         if (IsSelected ())
         {
            if (AreInternalComponentsVisible ())
            {
               // rebuild internal components
               SetInternalComponentsVisible (false);
               SetInternalComponentsVisible (true);
            }
         }
      }
      
//====================================================================
//   brothers
//====================================================================
      
      private var mBrothers:Array = null;
      
      public function GetBrothers ():Array // used only by BorthersManager
      {
         return mBrothers;
      }
      
      public function SetBrothers (brothers:Array):void // used only by BorthersManager
      {
         mBrothers = brothers;
      }
      
//====================================================================
//   draw entity links
//====================================================================
      
      public static const DrawLinksOrder_Normal:int = 10;
      public static const DrawLinksOrder_Logic:int = 20;
      public static const DrawLinksOrder_Task:int = 30;
      public static const DrawLinksOrder_EventHandler:int = 50;
      
      public function GetDrawLinksOrder ():int
      {
         return DrawLinksOrder_Normal;
      }
      
      public function DrawEntityLinks (canvasSprite:Sprite, forceDraw:Boolean, isExpanding:Boolean = false):void
      {
         // to override
      }
      
//====================================================================
//   draw entity id
//====================================================================
      
      private var mIdText:TextFieldEx = null;
      private var mLasteId:int = -1;
      
      public function DrawEntityId (canvasSprite:Sprite):void
      {
         if (canvasSprite == null)
            return;
         
         var creationOrderId:int = GetCreationOrderId ();
         if (mLasteId != creationOrderId)// || mIdText == null)
         {
            RemoveIdText ();
            
            mLasteId = creationOrderId;
            mIdText = TextFieldEx.CreateTextField (mLasteId.toString (), true, 0xFFFFFF, 0x0, false, 0, false, true, 0x0);
         }
         
         if (mIdText.parent != canvasSprite)
         {
            canvasSprite.addChild (mIdText);
         }
         
         mIdText.scaleX = 1.0 / mEntityContainer.scaleX;
         mIdText.scaleY = 1.0 / mEntityContainer.scaleY;
         mIdText.x = GetLinkPointX () - 0.5 * mIdText.width;
         mIdText.y = GetLinkPointY () - 0.5 * mIdText.height;
      }
      
      public function RemoveIdText ():void
      {
         if (mIdText != null)
         {
            if (mIdText.parent != null)
            {
               mIdText.parent.removeChild (mIdText);
            }
            
            mIdText = null;
         }
      } 

   }
}