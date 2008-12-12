package com.tapirgames.suit2d.loader {
   
   import game.res.kDefines; 
   
   import flash.utils.ByteArray;
   
   public class ActorDefine //extends GameEntity
   {
      public var mTemplate:ActorTemplate;
      
      public var mPosX:int;
      public var mPosY:int;
      public var mZOrder:int;
      //public var mFlipX:Boolean;
      //public var mFlipY:Boolean;
      public var mRotation:Number;
      public var mScaleX:Number;
      public var mScaleY:Number;
      
      public var mPropertyValues:Array;
      
      public var mAppearanceValues:Array;
      
      public function ActorDefine ()
      {
      }
      
      
      public function Load (dataSrc:ByteArray, defineFile:DefineFile):void
      {
         var isReserved:Boolean = dataSrc.readBoolean ();
         
         if (isReserved)
            return;
         
         var templateID:int = dataSrc.readShort ();
         mTemplate = defineFile.GetActorTemplate (templateID);
         
         trace ("        template: " + mTemplate.GetName ());
         
         mPosX   = dataSrc.readShort ();
         mPosY   = dataSrc.readShort ();
         mZOrder = dataSrc.readShort ();
         //mFlipX  = dataSrc.readBoolean ();
         //mFlipY  = dataSrc.readBoolean ();
         mRotation = dataSrc.readFloat ();
         mScaleX = dataSrc.readFloat ();
         mScaleY = dataSrc.readFloat ();
         
         mPropertyValues = ActorTemplate.LoadPropertyValues (dataSrc, mTemplate.GetInstancePropertyDefines ());
         
         var appearanceDefines:Array = mTemplate.GetActorAppearanceDefines ();
         var appearancesCount:int = dataSrc.readByte (); // appearancesCount == appearanceDefines.length ();
         
         mAppearanceValues = new Array (appearancesCount);
         
         for (var appearanceID:int = 0; appearanceID < appearancesCount; ++ appearanceID)
         {
            var appearanceDefine:Object = appearanceDefines [appearanceID];
            
            switch (appearanceDefine.mTypeID)
            {
               case kDefines.AppearanceType_sprite2d:
                  mAppearanceValues [appearanceID] = dataSrc.readShort (); // animation id
                  break
               case kDefines.AppearanceType_background2d:
                  mAppearanceValues [appearanceID] = dataSrc.readShort (); // background id
                  break
               case kDefines.AppearanceType_box2d:
                  var box:Array = new Array (4);
                  box [0] = dataSrc.readShort ();
                  box [1] = dataSrc.readShort ();
                  box [2] = dataSrc.readShort ();
                  box [3] = dataSrc.readShort ();
                  mAppearanceValues [appearanceID] = box;
                  
                  trace ("box = " + box);
                  break
               case kDefines.AppearanceType_circle:
                  var circle:Array = new Array (3);
                  circle[0] = dataSrc.readShort ();
                  circle[1] = dataSrc.readShort ();
                  circle[2] = dataSrc.readShort ();
                  mAppearanceValues [appearanceID] = circle;
                  break
               case kDefines.AppearanceType_line2d:
                  var line:Array = new Array (4);
                  line[0] = dataSrc.readShort ();
                  line[1] = dataSrc.readShort ();
                  line[2] = dataSrc.readShort ();
                  line[3] = dataSrc.readShort ();
                  mAppearanceValues [appearanceID] = line;
                  break
               default:
            }
         }
      }
   }
}