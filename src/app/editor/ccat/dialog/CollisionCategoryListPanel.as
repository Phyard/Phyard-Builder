
package editor.ccat.dialog {
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
   
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.controls.Label;
   import mx.controls.TextInput;
   import mx.controls.RadioButton;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.asset.Asset;
   import editor.asset.AssetManagerPanel;
   import editor.asset.Linkable;
   
   import editor.asset.IntentPutAsset;
   
   import editor.ccat.CollisionCategoryManager;
   import editor.ccat.CollisionCategory;
   
   import common.Define;
   import common.Version;
   
   public class CollisionCategoryListPanel extends AssetManagerPanel
   {
      private var mCollisionCategoryManager:CollisionCategoryManager = null;
      
      public function SetCollisionCategoryManager (collisionCategoryManager:CollisionCategoryManager):void
      {  
         if (mCollisionCategoryManager != collisionCategoryManager)
         {
            mCollisionCategoryManager = collisionCategoryManager;
         }
         
         super.SetAssetManager (collisionCategoryManager);
         
         UpdateInterface ();
      }
      
//============================================================================
//   
//============================================================================
      
      override public function UpdateInterface ():void
      {
         var numCategories:int = 0;
         var numSelecteds:int = 0;
         var onlySelected:CollisionCategory = null;
         if (mCollisionCategoryManager != null)
         {
            numCategories = mCollisionCategoryManager.GetNumCollisionCategories ();
            
            var selecteds:Array = mCollisionCategoryManager.GetSelectedAssets ();
            numSelecteds = selecteds.length;
            
            if (numSelecteds == 1)
               onlySelected = selecteds [0] as CollisionCategory;
         }
         
         mButtonCreateCollisionCategory.enabled = (mCollisionCategoryManager != null) && (numCategories < Define.MaxCCatsCount - 1);
         
         mButtonDelete.enabled = numSelecteds > 0;
         
         mLabelName.enabled = numSelecteds == 1;
         mTextInputName.enabled = numSelecteds == 1;
         mCheckBoxCollideInternally.enabled = numSelecteds == 1;
         mCheckBoxDefaultCategory.enabled = numSelecteds == 1;
         
         if (onlySelected != null)
         {
            mCheckBoxCollideInternally.selected = onlySelected.IsCollideInternally ();
            mCheckBoxDefaultCategory.selected = onlySelected.IsDefaultCategory ();
            mTextInputName.text = onlySelected.GetCategoryName ();
         }
         else
         {
            mCheckBoxCollideInternally.selected = false;
            mCheckBoxDefaultCategory.selected = false;
            mTextInputName.text = "";
         }
      }
      
      override public function CreateOrBreakAssetLink (startLinkable:Linkable, mStartManagerX:Number, mStartManagerY:Number, endManagerX:Number, endManagerY:Number):void
      {
         if (mCollisionCategoryManager == null)
            return;
         
         var fromCategory:CollisionCategory = startLinkable as CollisionCategory;
         if (fromCategory == null)
            return;
            
         var toAssetArray:Array = mCollisionCategoryManager.GetAssetsAtPoint (endManagerX, endManagerY);
         
         var toCategory:CollisionCategory = null;
         
         for (var i:int = 0; i < toAssetArray.length; ++ i)
         {
            if (toAssetArray[i] is CollisionCategory)
            {
               toCategory = toAssetArray[i] as CollisionCategory;
               break;
            }
         }
         
         if (toCategory == null || toCategory == fromCategory)
         {
            return;
         }
         
         mCollisionCategoryManager.CreateOrBreakCollisionCategoryFriendLink (fromCategory, toCategory);
      }
      
      override protected function UpdateAssetLinkLines ():void
      {
         if (mCollisionCategoryManager == null)
            return;
         
         GraphicsUtil.Clear (mAssetLinksLayer);
         
         var friendPairs:Array = mCollisionCategoryManager.GetCollisionCategoryFriendPairs ();
         var point1:Point;
         var point2:Point;
         var friend1:CollisionCategory;
         var friend2:CollisionCategory;
         
         for (var i:int = 0; i <  friendPairs.length; ++ i)
         {
            friend1 = friendPairs [i].mCategory1;
            friend2 = friendPairs [i].mCategory2;
            
            point1 = ManagerToPanel (new Point (friend1.x, friend1.y) );
            point2 = ManagerToPanel (new Point (friend2.x, friend2.y) );
            
            GraphicsUtil.DrawLine (mAssetLinksLayer, point1.x, point1.y, point2.x, point2.y, 0x0000FF, 2);
         }
      }
      
//============================================================================
//   
//============================================================================
      
      public var mButtonCreateCollisionCategory:Button;
      
      private var mCurrentSelectedCreateButton:Button = null;
      
      protected function OnCreatingFinished (asset:Asset):void
      {
         if (mCurrentSelectedCreateButton != null)
            mCurrentSelectedCreateButton.selected = false;
         
         mCurrentSelectedCreateButton = null;
         
         OnAssetSelectionsChanged (false);
      }
      
      protected function OnCreatingCancelled (asset:Asset = null):void
      {
         DeleteSelectedAssets ();
         OnAssetSelectionsChanged ();
                  
         if (mCurrentSelectedCreateButton != null)
            mCurrentSelectedCreateButton.selected = false;
         
         mCurrentSelectedCreateButton = null;
      }
      
      protected function OnPutingCreating (asset:Asset, done:Boolean):void
      {
         if (done)
         {
            OnCreatingFinished (asset);
         }
      }
      
      public function OnCreateButtonClick (event:MouseEvent):void
      {
         if (! event.target is Button)
            return;
         
         SetCurrentIntent (null);
         
         // cancel old
         if (mCurrentSelectedCreateButton == event.target)
         {
            mCurrentSelectedCreateButton = null;
            return;
         }
         
         mCurrentSelectedCreateButton = event.target as Button;
         
         switch (event.target)
         {
            case mButtonCreateCollisionCategory:
               SetCurrentIntent (new IntentPutAsset (
                                 mCollisionCategoryManager.CreateCollisionCategory (null, null, true), 
                                 OnPutingCreating, OnCreatingCancelled));
               break;
         // ...
            default:
               SetCurrentIntent (null);
               break;
         }
         
      }
      
      public var mButtonDelete:Button;
      public var mCheckBoxCollideInternally:CheckBox;
      public var mCheckBoxDefaultCategory:CheckBox;
      
      public function OnEditButtonClick (event:MouseEvent):void
      {
         switch (event.target)
         {
            case mButtonDelete:
               DeleteSelectedAssets ();
               break;
            case mCheckBoxCollideInternally:
               SetTheSelectedCategoryCollideInternally (mCheckBoxCollideInternally.selected);
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
            if (mCollisionCategoryManager == null)
               return;
            
            if (mCollisionCategoryManager.GetSelectedAssets ().length != 1)
               return;
            
            var category:CollisionCategory = mCollisionCategoryManager.GetSelectedAssets () [0] as CollisionCategory;
            
            //category.SetCategoryName (mTextInputName.text);
            category.SetName (mTextInputName.text);
            category.UpdateTimeModified ();
            
            mCollisionCategoryManager.SetChanged (true);
            
            category.UpdateAppearance ();
            
            UpdateInterface ();
         }
      }
      
      public function SetTheSelectedCategoryCollideInternally (collide:Boolean):void
      {
         if (mCollisionCategoryManager == null)
            return;
         
         if (mCollisionCategoryManager.GetSelectedAssets ().length != 1)
            return;
         
         var category:CollisionCategory = mCollisionCategoryManager.GetSelectedAssets () [0] as CollisionCategory;
         
         category.SetCollideInternally (collide);
         category.UpdateAppearance ();
      }
      
      public function SetTheSelectedCategoryDefaultCategory (isDefault:Boolean):void
      {
         if (mCollisionCategoryManager == null)
            return;
         
         if (mCollisionCategoryManager.GetSelectedAssets ().length != 1)
            return;
         
         var category:CollisionCategory = mCollisionCategoryManager.GetSelectedAssets () [0] as CollisionCategory;
         
         category.SetAsDefaultCategory (isDefault);
         category.UpdateAppearance ();
      }
      
//============================================================================
//   
//============================================================================
      
   }
}
