
package editor.display.panel {
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.EventPhase;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import flash.net.URLRequest;
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   import mx.core.UIComponent;
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.controls.Label;
   import mx.controls.TextInput;
   import mx.controls.RadioButton;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.EditorContext;
   import editor.core.KeyboardListener;
   
   import editor.entity.Entity;
   
   import editor.trigger.entity.Linkable;
   
   import editor.trigger.entity.EntityFunction;
   import editor.trigger.entity.EntityFunctionPackage;
   
   import editor.trigger.CodeSnippet;
   
   import editor.world.FunctionManager;
   
   import editor.mode.FunctionMode;
   
   import editor.mode.FunctionModePlaceCreateEntity;
   import editor.mode.FunctionModeCreateEntityLink;
   
   import editor.mode.FunctionModeRegionSelectEntities;
   import editor.mode.FunctionModeMoveSelectedEntities;
   
   import editor.WorldView;
   
   import common.Define;
   import common.Version;
   
   public class FunctionEditingView extends UIComponent implements KeyboardListener
   {
      public var mBackgroundLayer:Sprite;
      public var mEntityLinksLayer:Sprite;
      public var mForegroundLayer:Sprite;
      
      private var mFunctionManager:FunctionManager = null;
      
      public function FunctionEditingView ()
      {
         enabled = true;
         mouseFocusEnabled = true;
         
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         addEventListener(Event.RESIZE, OnResize);
         
         //
         mBackgroundLayer = new Sprite ();
         addChild (mBackgroundLayer);
         
         mEntityLinksLayer = new Sprite ();
         addChild (mEntityLinksLayer);
         
         mForegroundLayer = new Sprite ();
         addChild (mForegroundLayer);
         
         //
         BuildContextMenu ();
      }
      
      public function GetFunctionManager ():FunctionManager
      {
         return mFunctionManager;
      }
      
      public function SetFunctionManager (fm:FunctionManager):void
      {
         if (mFunctionManager == fm)
            return;
         
         if (mFunctionManager != null && contains (mFunctionManager))
         {
            removeChild (mFunctionManager);
         }
         
         mFunctionManager = fm;
         
         if (mFunctionManager != null)
         {
            addChildAt (mFunctionManager, getChildIndex (mForegroundLayer));
            
            mask = mContentMaskSprite;
         }
         
         UpdateEntityLinkLines ();
         
         UpdateToolbarConponents ();
      }
      
      public function UpdateEntityLinkLines ():void
      {
      }
      
//============================================================================
//   stage event
//============================================================================
      
      private function OnAddedToStage (event:Event):void 
      {
         // ...
         addEventListener (Event.ENTER_FRAME, OnEnterFrame);
         
         addEventListener (MouseEvent.CLICK, OnMouseClick);
         addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
         addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
         addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
         addEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);
         addEventListener (MouseEvent.MOUSE_WHEEL, OnMouseWheel);
         
         // now put in EditorContext
         //stage.addEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
      }
      
      private var mContentMaskSprite:Shape = null;
      
      private function OnResize (event:Event):void 
      {
         var parentWidth :Number = parent.width;
         var parentHeight:Number = parent.height;
         
         GraphicsUtil.ClearAndDrawRect (mBackgroundLayer, 0, 0, parentWidth - 1, parentHeight - 1, 0x0, 1, true, 0xDDDDA0);
         
         // mask
         {
            if (mContentMaskSprite == null)
            {
               mContentMaskSprite = new Shape ();
               addChild (mContentMaskSprite);
            }
            
            mContentMaskSprite.graphics.clear ();
            mContentMaskSprite.graphics.beginFill(0x0);
            mContentMaskSprite.graphics.drawRect (0, 0, parentWidth, parentHeight);
            mContentMaskSprite.graphics.endFill ();
            
            mask = mContentMaskSprite;
         }
         
         if (mFunctionManager != null)
         {
            mFunctionManager.x = mBackgroundLayer.x;
            mFunctionManager.y = mBackgroundLayer.y;
            mFunctionManager.scaleX = mBackgroundLayer.scaleX;
            mFunctionManager.scaleY = mBackgroundLayer.scaleY;
            
            UpdateEntityLinkLines ();
         }
      }
      
      private var mStepTimeSpan:TimeSpan = new TimeSpan ();
      
      private function OnEnterFrame (event:Event):void 
      {
         //
         mStepTimeSpan.End ();
         mStepTimeSpan.Start ();
         
         if (mFunctionManager != null)
            mFunctionManager.Update (mStepTimeSpan.GetLastSpan ());
      }
      
//==================================================================================
// mode
//==================================================================================
      
      // create mode
      private var mCurrentCreateMode:FunctionMode = null;
      private var mLastSelectedCreateButton:Button = null;
      
      // edit mode
      private var mCurrentEditMode:FunctionMode = null;
      
      public function SetCurrentCreateMode (mode:FunctionMode):void
      {
         if (mCurrentCreateMode != null)
         {
            mCurrentCreateMode.Destroy ();
            mCurrentCreateMode = null;
         }
         
         if (EditorContext.HasSettingDialogOpened ())
         {
            if (mLastSelectedCreateButton != null)
               mLastSelectedCreateButton.selected = false;
            return;
         }
         
         mCurrentCreateMode = mode;
         
         if (mCurrentCreateMode != null)
         {
            mIsCreating = true;
            mLastSelectedCreateButton.selected = true;
         }
         else
         {
            mIsCreating = false;
            if (mLastSelectedCreateButton != null)
               mLastSelectedCreateButton.selected = false;
         }
         
         if (mCurrentCreateMode != null)
            mCurrentCreateMode.Initialize ();
      }
      
      public function CancelCurrentCreatingMode ():void
      {
         if (mCurrentCreateMode != null)
         {
            SetCurrentCreateMode (null);
         }
      }
      
      public function SetCurrentEditMode (mode:FunctionMode):void
      {
         if (mCurrentEditMode != null)
         {
            mCurrentEditMode.Destroy ();
            mCurrentEditMode = null;
         }
         
         if (EditorContext.HasSettingDialogOpened ())
         {
            if (mLastSelectedCreateButton != null)
               mLastSelectedCreateButton.selected = false;
            return;
         }
         
         mCurrentEditMode = mode;
         
         if (mCurrentEditMode != null)
            mCurrentEditMode.Initialize ();
      }
      
      public function CancelCurrentEditingMode ():void
      {
         if (mCurrentEditMode != null)
         {
            SetCurrentEditMode (null);
         }
      }
      
      private var mIsCreating:Boolean = false;
      private var mIsPlaying:Boolean = false;
      
      private function IsCreating ():Boolean
      {
         return mIsCreating;
      }
      
      private function IsEditing ():Boolean
      {
         return ! mIsCreating;
      }
      
//==================================================================================
// mode
//==================================================================================
      
      public var mButtonCreatePureFunction:Button;
      public var mButtonCreateDirtyFunction:Button;
      public var mButtonCreatePackage:Button;
      public var mButtonCreateClass:Button;
      
      public function OnCreateButtonClick (event:MouseEvent):void
      {
         if ( ! event.target is Button)
            return;
         
         SetCurrentCreateMode (null);
         mLastSelectedCreateButton = (event.target as Button);
         
         switch (event.target)
         {
            case mButtonCreatePureFunction:
               SetCurrentCreateMode (new FunctionModePlaceCreateEntity (this, CreateEntityFunction, {mIsDesignDependent: false}));
               break;
            case mButtonCreateDirtyFunction:
               SetCurrentCreateMode (new FunctionModePlaceCreateEntity (this, CreateEntityFunction, {mIsDesignDependent: true}));
               break;
            case mButtonCreatePackage:
               //SetCurrentCreateMode (new FunctionModePlaceCreateEntity (this, CreateEntityFunctionPackage));
               break;
            case mButtonCreateClass:
               //SetCurrentCreateMode (new FunctionModePlaceCreateEntity (this, CreateEntityClass));
               break;
         // ...
            default:
               SetCurrentCreateMode (null);
               break;
         }
         
      }
      
      public var mButtonDelete:Button;
      public var mButtonSetting:Button;
      
      public function OnEditButtonClick (event:MouseEvent):void
      {
         switch (event.target)
         {
            case mButtonDelete:
               DeleteSelectedEntities ();
               break;
            case mButtonSetting:
               OpenEntitySettingDialog ();
               break;
            default:
               break;
         }
      }
      
      public var mLabelName:Label;
      public var mTextInputName:TextInput;
      public var mButtonIsPure:RadioButton;
      public var mButtonIsDirty:RadioButton;
      
      public function OnTextInputEnter (event:Event):void
      {
         if (event.target == mTextInputName)
         {
            SetTheSelectedEntityName (mTextInputName.text);
         }
      }
      
      public function UpdateToolbarConponents ():void
      {
         var numSelecteds:int = 0;
         var onlySelected:Entity = null;
         if (mFunctionManager != null)
         {
            var selecteds:Array = mFunctionManager.GetSelectedEntities ();
            numSelecteds = selecteds.length;
            
            if (numSelecteds == 1)
               onlySelected = selecteds [0] as Entity;
         }
         
         mButtonDelete.enabled = numSelecteds > 0;
         mButtonSetting.enabled = (onlySelected is EntityFunction);
         
         mLabelName.enabled = numSelecteds == 1;
         mTextInputName.enabled = numSelecteds == 1;
         
         if (onlySelected != null)
         {
            mTextInputName.text = onlySelected.GetName ();
         }
         else
         {
            mTextInputName.text = "";
         }
      }
      
      public var ShowFunctionSettingDialog:Function = null;
      
      private function OpenEntitySettingDialog ():void
      {
         if (! IsEditing ())
            return;
         
         if (EditorContext.HasSettingDialogOpened ())
            return;
         
         var selectedEntities:Array = mFunctionManager.GetSelectedEntities ();
         if (selectedEntities == null || selectedEntities.length != 1)
            return;
         
         var entity:Entity = selectedEntities [0] as Entity;
         
         var values:Object = new Object ();
         
         if (entity is EntityFunction)
         {
            var aFunction:EntityFunction = entity as EntityFunction;
            
            values.mCodeSnippetName = aFunction.GetCodeSnippetName ();
            values.mCodeSnippet  = aFunction.GetCodeSnippet ().Clone (null);
            (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (EditorContext.GetCurrentWorld ().GetCoordinateSystem ());
            
            ShowFunctionSettingDialog (values, ConfirmSettingEntityProperties);
         }
      }
      
      private function ConfirmSettingEntityProperties (params:Object):void
      {
         var selectedEntities:Array = mFunctionManager.GetSelectedEntities ();
         if (selectedEntities == null || selectedEntities.length != 1)
            return;
         
         var entity:Entity = selectedEntities [0] as Entity;
         
         if (entity is EntityFunction)
         {
            var aFunction:EntityFunction = entity as EntityFunction;
            
            var code_snippet:CodeSnippet = aFunction.GetCodeSnippet ();
            code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
            code_snippet.PhysicsValues2DisplayValues (EditorContext.GetCurrentWorld ().GetCoordinateSystem ());
         }
      }
      
//=================================================================================
// creat
//=================================================================================
      
      public function CreateEntityFunction (options:Object):EntityFunction
      {
         if (options.stage == FunctionModePlaceCreateEntity.StageFinished)
         {
            return null;
         }
         else
         {
            var aFunction:EntityFunction = mFunctionManager.CreateEntityFunction (null, options.mIsDesignDependent);
            if (aFunction == null)
               return null;
            
            SetTheOnlySelectedEntity (aFunction);
            
            return aFunction;
         }
      }
      
      public function CreateEntityFunctionPackage (options:Object = null):EntityFunctionPackage
      {
         if (options != null && options.stage == FunctionModePlaceCreateEntity.StageFinished)
         {
            return null;
         }
         else
         {
            var aPackage:EntityFunctionPackage = mFunctionManager.CreateEntityFunctionPackage ();
            if (aPackage == null)
               return null;
            
            SetTheOnlySelectedEntity (aPackage);
            
            return aPackage;
         }
      }
      
//=================================================================================
// coordinates
//=================================================================================
      
      public function ViewToManager (point:Point):Point
      {
         return DisplayObjectUtil.LocalToLocal (this, mFunctionManager, point);
      }
      
      public function ManagerToView (point:Point):Point
      {
         return DisplayObjectUtil.LocalToLocal (mFunctionManager, this, point);
      }
      
//==================================================================================
// mouse and key events
//==================================================================================
      
      private var _mouseEventCtrlDown:Boolean = false;
      private var _mouseEventShiftDown:Boolean = false;
      private var _mouseEventAltDown:Boolean = false;
      
      private var _isZeroMove:Boolean = false;
      
      private function CheckModifierKeys (event:MouseEvent):void
      {
         _mouseEventCtrlDown   = event.ctrlKey;
         _mouseEventShiftDown = event.shiftKey;
         _mouseEventAltDown     = event.altKey;
      }
      
//==================================================================================
// mouse and key events
//==================================================================================
      
      public function OnMouseClick (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         //CheckModifierKeys (event);
         
         if (IsEditing ())
         {
         }
      }
      
      public function OnMouseDown (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         EditorContext.SetKeyboardListener (this);
         stage.focus = this;
         
         if (mFunctionManager == null)
            return;
         
         CheckModifierKeys (event);
         _isZeroMove = true;
         
         var worldPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, mFunctionManager, new Point (event.localX, event.localY) );
         
         if (IsCreating ())
         {
            if (mCurrentCreateMode != null)
            {
               mCurrentCreateMode.OnMouseDown (worldPoint.x, worldPoint.y);
            }
         }
         
         if (IsEditing ())
         {
         // create / break logic link
            
            var linkable:Linkable = mFunctionManager.GetFirstLinkablesAtPoint (worldPoint.x, worldPoint.y);
            if (linkable != null && linkable.CanStartCreatingLink (worldPoint.x, worldPoint.y))
            {
               SetCurrentEditMode (new FunctionModeCreateEntityLink (this, linkable));
               mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
               
               return;
            }
            
         // entities
            
            var entityArray:Array = mFunctionManager.GetEntitiesAtPoint (worldPoint.x, worldPoint.y, mLastSelectedEntity);
            var entity:Entity;
            
            // move selecteds, first time
            {
               if (mFunctionManager.AreSelectedEntitiesContainingPoint (worldPoint.x, worldPoint.y))
               {
                  if (_mouseEventShiftDown && _mouseEventCtrlDown)
                  {
                  }
                  else if (_mouseEventShiftDown)
                  {
                  }
                  else if (_mouseEventCtrlDown)
                  {
                  }
                  else
                  {
                     SetCurrentEditMode (new FunctionModeMoveSelectedEntities (this));
                  }
                   
                  if (mCurrentEditMode != null)
                     mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
                   
                   return;
               }
            }
            
            // point select, ctrl not down.
            // for the situation: press on an unselected entity and move it
            if (entityArray.length > 0)
            {
               entity = (entityArray[0] as Entity);
               
               if (! _mouseEventCtrlDown)
               {
                  SetTheOnlySelectedEntity (entity);
                  
                  _isZeroMove = false;
               }
            }
            
            // move selecteds, 2nd time
            {
               if (mFunctionManager.AreSelectedEntitiesContainingPoint (worldPoint.x, worldPoint.y))
               {
                  SetCurrentEditMode (new FunctionModeMoveSelectedEntities (this));
                  
                  mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
                   
                  return;
               }
            }
            
            //if (mSingleHandMode == SingleHandMode_Scale)
            //   _mouseEventCtrlDown = false;
            
            if (_mouseEventCtrlDown)
               mLastSelectedEntities = mFunctionManager.GetSelectedEntities ();
            else
               mFunctionManager.ClearSelectedEntities ();
            
            // region select
            {
               //var entityArray:Array = mCollisionManager.GetEntityAtPoint (worldPoint.x, worldPoint.y, null);
               if (entityArray.length == 0)
               {
                  _isZeroMove = false;
                  
                  SetCurrentEditMode (new FunctionModeRegionSelectEntities (this));
                  
                  mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
               }
            }
         }
      }
      
      public function OnMouseMove (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         if (mFunctionManager == null)
            return;
         
         var point:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, this, new Point (event.localX, event.localY) );
         var rect:Rectangle = new Rectangle (0, 0, parent.width, parent.height);
         
         if ( ! rect.containsPoint (point) )
         {
            // wired: sometimes, moust out event can't be captured, so create a fake mouse out event here
            OnMouseOut (event);
            return;
         }
         
         _isZeroMove = false;
         
         var worldPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, mFunctionManager, new Point (event.localX, event.localY) );
         
         if (IsCreating ())
         {
            if (mCurrentCreateMode != null)
            {
               mCurrentCreateMode.OnMouseMove (worldPoint.x, worldPoint.y);
            }
         }
         
         
         if (IsEditing ())
         {
            if (mCurrentEditMode != null)
            {
               mCurrentEditMode.OnMouseMove (worldPoint.x, worldPoint.y);
            }
         }
      }
      
      public function OnMouseUp (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         if (mFunctionManager == null)
            return;
         
         var worldPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, mFunctionManager, new Point (event.localX, event.localY) );
         
         if (IsCreating ())
         {
            if (mCurrentCreateMode != null)
            {
               mCurrentCreateMode.OnMouseUp (worldPoint.x, worldPoint.y);
               
               return;
            }
         }
         
         
         if (IsEditing ())
         {
            if (_isZeroMove)
            {
               var entityArray:Array = mFunctionManager.GetEntitiesAtPoint (worldPoint.x, worldPoint.y, mLastSelectedEntity);
               var entity:Entity;
               
               // point select, ctrl down
               if (entityArray.length > 0)
               {
                  entity = (entityArray[0] as Entity);
                  
                  if (_mouseEventCtrlDown)
                  {
                     ToggleEntitySelected (entity);
                  }
                  else 
                  {
                     SetTheOnlySelectedEntity (entity);
                  }
                }
             }
            
            if (mCurrentEditMode != null)
            {
               mCurrentEditMode.OnMouseUp (worldPoint.x, worldPoint.y);
            }
         }
      }
      
      public function OnMouseOut (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         if (mFunctionManager == null)
            return;
         
         CheckModifierKeys (event);
         
         //var point:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, this, new Point (event.localX, event.localY) );
         //var rect:Rectangle = new Rectangle (0, 0, parent.width, parent.height);
         var point:Point = globalToLocal ( new Point (event.stageX, event.stageY) );
         var rect:Rectangle = new Rectangle (0, 0, width, height);
         
         var isOut:Boolean = ! rect.containsPoint (point);
         
         if ( ! isOut )
            return;
         
         if (IsCreating ())
         {
            if (mCurrentCreateMode != null)
            {
               CancelCurrentCreatingMode ();
            }
         }
         
         
         if (IsEditing ())
         {
            if (mCurrentEditMode != null)
            {
               CancelCurrentEditingMode ();
            }
         }
      }
      
      public function OnMouseWheel (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         if (mFunctionManager == null)
            return;
         
         CheckModifierKeys (event);
         
         if (IsEditing ())
         {
         }
      }
      
      public function OnKeyDown (event:KeyboardEvent):void
      {
         switch (event.keyCode)
         {
            case Keyboard.ESCAPE:
               CancelCurrentCreatingMode ();
               break;
            case Keyboard.SPACE:
               OpenEntitySettingDialog ();
               break;
            default:
               break;
         }
      }
      
