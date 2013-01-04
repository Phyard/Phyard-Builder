package player.entity {
   
   import common.display.ModuleSprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.design.Global;
   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import player.module.Module;
   import player.module.ModuleInstance;
   
   import player.trigger.entity.EntityEventHandler;
   import player.trigger.Parameter_Direct;
   
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
         SetModuleIndexByAPI_Internal (moduleIndex);
         
         mLoopToEndEventHandler = loopToEndEventHandler;
         
         //RebuildShapePhysicsInternal (); // ! bug, the old one is not destroyed.
         RebuildShapePhysics ();
      }
      
      protected function SetModuleIndexByAPI_Internal (moduleIndex:int):void
      {
         // to override
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
            var valueSource1:Parameter_Direct = new Parameter_Direct (module);
            var valueSource0:Parameter_Direct = new Parameter_Direct (this, valueSource1);
            
            mWorld.IncStepStage ();
            mLoopToEndEventHandler.HandleEvent (valueSource0);
         }
         
         return moduleInstance != GetModuleInstance ();
      }

   }
}
