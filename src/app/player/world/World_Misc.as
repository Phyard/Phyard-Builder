      
      public function ResetEntitySpecialIds ():void
      {
         Entity.ResetLastSpecialId ();
         mEntityList.ResetEntitySpecialIds ();
         mEntityListBody.ResetEntitySpecialIds ();
      }
      
      public var mJointColor:uint = 0x000000;
      public var mCiStaticColor:uint = Define.ColorStaticObject;
      public var mCiMovableColor:uint = Define.ColorMovableObject;
      public var mCiBreakableColor:uint = Define.ColorBreakableObject;
      public var mCiInfectedColor:uint = Define.ColorInfectedObject;
      public var mCiUninfectedColor:uint = Define.ColorUninfectedObject;
      public var mCiDontInfectColor:uint = Define.ColorDontInfectObject;
      public var mInColorBlindMode:Boolean = false;
      
      public function SetLevelProperty (property:int, value:Object):void
      {
         switch (property)
         {
            case Define.LevelProperty_JointColor:
               mJointColor = uint (value) & 0xFFFFFFFF;
               UpdateEntityAppearances (IsJointRelated);
               break;
            case Define.LevelProperty_CiStaticColor:
               mCiStaticColor = uint (value) & 0xFFFFFFFF;
               UpdateEntityAppearances (IsCiShape);
               break;
            case Define.LevelProperty_CiMovableColor:
               mCiMovableColor = uint (value) & 0xFFFFFFFF;
               UpdateEntityAppearances (IsCiShape);
               break;
            case Define.LevelProperty_CiBreakableColor:
               mCiBreakableColor = uint (value) & 0xFFFFFFFF;
               UpdateEntityAppearances (IsCiShape);
               break;
            case Define.LevelProperty_CiInfectedColor:
               mCiInfectedColor = uint (value) & 0xFFFFFFFF;
               UpdateEntityAppearances (IsCiShape);
               break;
            case Define.LevelProperty_CiUninfectedColor:
               mCiUninfectedColor = uint (value) & 0xFFFFFFFF;
               UpdateEntityAppearances (IsCiShape);
               break;
            case Define.LevelProperty_CiDontInfectColor:
               mCiDontInfectColor = uint (value) & 0xFFFFFFFF;
               UpdateEntityAppearances (IsCiShape);
               break;
            case Define.LevelProperty_ColorBlindMode:
               mInColorBlindMode = Boolean (value);
               UpdateEntityAppearances (IsCiShape);
               break;
            case Define.LevelProperty_RenderQuality:
               Global.sTheGlobal.Viewer_mLibGraphics.SetRenderQuality (value as String);
               break;
         }
      }
      
      private function UpdateEntityAppearances (filterFunc:Function):void
      {
         if (mFirstRepaintCommitted)
         {
            mEntityList.UpdateEntityAppearances (filterFunc);
         }
      }
      
      private function IsJointRelated (entity:Entity):Boolean
      {
         return (entity is EntityJoint) || (entity is SubEntityJointAnchor);
      }     
      
      private function IsCiShape (entity:Entity):Boolean
      {
         var shape:EntityShape = entity as EntityShape;
         return shape != null && shape.GetShapeAiType () != Define.ShapeAiType_Unknown;
      }
      
      public function GetShapeFilledColor (shapeAiType:int):uint
      {
         switch (shapeAiType)
         {
            case Define.ShapeAiType_Static:
               return mCiStaticColor;
            case Define.ShapeAiType_Movable:
               return mCiMovableColor;
            case Define.ShapeAiType_Breakable:
               return mCiBreakableColor;
            case Define.ShapeAiType_Infected:
               return mCiInfectedColor;
            case Define.ShapeAiType_Uninfected:
               return mCiUninfectedColor;
            case Define.ShapeAiType_DontInfect:
               return mCiDontInfectColor;
            
            case Define.ShapeAiType_Bomb:
            case Define.ShapeAiType_BombParticle:
               return Define.ColorBombObject;
            case Define.ShapeAiType_Unknown:
            default:
               return 0xFFFFFF;
         }
      }