
package common {
   
   public class Define
   {
      
      
//===========================================================================
// general
//===========================================================================
      
      public static const AboutUrl:String = "http://www.colorinfection.com";
      public static const EditingTutorialUrl:String = "http://sites.google.com/site/colorinfectiondocument/documents/toturials";
      public static const ShowcasesUrl:String = "http://sites.google.com/site/colorinfectiondocument/showcases";
      public static const EmbedTutorialUrl:String = "http://sites.google.com/site/colorinfectiondocument/documents/publish-your-puzzles";
      public static const EditorUrl:String = "http://colorinfection.appspot.com/htmls/editor_page_beta.html";
      
//===========================================================================
// world
//===========================================================================
      
      //public static const MaxEntitiesCount:int = 512;
      public static const MaxEntitiesCount:int = 1024;
      
      public static const DefaultWorldWidth:int = 600; 
      public static const DefaultWorldHeight:int = 600; 
      public static const WorldBorderThinknessLR:int = 10; 
      public static const WorldBorderThinknessTB:int = 20; 
      
      public static const LargeWorldHalfWidth:int = 12000; 
      public static const LargeWorldHalfHeight:int = 12000; 
      
      public static const CategoryViewWidth:int = 680; 
      public static const CategoryViewHeight:int = 630; 
      
      public static const WorldStepTimeInterval:Number = 1.0 / 30;
      
      public static const DefaultGravityAcceleration:Number = 9.8;
      
      public static function IsNormalScene (sceneLeft:int, sceneTop:int, sceneWidth:int, sceneHeight:int):Boolean
      {
         return sceneLeft == 0 && sceneTop == 0 && sceneWidth == DefaultWorldWidth && sceneHeight == DefaultWorldHeight;
      }
      public static function IsLargeScene (sceneLeft:int, sceneTop:int, sceneWidth:int, sceneHeight:int):Boolean
      {
         return sceneLeft == - LargeWorldHalfWidth / 2 && sceneTop == - LargeWorldHalfHeight / 2 && sceneWidth == LargeWorldHalfWidth && sceneHeight == LargeWorldHalfHeight;
      }
      
      public static const MaxWorldZoomScale:Number = 4.0;
      public static const MinWorldZoomScale:Number = 1.0 / 16.0;
      
//===========================================================================
// joint connected shape index
//===========================================================================
      
      public static const EntityId_None:int = -1;
      public static const EntityId_Ground:int = -2;
      public static const MinEntityId:int = -2;
      
//===========================================================================
// collsion category
//===========================================================================
      
      public static const MaxCollisionCategoriesCount:int = 64; // must be less than 128
      
      public static const CategoryDefaultName:String = "Category";
      public static const MinCollisionCategoryNameLength:int = 1;
      public static const MaxCollisionCategoryNameLength:int = 30; // would be 32 when plus 2 digits number
      
      public static const CollisionCategoryId_HiddenCategory:int = -1;
      public static const MinCollisionCategoryId:int = -1;
      
//===========================================================================
// rect
//===========================================================================
      
      public static const MinRectSideLength:uint = 4;
      public static const MaxRectSideLength:uint = int.MAX_VALUE; //600;
      public static const MaxRectArea:uint = int.MAX_VALUE; // 600 * 200;
      
//===========================================================================
// circle
//===========================================================================
      
      public static const MinCircleRadium:uint = MinRectSideLength * 0.5; // don't change
      public static const MaxCircleRadium:uint = int.MAX_VALUE; //100;
      
//===========================================================================
// bomb
//===========================================================================
      
      public static const MinBombRadius:uint = 2; // don't change
      public static const MaxBombRadius:uint = 16;
      public static const MinBombSquareSideLength:uint = MinBombRadius * 2; // don't change
      public static const MaxBombSquareSideLength:uint = MaxBombRadius * 2;
      public static const DefaultBombSquareSideLength:uint = 16;
      
//===========================================================================
// hinge
//===========================================================================
      
      public static const MaxHingeLimitAngle:int = 36000; // degree
      public static const MaxHingeMotorSpeed:int = 360; // degree
      public static const MaxHingeMotorTorque:Number = Number.MAX_VALUE; 
      
      public static const DefaultHingeMotorTorque:Number = 10000000;
      
//===========================================================================
// slider
//===========================================================================
      
      public static const MaxSliderLimitTranslation:int = 36000; // degree
      public static const MaxSliderMotorSpeed:int = 300; // degree
      public static const MaxSliderMotorForce:Number = Number.MAX_VALUE; 
      
      public static const DefaultSliderMotorForce:Number = 100000000;
      
//===========================================================================
// spring
//===========================================================================
      
      public static const SpringType_Unkonwn:int = -1;
      public static const SpringType_Weak:int = 0;
      public static const SpringType_Normal:int = 1;
      public static const SpringType_Strong:int = 2;
      
      public static const MaxSpringFrequencyHz:Number = Infinity; // 100;
      
      public static const SpringSegmentLength:int = 16;
      
//===========================================================================
// text
//===========================================================================
      
      public static const MinTextSideLength:uint = 10;
      
      public static const MaxTextLength:uint = 1000;
      
//===========================================================================
// gravity controller
//===========================================================================
      
      public static const MinGravityControllerRadium:uint = 10;
      public static const MaxGravityControllerRadium:uint = 200;
      
      public static const GravityControllerZeroRegionRadius:int = 5;
      public static const GravityControllerOneRegionThinkness:int = 7;
      
//===========================================================================
// colors
//===========================================================================
      
      public static const ColorObjectBorder:uint = 0xFF000000;
      
      
      public static const ColorStaticObject:uint = 0xFF606060;
      public static const ColorMovableObject:uint = 0xFFA0A0FF;
      
      public static const ColorBreakableObject:uint = 0xFFFF00FF; // 0xFF6600; // 
      
      public static const ColorInfectedObject:uint = 0xFF804000;;
      public static const ColorUninfectedObject:uint = 0xFFFFFF00;
      public static const ColorDontInfectObject:uint = 0xFF60FF60;
      
      // v1.01
      public static const ColorBombObject:uint = 0xFF000000;
      
      //v1.02
      public static const ColorTextBackground:uint = 0xFFFEFEFE; // if set as FFFFFF, no bakcground is painted, why?
      
      
//===========================================================================
// circle appearance type
//===========================================================================
      
      public static const CircleAppearanceType_Ball:int = 0;
      public static const CircleAppearanceType_Column:int = 1;
      public static const CircleAppearanceType_Circle:int = 2;
      
//===========================================================================
// entity types
//===========================================================================
      
      public static const EntityType_Unkonwn:int = -1;
      public static const EntityType_ShapeCircle:int = 10;
      public static const EntityType_ShapeRectangle:int = 11;
      public static const EntityType_ShapePolygon:int = 12;
      
      public static const EntityType_ShapeText:int = 31; // from v1.02
      public static const EntityType_ShapeGravityController:int = 32; // from v1.02
      
      public static const EntityType_JointHinge:int = 60;
      public static const EntityType_JointSlider:int = 61;
      public static const EntityType_JointDistance:int = 62;
      public static const EntityType_JointSpring:int = 63; // from v1.01
      
      public static const SubEntityType_JointAnchor:int = 100;
      
      public static function IsBasicShapeEntity (entityType:int):Boolean
      {
         return   entityType == EntityType_ShapeCircle 
               || entityType == EntityType_ShapeRectangle
               || entityType == EntityType_ShapePolygon
               ;
      }
      
      public static function IsShapeEntity (entityType:int):Boolean
      {
         return   entityType == EntityType_ShapeCircle 
               || entityType == EntityType_ShapeRectangle 
               || entityType == EntityType_ShapePolygon 
               || entityType == EntityType_ShapeText
               || entityType == EntityType_ShapeGravityController
               ;
      }
      
      public static function IsPhysicsJointEntity (entityType:int):Boolean
      {
         return entityType == EntityType_JointHinge || entityType == EntityType_JointSlider || entityType == EntityType_JointDistance
                              || entityType == EntityType_JointSpring // v2.0
                              ;
      }
      
      public static function IsJointAnchorEntity (entityType:int):Boolean
      {
         return entityType == SubEntityType_JointAnchor;
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
            default:
               return 0xFFFFFF;
         }
      }
      
   }
}
