package com.tapirgames.suit2d.loader {
   
   import flash.utils.ByteArray;
   
   
   public class DefineFile 
   {
      public var mFilePath:String;
      
      private var mActorTemplates:Array;
      
      public function DefineFile (filePath:String)
      {
         mFilePath = filePath;
      }
            
      public function Load (dataSrc:ByteArray):void
      {
         var actorTemplatesCount:int = dataSrc.readShort ();
         
         trace ("template count: " + actorTemplatesCount);
         
         mActorTemplates = new Array (actorTemplatesCount);
         
         for (var actorTemplateID:int = 0; actorTemplateID < actorTemplatesCount; ++ actorTemplateID)
         {
            var actorTemplate:ActorTemplate = new ActorTemplate (actorTemplateID);
            actorTemplate.Load (dataSrc);
            
            mActorTemplates [actorTemplateID] = actorTemplate;
         }
      }
      
      public function GetActorTemplate (templateID:int):ActorTemplate
      {
         return mActorTemplates[templateID];
      }
   }
}