
package editor {
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.EventPhase;
   
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   import mx.core.UIComponent;
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.controls.Label;
   import mx.controls.TextInput;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.runtime.Runtime;
   
   import editor.entity.Entity;
   
   import editor.world.CollisionManager;
   
   import editor.entity.EntityCollisionCategory;
   
   import editor.trigger.entity.Linkable;
   
   import editor.mode.CollisionCategoryMode;
   
   import editor.mode.CollisionCategoryModeCreateCategory;
   import editor.mode.CollisionCategoryModeCreateCategoryFriendLink;
   
   import editor.mode.CollisionCategoryModeRegionSelectEntities;
   import editor.mode.CollisionCategoryModeMoveSelectedEntities;
   
   import common.Define;
   
   public class CollisionManagerView extends UIComponent 
   {
      public var mBackgroundLayer:Sprite;
      public var mFriendLinksLayer:Sprite;
      public var mForegroundLayer:Sprite;
      
      private var mCollisionManager:CollisionManager = null;
      
      public function CollisionManagerView ()
      {
         enabled = true;
         mouseFocusEnabled = true;
         
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         addEventListener(Event.RESIZE, OnResize);
         
         //
         mBackgroundLayer = new Sprite ();
         addChild (mBackgroundLayer);
         
         mFriendLinksLayer = new Sprite ();
         addChild (mFriendLinksLayer);
         
         mForegroundLayer = new Sprite ();
         addChild (mForegroundLayer);
      }
      
      public function SetCollisionManager (cm:CollisionManager):void
      {
         if (mCollisionManager == cm)
            return;
         
         if (mCollisionManager != null && contains (mCollisionManager))
         {
            mCollisionManager.SetFriendLinksChangedCallback (null);
            removeChild (mCollisionManager);
         }
         
         mCollisionManager = cm;
         
         if (mCollisionManager != null)
         {
            addChildAt (mCollisionManager, getChildIndex (mForegroundLayer));
            mCollisionManager.SetFriendLinksChangedCallback (UpdateFriendLinkLines);
            
            mask = mContentMaskSprite;
         }
         
         UpdateFriendLinkLines ();
         
         UpdateToolbarConponents ();
      }
      
      public function UpdateFriendLinkLines ():void
      {
         if (mCollisionManager == null)
            return;
         
         GraphicsUtil.Clear (mFriendLinksLayer);
         
         var friendPairs:Array = mCollisionManager.GetCollisionCategoryFriendPairs ();
         var point1:Point;
         var point2:Point;
         var friend1:EntityCollisionCategory;
         var friend2:EntityCollisionCategory;
         
         for (var i:int = 0; i <  friendPairs.length; ++ i)
         {
            friend1 = friendPairs [i].mCategory1;
            friend2 = friendPairs [i].mCategory2;
            
            point1 = DisplayObjectUtil.LocalToLocal (mCollisionManager, mFriendLinksLayer, new Point (friend1.x, friend1.y) );
            point2 = DisplayObjectUtil.LocalToLocal (mCollisionManager, mFriendLinksLayer, new Point (friend2.x, friend2.y) );
            
            GraphicsUtil.DrawLine (mFriendLinksLayer, point1.x, point1.y, point2.x, point2.y, 0x0000FF, 2);
         }
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
         
         stage.addEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
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
         
         if (mCollisionManager != null)
         {
            mCollisionManager.x = mBackgroundLayer.x;
            mCollisionManager.y = mBackgroundLayer.y;
            mCollisionManager.scaleX = mBackgroundLayer.scaleX;
            mCollisionManager.scaleY = mBackgroundLayer.scaleY;
            
            UpdateFriendLinkLines ();
         }
      }
      
      private var mStepTimeSpan:TimeSpan = new TimeSpan ();
      
      private function OnEnterFrame (event:Event):void 
      {
         //
         mStepTimeSpan.End ();
         mStepTimeSpan.Start ();
         
         if (mCollisionManager != null)
            mCollisionManager.Update (mStepTimeSpan.GetLastSpan ());
      }
      
//==================================================================================
// mode
//==================================================================================
      
      // create mode
      private var mCurrentCreateMode:CollisionCategoryMode = null;
      private var mLastSelectedCreateButton:Button = null;
      
      // edit mode
      private var mCurrentEditMode:CollisionCategoryMode = null;
      
      public function SetCurrentCreateMode (mode:CollisionCategoryMode):void
      {
         if (mCurrentCreateMode != null)
         {
            mCurrentCreateMode.Destroy ();
            mCurrentCreateMode = null;
         }
         
         if (Runtime.HasSettingDialogOpened ())
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
      
      public function SetCurrentEditMode (mode:CollisionCategoryMode):void
      {
         if (mCurrentEditMode != null)
         {
            mCurrentEditMode.Destroy ();
            mCurrentEditMode = null;
         }
         
         if (Runtime.HasSettingDialogOpened ())
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
      
      public var mButtonCreateCollisionCategory:Button;
      
      public function OnCreateButtonClick (event:MouseEvent):void
      {
         if ( ! event.target is Button)
            return;
         
         SetCurrentCreateMode (null);
         mLastSelectedCreateButton = (event.target as Button);
         
         switch (event.target)
         {
            case mButtonCreateCollisionCategory:
               SetCurrentCreateMode ( new CollisionCategoryModeCreateCategory (this) );
               break;
         // ...
            default:
               SetCurrentCreateMode (null);
               break;
         }
         
      }
      
      public var mButtonDelete:Button;
      public var mCheckBoxHarmoniousCategory:CheckBox;
      public var mCheckBoxDefaultCategory:CheckBox;
      
      public function OnEditButtonClick (event:MouseEvent):void
      {
         switch (event.target)
         {
            case mButtonDelete:
               DeleteSelectedEntities ();
               break;
            case mCheckBoxHarmoniousCategory:
               SetTheSelectedCategoryCollideInternally (! mCheckBoxHarmoniousCategory.selected);
               break;
            case mCheckBoxDefaultCategory:
               SetTheSelectedCategoryDefaultCategory (mCheckBoxDefaultCategory.selected);
               break;
            default:
               break;
         }
      }
      
      public var mLabelName:Label;
      public var mTextInputName:TextInput;
      
      public function OnTextInputEnter (event:Event):void
      {
         if (event.target == mTextInputName)
         {
            SetTheSelectedCategoryName (mTextInputName.text);
         }
      }
      
      public function UpdateToolbarConponents ():void
      {
         var numCategories:int = 0;
         var numSelecteds:int = 0;
         var onlySelected:EntityCollisionCategory = null;
         if (mCollisionManager != null)
         {
            numCategories = mCollisionManager.GetNumCollisionCategories ();
            
            var selecteds:Array = mCollisionManager.GetSelectedEntities ();
            numSelecteds = selecteds.length;
            
            if (numSelecteds == 1)
               onlySelected = selecteds [0] as EntityCollisionCategory;
         }
         
         mButtonCreateCollisionCategory.enabled = (mCollisionManager != null) && (numCategories < Define.MaxCCatsCount - 1);
         
         mButtonDelete.enabled = numSelecteds > 0;
         
         mLabelName.enabled = numSelecteds == 1;
         mTextInputName.enabled = numSelecteds == 1;
         mCheckBoxHarmoniousCategory.enabled = numSelecteds == 1;
         mCheckBoxDefaultCategory.enabled = numSelecteds == 1;
         
         if (onlySelected != null)
         {
            mCheckBoxHarmoniousCategory.selected = ! onlySelected.IsCollideInternally ();
            mCheckBoxDefaultCategory.selected = onlySelected.IsDefaultCategory ();
            mTextInputName.text = onlySelected.GetCategoryName ();
         }
         else
         {
            mCheckBoxHarmoniousCategory.selected = false;
            mCheckBoxDefaultCategory.selected = false;
            mTextInputName.text = "";
         }
      }
      
      
      
//=================================================================================
// coordinates
//=================================================================================
      
      public function ViewToManager (point:Point):Point
      {
         return DisplayObjectUtil.LocalToLocal (this, mCollisionManager, point);
      }
      
      public function ManagerToView (point:Point):Point
      {
         return DisplayObjectUtil.LocalToLocal (mCollisionManager, this, point);
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
         
         stage.focus = this;
         
         if (mCollisionManager == null)
            return;
         
         CheckModifierKeys (event);
         _isZeroMove = true;
         
         var worldPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, mCollisionManager, new Point (event.localX, event.localY) );
         
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
            
            var linkable:Linkable = mCollisionManager.GetFirstLinkablesAtPoint (worldPoint.x, worldPoint.y);
            if (linkable != null && linkable.CanStartCreatingLink (worldPoint.x, worldPoint.y))
            {
               if (linkable is EntityCollisionCategory)
               {
                  SetCurrentEditMode (new CollisionCategoryModeCreateCategoryFriendLink (this, linkable as EntityCollisionCategory));
                  mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
               }
               
               return;
            }
            
         // entities
            
            var entityArray:Array = mCollisionManager.GetEntitiesAtPoint (worldPoint.x, worldPoint.y, mLastSelectedEntity);
            var entity:Entity;
            
            // move selecteds, first time
            {
               if (mCollisionManager.IsSelectedEntitiesContainPoint (worldPoint.x, worldPoint.y))
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
                     SetCurrentEditMode (new CollisionCategoryModeMoveSelectedEntities (this));
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
               if (mCollisionManager.IsSelectedEntitiesContainPoint (worldPoint.x, worldPoint.y))
               {
                  SetCurrentEditMode (new CollisionCategoryModeMoveSelectedEntities (this));
                  
                  mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
                   
                  return;
               }
            }
            
            //if (mSingleHandMode == SingleHandMode_Scale)
            //   _mouseEventCtrlDown = false;
            
            if (_mouseEventCtrlDown)
               mLastSelectedEntities = mCollisionManager.GetSelectedEntities ();
            else
               mCollisionManager.ClearSelectedEntities ();
            
            // region select
            {
               //var entityArray:Array = mCollisionManager.GetEntitiyAtPoint (worldPoint.x, worldPoint.y, null);
               if (entityArray.length == 0)
               {
                  _isZeroMove = false;
                  
                  SetCurrentEditMode (new CollisionCategoryModeRegionSelectEntities (this));
                  
                  mCurrentEditMode.OnMouseDown (worldPoint.x, worldPoint.y);
               }
            }
         }
      }
      
      public function OnMouseMove (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         if (mCollisionManager == null)
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
         
         var worldPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, mCollisionManager, new Point (event.localX, event.localY) );
         
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
         
         if (mCollisionManager == null)
            return;
         
         var worldPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, mCollisionManager, new Point (event.localX, event.localY) );
         
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
               var entityArray:Array = mCollisionManager.GetEntitiesAtPoint (worldPoint.x, worldPoint.y, mLastSelectedEntity);
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
         
         if (mCollisionManager == null)
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
         
         if (mCollisionManager == null)
            return;
         
         CheckModifierKeys (event);
         
         if (IsEditing ())
         {
         }
      }
      
      public function OnKeyDown (event:KeyboardEvent):void
      {
         if (! Runtime.IsActiveView (this))
            return;
         
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         switch (event.keyCode)
         {
            case Keyboard.ESCAPE:
               CancelCurrentCreatingMode ();
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
         if (mCollisionManager == null)
            return;
         
         if (entity == null)
            return;
         
         mCollisionManager.ClearSelectedEntities ();
         
         if (mCollisionManager.GetSelectedEntities ().length != 1 || mCollisionManager.GetSelectedEntities () [0] != entity)
            mCollisionManager.SetSelectedEntity (entity);
         
         if (mCollisionManager.GetSelectedEntities ().length != 1)
            return;
         
         mLastSelectedEntity = entity;
         
         UpdateToolbarConponents ();
      }
      
      public function ToggleEntitySelected (entity:Entity):void
      {
         if (mCollisionManager == null)
            return;
         
         mCollisionManager.ToggleEntitySelected (entity);
         
         mLastSelectedEntity = entity;
         
         UpdateToolbarConponents ();
      }
      
      public function RegionSelectEntities (left:Number, top:Number, right:Number, bottom:Number):void
      {
         if (mCollisionManager == null)
            return;
         
         var entities:Array = mCollisionManager.GetEntitiesIntersectWithRegion (left, top, right, bottom);
         
         mCollisionManager.ClearSelectedEntities ();
         
         if (_mouseEventCtrlDown)
         {
            if (mLastSelectedEntities != null)
               mCollisionManager.SelectEntities (mLastSelectedEntities);
            
            //mCollisionManager.SelectEntities (entities);
            for (var i:int = 0; i < entities.length; ++ i)
            {
               mCollisionManager.ToggleEntitySelected (entities [i]);
            }
         }
         else
         {
            mCollisionManager.SelectEntities (entities);
         }
         
         UpdateToolbarConponents ();
      }
      
//=================================================================================
//   create / delete / setting / move entities
//=================================================================================
      
      public function DestroyEntity (entity:Entity):void
      {
         if (mCollisionManager == null)
            return;
         
         mCollisionManager.DestroyEntity (entity);
         
         UpdateToolbarConponents ();
      }
      
      public function CreateCollisionCategory (posX:Number, posY:Number):EntityCollisionCategory
      {
         if (mCollisionManager == null)
            return null;
         
         var category:EntityCollisionCategory = mCollisionManager.CreateEntityCollisionCategory ();
         if (category == null)
            return null;
            
         category.SetPosition (posX, posY);
         
         SetTheOnlySelectedEntity (category);
         
         UpdateToolbarConponents ();
         
         return category;
      }
      
      public function CreateOrBreakCollisionCategoryFriendLink (fromCategory:EntityCollisionCategory, posX2:Number, posY2:Number):void
      {
         if (mCollisionManager == null)
            return;
         
         if (fromCategory == null)
            return;
            
         var toEntityArray:Array = mCollisionManager.GetEntitiesAtPoint (posX2, posY2);
         
         var toCategory:EntityCollisionCategory = null;
         
         for (var i:int = 0; i < toEntityArray.length; ++ i)
         {
            if (toEntityArray[i] is EntityCollisionCategory)
            {
               toCategory = toEntityArray[i] as EntityCollisionCategory;
               break;
            }
         }
         
         if (toCategory == null || toCategory == fromCategory)
         {
            return;
         }
         
         mCollisionManager.CreateOrBreakEntityCollisionCategoryFriendLink (fromCategory, toCategory);
      }
      
      public function MoveSelectedEntities (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean):void
      {
         if (mCollisionManager == null)
            return;
         
         mCollisionManager.MoveSelectedEntities (offsetX, offsetY, updateSelectionProxy);
         
         UpdateFriendLinkLines ();
      }
      
      public function DeleteSelectedEntities ():void
      {
         if (mCollisionManager == null)
            return;
         
         mCollisionManager.DeleteSelectedEntities ();
         
         UpdateFriendLinkLines ();
         
         UpdateToolbarConponents ();
      }
      
      public function SetTheSelectedCategoryCollideInternally (collide:Boolean):void
      {
         if (mCollisionManager == null)
            return;
         
         if (mCollisionManager.GetSelectedEntities ().length != 1)
            return;
         
         var category:EntityCollisionCategory = mCollisionManager.GetSelectedEntities () [0] as EntityCollisionCategory;
         
         category.SetCollideInternally (collide);
         category.UpdateAppearance ();
      }
      
      public function SetTheSelectedCategoryDefaultCategory (isDefault:Boolean):void
      {
         if (mCollisionManager == null)
            return;
         
         if (mCollisionManager.GetSelectedEntities ().length != 1)
            return;
         
         var category:EntityCollisionCategory = mCollisionManager.GetSelectedEntities () [0] as EntityCollisionCategory;
         
         category.SetDefaultCategory (isDefault);
         category.UpdateAppearance ();
      }
      
      public function SetTheSelectedCategoryName (ccName:String):void
      {
         if (mCollisionManager == null)
            return;
         
         if (mCollisionManager.GetSelectedEntities ().length != 1)
            return;
         
         var category:EntityCollisionCategory = mCollisionManager.GetSelectedEntities () [0] as EntityCollisionCategory;
         
         category.SetCategoryName (ccName);
         category.UpdateAppearance ();
         
         UpdateToolbarConponents ();
      }
      
   }
}