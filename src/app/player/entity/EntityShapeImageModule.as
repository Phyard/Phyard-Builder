package player.entity {
   
   import common.display.ModuleSprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.world.Global;
   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import player.module.Module;
   import player.module.ModuleInstance;
   
   import player.trigger.CoreClassesHub;
   
   import player.trigger.entity.EntityEventHandler;
   import player.trigger.Parameter_DirectConstant;
   
   import common.Define;
   import common.Transform2D;
   
   public class EntityShapeImageModule extends EntityShape
   {
      public function EntityShapeImageModule (world:World)
      {
         super (world);
         
         mPhysicsShapePotentially = true;
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mLoopToEndEventHandler:EntityEventHandler = null;
      
      // for calling in APIs
      public function SetModuleIndexByAPI (moduleIndex:int, loopToEndEventHandler:EntityEventHandler):void
      {
         if (SetModuleIndexByAPI_Internal (moduleIndex))
         {
            //RebuildShapePhysicsInternal (); // ! bug, the old one is not destroyed.
            RebuildShapePhysics ();
         }
         
         mLoopToEndEventHandler = loopToEndEventHandler;
      }
      
      protected function SetModuleIndexByAPI_Internal (moduleIndex:int):Boolean
      {
         return false; // to override
      }
      
      protected function GetModuleInstance ():ModuleInstance
      {
         // to override
      
         return null;
      }
      
      public function GetModuleIndex ():int
      {
         // to override
         
         return -1;
      }
      
      // return: if the module changed.
      protected function OnModuleReachesSequeunceEnd (module:Module):Boolean
      {
         var moduleInstance:ModuleInstance = GetModuleInstance ();
         
         if (mLoopToEndEventHandler != null)
         {
            var valueSource1:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kModuleClassDefinition, module, null);
            var valueSource0:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClassesHub.kEntityClassDefinition, this, valueSource1);
            
            mWorld.IncStepStage ();
            mLoopToEndEventHandler.HandleEvent (valueSource0);
         }
         
         return moduleInstance != GetModuleInstance ();
      }

   }
}
