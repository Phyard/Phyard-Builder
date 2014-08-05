
package common {
   
   public class Define
   {
      
      
//===========================================================================
// general
//===========================================================================
      
      public static const EditingTutorialUrl:String = "http://wiki.colorinfection.com";
      public static const ShowcasesUrl:String = "http://www.phyard.com/hot";
      public static const EmbedTutorialUrl:String = "http://sites.google.com/site/colorinfectiondocument/documents/publish-your-puzzles";
      public static const EditorUrl:String = "http://www.phyard.com";
      
      public static const kPI_x_2:Number = Math.PI * 2.0;
      public static const kRadians2Degrees:Number = 180.0 / Math.PI;
      public static const kDegrees2Radians:Number = Math.PI / 180.0;
      
      public static const kFloatEpsilon:Number = 1.192092896e-07;

//===========================================================================
// network return code
//===========================================================================
      
      //public static const k_ReturnCode_UnknowError:int = 0;
      public static const k_ReturnCode_Successed:int = 1;
      public static const k_ReturnCode_Successed_Extended:int = 2;
            
//===========================================================================
// world
//===========================================================================
      
      //public static const MaxEntitiesCount:int = 512;
      //public static const MaxEntitiesCount:int = 1024;
      //public static const MaxEntitiesCount:int = 1024 * 3;
      public static const MaxEntitiesCount:int = 0x7FFFFFFF; // unlimited
      
      public static const MaxViewportSize:int = 1024;
      public static const MinViewportSize:int = 50;
      
      public static const DefaultWorldWidth:int = 500; //600; 
      public static const DefaultWorldHeight:int = 500; //600; 
      public static const WorldBorderThinknessLR:int = 10; 
      public static const WorldBorderThinknessTB:int = 10; // 20; // 20 is before v1.08
      
      public static const MinWorldWidth:int = 100;
      public static const MinWorldHeight:int = 100; 
      
      public static const LargeWorldHalfWidth:int = 12000; 
      public static const LargeWorldHalfHeight:int = 12000; 
      
      public static const WorldFieldMargin:int = 1024; // how much the entites can be put outside of the player field.
      
      public static const MinAppFPS:Number = 10.0;
      public static const MaxAppFPS:Number = 100.0;
      
      //public static const WorldStepTimeInterval_SpeedX2:Number = 1.0 / 30;
      //public static const WorldStepTimeInterval_SpeedX1:Number = 0.5 * WorldStepTimeInterval_SpeedX2;
      
      public static const WorldStepVelocityIterations_Low:int = 1;
      public static const WorldStepPositionIterations_Low:int = 1;
      public static const WorldStepVelocityIterations_Medium:int = 8;
      public static const WorldStepPositionIterations_Medium:int = 3;
      public static const WorldStepVelocityIterations_High:int = 15;
      public static const WorldStepPositionIterations_High:int = 5;
      
      public static function IsNormalScene (sceneLeft:int, sceneTop:int, sceneWidth:int, sceneHeight:int):Boolean
      {
         return sceneLeft == 0 && sceneTop == 0 && sceneWidth == DefaultWorldWidth && sceneHeight == DefaultWorldHeight;
      }
      public static function IsLargeScene (sceneLeft:int, sceneTop:int, sceneWidth:int, sceneHeight:int):Boolean
      {
         return sceneLeft == - LargeWorldHalfWidth / 2 && sceneTop == - LargeWorldHalfHeight / 2 && sceneWidth == LargeWorldHalfWidth && sceneHeight == LargeWorldHalfHeight;
      }
      
      // ...
      public static const BodyCloneOffsetX:uint = 20;
      public static const BodyCloneOffsetY:uint = 0;
      
      //=======
      
      public static function GetDefaultWorldSavedDataFilename (worldKey:String):String
      {
         return "-" + worldKey;
      }
      
//===========================================================================
// level
//===========================================================================
      
      public static const LevelProperty_Invalid:int = -1;
      public static const LevelProperty_JointColor:int = 0;
      public static const LevelProperty_CiStaticColor:int = 100;
      public static const LevelProperty_CiMovableColor:int = 101;
      public static const LevelProperty_CiBreakableColor:int = 102;
      public static const LevelProperty_CiInfectedColor:int = 103;
      public static const LevelProperty_CiUninfectedColor:int = 104;
      public static const LevelProperty_CiDontInfectColor:int = 105;
      public static const LevelProperty_ColorBlindMode:int = 1000;
      public static const LevelProperty_RenderQuality:int = 1001;
      
      // DOPN"T change these values. They are must same as the values in Viewer.
      public static const SceneSwitchingStyle_None:int = 0;
      public static const SceneSwitchingStyle_FadingIn:int = 1;
      public static const SceneSwitchingStyle_FadingOut:int = 2;
      public static const SceneSwitchingStyle_FadingOutThenFadingIn:int = 3;
      public static const SceneSwitchingStyle_Blend:int = 4;
      
      //curtain
      
//===========================================================================
// sound / module
//===========================================================================
      
      public static const ModuleId_None:int = -1;
      public static const SoundId_None:int = -1;
      
      
            
      public static const SequencedModule_ConstantPhysicsGeomForAllFrames:int = 1 << 0;
      //public SequencedModule_StopAtTheLastFrameLint = 1 << 1; // (<=> not loop)
      
//===========================================================================
// entity common
//===========================================================================
      
      // public static const MaxNumEntitiesInPlaying:uint = 10000; // entities defined in editor + entities created at runtime
         // unlimited now. Notice: there are some other limits below:
         // - MaxCoexistParticles
         // - If there is no contact proxy id between 0 and 0xFFFF to apply for a new shape, there may be some problems
      
      public static const MinEntityNameLength:int = 1;
      //public static const MaxEntityNameLength:int = 30; // would be 32 when plus 2 digits number
      public static const MaxEntityNameLength:int = 62; // would be 64 when plus 2 digits number
      
      public static const EntityId_None:int = -1;
      public static const EntityId_Ground:int = -2;
      public static const MinEntityId:int = -2;

//===========================================================================
// collsion category
//===========================================================================
      
      public static const MaxCCatsCount:int = 128; // can be larger
      
      public static const DefaultCCatName:String = "Category";
      
      public static const CCatId_None:int = -2;
      public static const CCatId_Hidden:int = -1;
      public static const MinCCatId:int = -1;
      
//===========================================================================
// shape common
//===========================================================================
      
      public static const DefaultShapeDensity:Number = 5; // 2700; // 2700 is the density of stone and glass
      
//===========================================================================
// rect
//===========================================================================
      
      public static const MinRectSideLength:uint = 2;
      public static const MaxRectSideLength:uint = int.MAX_VALUE; //600;
      public static const MaxRectArea:uint = int.MAX_VALUE; // 600 * 200;
      
//===========================================================================
// circle
//===========================================================================
      
      public static const MinCircleRadius:uint = MinRectSideLength * 0.5; // don't change
      public static const MaxCircleRadius:uint = int.MAX_VALUE; //100;
      
//===========================================================================
// bomb
//===========================================================================
      
      public static const MaxCoexistParticles:uint = 1000; // in playing
      
      public static const MinBombRadius:uint = MinCircleRadius; // don't change
      public static const MaxBombRadius:uint = 16;
      public static const MinBombSquareSideLength:uint = MinBombRadius * 2; // don't change
      public static const MaxBombSquareSideLength:uint = MaxBombRadius * 2;
      public static const DefaultBombSquareSideLength:uint = 16;
      
      public static const MinNumParticls_CreateExplosion:int = 4;
      public static const MaxNumParticls_CreateExplosion:int = 100;
      
//===========================================================================
// hinge
//===========================================================================
      
      public static const MaxHingeLimitAngle:int = 36000; // degree
      public static const MaxHingeMotorSpeed:int = 360; // degree
      public static const MaxHingeMotorTorque:Number = Number.MAX_VALUE; 
      
      public static const DefaultHingeMotorSpeed:int = 60; // degree
      public static const DefaultHingeMotorTorque:Number = 1.0e+10; // pixles-s-kg
      
//===========================================================================
// slider
//===========================================================================
      
      public static const MaxSliderLimitTranslation:int = 36000; // pixels
      public static const MaxSliderMotorSpeed:int = 300; // pixels
      public static const MaxSliderMotorForce:Number = Number.MAX_VALUE; 
      
      public static const DefaultSliderMotorSpeed:Number = 30; // pixles
      public static const DefaultSliderLimitTranslation:Number = 20; // pixles
      public static const DefaultSliderMotorForce:Number = 1.0e+8; // pixles-s-kg
      
//===========================================================================
// spring
//===========================================================================
      
      public static const SpringFrequencyDetermineManner_Preset:int = 0;
      public static const SpringFrequencyDetermineManner_CustomFrequency:int = 1;
      public static const SpringFrequencyDetermineManner_CustomSpringConstant:int = 2;
      
      public static const SpringType_Unkonwn:int = -1;
      public static const SpringType_Weak:int = 0;
      public static const SpringType_Normal:int = 1;
      public static const SpringType_Strong:int = 2;
      
      public static const MaxSpringFrequencyHz:Number = Infinity; // 100;
      
      public static const SpringSegmentLength:int = 16;
      
//===========================================================================
// text
//===========================================================================
      
      //public static const MinTextSideLength:uint = 10;
      
      //public static const MaxTextLength:uint = 4096;
      
      public static const ColorTextBackground:uint = 0xFFFEFEFE; // if set as FFFFFF, no bakcground is painted, why?
      
//===========================================================================
// text button
//===========================================================================
      
      public static const ColorTextButtonBackground:uint = 0xFFA0FFA0;
      public static const ColorTextButtonBackground_MouseOver:uint = 0xFFA0A0FF;
      public static const ColorTextButtonBackground_MouseDown:uint = 0xFFA0A0FF;
      public static const ColorTextButtonText:uint = 0x000000;
      public static const ColorTextButtonBorder:uint = 0x000000;
      
//===========================================================================
// gravity controller
//===========================================================================
      
      public static const kInteractiveColor:uint = 0x6060FF;
      public static const kUninteractiveColor:uint = 0xA0A0A0;
      
      public static const MinGravityControllerRadium:uint = 10;
      public static const MaxGravityControllerRadium:uint = 200;
      
      public static const GravityControllerZeroRegionRadius:int = 7;
      public static const GravityControllerOneRegionThinkness:int = 10;
      
      public static const GravityController_InteractiveZone_AllArea:uint = 0;
      public static const GravityController_InteractiveZone_Up:uint = 1;
      public static const GravityController_InteractiveZone_Down:uint = 2;
      public static const GravityController_InteractiveZone_Left:uint = 3;
      public static const GravityController_InteractiveZone_Right:uint = 4;
      public static const GravityController_InteractiveZone_Center:uint = 5;
      public static const GravityController_InteractiveZonesCount:uint = 6;
      
//===========================================================================
// camera
//===========================================================================
      
      public static const Camera_FollowedTarget_Brothers:int = 0;
      public static const Camera_FollowedTarget_Self:int = 1;
      
      public static const Camera_FollowingStyle_X       :int = 0x01;
      public static const Camera_FollowingStyle_Y       :int = 0x02;
      public static const Camera_FollowingStyle_Angle   :int = 0x04;
      public static const Camera_FollowingStyle_SmoothlyX       :int = 0x10;
      public static const Camera_FollowingStyle_SmoothlyY       :int = 0x20;
      public static const Camera_FollowingStyle_SmoothlyAngle   :int = 0x40;
      public static const Camera_FollowingStyle_Default :int = Camera_FollowingStyle_X | Camera_FollowingStyle_Y; // don't change it 
      
//===========================================================================
// power source
//===========================================================================
      
      public static const PowerSource_Force              :int = 0;
      public static const PowerSource_Torque             :int = 1;
      public static const PowerSource_LinearImpusle      :int = 2;
      public static const PowerSource_AngularImpulse     :int = 3;
      public static const PowerSource_AngularAcceleration:int = 4;
      public static const PowerSource_AngularVelocity    :int = 5;
      //public static const PowerSource_LinearAcceleration :int = 6;
      //public static const PowerSource_LinearVelocity     :int = 7;
      
//===========================================================================
// Logic
//===========================================================================
      
      //public static const NumRegistersPerVariableType:int = 16;
      public static const NumRegistersPerVariableType:int = 32; // from v1.10
      
      public static const MaxLogicComponentNameLength:int = 32;
      public static const TriggerComponentRadius:int = 10;
      
      public static const EntitySelectorType_Any:int = 0;
      public static const EntitySelectorType_Single:int = 1;
      public static const EntitySelectorType_Many:int = 2;
      
      public static const EntityAssignerType_Any:int = 0;
      public static const EntityAssignerType_Single:int = 1;
      public static const EntityAssignerType_Many:int = 2;
      
      public static const EntityPairAssignerType_OneToOne:int = 0;
      public static const EntityPairAssignerType_ManyToMany:int = 1;
      public static const EntityPairAssignerType_ManyToAny:int = 2;
      public static const EntityPairAssignerType_AnyToMany:int = 3;
      public static const EntityPairAssignerType_AnyToAny:int = 4;
      public static const EntityPairAssignerType_EitherInMany:int = 5;
      public static const EntityPairAssignerType_BothInMany:int = 6;
      
      public static const MaxEntitiesCountEachAssigner:int = 64; // valid for EntityAssignerType_Many and EntityPairAssignerType_OneToOne
      public static const MaxEntityPairesCountEachOneToOnePairAssigner:int = 32; // valid for EntityAssignerType_Many and EntityPairAssignerType_OneToOne
      
//===========================================================================
// Coding 
//===========================================================================
      
      public static const CodingFormat_Traditional:int = 0;
      public static const CodingFormat_ObjectOriented:int = 1;
      public static const CodingFormat_Poem:int = 2;
      
      public static const FunctionDefaultName:String = "Function";
      public static const ClassDefaultName:String = "Type";
      public static const PackageDefaultName:String = "Package";
      
//===========================================================================
// colors 
//===========================================================================
      
      public static const ColorObjectBorder:uint = 0x000000;
      
      
      public static const ColorStaticObject:uint = 0x606060;
      //public static const ColorMovableObject:uint = 0xA0A0FF;
      public static const ColorMovableObject:uint = 0x5555FF; // from v1.07
      
      public static const ColorBreakableObject:uint = 0xFF00FF; // 0xFF6600; // 
      
      public static const ColorInfectedObject:uint = 0x804000;
      public static const ColorUninfectedObject:uint = 0xFFFF00;
      public static const ColorDontInfectObject:uint = 0x60FF60;
      
      // v1.01
      public static const ColorBombObject:uint = 0x000000;
      
      // ...
      public static const BorderColorSelectedObject:uint = 0x0000FF;
      public static const BorderColorUnselectedObject:uint = Define.ColorObjectBorder;

//===========================================================================
// circle appearance type
//===========================================================================
      
      public static const CircleAppearanceType_Ball:int = 0;
      public static const CircleAppearanceType_Column:int = 1;
      public static const CircleAppearanceType_Circle:int = 2;
      
//===========================================================================
// random number generator methods
//===========================================================================
      
      public static const NumRngSlots:int = 4;
      
      public static const NumRngMethods:int = 1;
      
      public static const RngMethod_MersenneTwister:int = 0;
      
//===========================================================================
// entity types
//===========================================================================
      
      public static const kNumCreateStages:int = 3;
         
      // basic shapes
      public static const EntityType_Unkonwn:int = -1;
      public static const EntityType_ShapeCircle:int = 10;
      public static const EntityType_ShapeRectangle:int = 11;
      public static const EntityType_ShapePolygon:int = 12;
      public static const EntityType_ShapePolyline:int = 13;
      
      // preset shapes
      public static const EntityType_ShapeText:int = 31; // from v1.02
      public static const EntityType_ShapeGravityController:int = 32; // from v1.02
      public static const EntityType_ShapeTextButton:int = 33; // from v1.08
      
      // mobule shapes
      public static const EntityType_ShapeImageModule:int = 50; // from v1.58
      public static const EntityType_ShapeImageModuleButton:int = 51; // from v1.58

      // basic joints
      public static const EntityType_JointHinge:int = 60;
      public static const EntityType_JointSlider:int = 61;
      public static const EntityType_JointDistance:int = 62;
      public static const EntityType_JointSpring:int = 63; // from v1.01
      public static const EntityType_JointWeld:int = 64; // from v1.09
      public static const EntityType_JointDummy:int = 65; // from v1.09
      
      public static const SubEntityType_JointAnchor:int = 100;
      
      // preset shapes, for history reason, the id jumps to here
      public static const EntityType_UtilityCamera:int = 110;
      public static const EntityType_UtilityPowerSource:int = 111; // from v1.10
      
      // logic // from v1.07
      public static const EntityType_LogicCondition:int = 210;
      public static const EntityType_LogicTask:int = 211;
      public static const EntityType_LogicConditionDoor:int = 212;
      public static const EntityType_LogicEventHandler:int = 213;
      public static const EntityType_LogicInputEntityAssigner:int = 214;
      public static const EntityType_LogicInputEntityPairAssigner:int = 215;
      public static const EntityType_LogicAction:int = 216; // from v1.08
      public static const EntityType_LogicInputEntityFilter:int = 217; // from v1.56
      public static const EntityType_LogicInputEntityPairFilter:int = 218; // from v1.56
      
      // from v1.07, folloing functions should only be used in packaging / loading
      // they should NOT used in player pacakge, use player.EntityShape.mPhysicsShapePotentially instead
      
      public static function IsBasicAreaVectorShapeEntity (entityType:int):Boolean
      {
         return   entityType == EntityType_ShapeCircle
               || entityType == EntityType_ShapeRectangle
               || entityType == EntityType_ShapePolygon
               ;
      }
      
      public static function IsBasicPathVectorShapeEntity (entityType:int):Boolean
      {
         return   entityType == EntityType_ShapePolyline
               ;
      }
      
      public static function IsBasicVectorShapeEntity (entityType:int):Boolean
      {
         return   IsBasicAreaVectorShapeEntity (entityType)
               || IsBasicPathVectorShapeEntity (entityType)
               ;
      }
      
      public static function IsVectorShapeEntity (entityType:int):Boolean
      {
         return   IsBasicVectorShapeEntity (entityType) 
               || entityType == EntityType_ShapeText
               || entityType == EntityType_ShapeTextButton
               || entityType == EntityType_ShapeGravityController
               ;
      }
      
      public static function IsShapeEntity (entityType:int):Boolean
      {
         return   IsVectorShapeEntity (entityType)
               || entityType == EntityType_ShapeImageModule
               || entityType == EntityType_ShapeImageModuleButton
               ;
      }
      
      public static function IsPhysicsJointEntity (entityType:int):Boolean
      {
         return   entityType == EntityType_JointHinge 
               || entityType == EntityType_JointSlider 
               || entityType == EntityType_JointDistance 
               || entityType == EntityType_JointSpring 
               || entityType == EntityType_JointWeld 
               || entityType == EntityType_JointDummy 
               ;
      }
      
      public static function IsJointAnchorEntity (entityType:int):Boolean
      {
         return entityType == SubEntityType_JointAnchor;
      }
      
      public static function IsUtilityEntity (entityType:int):Boolean
      {
         return   entityType == EntityType_UtilityCamera
               || entityType == EntityType_UtilityPowerSource;
      }
      
      public static function IsLogicEntity (entityType:int):Boolean
      {
         return   entityType == EntityType_LogicCondition 
               || entityType == EntityType_LogicTask 
               || entityType == EntityType_LogicConditionDoor 
               || entityType == EntityType_LogicEventHandler 
               || entityType == EntityType_LogicAction 
               || entityType == EntityType_LogicInputEntityAssigner 
               || entityType == EntityType_LogicInputEntityPairAssigner 
               || entityType == EntityType_LogicInputEntityFilter
               || entityType == EntityType_LogicInputEntityPairFilter
               ;
      }
      
//===========================================================================
// shape ai types
//===========================================================================
      
      public static const ShapeAiType_Unknown:int = -1;
      public static const ShapeAiType_Static:int = 0;
      public static const ShapeAiType_Movable:int = 1;
      public static const ShapeAiType_Breakable:int = 2;
      public static const ShapeAiType_Infected:int = 3;
      public static const ShapeAiType_Uninfected:int = 4;
      public static const ShapeAiType_DontInfect:int = 5;
      
      // v1.02
      public static const ShapeAiType_Bomb:int = 6;
      public static const ShapeAiType_BombParticle:int = 100;
      
      public static function IsBreakableShape (shapeAiType:int):Boolean
      {
         return shapeAiType == ShapeAiType_Breakable;
      }
      
      public static function IsInfectableShape (shapeAiType:int):Boolean
      {
         return shapeAiType == ShapeAiType_Uninfected || shapeAiType == ShapeAiType_DontInfect;
      }
      
      public static function IsInfectedShape (shapeAiType:int):Boolean
      {
         return shapeAiType == ShapeAiType_Infected;
      }
      
      public static function IsBombShape (shapeAiType:int):Boolean
      {
         return shapeAiType == ShapeAiType_Bomb;
      }
      
      public static function GetShapeAiType (filledColor:uint):int
      {
         switch (filledColor)
         {
            case ColorStaticObject:
               return ShapeAiType_Static;
            case ColorMovableObject:
               return ShapeAiType_Movable;
            case ColorBreakableObject:
               return ShapeAiType_Breakable;
            case ColorInfectedObject:
               return ShapeAiType_Infected;
            case ColorUninfectedObject:
               return ShapeAiType_Uninfected;
            case ColorDontInfectObject:
               return ShapeAiType_DontInfect;
            
            case ColorBombObject:
               return ShapeAiType_Bomb;
            default:
               return ShapeAiType_Unknown;
         }
      }
      
      public static function GetShapeFilledColor (shapeAiType:int):uint
      {
         switch (shapeAiType)
         {
            case ShapeAiType_Static:
               return ColorStaticObject;
            case ShapeAiType_Movable:
               return ColorMovableObject;
            case ShapeAiType_Breakable:
               return ColorBreakableObject;
            case ShapeAiType_Infected:
               return ColorInfectedObject;
            case ShapeAiType_Uninfected:
               return ColorUninfectedObject;
            case ShapeAiType_DontInfect:
               return ColorDontInfectObject;
            
            case ShapeAiType_Bomb:
            case ShapeAiType_BombParticle:
               return ColorBombObject;
            case ShapeAiType_Unknown:
            default:
               return 0xFFFFFF;
         }
      }
      
   }
}
