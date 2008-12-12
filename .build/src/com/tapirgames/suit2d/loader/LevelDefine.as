package com.tapirgames.suit2d.loader {
   
   import flash.utils.ByteArray;
   
   import engine.util.Util;
   
   import engine.Engine;
   
   public class LevelDefine
   {
      public var mFilePath:String;
      public var mDefineFile:DefineFile;
      public var mPlayfieldWidth:int;
      public var mPlayfieldHeight:int;
      
      public var mActorDefines:Array;
      
      public var mPathSearchZones:Array;
      public var mPathSearchJoints:Array;
      public var mPathSearchLinks:Array;
      
      public function LevelDefine (filePath:String)
      {
         mFilePath = filePath;
      }
      
      public function GetDefineFile ():DefineFile
      {
         return mDefineFile;
      }
      
      public function GetFieldWidth ():int
      {
         return mPlayfieldWidth;
      }
      
      public function GetFieldHeight ():int
      {
         return mPlayfieldHeight;
      }
      
      public function Load (dataSrc:ByteArray):void
      {
         var defineFilePath:String = dataSrc.readUTF ();
         defineFilePath = Util.GetFullFilePath (defineFilePath, mFilePath);
         
         mDefineFile = Engine.GetDataAsset (defineFilePath) as DefineFile;
         
         trace ("  define file: " + mDefineFile + " (" + defineFilePath + ")");
         
         mPlayfieldWidth = dataSrc.readShort ();
         mPlayfieldHeight = dataSrc.readShort ();
         
         var actorsCount:int = dataSrc.readShort ();
         
         trace ("  width = " + mPlayfieldWidth + ", height = " + mPlayfieldHeight + ", actor count = " + actorsCount);
         
         mActorDefines = new Array (actorsCount);
         
         for (var actorID:int = 0; actorID < actorsCount; ++ actorID)
         {
            trace ("     actor # " + actorID);
         
            var dataFollowed:Boolean = dataSrc.readBoolean ();
            if ( ! dataFollowed )
            {
               // path search zones, joints
               continue;
            }
            
            var actorDefine:ActorDefine = new ActorDefine ();
            actorDefine.Load (dataSrc, mDefineFile);
            
            mActorDefines [actorID] = actorDefine;
         }
         
         var hasPathSearchData:Boolean = dataSrc.readBoolean ();
         if (hasPathSearchData)
         {
            var pathSearchZonesCount:int = dataSrc.readShort ();
            
            trace ("    path search zones count: " + pathSearchZonesCount);
            
            mPathSearchZones = new Array (pathSearchZonesCount);
            
            for (var zoneID:int = 0; zoneID < pathSearchZonesCount; ++ zoneID)
            {
               var zone:Array = new Array (4);
               zone [0] = dataSrc.readShort ();
               zone [1] = dataSrc.readShort ();
               zone [2] = dataSrc.readShort ();
               zone [3] = dataSrc.readShort ();
               
               mPathSearchZones [zoneID] = zone;
            }
            
            var pathSearchJointsCount:int = dataSrc.readShort ();
            
            trace ("    path search joint count: " + pathSearchJointsCount);
            
            mPathSearchJoints = new Array (pathSearchJointsCount);
            
            for (var jointID:int = 0; jointID < pathSearchJointsCount; ++ jointID)
            {
               var joint:Array = new Array (6);
               joint [0] = dataSrc.readShort ();
               joint [1] = dataSrc.readShort ();
               joint [2] = dataSrc.readShort ();
               joint [3] = dataSrc.readShort ();
               joint [4] = dataSrc.readShort ();
               joint [5] = dataSrc.readShort ();
               
               mPathSearchJoints [jointID] = joint;
            }
            
            var pathSearchLinksCount:int = dataSrc.readShort ();
            
            trace ("    path search links count: " + pathSearchLinksCount);
            
            mPathSearchLinks = new Array (pathSearchLinksCount);
            
            for (var linkID:int = 0; linkID < pathSearchLinksCount; ++ linkID)
            {
               var link:Array = new Array (3);
               link [0] = dataSrc.readShort ();
               link [1] = dataSrc.readShort ();
               link [2] = dataSrc.readShort ();
               
               mPathSearchLinks [linkID] = link;
            }
         }
      }
   }
}