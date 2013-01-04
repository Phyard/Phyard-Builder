package editor.world {

   import editor.entity.*;
   import editor.trigger.entity.*;

   public class Filters
   {



//=====================================================
// filter, used in joint dialog
//=====================================================

      public static function IsPhysicsShapeEntity (entity:Entity):Boolean
      {
         var shape:EntityShape =  entity as EntityShape;

         // before v1.58
         //return shape != null && shape.IsBasicShapeEntity () && shape.IsPhysicsEnabled ();

         // from v1.58
         return shape != null && shape.IsPhysicsCapableShapeEntity () && shape.IsPhysicsEnabled ();
            // maybe shape.IsPhysicsEnabled () is not needed.
      }

//=====================================================
// all kind of prototypes list
//=====================================================

   // can apply SetTask?

      public static const sTaskEntityClasses:Array  = [
                  Entity,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sVisualEntityClasses:Array = [
                  EntityShape,
                  EntityJoint,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sMoveableEntityClasses:Array = [
                  EntityShape,
                  EntityUtilityCamera,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sShapeEntityClasses:Array = [
                  EntityShape,
                  EntityUtilityCamera, // appended from v1.55
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sSimpleVectorShapeEntityClasses:Array = [
                  EntityVectorShape,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sCircleShapeEntityClasses:Array = [
                  EntityVectorShapeCircle,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sRectangleShapeEntityClasses:Array = [
                  EntityVectorShapeRectangle,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sPolyShapeEntityClasses:Array = [
                  EntityVectorShapePolygon,
                  EntityVectorShapePolyline,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sAeraShapeEntityClasses:Array = [
                  EntityVectorShapePolygon,
                  EntityVectorShapeRectangle,
                  EntityVectorShapeCircle,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sCurveShapeEntityClasses:Array = [
                  EntityVectorShapePolyline,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sTextEntityClasses:Array = [
                  EntityVectorShapeText,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sModuleShapeEntityClasses:Array = [
                  EntityShapeImageModule,
                  EntityShapeImageModuleButton,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sModuleButtonShapeEntityClasses:Array = [
                  EntityShapeImageModuleButton,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sCameraEntityClasses:Array = [
                  EntityUtilityCamera,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sGravityControllerEntityClasses:Array = [
                  EntityVectorShapeGravityController,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sJointEntityClasses:Array = [
                  EntityJoint,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sLimitsConfigureableJointEntityClasses:Array = [
                  EntityJointHinge,
                  EntityJointSlider,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sMotorConfigureableJointEntityClasses:Array = [
                  EntityJointHinge,
                  EntityJointSlider,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sJointHingeEntityClasses :Array = [
                  EntityJointHinge,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sJointSliderEntityClasses :Array = [
                  EntityJointSlider,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sLogicEntityClasses:Array = [
                  EntityLogic,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sScriptHolderEntityClasses:Array = [
                  EntityAction,
                  EntityBasicCondition,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sBasicConditionEntityClasses:Array = [
                  EntityBasicCondition,
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sTimerEventHandlerEntityClasses:Array = [
                  EntityEventHandler_Timer
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sOnModuleLoopToEndHandlerEntityClasses:Array = [
                  EntityEventHandler_ModuleLoopToEnd
            ];

      // object can be an Entity subclass.prototype or a subclass instance
      public static const sCanBeDisabledEntityClasses:Array = [
                  EntityEventHandler,
                  EntityUtilityPowerSource,
            ];
   }
}

