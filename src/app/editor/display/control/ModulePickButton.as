
package editor.display.control {
   
   import flash.events.MouseEvent;
   
   import mx.events.FlexEvent;
   
   import mx.controls.Button;
   
   import editor.asset.Asset;
   import editor.image.AssetImageModule;
   import editor.image.dialog.AssetImageModuleListDialog;
   
   public class ModulePickButton extends Button 
   {
      protected var mModule:AssetImageModule;
      
      public function ModulePickButton (initialModule:AssetImageModule = null)
      {
         OnModulePicked (initialModule);
         
         addEventListener (MouseEvent.CLICK, OnClick);
      }
      
      public function GetPickedModule ():AssetImageModule
      {
         return mModule;
      }
      
      public function SetPickedModule (module:AssetImageModule):void
      {
          OnModulePicked (module);
      }
      
      private function OnModulePicked (asset:Asset):void 
      {
         mModule = asset as AssetImageModule;
         
         label = mModule == null ? "Null" : mModule.ToCodeString ();
      }
      
      private function OnClick (event:MouseEvent):void 
      {
         AssetImageModuleListDialog.StartPickModule (OnModulePicked);
      }
   }
}
