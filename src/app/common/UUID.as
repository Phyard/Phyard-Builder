package common {
   
   import flash.utils.ByteArray;
   
   public class UUID
   {  
      public static const kTime20090101:Number = new Date (2009, 0, 1, 0, 0, 0, 0).getTime (); // 2009.01.01 00:00:00
      
      private static const kMaxAccId:int = 0xFFFFFF;
      
      private static const kShift24bits:int = 1 << 24;
      
      public static function BuildKey (accId:int):String
      {
         var time:Number = new Date ().getTime () - kTime20090101;
         var time1:int = int (time / kShift24bits) & (kShift24bits - 1);
         var time2:int = time & (kShift24bits - 1);
         
         var random:int = Math.floor (Math.random () * kShift24bits);
         
         var bytes:ByteArray = new ByteArray ();
         bytes.length = 12;
         FillByteArrayWith24bits (bytes, 0, random);
         FillByteArrayWith24bits (bytes, 3, accId & kMaxAccId);
         FillByteArrayWith24bits (bytes, 6, time1);
         FillByteArrayWith24bits (bytes, 9, time2);
         
         var base64String:String = DataFormat3.EncodeByteArray2String (bytes);
         
         //var key:String = (spaceName == null ? base64String : spaceName + "/" + base64String);
         //return key;
         
         return base64String;
      }
      
      private static function FillByteArrayWith24bits (bytes:ByteArray, fromIndex:int, value:int):void
      {
         bytes [fromIndex ++] = (value >> 16) & 0xFF;
         bytes [fromIndex ++] = (value >>  8) & 0xFF;
         bytes [fromIndex ++] = (value >>  0) & 0xFF;
      }
      
      public static function BuildRandomKey ():String
      {
         return BuildKey (Math.floor (Math.random () * kShift24bits));
      }
      
      //========================
      // 16 bytes UUID, for multiple player simulated server
      //========================
      
      public static function BuildUUID ():ByteArray
      {
         var time:Number = new Date ().getTime () - kTime20090101;
         var time1:int = int (time / kShift24bits) & (kShift24bits - 1);
         var time2:int = time & (kShift24bits - 1);
         
         var random0:int = Math.floor (Math.random () * kShift24bits);
         var random1:int = Math.floor (Math.random () * kShift24bits);
         var random2:int = Math.floor (Math.random () * kShift24bits);
         
         var bytes:ByteArray = new ByteArray ();
         bytes.length = 16;
         FillByteArrayWith24bits (bytes, 0, random0);
         FillByteArrayWith24bits (bytes, 3, random1);
         FillByteArrayWith24bits (bytes, 6, random2);
         bytes [9] = Math.floor (Math.random () * 256)
         FillByteArrayWith24bits (bytes, 10, time1);
         FillByteArrayWith24bits (bytes, 13, time2);
         
         return bytes;
      }
   }
}
