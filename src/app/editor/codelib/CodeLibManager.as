
package editor.codelib {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   
   import flash.net.FileReferenceList;
   import flash.net.FileReference;
   import flash.net.FileFilter;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import editor.world.World;
   
   import editor.asset.Asset; 
   import editor.asset.AssetManager;
   
   import editor.trigger.FunctionMenuGroup;
   
   import editor.runtime.Runtime;
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class CodeLibManager extends AssetManager
   {
      internal  var mWorld:World; // todo: to remove
      
      public function CodeLibManager (world:World)
      {
         mWorld = world;
      }
      
      override public function SupportScaleRotateFlipTransforms ():Boolean
      {
         return false;
      }
      
      override public function DestroyAsset (asset:Asset):void
      {
         if (asset is AssetFunction)
         {
            var index:int = mFunctionAssets.indexOf (asset);
            if (index >= 0) // must be
            {
               delete mFunctionLookupTable[ (asset as AssetFunction).GetFunctionName () ];
               (asset as AssetFunction).SetFunctionIndex (-1);
               mFunctionAssets.splice (index, 1);
               
               UpdateFunctionIndexes ();
            }
         }
         
         SetChanged (true);
         
         super.DestroyAsset (asset);
         
         // ids changed, maybe
         for (var i:int = 0; i < numChildren; ++ i)
         {
            asset = getChildAt (i) as Asset;
            if (asset != null) // should be
            {
               asset.UpdateAppearance ();
            }
         }
      }
      
//===============================
// functions
//===============================
      
      private var mFunctionAssets:Array = new Array ();
      private var mFunctionLookupTable:Dictionary = new Dictionary ();
      
      public function GetNumFunctions ():int
      {
         return mFunctionAssets.length;
      }
      
      private function GetFunctionRecommendName (functionName:String):String
      {
         var n:int = 1;
         var functionNameN:String = functionName;
         while (true)
         {
            if (mFunctionLookupTable [functionNameN] == null)
               return functionNameN;
            
            functionNameN = functionName + " " + (n ++);
         }
         
         return null;
      }
      
      public function GetFunctionByIndex (index:int):AssetFunction
      {
         if (index < 0 || index >= mFunctionAssets.length)
            return null;
         
         return mFunctionAssets [index] as AssetFunction;
      }
      
      public function CreateFunction (funcName:String = null, designDependent:Boolean = false, selectIt:Boolean = false):AssetFunction
      {
         if (funcName == null)
            funcName = Define.FunctionDefaultName;
         
         var aFunction:AssetFunction = new AssetFunction (this);
         addChild (aFunction);
         
         mFunctionAssets.push (aFunction);
         
         aFunction.SetFunctionName (GetFunctionRecommendName (funcName), false);
         aFunction.SetDesignDependent (designDependent);
         
         mFunctionLookupTable [aFunction.GetFunctionName ()] = aFunction;
         
         UpdateFunctionIndexes ();
         
         if (selectIt)
         {
            aFunction.SetPosition (mouseX, mouseY);
            SetSelectedAsset (aFunction);
         }
         
         SetChanged (true);
         
         return aFunction;
      }
      
      public function ChangeFunctionName (newName:String, oldName:String):void
      {
         if (oldName == null)
            return;
         if (newName == null)
            return;
         if (newName.length < Define.MinEntityNameLength)
            return;
         
         var aFunction:AssetFunction = mFunctionLookupTable [oldName];
         
         if (aFunction == null)
            return;
         
         delete mFunctionLookupTable [oldName];
         
         if (newName.length > Define.MaxEntityNameLength)
            newName = newName.substr (0, Define.MaxEntityNameLength);
         
         newName = GetFunctionRecommendName (newName);
         
         mFunctionLookupTable [newName] = aFunction;
         
         if (newName == oldName)
         {
            return;
         }
         
         aFunction.SetFunctionName (newName, false);
         
         SetChanged (true);
      }
      
      private function UpdateFunctionIndexes ():void
      {
         for (var index:int = 0; index < mFunctionAssets.length; ++ index)
         {
            (mFunctionAssets [index] as AssetFunction).SetFunctionIndex (index);
         }
      }
      
//=============================================
// for undo point
//=============================================
      
      public function SetEntityLinksChangedCallback (callback:AssetFunction):void
      {
      }
      
//=============================================
// for undo point
//=============================================
      
      private var mIsChanged:Boolean = false;
      
      public function SetChanged (changed:Boolean):void
      {
         mIsChanged = changed;
         
         if (mIsChanged && mUpdateFunctionMenuAtOnce)
         {
            UpdateFunctionMenu ();
         }
      }
      
      public function IsChanged ():Boolean
      {
         return mIsChanged;
      }
      
      private var mUpdateFunctionMenuAtOnce:Boolean = true;
      
      public function SetDelayUpdateFunctionMenu (delay:Boolean):void
      {
         mUpdateFunctionMenuAtOnce = ! delay;
      }
      
//=============================================
// menu
//=============================================
      
      private var mFunctionMenuGroup:FunctionMenuGroup;
      
      public function SetFunctionMenuGroup (menuGroup:FunctionMenuGroup):void
      {
         mFunctionMenuGroup = menuGroup;
      }
      
      public function UpdateFunctionMenu ():void
      {
         if (mFunctionMenuGroup == null)
            return;
         
         mFunctionMenuGroup.Clear ();
         
         // mFunctionMenuGroup.AddChildMenuGroup ();
         // mFunctionMenuGroup.AddFunctionDeclaration ();
         
         for (var i:int = 0; i < mFunctionAssets.length; ++ i)
         {
            mFunctionMenuGroup.AddFunctionDeclaration ((mFunctionAssets [i] as AssetFunction).GetFunctionDeclaration ());
         }
         
         Runtime.GetCurrentWorld ().GetTriggerEngine ().UpdateCustomFunctionMenu ();
      }
        
//=====================================================================
// context menu
//=====================================================================
      
      override public function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         /*
         var menuItemLoadLocalSoundss:ContextMenuItem = new ContextMenuItem("Load Local Sounds(s) ...", true);
         //var menuItemCreateSound:ContextMenuItem = new ContextMenuItem("Create Blank Sound ...");
         var menuItemDeleteSelecteds:ContextMenuItem = new ContextMenuItem("Delete Selected(s) ...", true);
         
         menuItemLoadLocalSoundss.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_LocalSounds);
         //menuItemCreateSound.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_CreateSound);
         menuItemDeleteSelecteds.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_DeleteSelectedAssets);

         customMenuItemsStack.push (menuItemLoadLocalSoundss);
         //customMenuItemsStack.push (menuItemCreateSound);
         customMenuItemsStack.push (menuItemDeleteSelecteds);
         */
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      /*
      private function OnContextMenuEvent_CreateSound (event:ContextMenuEvent):void
      {
         CreateSound (true);
      }
      
      private function OnContextMenuEvent_LocalSounds (event:ContextMenuEvent):void
      {
         OpenLocalSoundFileDialog ();
      }
      
      private function OnContextMenuEvent_DeleteSelectedAssets (event:ContextMenuEvent):void
      {
         DeleteSelectedAssets ();
      }
      */
      
   }
}

