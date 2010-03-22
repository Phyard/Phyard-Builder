
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.display.TextFieldEx;
   
   import editor.world.EntityContainer;
   //import editor.world.World;
   
   import editor.selection.SelectionProxy;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class Entity extends Sprite
   {
      protected var mEntityContainer:EntityContainer;
      protected var mAppearanceLayerId:int = -1;
      protected var mCreationOrderId:int = -1; // to reduce random factors
      
      protected var mSelectionProxy:SelectionProxy = null;
      
      private var mPosX:Number = 0;
      private var mPosY:Number = 0;
      private var mRotation:Number = 0;
      
      protected var mIsVisible:Boolean = true;
      
      //>> v1.08
      protected var mAlpha:Number = 1.0;
      protected var mIsEnabled:Boolean = true;
      //<<
      
      public function Entity (container:EntityContainer)
      {
         mEntityContainer = container;
         
         if (mEntityContainer != null) // at some special cases, mEntityContainer is null
            mEntityContainer.OnEntityCreated (this);
         
         //SetName (null);
         
         SetVisibleInEditor (true);
         
         mouseChildren = false;
      }
      
      public function GetContainer ():EntityContainer
      {
         return mEntityContainer;
      }
      
      public function IsUtilityEntity ():Boolean
      {
         return false;
      }
      
      public function GetDefaultName ():String
      {
         return "Entity";
      }
      
      public function ToCodeString ():String
      {
         return "Entity#" + mCreationOrderId;
      }
      
//======================================================
// 
//======================================================
      
      protected var mVisibleInEditor:Boolean = true;
      
      public function SetVisibleInEditor (visibleInEditor:Boolean):void
      {
         mVisibleInEditor = visibleInEditor;
         
         alpha = mVisibleInEditor ? GetVisibleAlpha () : GetInvisibleAlpha ();
      }
      
      public function IsVisibleInEditor ():Boolean
      {
         return mVisibleInEditor;
      }
      
      public function GetVisibleAlpha ():Number
      {
         return 1.0;
      }
      
      public function GetInvisibleAlpha ():Number
      {
         return 0.2;
      }
      
//======================================================
// 
//======================================================
      
      public function SetAppearanceLayerId (index:int):void
      {
         mAppearanceLayerId = index;
      }
      
      public function GetAppearanceLayerId ():int
      {
         mEntityContainer.CorrectEntityAppearanceIds ();
         
         return mAppearanceLayerId;
      }
      
      public function SetCreationOrderId (index:int):void
      {
         mCreationOrderId = index;
      }
      
      public function GetCreationOrderId ():int
      {
         mEntityContainer.CorrectEntityCreationIds ();
         
         return mCreationOrderId;
      }
      
//======================================================
// 
//======================================================
      
      public function Destroy ():void
      {
         SetInternalComponentsVisible (false);
         
         RemoveIdText ();
         
         if (mSelectionProxy != null)
            mSelectionProxy.Destroy ();
         
         mEntityContainer.OnEntityDestroyed (this);
      }
      
      public function Update (escapedTime:Number):void
      {
      }
      
      public function UpdateAppearance ():void
      {
      }
      
      public function SetSelectable (selectable:Boolean):void
      {
         if (mSelectionProxy != null)
            mSelectionProxy.SetSelectable (selectable);
      }
      
      public function GetTypeName ():String
      {
         return "Entity";
      }
      
      public function GetInfoText ():String
      {
         return     "x = " + ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_PositionX (mPosX), 6) 
                + ", y = " + ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_PositionY (mPosY), 6) 
                + ", angle = " + ValueAdjuster.Number2Precision ((mEntityContainer.GetCoordinateSystem ().D2P_RotationRadians (mRotation) * Define.kRadians2Degrees), 6);
      }
      
      public function GetPhysicsShapesCount ():uint
      {
         return 0;
      }
      
//======================================================
// visible, alpha, active
//======================================================
      
      public function SetVisible (visible:Boolean):void
      {
         mIsVisible = visible;
      }
      
      public function IsVisible ():Boolean
      {
         return mIsVisible;
      }
      
      public function SetAlpha (playingAlpha:Number):void
      {
         mAlpha = playingAlpha;
      }
      
      public function GetAlpha ():Number
      {
         return mAlpha;
      }
      
      public function SetEnabled (enabled:Boolean):void
      {
         mIsEnabled = enabled;
      }
      
      public function IsEnabled ():Boolean
      {
         return mIsEnabled;
      }
      
      //public function SetName (name:String):void
      //{
      //   if (name == null)
      //      name = GetDefaultName ();
      //   
      //   mName = name;
      //}
      //
      //public function GetName ():String
      //{
      //   return mName;
      //}
      
//======================================================
// pos, rotition
//======================================================
      
      public function GetPositionX ():Number
      {
         return mPosX;
      }
      
      public function GetPositionY ():Number
      {
         return mPosY;
      }
      
      public function GetRotation ():Number
      {
         return mRotation;
      }
      
      public function SetPosition (posX:Number, posY:Number):void
      {
         mPosX = posX;
         mPosY = posY;
         x = mPosX;
         y = mPosY;
      }
      
      public function SetRotation (rot:Number):void
      {
         mRotation = rot % Define.kPI_x_2;
         if (mRotation < 0)
            mRotation += Define.kPI_x_2;
         
         rotation = (mRotation * Define.kRadians2Degrees) % 360.0;
      }
      
