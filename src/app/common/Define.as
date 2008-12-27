
package common {
   
   public class Define
   {
      
      
//===========================================================================
// general
//===========================================================================
      
      public static const AboutUrl:String = "http://www.tapirgames.com";
      
//===========================================================================
// world
//===========================================================================
      
      public static const WorldWidth:int = 600; 
      public static const WorldHeight:int = 600; 
      public static const WorldBorderThinkness:int = 10; 
      
      public static const WorldStepTimeInterval:Number = 1.0 / 30;
      
      public static const MinCircleRadium:uint = 2;
      public static const MaxCircleRadium:uint = 100;
      
//===========================================================================
// colors
//===========================================================================
      
      public static const ColorObjectBorder:uint = 0xFF000000;
      
      
      public static const ColorStaticObject:uint = 0xFF606060;
      public static const ColorMovableObject:uint = 0xFFA0A0FF;
      
      public static const ColorBreakableObject:uint = 0xFFFF00FF;
      
      public static const ColorInfectedObject:uint = 0xFF804000;;
      public static const ColorUninfectedObject:uint = 0xFFFFFF00;
      public static const ColorDontInfectObject:uint = 0xFF60FF60;
      
      
//===========================================================================
// circle appearance type
//===========================================================================
      
      public static const CircleAppearanceType_Ball:int = 0;
      public static const CircleAppearanceType_Column:int = 1;
      
//===========================================================================
// entity types
//===========================================================================
      
      public static const EntityType_Unkonwn:int = -1;
      public static const EntityType_ShapeCircle:int = 10;
      public static const EntityType_ShapeRectangle:int = 11;
      public static const EntityType_JointHinge:int = 60;
      public static const EntityType_JointSlider:int = 61;
      public static const EntityType_JointDistance:int = 62;
      public static const SubEntityType_JointAnchor:int = 100;
      
      public static function IsPhysicsShapeEntity (entityType:int):Boolean
      {
         return entityType == EntityType_ShapeCircle || entityType == EntityType_ShapeRectangle;
      }
      
      public static function IsPhysicsJointEntity (entityType:int):Boolean
      {
         return entityType == EntityType_JointHinge || entityType == EntityType_JointSlider || entityType == EntityType_JointDistance;
      }
      
      public static function IsJointAnchorEntity (entityType:int):Boolean
      {
         return entityType == SubEntityType_JointAnchor;
      }
      
//===========================================================================
// shape ai types
//===========================================================================
      
      public static const ShapeAiType_Unkown:int = -1;
      public static const ShapeAiType_Static:int = 0;
      public static const ShapeAiType_Movable:int = 1;
      public static const ShapeAiType_Breakable:int = 2;
      public static const ShapeAiType_Infected:int = 3;
      public static const ShapeAiType_Uninfected:int = 4;
      public static const ShapeAiType_DontInfect:int = 5;
      
      
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
            default:
               return ShapeAiType_Unkown;
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
            default:
               return 0xFFFFFF;
         }
      }
      
   }
}