//=================================================================================
//   select
//=================================================================================
      
      private var mLastSelectedEntity:Entity = null;
      private var mLastSelectedEntities:Array = null;
      
      public function SetTheOnlySelectedEntity (entity:Entity):void
      {
         if (mFunctionManager == null)
            return;
         
         if (entity == null)
            return;
         
         mFunctionManager.ClearSelectedEntities ();
         
         if (mFunctionManager.GetSelectedEntities ().length != 1 || mFunctionManager.GetSelectedEntities () [0] != entity)
            mFunctionManager.SetSelectedEntity (entity);
         
         if (mFunctionManager.GetSelectedEntities ().length != 1)
            return;
         
         mLastSelectedEntity = entity;
         
         UpdateToolbarConponents ();
      }
      
      public function ToggleEntitySelected (entity:Entity):void
      {
         if (mFunctionManager == null)
            return;
         
         mFunctionManager.ToggleEntitySelected (entity);
         
         mLastSelectedEntity = entity;
         
         UpdateToolbarConponents ();
      }
      
      public function RegionSelectEntities (left:Number, top:Number, right:Number, bottom:Number):void
      {
         if (mFunctionManager == null)
            return;
         
         var entities:Array = mFunctionManager.GetEntitiesIntersectWithRegion (left, top, right, bottom);
         
         mFunctionManager.ClearSelectedEntities ();
         
         if (_mouseEventCtrlDown)
         {
            if (mLastSelectedEntities != null)
               mFunctionManager.SelectEntities (mLastSelectedEntities);
            
            //mCollisionManager.SelectEntities (entities);
            for (var i:int = 0; i < entities.length; ++ i)
            {
               mFunctionManager.ToggleEntitySelected (entities [i]);
            }
         }
         else
         {
            mFunctionManager.SelectEntities (entities);
         }
         
         UpdateToolbarConponents ();
      }
      
