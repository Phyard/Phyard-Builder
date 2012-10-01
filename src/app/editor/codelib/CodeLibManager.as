
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
   import editor.world.CoreFunctionDeclarationsForPlaying;
   
   import editor.asset.Asset; 
   import editor.asset.AssetManager;
   
   import editor.entity.Scene;
   
   import editor.trigger.FunctionMenuGroup;
   import editor.trigger.FunctionDeclaration;
   import editor.trigger.VariableSpaceSession;
   import editor.trigger.VariableSpaceGlobal;
   import editor.trigger.VariableSpaceEntityProperties;
   
   import editor.EditorContext;
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class CodeLibManager extends AssetManager
   {
      protected var mScene:Scene;
      
      public function CodeLibManager (scene:Scene)
      {
         super ();
         
         mScene = scene;
         
         // session variable space
         
         mSessionVariableSpace = new VariableSpaceSession (/*this*/);
         
         // custom global variable space
         
         mGlobalVariableSpace = new VariableSpaceGlobal (/*this*/);
         
         // custom entity property space
         
         mEntityVariableSpace = new VariableSpaceEntityProperties (/*this*/);
         
         // register variables
         // put in World now
         
         // memo: which packages and classes introduced later,
         //       put them in seperated PacakgeManager and ClassManager.
         //       3 manager layers: function layer, pacakge layer, class layer
      }
      
      public function GetScene ():Scene
      {
         return mScene;
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
      
      override public function DestroyAllAssets ():void
      {
         mSessionVariableSpace.DestroyAllVariableInstances ();
         mGlobalVariableSpace.DestroyAllVariableInstances ();
         mEntityVariableSpace.DestroyAllVariableInstances ();
         
         super.DestroyAllAssets ();
      }
      
//==============================
// 
//==============================
      
      // session variables
      private var mSessionVariableSpace:VariableSpaceSession;
      
      // custom global variables
      private var mGlobalVariableSpace:VariableSpaceGlobal;
      
      // custom entity properties
      private var mEntityVariableSpace:VariableSpaceEntityProperties;
      
      // register variables
      // put in World now.
      
      public function GetSessionVariableSpace ():VariableSpaceSession
      {
         return mSessionVariableSpace;
      }
      
      public function GetGlobalVariableSpace ():VariableSpaceGlobal
      {
         return mGlobalVariableSpace;
      }
      
      public function GetEntityVariableSpace ():VariableSpaceEntityProperties
      {
         return mEntityVariableSpace;
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
      
      public function CreateFunction (key:String, funcName:String = null, designDependent:Boolean = false, selectIt:Boolean = false):AssetFunction
      {
         if (funcName == null)
            funcName = Define.FunctionDefaultName;
         
         var aFunction:AssetFunction = new AssetFunction (this, ValidateAssetKey (key));
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
      
      public function UpdateFunctionMenu ():void
      {
         if (mCustomMenuGroup == null)
            return;
         
         mCustomMenuGroup.Clear ();
         
         // mCustomMenuGroup.AddChildMenuGroup ();
         // mCustomMenuGroup.AddFunctionDeclaration ();
         
         for (var i:int = 0; i < mFunctionAssets.length; ++ i)
         {
            mCustomMenuGroup.AddFunctionDeclaration ((mFunctionAssets [i] as AssetFunction).GetFunctionDeclaration ());
         }
         
         //EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().UpdateCustomFunctionMenu ();
         UpdateCustomMenu ();
      }

      public function UpdateCustomMenu ():void
      {
         var parent:XML;

         parent = mMenuBarDataProvider_Longer.menuitem.(@name=="Custom")[0].parent ();
         delete mMenuBarDataProvider_Longer.menuitem.(@name=="Custom")[0];

         ConvertMenuGroupToXML (mCustomMenuGroup, parent, null)

         parent = mMenuBarDataProvider_Shorter.menuitem.(@name=="Custom")[0].parent ();
         delete mMenuBarDataProvider_Shorter.menuitem.(@name=="Custom")[0];

         ConvertMenuGroupToXML (mCustomMenuGroup, parent, null)
      }
      
      //========================

      private var mCustomMenuGroup:FunctionMenuGroup = new FunctionMenuGroup ("Custom");

      private var mMenuBarDataProvider_Shorter:XML = CreateXmlFromMenuGroups (CoreFunctionDeclarationsForPlaying.GetMenuGroupsForShorterMenuBar ().concat ([mCustomMenuGroup]));
      private var mMenuBarDataProvider_Longer:XML = CreateXmlFromMenuGroups (CoreFunctionDeclarationsForPlaying.GetMenuGroupsForLongerMenuBar ().concat ([mCustomMenuGroup]));
      
      public function GetShorterMenuBarDataProvider ():XML
      {
         return mMenuBarDataProvider_Shorter;
      }

      public function GetLongerMenuBarDataProvider ():XML
      {
         return mMenuBarDataProvider_Longer;
      }

      // top level
      private static function CreateXmlFromMenuGroups (packages:Array):XML
      {
         var xml:XML = <root />;

         for each (var functionMenuGroup:FunctionMenuGroup in packages)
         {
            ConvertMenuGroupToXML (functionMenuGroup, xml, packages);
         }

         return xml;
      }

      private static function ConvertMenuGroupToXML (functionMenuGroup:FunctionMenuGroup, parentXml:XML, topMenuGroups:Array):void
      {
         var package_element:XML = <menuitem />;
         package_element.@name = functionMenuGroup.GetName ();
         parentXml.appendChild (package_element);

         var num_items:int = 0;

         var child_packages:Array = functionMenuGroup.GetChildMenuGroups ();
         for (var i:int = 0; i < child_packages.length; ++ i)
         {
            if (topMenuGroups == null || topMenuGroups.indexOf (child_packages [i]) < 0)
            {
               ConvertMenuGroupToXML (child_packages [i] as FunctionMenuGroup, package_element, topMenuGroups);

               ++ num_items;
            }
         }

         var declarations:Array = functionMenuGroup.GetFunctionDeclarations ();
         var declaration:FunctionDeclaration;
         var function_element:XML;
         for (var j:int = 0; j < declarations.length; ++ j)
         {
            declaration = declarations [j] as FunctionDeclaration;
            if (declaration.IsShowUpInApiMenu ())
            {
               function_element = <menuitem />;
               function_element.@name = declaration.GetName ();
               function_element.@id = declaration.GetID ();
               function_element.@type = declaration.GetType ();

               package_element.appendChild (function_element);

               ++ num_items;
            }
         }

         if (num_items == 0)
         {
            function_element = <menuitem />;
            function_element.@name = "[nothing]";
            function_element.@id = -1;

            package_element.appendChild (function_element);
         }
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

