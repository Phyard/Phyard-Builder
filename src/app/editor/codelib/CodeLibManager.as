
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
   import editor.world.CoreClassesHub;
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
               (asset as AssetFunction).SetFunctionIndex (-1);
               mFunctionAssets.splice (index, 1);

               // ... todo
               //RemoveReferencesOfFunction (asset as AssetFunction);
               
               //delete mNameLookupTable[ (asset as AssetFunction).GetFunctionName () ];
               
               UpdateFunctionIndexes ();
               UpdateFunctionAppearances ();
            }
         }
         else if (asset is AssetClass)
         {
            index = mClassAssets.indexOf (asset);
            if (index >= 0) // must be
            {
               (asset as AssetClass).SetClassIndex (-1); // should before calling RemoveReferencesOfClass
               mClassAssets.splice (index, 1);

               // ...
               //RemoveReferencesOfClass (asset as AssetClass);
               RemoveReferencesOfInvalidClasses ();
               
               //delete mNameLookupTable[(asset as AssetFunction).GetFunctionName ()];
               
               UpdateClassIndexes ();
               UpdateClassAppearances ();
            }
         }
         else if (asset is AssetPackage)
         {
            index = mPackageAssets.indexOf (asset);
            if (index >= 0) // must be
            {
               (asset as AssetPackage).SetPackageIndex (-1);
               mPackageAssets.splice (index, 1);

               // ...
               var thePackage:AssetPackage = asset as AssetPackage;
               
               var numAssets:int = mAssetsSortedByCreationId.length;
               for (var i:uint = 0; i < numAssets; ++ i)
               {
                  var element:AssetCodeLibElement = GetAssetByCreationId (i) as AssetCodeLibElement;
                  
                  if (element != null) // && element.IsInPackage (thePackage))
                  {
                     element.RemoveFromPackage (thePackage);
                  }
               }
               
               //delete mNameLookupTable[ (asset as AssetFunction).GetFunctionName () ];
               
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
      
      //public function RemoveReferencesOfClass (theClass:AssetClass):void
      public function RemoveReferencesOfInvalidClasses ():void
      {
         //var theCustomClassDefinition:ClassDefinition_Custom = theClass.GetCustomClass ();
         
         mGlobalVariableSpace.Validate (); // RemoveReferencesOfClass (theCustomClassDefinition);
         mEntityVariableSpace.Validate (); // RemoveReferencesOfClass (theCustomClassDefinition);
         mSessionVariableSpace.Validate (); // RemoveReferencesOfClass (theCustomClassDefinition); // may be not essential
         
         var index:int;
         
         for (index = 0; index < mClassAssets.length; ++ index)
         {
            var aClass:AssetClass = mClassAssets [index] as AssetClass;
            //if (aClass != theClass)
            //{
               aClass.GetCustomClass ().GetPropertyDefinitionSpace ().Validate (); // RemoveReferencesOfClass (theCustomClassDefinition);
            //}
         }
         
         for (index = 0; index < mFunctionAssets.length; ++ index)
         {
            var aFunction:FunctionDefinition = (mFunctionAssets [index] as AssetFunction).GetFunctionDefinition ();
            aFunction.GetLocalVariableSpace ().Validate (); // RemoveReferencesOfClass (theCustomClassDefinition);
            aFunction.GetFunctionDeclaration ().GetInputVariableSpace ().Validate (); // RemoveReferencesOfClass (theCustomClassDefinition);
            aFunction.GetFunctionDeclaration ().GetOutputVariableSpace ().Validate (); // RemoveReferencesOfClass (theCustomClassDefinition);
         }
         
         // up to now, the CodeSnippets in Entities are still not validated.
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
      
      private var mIsChanged:Boolean = true; // false;
      
      public function SetChanged (changed:Boolean):void
      {
         mIsChanged = changed;
         
         //if (mIsChanged && mUpdateFunctionMenuAtOnce)
         //{
         //   UpdateFunctionMenu ();
         //}
      }
      
      public function IsChanged ():Boolean
      {
         return mIsChanged;
      }
      
      //private var mUpdateFunctionMenuAtOnce:Boolean = true;
      
      public function SetDelayUpdateFunctionMenu (delay:Boolean):void
      {
         //mUpdateFunctionMenuAtOnce = ! delay; // since v2.05, this fucntion is useless.
      }
      
      public function UpdateFunctionMenu ():void
      {
         // since v2.05, this fucntion is useless.
      }
      
//=============================================
// menu
//=============================================

      internal var mCoreAndCustomClassesDataProvider:XML = null;
      private static var sCoreClassesDataProvider:XML = null;
      private static var sSceneIndependentClassesDataProvider:XML = null;
      private static var sGameSaveClassesDataProvider:XML = null;
      
      public static function GetTypesDataProviderForMenu (codeLibManager:CodeLibManager, isCurrentSceneDataDependent:Boolean, isAnySceneDataIndependent:Boolean, isForGameSave:Boolean):XML
      {
         if (isCurrentSceneDataDependent) // codeLibManager must not be null.
         {
            if (codeLibManager.IsChanged ())
            {  
               codeLibManager.SetChanged (false);
               
               codeLibManager.UpdateDataProvidersForMenu ();
            }
            
            return codeLibManager.mCoreAndCustomClassesDataProvider;
         }
         else // codeLibManager must be null
         {
            if (isAnySceneDataIndependent)
            {
               if (isForGameSave)
               {
                  if (sGameSaveClassesDataProvider == null)
                     BuildGameSaveClassesDataProvider ();
                  
                  return sGameSaveClassesDataProvider;
               }
               else
               {
                  if (sSceneIndependentClassesDataProvider == null)
                     BuildSceneIndependentClassesDataProvider ();
                  
                  return sSceneIndependentClassesDataProvider;
               }
            }
            else // codeLibManager is null
            {
               if (sCoreClassesDataProvider == null)
                  BuildCoreClassesDataProvider ();
               
               return sCoreClassesDataProvider;
            }
         }
      }
      
      private var mFunctionsDataProviderShorter:XML = CreateXmlFromCodePackages (CoreFunctionDeclarationsForPlaying.GetCodePackagesForShorterMenuBar ().concat ([new CodePackage (kCustomPackagename)]), true);
      private var mFunctionsDataProviderLonger :XML = CreateXmlFromCodePackages (CoreFunctionDeclarationsForPlaying.GetCodePackagesForLongerMenuBar ().concat ([new CodePackage (kCustomPackagename)]), true);

      public function GetShorterMenuBarDataProvider ():XML
      {
         if (IsChanged ())
         {  
            SetChanged (false);
            
            UpdateDataProvidersForMenu ();
         }
         
         return mFunctionsDataProviderShorter;
      }

      public function GetLongerMenuBarDataProvider ():XML
      {
         if (IsChanged ())
         {  
            SetChanged (false);
            
            UpdateDataProvidersForMenu ();
         }
         
         return mFunctionsDataProviderLonger;
      }
      
   //==========================================
   // 
   //==========================================
      
      private static function BuildCoreClassesDataProvider ():void
      {
         var coreClassPackage:CodePackage = CoreClassesHub.GetCoreClassPackage ();
         
         sCoreClassesDataProvider = ConvertCodePackageToXML (coreClassPackage, null, null, false, false, false);
      }
      
      private static function BuildSceneIndependentClassesDataProvider ():void
      {
         var coreClassPackage:CodePackage = CoreClassesHub.GetCoreClassPackage ();
         
         sSceneIndependentClassesDataProvider = ConvertCodePackageToXML (coreClassPackage, null, null, false, true, false);
      }
      
      private static function BuildGameSaveClassesDataProvider ():void
      {
         var coreClassPackage:CodePackage = CoreClassesHub.GetCoreClassPackage ();
         
         sGameSaveClassesDataProvider = ConvertCodePackageToXML (coreClassPackage, null, null, false, true, true);
         
         //for each (var menuItem:Object in sGameSaveClassesDataProvider.menuitem)
         //{
         //   if (menuItem.@["scene_data_dependent"] == true)
         //   {
         //      //sGameSaveClassesDataProvider.removeChild (menuItem);
         //      delete menuItem.parent().children()[menuItem.childIndex()];
         //   }
         //}
      }
      
      public static const kCustomPackagename:String = "Custom";
      
      internal function UpdateDataProvidersForMenu ():void
      {
         var topPackage:CodePackage = new CodePackage (kCustomPackagename);

         for each (var aPackage:AssetPackage in mPackageAssets)
         {
            if (! aPackage.HasContainingPackages ())
            {
               topPackage.AddChildCodePackage (aPackage.GetCodePackageData ());
            }
         }

         for each (var aClass:AssetClass in mClassAssets)
         {
            if (! aClass.HasContainingPackages ())
            {
               topPackage.AddClass (aClass.GetCustomClass ());
            }
         }
         
         for each (var aFunction:AssetFunction in mFunctionAssets)
         {
            if (! aFunction.HasContainingPackages ())
            {
               topPackage.AddFunctionDeclaration (aFunction.GetFunctionDeclaration ());
            }
         }
         
         // classes
         
         if (sCoreClassesDataProvider == null)
            BuildCoreClassesDataProvider ();
         
         if (GetNumClasses () > 0)
         {
            var customClassesDataProvider:XML = ConvertCodePackageToXML (topPackage, null, null, false, false);
            
            mCoreAndCustomClassesDataProvider = <root />;
            mCoreAndCustomClassesDataProvider.appendChild (sCoreClassesDataProvider);
            mCoreAndCustomClassesDataProvider.appendChild (customClassesDataProvider);
         }
         else
         {
            mCoreAndCustomClassesDataProvider = sCoreClassesDataProvider;
         }
         
         // functions
         
         delete mFunctionsDataProviderLonger.menuitem.(@name==kCustomPackagename)[0];
         mFunctionsDataProviderLonger.appendChild (ConvertCodePackageToXML (topPackage, null, null, true));

         delete mFunctionsDataProviderShorter.menuitem.(@name==kCustomPackagename)[0];
         mFunctionsDataProviderShorter.appendChild (ConvertCodePackageToXML (topPackage, null, null, true));
      }

      // top level
      // forFunctions: true for functions, false for classes.
      private static function CreateXmlFromCodePackages (packages:Array, forFunctions:Boolean):XML
      {
         var xml:XML = <root />;

         for each (var codePackage:CodePackage in packages)
         {
            ConvertCodePackageToXML (codePackage, xml, packages, forFunctions);
         }

         return xml;
      }

      // the ending params ae only for classes.
      private static function ConvertCodePackageToXML (codePackage:CodePackage, parentXml:XML, topCodePackages:Array, forFunctions:Boolean, onlyAllowSceneIndependentClasses:Boolean = true, forGameSave:Boolean = false):XML
      {
         codePackage.UpdateElementOrders ();
         
         var package_element:XML = <menuitem />;
         package_element.@name = codePackage.GetName ();
         
         if (parentXml != null)
            parentXml.appendChild (package_element);

         var num_items:int = 0;

         var numChildPackages:int = codePackage.GetNumChildCodePackages ();
         for (var i:int = 0; i < numChildPackages; ++ i)
         {
            var childCodePackage:CodePackage = codePackage.GetChildCodePackageAtIndex (i);
            if (topCodePackages == null || topCodePackages.indexOf (childCodePackage) < 0)
            {
               var child_pkg_element:XML = ConvertCodePackageToXML (childCodePackage, package_element, topCodePackages, forFunctions, onlyAllowSceneIndependentClasses, forGameSave);

               if (child_pkg_element.@name == childCodePackage.GetName ()) // false for removed.
               {
                  ++ num_items;
               } 
            }
         }
         
         var j:int;

         if (forFunctions)
         {
            var numFunctions:int = codePackage.GetNumFunctionDeclarations (); 
            var declaration:FunctionDeclaration;
            var function_element:XML;
            for (j = 0; j < numFunctions; ++ j)
            {
               declaration = codePackage.GetFunctionDeclarationAtIndex (j);
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
         }
         else
         {
            var numClasses:int = codePackage.GetNumClasses (); 
            var aClass:ClassDefinition;
            var class_element:XML;
            for (j = 0; j < numClasses; ++ j)
            {
               aClass = codePackage.GetClassAtIndex (j);
               
               if (onlyAllowSceneIndependentClasses && aClass.IsSceneDataDependent ())
                  continue;
               
               if (forGameSave && (! aClass.IsGameSavable ()))
                  continue;
               
               // ...
               
               class_element = <menuitem />;
               class_element.@name = aClass.GetName ();
               class_element.@id = aClass.GetID ();
               class_element.@type = aClass.GetClassType ();

               package_element.appendChild (class_element);

               ++ num_items;
            }
         }

         if (num_items == 0 && parentXml != null)
         {
            //var element:XML = <menuitem />;
            //element.@name = "[nothing]";
            //element.@id = -1;
            //
            //package_element.appendChild (element);
            
            delete parentXml.menuitem [parentXml.menuitem.length () - 1];
            
            package_element.@name = "";
         }
         
         return package_element;
      }
        
//=====================================================================
// calling parameter editing related
//=====================================================================
      
      public static function GetTypesDataProviderForParameter (codeLibManager:CodeLibManager, isCurrentSceneDataDependent:Boolean, isAnySceneDataIndependent:Boolean):Array
      {
         var provider:Array = new Array ();
         
         var type_element:Object;
         
         type_element = new Object ();
         type_element.label = "null";
         type_element.id = CoreClassIds.ValueType_Void;
         type_element.type = ClassTypeDefine.ClassType_Core;
         
         provider.push (type_element);
         
         codeLibManager.GetCustomTypesDataProviderForParameter (provider);
         
         return provider;
      }
      
      public function GetCustomTypesDataProviderForParameter (provider:Array):void
      {
         var type_element:Object;
         var aClass:AssetClass;
         for (var typeId:int = 0; typeId < mClassAssets.length; ++ typeId)
         {
            aClass = mClassAssets [typeId] as AssetClass;
            
            type_element = new Object ();
            type_element.label = aClass.GetName ();
            type_element.id = typeId; // aClass.GetID ();
            type_element.type = ClassTypeDefine.ClassType_Custom; // aClass.GetClassType ();

            provider.push (type_element);
         }
      }
      
      public static function GetSelectIndexForParameter (provider:Array, aClass:ClassDefinition):int
      {
         if (provider == null || aClass == null)
            return 0; // null
         
         for (var i:int = 1; i < provider.length; ++ i)
         {
            var type_element:Object = provider [i];
            
            if (type_element.type == aClass.GetClassType () && type_element.id == aClass.GetID ())
               return i;
         }
         
         return 0;
      }
      
      public function GetClassDefinitionForParameterFromSelectItem (type_element:Object):ClassDefinition
      {
         return GetClass (this, type_element.type, type_element.id);
      }
        
//=====================================================================
// custom variable definition
//=====================================================================

      public static function GetClass (codelibManager:CodeLibManager, classType:int, classId:int):ClassDefinition
      {
         var aClass:ClassDefinition = null;
         if (classType == ClassTypeDefine.ClassType_Custom)
         {
            if (codelibManager == null)
               throw new Error ("codelibManager can't be null.");
            
            aClass = codelibManager.GetCustomClass (classId);
            
            if (aClass != null)
               return aClass;
            
            classId = CoreClassIds.ValueType_Void;
         }

         return World.GetCoreClassById (classId);
      }
      
      public function GetCustomClass (index:int):ClassDefinition_Custom
      {
         var classAsset:AssetClass = GetClassByIndex (index);
         return classAsset == null ? null : classAsset.GetCustomClass ();
      }

      // variableName == nul means default name
      public function CreateCustomVariableDefinition (classId:int, variableName:String = null):VariableDefinition
      {
         var customClass:ClassDefinition_Custom = GetCustomClass (classId);
         
         if (customClass != null)
         {
            if (variableName == null)
               variableName = customClass.GetDefaultInstanceName ();
            
            return new VariableDefinition_Custom (customClass, variableName);
         }
         
         //throw new Error ("unknown class in CreateCustomVariableDefinition");
         
         return null;
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
      
      private static function CompareFuncByAssetY (asset1:Asset, asset2:Asset):Number
      {
         return asset1.GetPositionY () - asset2.GetPositionY ();
      }
      
      override public function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var sortFunctionOrder:ContextMenuItem = new ContextMenuItem("Sort Function Orders By Y Coordinate", true);
         var sortCustomTypeOrder:ContextMenuItem = new ContextMenuItem("Sort Class Orders By Y Coordinate", false);
         var sortPackageOrder:ContextMenuItem = new ContextMenuItem("Sort Package Orders By Y Coordinate", false);
         var sortAllOrder:ContextMenuItem = new ContextMenuItem("Sort All Orders By Y Coordinate", false);
         
         sortFunctionOrder.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_SortFunctionOrder);
         sortCustomTypeOrder.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_SortCustomTypeOrder);
         sortPackageOrder.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_SortPackageOrder);
         sortAllOrder.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_SortAllOrder);

         customMenuItemsStack.push (sortFunctionOrder);
         customMenuItemsStack.push (sortCustomTypeOrder);
         customMenuItemsStack.push (sortPackageOrder);
         customMenuItemsStack.push (sortAllOrder);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_SortFunctionOrder (event:ContextMenuEvent):void
      {
         mFunctionAssets.sort (CompareFuncByAssetY);
         
         // ...
         
         UpdateFunctionIndexes ();
         
         SetChanged (true);
         
         UpdateFunctionAppearances ();
      }
      
      
      private function OnContextMenuEvent_SortCustomTypeOrder (event:ContextMenuEvent):void
      {
         mClassAssets.sort (CompareFuncByAssetY);
         
         // ...
         
         UpdateClassIndexes ();
         
         SetChanged (true);
         
         UpdateClassAppearances ();
      }
      
      private function OnContextMenuEvent_SortPackageOrder (event:ContextMenuEvent):void
      {
         mPackageAssets.sort (CompareFuncByAssetY);
         
         // ...
         
         UpdatePackageIndexes ();
         
         SetChanged (true);
         
         UpdatePackageAppearances ();
      }
      
      private function OnContextMenuEvent_SortAllOrder (event:ContextMenuEvent):void
      {
         OnContextMenuEvent_SortFunctionOrder (event);
         OnContextMenuEvent_SortCustomTypeOrder (event);
         OnContextMenuEvent_SortPackageOrder (event);
      }
      
   }
}
