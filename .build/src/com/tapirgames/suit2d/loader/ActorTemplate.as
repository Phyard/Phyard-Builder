package com.tapirgames.suit2d.loader {
   
   import game.res.kDefines;
   
   import flash.utils.ByteArray;
   
   public class ActorTemplate 
   {
      public var mName:String;
      public var mTemplateID:int;
      public var mInstanceActorType:int;
      public var mInstanceZOrder:int;
      
      public var mTemplatePropertyDefines:Array;
      
      public var mTemplatePropertyValues:Array;
      
      public var mInstancePropertyDefines:Array;
      
      public var mActorAppearanceDefines:Array;
      
      public function ActorTemplate (id:int)
      {
         mTemplateID = id;
      }
      
      public function GetName ():String
      {
         return mName;
      }
      
      public function GetTemplatePropertyDefines ():Array
      {
         return mTemplatePropertyDefines;
      }
      
      public function GetProperty (propertyID:uint):Object
      {
         return mTemplatePropertyValues [propertyID];
      }
      
      public function GetInstancePropertyDefines ():Array
      {
         return mInstancePropertyDefines;
      }
      
      public function GetActorAppearanceDefines ():Array
      {
         return mActorAppearanceDefines;
      }
      
      public function Load (dataSrc:ByteArray):void
      {
         mName              = dataSrc.readUTF   ();
         mInstanceActorType = dataSrc.readShort ();
         mInstanceZOrder    = dataSrc.readShort ();
         
         trace ("  template: " + mName + ", actorType: " + mInstanceActorType + ", zOrder: " + mInstanceZOrder);
         
         mTemplatePropertyDefines = LoadPropertyDefines (dataSrc);
         
         mTemplatePropertyValues = LoadPropertyValues (dataSrc, mTemplatePropertyDefines);
         
         mInstancePropertyDefines = LoadPropertyDefines (dataSrc);
         
         mActorAppearanceDefines = LoadActorAppearanceDefines (dataSrc);
      }
      
      public static function LoadPropertyDefines (dataSrc:ByteArray):Array
      {
         var allPropertyDefinesCount:int = dataSrc.readShort ();
         
         var propertyDefines:Array = new Array (allPropertyDefinesCount);
         
         var propertyGroupDefinesCount:int = dataSrc.readShort ();
         
         trace ("     property define count: " + allPropertyDefinesCount);
         
         var index:int = 0;
         
         for (var propertyGroupDefineID:int = 0; propertyGroupDefineID < propertyGroupDefinesCount; ++ propertyGroupDefineID)
         {
            var propertyGroupName:String = dataSrc.readUTF ();
            
            var propertyDefinesCount:int = dataSrc.readShort ();
            
            for (var propertyDefineID:int = 0; propertyDefineID < propertyDefinesCount; ++ propertyDefineID)
            {
               var propertyName:String = dataSrc.readUTF ();
               var propertyType:int    = dataSrc.readShort ();
               
               trace ("        group: " + propertyGroupName + ", property: " + propertyName + ", type: " + propertyType);
               
               propertyDefines [index ++] = new PropertyDefine (propertyGroupName, propertyName, propertyType);
            }
         }
         
         return propertyDefines;
      }
         
      
      public static function LoadPropertyValues (dataSrc:ByteArray, propertyDefines:Array):Array
      {
         var propertiesCount:int = dataSrc.readShort ();
         
         trace ("        property count: " + propertiesCount);
         
         var propertyList:Array = new Array (propertiesCount);

         for (var propertyID:int = 0; propertyID < propertiesCount; ++ propertyID)
         {
            var propertyDefine:PropertyDefine = propertyDefines [propertyID];
            
            switch (propertyDefine.mTypeID)
            {
               case kDefines.PropertyType_number:
                  //propertyList [propertyID] = dataSrc.readInt ();
                  propertyList [propertyID] = dataSrc.readFloat ();
                  break;
               case kDefines.PropertyType_string:
                  propertyList [propertyID] = dataSrc.readUTF ();
                  break;
               case kDefines.PropertyType_items:
                  propertyList [propertyID] = dataSrc.readShort ();
                  break;
               case kDefines.PropertyType_entity_ref:
                  propertyList [propertyID] = dataSrc.readShort ();
                  break;
               case kDefines.PropertyType_boolean:
                  propertyList [propertyID] = dataSrc.readBoolean ();
                  break;
               default:
                  continue;
            }
            
            trace ("           " + propertyID + "): " + propertyList [propertyID]);
         }
         
         return propertyList;
      }
      
      public static function LoadActorAppearanceDefines (dataSrc:ByteArray):Array
      {
         var appearanceDefinesCount:int = dataSrc.readByte ();
         
         trace ("     appearance defines count: " + appearanceDefinesCount);
         
         var appearanceDefines:Array = new Array (appearanceDefinesCount);
         
         for (var appearanceDefineID:int = 0; appearanceDefineID < appearanceDefinesCount; ++ appearanceDefineID)
         {
            var appearanceTypeID:int = dataSrc.readShort ();
            var appearanceDefine:Object = new Object ();
            appearanceDefine.mTypeID = appearanceTypeID;
            switch (appearanceTypeID)
            {
               case kDefines.AppearanceType_sprite2d:
                  appearanceDefine.mFilePath = dataSrc.readUTF (); // sprite2d_file
                  appearanceDefine.mModelID = dataSrc.readShort (); // model_name
                  appearanceDefine.mAnimationID = dataSrc.readShort (); // animation_name
                  break;
               case kDefines.AppearanceType_background2d:
                  appearanceDefine.mFilePath = dataSrc.readUTF (); // sprite2d_file
                  appearanceDefine.mBackgroundID = dataSrc.readShort (); // background_name
                  break;
               case kDefines.AppearanceType_box2d:
                  appearanceDefine.mColorValue = dataSrc.readInt (); // border color
                  break;
               case kDefines.AppearanceType_circle:
                  appearanceDefine.mColorValue = dataSrc.readInt (); // border color
                  break;
               case kDefines.AppearanceType_line2d:
                  appearanceDefine.mColorValue = dataSrc.readInt (); // line color
                  break;
               default:
            }
            
            appearanceDefines [appearanceDefineID] = appearanceDefine;
         }
         
         return appearanceDefines;
      }
   }
}