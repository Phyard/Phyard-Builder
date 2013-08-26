
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
   import editor.world.CoreClasses;
   import editor.world.CoreFunctionDeclarationsForPlaying;
   
   import editor.asset.Asset; 
   import editor.asset.AssetManager;
   
   import editor.entity.Scene;
   
   import editor.trigger.*;
   
   import editor.EditorContext;
   
   import common.trigger.CoreClassIds;
   import common.trigger.ClassTypeDefine;
   
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
         var index:int;
         
         if (asset is AssetFunction)
         {
            index = mFunctionAssets.indexOf (asset);
            if (index >= 0) // must be
            {
               //delete mNameLookupTable[ (asset as AssetFunction).GetFunctionName () ];
               (asset as AssetFunction).SetFunctionIndex (-1);
               mFunctionAssets.splice (index, 1);
               
               UpdateFunctionIndexes ();
               UpdateFunctionAppearances ();
            }
         }
         
         if (asset is AssetClass)
         {
            index = mClassAssets.indexOf (asset);
            if (index >= 0) // must be
            {
               //delete mNameLookupTable[(asset as AssetFunction).GetFunctionName ()];
               (asset as AssetClass).SetClassIndex (-1);
               mClassAssets.splice (index, 1);
               
               UpdateClassIndexes ();
               UpdateClassAppearances ();
            }
         }
         
         if (asset is AssetPackage)
         {
            index = mPackageAssets.indexOf (asset);
            if (index >= 0) // must be
            {
               //delete mNameLookupTable[ (asset as AssetFunction).GetFunctionName () ];
               (asset as AssetPackage).SetPackageIndex (-1);
               mPackageAssets.splice (index, 1);
               
               UpdatePackageIndexes ();
               UpdatePackageAppearances ();
            }
         }
         
         SetChanged (true);
         
         super.DestroyAsset (asset);
      }
      
      override public function DestroyAllAssets ():void
      {
         mSessionVariableSpace.DestroyAllVariableInstances ();
         mGlobalVariableSpace.DestroyAllVariableInstances ();
         mEntityVariableSpace.DestroyAllVariableInstances ();
         
         mFunctionAssets.splice (0, mFunctionAssets.length);
         mClassAssets.splice (0, mClassAssets.length);
         mPackageAssets.splice (0, mPackageAssets.length);
         
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
// function / type / package lists
//===============================
      
      private var mFunctionAssets:Array = new Array ();
      private var mClassAssets:Array = new Array ();
      private var mPackageAssets:Array = new Array ();
      
      public function GetNumFunctions ():int
      {
         return mFunctionAssets.length;
      }
      
      public function GetNumClasses ():int
      {
         return mClassAssets.length;
      }
      
      public function GetNumPackages ():int
      {
         return mPackageAssets.length;
      }
      
      public function GetFunctionByIndex (index:int):AssetFunction
      {
         if (index < 0 || index >= mFunctionAssets.length)
            return null;
         
         return mFunctionAssets [index] as AssetFunction;
      }
      
      public function GetClassByIndex (index:int):AssetClass
      {
         if (index < 0 || index >= mClassAssets.length)
            return null;
         
         return mClassAssets [index] as AssetClass;
      }
      
      public function GetCustomClass (index:int):ClassDefinition_Custom
      {
         var classAsset:AssetClass = GetClassByIndex (index);
         return classAsset == null ? null : classAsset.GetCustomClass ();
      }
      
      public function GetPackageByIndex (index:int):AssetPackage
      {
         if (index < 0 || index >= mPackageAssets.length)
            return null;
         
         return mPackageAssets [index] as AssetPackage;
      }
      
      public function UpdateFunctionIndexes ():void
      {
         for (var index:int = 0; index < mFunctionAssets.length; ++ index)
         {
            (mFunctionAssets [index] as AssetFunction).SetFunctionIndex (index);
         }
      }
      
      public function UpdateClassIndexes ():void
      {
         for (var index:int = 0; index < mClassAssets.length; ++ index)
         {
            (mClassAssets [index] as AssetClass).SetClassIndex (index);
         }
      }
      
      public function UpdatePackageIndexes ():void
      {
         for (var index:int = 0; index < mPackageAssets.length; ++ index)
         {
            (mPackageAssets [index] as AssetPackage).SetPackageIndex (index);
         }
      }
      
      public function CreateFunction (key:String, funcName:String = null, designDependent:Boolean = false, selectIt:Boolean = false):AssetFunction
      {
         if (funcName == null)
            funcName = Define.FunctionDefaultName;
         
         var aFunction:AssetFunction = new AssetFunction (this, ValidateAssetKey (key), GetRecommendAssetName (funcName));
         addChild (aFunction);
         
         mFunctionAssets.push (aFunction);
         
         //aFunction.SetFunctionName (GetFunctionRecommendName (funcName), false); // moved to above
         aFunction.SetDesignDependent (designDependent);
         
         //mNameLookupTable [aFunction.GetFunctionName ()] = aFunction;
         
         UpdateFunctionIndexes ();
         
         if (selectIt)
         {
            aFunction.SetPosition (mouseX, mouseY);
            SetSelectedAsset (aFunction);
         }
         
         SetChanged (true);
         
         return aFunction;
      }
      
      public function CreateClass (key:String, typeName:String = null/*, designDependent:Boolean = false*/, selectIt:Boolean = false):AssetClass
      {
         if (typeName == null)
            typeName = Define.ClassDefaultName;
         
         var aClass:AssetClass = new AssetClass (this, ValidateAssetKey (key), GetRecommendAssetName (typeName));
         addChild (aClass);
         
         mClassAssets.push (aClass);
         
         //aFunction.SetFunctionName (GetFunctionRecommendName (funcName), false); // moved to above
         
         //mNameLookupTable [aFunction.GetFunctionName ()] = aFunction;
         
         UpdateClassIndexes ();
         
         if (selectIt)
         {
            aClass.SetPosition (mouseX, mouseY);
            SetSelectedAsset (aClass);
         }
         
         SetChanged (true);
         
         return aClass;
      }
      
      public function CreatePackage (key:String, typeName:String = null/*, designDependent:Boolean = false*/, selectIt:Boolean = false):AssetPackage
      {
         if (typeName == null)
            typeName = Define.PackageDefaultName;
         
         var aPackage:AssetPackage = new AssetPackage (this, ValidateAssetKey (key), GetRecommendAssetName (typeName));
         addChild (aPackage);
         
         mPackageAssets.push (aPackage);
         
         //aFunction.SetFunctionName (GetFunctionRecommendName (funcName), false); // moved to above
         
         //mNameLookupTable [aFunction.GetFunctionName ()] = aFunction;
         
         UpdatePackageIndexes ();
         
         if (selectIt)
         {
            aPackage.SetPosition (mouseX, mouseY);
            SetSelectedAsset (aPackage);
         }
         
         SetChanged (true);
         
         return aPackage;
      }
      
      public function ChangeFunctionOrderIDs (fromId:int, toId:int):void
      {
         if (fromId < 0 || fromId >= mFunctionAssets.length)
            return;
         if (toId < 0)
            toId = 0;
         if (toId >= mFunctionAssets.length)
            toId = mFunctionAssets.length - 1;
         
         var aFunction:AssetFunction = mFunctionAssets [fromId] as AssetFunction;
         mFunctionAssets.splice (fromId, 1);
         mFunctionAssets.splice (toId, 0, aFunction);
         
         // ...
         
         UpdateFunctionIndexes ();
         
         SetChanged (true);
         
         UpdateFunctionAppearances ();
      }
      
      public function ChangeClassOrderIDs (fromId:int, toId:int):void
      {
         if (fromId < 0 || fromId >= mClassAssets.length)
            return;
         if (toId < 0)
            toId = 0;
         if (toId >= mClassAssets.length)
            toId = mClassAssets.length - 1;
         
         var aClass:AssetClass = mClassAssets [fromId] as AssetClass;
         mClassAssets.splice (fromId, 1);
         mClassAssets.splice (toId, 0, aClass);
         
         // ...
         
         UpdateClassIndexes ();
         
         SetChanged (true);
         
         UpdateClassAppearances ();
      }
      
      public function ChangePackageOrderIDs (fromId:int, toId:int):void
      {
         if (fromId < 0 || fromId >= mPackageAssets.length)
            return;
         if (toId < 0)
            toId = 0;
         if (toId >= mPackageAssets.length)
            toId = mPackageAssets.length - 1;
         
         var aPackage:AssetPackage = mPackageAssets [fromId] as AssetPackage;
         mPackageAssets.splice (fromId, 1);
         mPackageAssets.splice (toId, 0, aPackage);
         
         // ...
         
         UpdatePackageIndexes ();
         
         SetChanged (true);
         
         UpdatePackageAppearances ();
      }
      
      private function UpdateFunctionAppearances ():void
      {
         // ids changed, maybe
         for each (var aFunction:AssetFunction in mFunctionAssets)
         {
            aFunction.UpdateAppearance ();
         }
      }
      
      private function UpdateClassAppearances ():void
      {
         // ids changed, maybe
         for each (var aClass:AssetClass in mClassAssets)
         {
            aClass.UpdateAppearance ();
         }
      }
      
      private function UpdatePackageAppearances ():void
      {
         // ids changed, maybe
         for each (var aPackage:AssetPackage in mPackageAssets)
         {
            aPackage.UpdateAppearance ();
         }
      }
      
      //private var mNameLookupTable:Dictionary = new Dictionary ();
      
      //private function GetFunctionRecommendName (functionName:String):String
      //{
      //   var n:int = 1;
      //   var functionNameN:String = functionName;
      //   while (true)
      //   {
      //      if (mNameLookupTable [functionNameN] == null)
      //         return functionNameN;
      //      
      //      functionNameN = functionName + " " + (n ++);
      //   }
      //   
      //   return null;
      //}
      
      //public function ChangeFunctionName (newName:String, oldName:String):void
      //{
      //   if (oldName == null)
      //      return;
      //   if (newName == null)
      //      return;
      //   if (newName.length < Define.MinEntityNameLength)
      //      return;
      //   
      //   var aFunction:AssetFunction = mNameLookupTable [oldName];
      //   
      //   if (aFunction == null)
      //      return;
      //   
      //   delete mNameLookupTable [oldName];
      //   
      //   if (newName.length > Define.MaxEntityNameLength)
      //      newName = newName.substr (0, Define.MaxEntityNameLength);
      //   
      //   newName = GetFunctionRecommendName (newName);
      //   
      //   mNameLookupTable [newName] = aFunction;
      //   
      //   if (newName == oldName)
      //   {
      //      return;
      //   }
      //   
      //   aFunction.SetFunctionName (newName, false);
      //   
      //   SetChanged (true);
      //}
      
//=============================================
// draw links
//=============================================
      
      override public function DrawAssetLinks (canvasSprite:Sprite, forceDraw:Boolean):void
      {
         DrawAssetsLinks_Default (canvasSprite, forceDraw);
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
         if (mCustomCodePackage == null)
            return;
         
         mCustomCodePackage.Clear ();
         
         // mCustomCodePackage.AddChildCodePackage ();
         // mCustomCodePackage.AddFunctionDeclaration ();
         
         var i:int;
         
         if (mFunctionAssets.length > 16)
         {
            var numGroups:int = Math.floor ((mFunctionAssets.length + 15) / 16);
            for (var g:int = 0; g < numGroups; ++ g)
            {
               var fromId:int = g * 16;
               var toId:int = fromId + 16;
               if (toId > mFunctionAssets.length)
                  toId = mFunctionAssets.length;
               
               var aCodePackage:CodePackage = new CodePackage (fromId + " - " + (toId - 1));
               mCustomCodePackage.AddChildCodePackage (aCodePackage);
               
               for (i = fromId; i < toId; ++ i)
               {
                  aCodePackage.AddFunctionDeclaration ((mFunctionAssets [i] as AssetFunction).GetFunctionDeclaration ());
               }
            }
         }
         else
         {
            for (i = 0; i < mFunctionAssets.length; ++ i)
            {
               mCustomCodePackage.AddFunctionDeclaration ((mFunctionAssets [i] as AssetFunction).GetFunctionDeclaration ());
            }
         }
         
         //EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().UpdateCustomFunctionMenu ();
         UpdateCustomMenu ();
      }

      public function UpdateCustomMenu ():void
      {
         var parent:XML;

         parent = mMenuBarDataProvider_Longer.menuitem.(@name=="Custom")[0].parent ();
         delete mMenuBarDataProvider_Longer.menuitem.(@name=="Custom")[0];

         ConvertFunctionCodePackageToXML (mCustomCodePackage, parent, null);

         parent = mMenuBarDataProvider_Shorter.menuitem.(@name=="Custom")[0].parent ();
         delete mMenuBarDataProvider_Shorter.menuitem.(@name=="Custom")[0];

         ConvertFunctionCodePackageToXML (mCustomCodePackage, parent, null);
      }
      
      //========================

      private static var kCoreTypesDataProvider:XML = null;

      public static function GetCoreTypesDataProvider ():XML
      {
         if (kCoreTypesDataProvider != null)
            return kCoreTypesDataProvider;
         
         var topPackage:CodePackage = CoreClasses.GetCoreClassPackage ();
         
         kCoreTypesDataProvider = ConvertClassCodePackageToXML (topPackage, null);
         
         return kCoreTypesDataProvider;
      }
      
      // to enhance
      private static function ConvertClassCodePackageToXML (classCodePackage:CodePackage, parentXml:XML = null):XML
      {
         var package_element:XML = <menuitem />;
         package_element.@label = classCodePackage.GetName ();
         
         if (parentXml != null)
            parentXml.appendChild (package_element);
         
         var num_items:int = 0;

         var child_packages:Array = classCodePackage.GetChildCodePackages ();
         for (var i:int = 0; i < child_packages.length; ++ i)
         {
            ConvertClassCodePackageToXML (child_packages [i] as CodePackage, package_element);

            ++ num_items;
         }

         var theClasses:Array = classCodePackage.GetClasses ();
         var aClass:ClassDefinition;
         var class_element:XML;
         for (var j:int = 0; j < theClasses.length; ++ j)
         {
            aClass = theClasses [j] as ClassDefinition;
            //if (aClass.IsShowUpInApiMenu ())
            //{
               class_element = <menuitem />;
               class_element.@label = aClass.GetName ();
               class_element.@id = aClass.GetID ();
               class_element.@type = aClass.GetClassType ();
               class_element.@scene_data_dependent = aClass.IsSceneDataDependent ();
   
               package_element.appendChild (class_element);

               ++ num_items;
            //}
         }

         if (num_items == 0)
         {
            class_element = <menuitem />;
            class_element.@label = "[nothing]";
            class_element.@id = -1;
            class_element.@type = ClassTypeDefine.ClassType_Unknown;

            package_element.appendChild (class_element);
         }
         
         return package_element;
      }

      public function GetCustomTypesDataProvider ():XML
      {
         if (mClassAssets.length == 0)
            return null;
         
         var top_element:XML = <menuitem />;
         top_element.@label = "Custom";
         
         var aClass:AssetClass;
         var type_element:XML;
         for (var typeId:int = 0; typeId < mClassAssets.length; ++ typeId)
         {
            aClass = mClassAssets [typeId] as AssetClass;
            
            type_element = <menuitem />;
            type_element.@label = aClass.GetName ();
            type_element.@id = typeId;
            type_element.@type = ClassTypeDefine.ClassType_Custom;

            top_element.appendChild (type_element);
         }
         
         return top_element;
      }
      
      private var mCustomCodePackage:CodePackage = new CodePackage ("Custom");

      private var mMenuBarDataProvider_Shorter:XML = CreateXmlFromCodePackages (CoreFunctionDeclarationsForPlaying.GetCodePackagesForShorterMenuBar ().concat ([mCustomCodePackage]));
      private var mMenuBarDataProvider_Longer :XML = CreateXmlFromCodePackages (CoreFunctionDeclarationsForPlaying.GetCodePackagesForLongerMenuBar ().concat ([mCustomCodePackage]));
      
      public function GetShorterMenuBarDataProvider ():XML
      {
         return mMenuBarDataProvider_Shorter;
      }

      public function GetLongerMenuBarDataProvider ():XML
      {
         return mMenuBarDataProvider_Longer;
      }

      // top level
      private static function CreateXmlFromCodePackages (packages:Array):XML
      {
         var xml:XML = <root />;

         for each (var functionCodePackage:CodePackage in packages)
         {
            ConvertFunctionCodePackageToXML (functionCodePackage, xml, packages);
         }

         return xml;
      }

      private static function ConvertFunctionCodePackageToXML (functionCodePackage:CodePackage, parentXml:XML, topCodePackages:Array):void
      {
         var package_element:XML = <menuitem />;
         package_element.@name = functionCodePackage.GetName ();
         parentXml.appendChild (package_element);

         var num_items:int = 0;

         var child_packages:Array = functionCodePackage.GetChildCodePackages ();
         for (var i:int = 0; i < child_packages.length; ++ i)
         {
            if (topCodePackages == null || topCodePackages.indexOf (child_packages [i]) < 0)
            {
               ConvertFunctionCodePackageToXML (child_packages [i] as CodePackage, package_element, topCodePackages);

               ++ num_items;
            }
         }

         var declarations:Array = functionCodePackage.GetFunctionDeclarations ();
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
// custom variable definition
//=====================================================================

      // variableName == nul means default name
      public function CreateCustomVariableDefinition (classId:int, variableName:String = null):VariableDefinition
      {
         var classAsset:AssetClass = GetClassByIndex (classId);
         if (classAsset != null)
         {
            var customClass:ClassDefinition_Custom = classAsset.GetCustomClass ();
            
            if (variableName == null)
               variableName = customClass.GetDefaultInstanceName ();
            
            return new VariableDefinition_Custom (customClass, variableName);
         }
         
         throw new Error ("unknown class in CreateCustomVariableDefinition");
      }

      // scene can be null if classType is core.
      public static function CreateVariableDefinition (codelibManager:CodeLibManager, classType:int, valueType:int, variableName:String = null):VariableDefinition
      {
         var variableDefinition:VariableDefinition;
         
         if (classType == ClassTypeDefine.ClassType_Custom)
         {
            if (codelibManager == null)
               throw new Error ("codelibManager can't be null.");
            
            return codelibManager.CreateCustomVariableDefinition (valueType, variableName);
         }
         else
         {
            if (variableName == null)
               variableName = World.GetCoreClassById (valueType).GetDefaultInstanceName ();
            variableDefinition = VariableDefinition.CreateCoreVariableDefinition (valueType, variableName);
         }
         
         return variableDefinition;
      }

//=====================================================================
// context menu
//=====================================================================
      
      override public function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         /*
         var menuItemLoadLocalSounds:ContextMenuItem = new ContextMenuItem("Load Local Sounds(s) ...", true);
         //var menuItemCreateSound:ContextMenuItem = new ContextMenuItem("Create Blank Sound ...");
         var menuItemDeleteSelecteds:ContextMenuItem = new ContextMenuItem("Delete Selected(s) ...", true);
         
         menuItemLoadLocalSounds.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_LocalSounds);
         //menuItemCreateSound.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_CreateSound);
         menuItemDeleteSelecteds.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_DeleteSelectedAssets);

         customMenuItemsStack.push (menuItemLoadLocalSounds);
         //customMenuItemsStack.push (menuItemCreateSound);
         customMenuItemsStack.push (menuItemDeleteSelecteds);
         */
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
   }
}