//====================================================================
//   Selection Proxy
//====================================================================
      
      public function UpdateSelectionProxy ():void
      {
      }
      
      public function ContainsPoint (pointX:Number, pointY:Number):Boolean
      {
         if (mSelectionProxy == null)
            return false;
         
         return mSelectionProxy.ContainsPoint (pointX, pointY);
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
            
            entity.UpdateSelectionProxy ();
            entity.UpdateAppearance ();
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
      }
      
      
//====================================================================
//   move, rotate, scale, flip
//====================================================================
      
      public function Move (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean = true):void
      {
         SetPosition (GetPositionX () + offsetX, GetPositionY () + offsetY);
         
         if (updateSelectionProxy)
            UpdateSelectionProxy ();
      }
      
      public function Rotate (centerX:Number, centerY:Number, dRadians:Number, updateSelectionProxy:Boolean = true):void
      {
         RotatePositioon (centerX, centerY, dRadians);
         RotateSelf (dRadians);
         
         if (updateSelectionProxy)
            UpdateSelectionProxy ();
      }
      
      public function RotateSelf (dRadians:Number):void
      {
         SetRotation (GetRotation () + dRadians);
      }
      
      public function RotatePositioon (centerX:Number, centerY:Number, dRadians:Number):void
      {
         var dx:Number = GetPositionX () - centerX;
         var dy:Number = GetPositionY () - centerY;
         var distance:Number = Math.sqrt (dx * dx + dy * dy);
         var radians:Number = Math.atan2 (dy, dx);
         radians += dRadians;
         
         SetPosition (centerX + distance * Math.cos (radians), centerY + distance * Math.sin (radians));
      }
      
      public function Scale (centerX:Number, centerY:Number, ratio:Number, updateSelectionProxy:Boolean = true):void
      {
         ScalePosition (centerX, centerY, ratio);
         ScaleSelf (ratio);
         
         UpdateAppearance ();
         
         if (updateSelectionProxy)
            UpdateSelectionProxy ();
      }
      
      public function ScaleSelf (ratio:Number):void
      {
         
      }
      
      public function ScalePosition (centerX:Number, centerY:Number, ratio:Number):void
      {
         var dx:Number = GetPositionX () - centerX;
         var dy:Number = GetPositionY () - centerY;
         
         SetPosition (centerX + dx * ratio, centerY + dy * ratio);
      }
      
      public function FlipHorizontally (mirrorX:Number, updateSelectionProxy:Boolean = true):void
      {
         FlipPositionHorizontally (mirrorX);
         FlipSelfHorizontally ();
         
         if (updateSelectionProxy)
            UpdateSelectionProxy ();
      }
      
      public function FlipSelfHorizontally ():void
      {
         //SetRotation (Math.PI + Math.PI - GetRotation () );
         SetRotation (Math.PI - GetRotation () );
      }
      
      public function FlipPositionHorizontally (mirrorX:Number):void
      {
         SetPosition (mirrorX + mirrorX - GetPositionX (), GetPositionY ());
      }
      
      public function FlipVertically (mirrorY:Number, updateSelectionProxy:Boolean = true):void
      {
         FlipPositionVertically (mirrorY);
         FlipSelfVertically ();
         
         if (updateSelectionProxy)
            UpdateSelectionProxy ();
      }
      
      public function FlipSelfVertically ():void
      {
         SetRotation (Math.PI + Math.PI - GetRotation () );
      }
      
      public function FlipPositionVertically (mirrorY:Number):void
      {
         SetPosition (GetPositionX (), mirrorY + mirrorY - GetPositionY ());
      }
      
//====================================================================
//   when clone and delete, we need the main entity.
//   after cloned, we need select new selectable sub entities
//====================================================================
      
      public function GetMainEntity ():Entity
      {
         return this;
      }
      
      public function GetSubEntities ():Array
      {
         return [this]; // maybe be not a good idea
         //return []; // if use this, be careful! Many need to modify.
      }
      
      public function GetSubIndex ():int
      {
         return 0;
      }
      
//====================================================================
//   when move and clone, we need the glued entity
//====================================================================
      
      public function GetGluedEntity ():Entity
      {
         return null;
      }
      
//====================================================================
//   selected
//====================================================================
      
      private var mSelected:Boolean = false;
      
      public function NotifySelectedChanged (selected:Boolean):void
      {
         var changed:Boolean =  mSelected != selected;
         
         mSelected = selected;
         
         if (! mSelected)
         {
            SetInternalComponentsVisible (false);
         }
         
         if (changed)
            UpdateAppearance ();
      }
      
      public function IsSelected ():Boolean // used internally, for external, use world.IsEntitySelected instead
      {
         return mSelected;
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
      
      public function GetLinkPointX ():Number
      {
         return mPosX;
      }
      
      public function GetLinkPointY ():Number
      {
         return mPosY;
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
         
         if (mLasteId != mCreationOrderId)// || mIdText == null)
         {
            RemoveIdText ();
            
            mLasteId = mCreationOrderId;
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
      
//====================================================================
//   properties
//====================================================================
      
      public function GetPropertyValue (propertyId:int):Object
      {
         return null;
      }
      
      public function SetPropertyValue (propertyId:int, value:Object):void
      {
      }
   }
}