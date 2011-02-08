package editor.world {
   
   import flash.display.Sprite;
   import flash.display.Shape;
   
   import flash.utils.Dictionary;
   
   import com.tapirgames.util.Logger;
   
   import editor.entity.Entity;
   
   import editor.trigger.entity.EntityFunction;
   import editor.trigger.entity.EntityFunctionPackage;
   
   import editor.trigger.FunctionMenuGroup;
   
   import editor.runtime.Runtime;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class FunctionManager extends EntityContainer
   {
      protected var mWorld:World;
      
      public function FunctionManager (world:World)
      {
         mWorld = world;
      }
      
      public function GetWorld ():World
      {
         return mWorld;
      }
      
      override public function DestroyEntity (entity:Entity):void
      {
         var index:int;
         
         if (entity is EntityFunction)
         {
            index = mFunctionEntities.indexOf (entity);
            if (index >= 0) // must be
            {
               delete mFunctionLookupTable[ (entity as EntityFunction).GetFunctionName () ];
               (entity as EntityFunction).SetFunctionIndex (-1);
               mFunctionEntities.splice (index, 1);
               
               UpdateEntityFunctionIndexes ();
            }
         }
         else if (entity is EntityFunctionPackage)
         {
            index = mPackageEntities.indexOf (entity);
            if (index >= 0) // must be
            {
               delete mPackageLookupTable[ (entity as EntityFunctionPackage).GetPackageName () ];
               (entity as EntityFunctionPackage).SetPackageIndex (-1);
               mPackageEntities.splice (index, 1);
               
               UpdateEntityPackageIndexes ();
            }
         }
         
         SetChanged (true);
         
         super.DestroyEntity (entity);
         
         // ids changed, maybe
         var entity:Entity;
         for (var i:int = 0; i < numChildren; ++ i)
         {
            entity = getChildAt (i) as Entity;
            if (entity != null) // should be
            {
               entity.UpdateAppearance ();
            }
         }
      }
      
   //===============================
   // functions
   //===============================
      
      private var mFunctionEntities:Array = new Array ();
      private var mFunctionLookupTable:Dictionary = new Dictionary ();
      
      public function GetNumFunctions ():int
      {
         return mFunctionEntities.length;
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
      
      public function GetFunctionByIndex (index:int):EntityFunction
      {
         if (index < 0 || index >= mFunctionEntities.length)
            return null;
         
         return mFunctionEntities [index] as EntityFunction;
      }
      
      public function CreateEntityFunction (funcName:String = null):EntityFunction
      {
         if (funcName == null)
            funcName = Define.FunctionDefaultName;
         
         var aFunction:EntityFunction = new EntityFunction (this);
         addChild (aFunction);
         
         mFunctionEntities.push (aFunction);
         
         aFunction.SetFunctionName (GetFunctionRecommendName (funcName), false);
         
         mFunctionLookupTable [aFunction.GetFunctionName ()] = aFunction;
         
         UpdateEntityFunctionIndexes ();
         
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
         
         var aFunction:EntityFunction = mFunctionLookupTable [oldName];
         
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
      
      private function UpdateEntityFunctionIndexes ():void
      {
         for (var index:int = 0; index < mFunctionEntities.length; ++ index)
         {
            (mFunctionEntities [index] as EntityFunction).SetFunctionIndex (index);
         }
      }
      
   //===============================
   // packages
   //===============================
      
      private var mPackageEntities:Array = new Array ();
      private var mPackageLookupTable:Dictionary = new Dictionary ();
      
      public function GetNumPackages ():int
      {
         return mPackageEntities.length;
      }
      
      private function GetRecommendPackageName (packageName:String):String
      {
         var n:int = 1;
         var functionNameN:String = packageName;
         while (true)
         {
            if (mPackageLookupTable [functionNameN] == null)
               return functionNameN;
            
            functionNameN = packageName + " " + (n ++);
         }
         
         return null;
      }
      
      public function GetPackageByIndex (index:int):EntityFunctionPackage
      {
         if (index < 0 || index >= mPackageEntities.length)
            return null;
         
         return mPackageEntities [index] as EntityFunctionPackage;
      }
      
      public function CreateEntityFunctionPackage (pkgName:String = null):EntityFunctionPackage
      {
         if (pkgName == null)
            pkgName = Define.PackageDefaultName;
         
         var aPackage:EntityFunctionPackage = new EntityFunctionPackage (this);
         addChild (aPackage);
         
         mPackageEntities.push (aPackage);
         
         aPackage.SetPackageName (GetRecommendPackageName (pkgName), false);
         
         mPackageLookupTable [aPackage.GetPackageName ()] = aPackage;
         
         UpdateEntityPackageIndexes ();
         
         SetChanged (true);
         
         return aPackage;
      }
      
      public function ChangePackageName (newName:String, oldName:String):void
      {
         if (oldName == null)
            return;
         if (newName == null)
            return;
         if (newName.length < Define.MinEntityNameLength)
            return;
         
         var aPackage:EntityFunctionPackage = mPackageLookupTable [oldName];
         
         if (aPackage == null)
            return;
         
         delete mPackageLookupTable [oldName];
         
         if (newName.length > Define.MaxEntityNameLength)
            newName = newName.substr (0, Define.MaxEntityNameLength);
         
         newName = GetRecommendPackageName (newName);
         
         mPackageLookupTable [newName] = aPackage;
         
         if (newName == oldName)
         {
            return;
         }
         
         aPackage.SetPackageName (newName, false);
         
         SetChanged (true);
      }
      
      private function UpdateEntityPackageIndexes ():void
      {
         for (var index:int = 0; index < mPackageEntities.length; ++ index)
         {
            (mPackageEntities [index] as EntityFunctionPackage).SetPackageIndex (index);
         }
      }
      
//=============================================
// for undo point
//=============================================
      
      public function SetEntityLinksChangedCallback (callback:Function):void
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
         
         for (var i:int = 0; i < mFunctionEntities.length; ++ i)
         {
            mFunctionMenuGroup.AddFunctionDeclaration ((mFunctionEntities [i] as EntityFunction).GetFunctionDeclaration ());
         }
         
         mWorld.GetTriggerEngine ().UpdateCustomFunctionMenu ();
      }
   }
}
