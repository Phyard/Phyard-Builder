
package editor.codelib {
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.asset.Asset;
   import editor.asset.Linkable;
   
   import editor.display.dialog.NameSettingDialog;
   
   import editor.EditorContext;
   
   import common.Define;
   
   public class AssetCodeLibElement extends Asset implements Linkable
   {
      protected var mCodeLibManager:CodeLibManager;
      
      protected var mPackages:Array; // the packages this stays in.
      
      public function AssetCodeLibElement (codeLibManager:CodeLibManager, key:String, name:String)
      {
         super (codeLibManager, key, name);
         
         mCodeLibManager = codeLibManager;
         
         mPackages = new Array ();
      }
      
      override public function Destroy ():void
      {
         RemoveFromAllContainingPackages ();
         
         super.Destroy ();
      }
      
      public function HasContainingPackages ():Boolean
      {
         return mPackages.length > 0;
      }
      
      public function IsInPackage (aPackage:AssetPackage):Boolean
      {
         return mPackages.indexOf (aPackage) >= 0;
      }
      
      public function AddIntoPackage (aPackage:AssetPackage):void
      {
         if (mPackages.indexOf (aPackage) < 0)
         {
            RemoveFromAllContainingPackages (); // currently, only one parent package is allowed.
               
            mPackages.push (aPackage);
            
            aPackage.OnElementAdded (this);
            
            mCodeLibManager.SetChanged (true);
         }
      }
      
      public function RemoveFromPackage (aPackage:AssetPackage):void
      {
         var index:int = mPackages.indexOf (aPackage);
         if (index >= 0)
         {
            RemoveFromPackageAtIndex (index);
         }
      }
      
      // the index must be valid.
      private function RemoveFromPackageAtIndex (index:int):void
      {
         var aPackage:AssetPackage = mPackages [index] as AssetPackage;
         
         mPackages.splice (index, 1);
         
         aPackage.OnElementRemoved (this);
         
         mCodeLibManager.SetChanged (true);
      }
      
      private function RemoveFromAllContainingPackages ():void
      {
         while (mPackages.length > 0)
            RemoveFromPackageAtIndex (mPackages.length - 1);
      }
      
      // current most one package
      public function SetContainingPackageIndices (indexes:Array):void
      {
         if (indexes != null)
         {
            for each (var index:int in indexes)
            {
               var aPackage:AssetPackage = mCodeLibManager.GetPackageByIndex (index);
               if (aPackage != null)
               {
                  AddIntoPackage (aPackage);
               }
            }
         }
      }
      
      public function GetContainingPackageIndices ():Array
      {
         var indices:Array = new Array ();
         
         for each (var aPackage:AssetPackage in mPackages)
         {
            var index:int = aPackage.GetPackageIndex ();
            if (index >= 0)
            {
               indices.push (index);
            }
         }
         
         return indices;
      }
      
//====================================================================
//   linkable
//====================================================================
      
      public function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int
      {
         return -1;
      }
      
      public function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean
      {
         return false;
      }
      
      public function TryToCreateLink (fromManagerDisplayX:Number, fromManagerDisplayY:Number, toAsset:Asset, toManagerDisplayX:Number, toManagerDisplayY:Number):Boolean
      {
         return false;
      }

  }
}
