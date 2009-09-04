
package editor.trigger.entity {
   
   import flash.display.Sprite;
   
   
   import editor.world.World;
   
   import editor.selection.SelectionProxy;
   
   import editor.entity.Entity;
   import editor.entity.WorldEntity;
   
   import common.Define;
   
   public class EntityLogic extends WorldEntity implements Linkable
   {
      public static function ValidateLinkedEntities (entities:Array):void
      {
         if (entities == null)
            return;
         
         var entity:Entity;
         var i:int = 0;
         while (i < entities.length)
         {
            entity = entities [i] as Entity;
            if (entity == null || entity.GetEntityIndex () < 0)
               entities .splice (i, 1);
            else
               ++ i;
         }
      }
      
//====================================================================
//   
//====================================================================
      
      public function EntityLogic (world:World)
      {
         super (world);
      }
      
      override public function GetTypeName ():String
      {
         return "Logic";
      }
      
      override public function GetPhysicsShapesCount ():uint
      {
         return 0;
      }
      
//====================================================================
//   clone
//====================================================================
      
      // to override
      override protected function CreateCloneShell ():Entity
      {
         return null;
      }
      
//====================================================================
//   move, rotate, scale, flip
//====================================================================
      
      override public function RotateSelf (dRadians:Number):void
      {
      }
      
      override public function ScaleSelf (ratio:Number):void
      {
      }
      
      override public function FlipSelfHorizontally ():void
      {
      }
      
      override public function FlipSelfVertically ():void
      {
      }
      
//====================================================================
//   linkable
//====================================================================
      
      public function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int
      {
         return -1;
      }
      
      public function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean
      {
         return false;
      }
      
      public function TryToCreateLink (fromWorldDisplayX:Number, fromWorldDisplayY:Number, toEntity:Entity, toWorldDisplayX:Number, toWorldDisplayY:Number):Boolean
      {
         return false;
      }
   }
}
