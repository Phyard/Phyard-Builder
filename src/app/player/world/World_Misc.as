
      public function ResetEntitySpecialIds ():void
      {
         mEntityList.ResetEntitySpecialIds ();
         mEntityListBody.ResetEntitySpecialIds ();
      }
      
      public var mJointColor:uint = 0x000000;
      
      public function SetLevelProperty (property:int, value:Number):void
      {
         switch (property)
         {
            case Define.LevelProperty_JointColor:
               mJointColor = uint (value);
               mEntityList.UpdateJointAppearances ();
               break;
         }
      }