//=================================================================================
//   create / delete / setting / move entities
//=================================================================================
      
      public function DestroyEntity (entity:Entity):void
      {
         if (mFunctionManager == null)
            return;
         
         mFunctionManager.DestroyEntity (entity);
         
         UpdateToolbarConponents ();
      }
      
      public function MoveSelectedEntities (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean):void
      {
         if (mFunctionManager == null)
            return;
         
         mFunctionManager.MoveSelectedEntities (offsetX, offsetY, updateSelectionProxy);
         
         UpdateEntityLinkLines ();
      }
      
      public function DeleteSelectedEntities ():void
      {
         if (mFunctionManager == null)
            return;
         
         mFunctionManager.DeleteSelectedEntities ();
         
         UpdateEntityLinkLines ();
         
         UpdateToolbarConponents ();
      }
      
      public function SetTheSelectedEntityName (name:String):void
      {
         if (mFunctionManager == null)
            return;
         
         if (mFunctionManager.GetSelectedEntities ().length != 1)
            return;
         
         var entity:Entity = mFunctionManager.GetSelectedEntities () [0] as Entity;
         
         if (entity is EntityFunction)
         {
            (entity as EntityFunction).SetFunctionName (name);
         }
         else if (entity is EntityFunctionPackage)
         {
            (entity as EntityFunctionPackage).SetPackageName (name);
         }
         
         entity.UpdateAppearance ();
         
         UpdateToolbarConponents ();
      }
      
//=====================================================================
// context menu
//=====================================================================
      
      private function BuildContextMenu ():void
      {
         var theContextMenu:ContextMenu = new ContextMenu ();
         theContextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = theContextMenu.builtInItems;
         defaultItems.print = true;
         contextMenu = theContextMenu;
         
         // need flash 10
         //theContextMenu.clipboardMenu = true;
         //var clipboardItems:ContextMenuClipboardItems = theContextMenu.builtInItems;
         //clipboardItems.clear = true;
         //clipboardItems.cut = false;
         //clipboardItems.copy = true;
         //clipboardItems.paste = true;
         //clipboardItems.selectAll = false;
            
         theContextMenu.customItems.push (EditorContext.GetAboutContextMenuItem ());
      }
      
   }
}
