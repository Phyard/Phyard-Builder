
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

public static function BinaryData2WorldDefine (binaryData:ByteArray):Object
{
   return DataFormat2.ByteArray2WorldDefine (binaryData);
}

public function SetParametersFromUI (params:Object):void
{
   Global.RestartPlay = params.OnClickRestart;
   Global.IsPlaying = params.IsPlaying;
   Global.SetPlaying = params.SetPlaying;
   Global.GetSpeedX = params.GetPlayingSpeedX;
   Global.SetSpeedX = params.SetPlayingSpeedX;
   Global.GetScale = params.GetZoomScale;
   Global.SetScale = params.SetZoomScale;
}

public function GetParametersToUI ():Object
{
   var params:Object = {
      
   };
   
   return params;
}

//============== more interfaces in other files ======================
// public function Initialize ():void
// public function Update (escapedTime:Number, speedX:int, forceUpdateCamera:Boolean):void

