
public function ResetEntitySpecialIds ():void
{
   mEntityList.ResetEntitySpecialIds ();
   mEntityListBody.ResetEntitySpecialIds ();
}

//=========================================================================
// interfaces for ViewerUI
//=========================================================================

public static function CreateInstance (binaryData:ByteArray):World
{
   binaryData.position = 0;
   return DataFormat2.WorldDefine2PlayerWorld (DataFormat2.ByteArray2WorldDefine (binaryData));
}

public static function PlayCode2BinaryData (playCode:String):ByteArray
{
   return DataFormat2.HexString2ByteArray (playCode);
}

public function SetProperty (name:String, value:Object):void
{
   switch (name)
   {
      default:
      {
      }
   }
}

public function GetProperty (name:String):Object
{
   switch (name)
   {
      default:
      {
         return null;
      }
   }
}

