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
         
         mAppearanceObjectsContainer.addChild (mModuleSprite);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mModuleIndex != undefined)
               SetModuleIndex (entityDefine.mModuleIndex);
         }
      }
      
      override public function ToEntityDefine (entityDefine:Object):Object
      {
         super.ToEntityDefine (entityDefine);
         
         entityDefine.mModuleIndex = mModuleIndex;
         
         entityDefine.mEntityType = Define.EntityType_ShapeImageModule;
         return entityDefine;
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mModuleIndex:int = -1;
      
      // for calling in loading 
      public function SetModuleIndex (moduleIndex:int):void
      {
         if (mModuleIndex == moduleIndex && mModuleInstance != null)
         {
            return;
         }
         
         mModuleIndex = moduleIndex;
         mModuleInstance = new ModuleInstance (Global.GetImageModuleByGlobalIndex (mModuleIndex));
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance (); 
      }

//=============================================================
//   
//=============================================================

      protected var mModuleInstance:ModuleInstance; // should not be null
            
      protected var mLoopToEndEventHandler:EntityEventHandler = null;
      
      // for calling in APIs
      public function SetModuleIndexByAPI (moduleIndex:int, loopToEndEventHandler:EntityEventHandler):void
      {
         SetModuleIndex (moduleIndex);
         
         mLoopToEndEventHandler = loopToEndEventHandler;
         
         RebuildShapePhysicsInternal ();
      }
      
      // return: if the module changed.
      private function OnModuleReachesSequeunceEnd (module:Module):Boolean
      {
         var moduleInstance:ModuleInstance = mModuleInstance;
         
         if (mLoopToEndEventHandler != null)
         {
            var valueSource1:Parameter_Direct = new Parameter_Direct (module);
            var valueSource0:Parameter_Direct = new Parameter_Direct (this, valueSource1);
            
            mWorld.IncStepStage ();
            mLoopToEndEventHandler.HandleEvent (valueSource0);
         }
         
         return moduleInstance != mModuleInstance;
      }
      
//=============================================================
//   
//=============================================================
      
      public function OnModuleAppearanceChanged ():void
      {
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance ();
      }
      
//=============================================================
//   update
//=============================================================
      
      override protected function UpdateInternal (dt:Number):void
      {
         if (mModuleInstance.Step (OnModuleReachesSequeunceEnd))
         {
            mNeedRebuildAppearanceObjects = true;
            DelayUpdateAppearance ();
            
            OnShapeGeomModified (this);
         }
      }
      
//=============================================================
//   appearance
//=============================================================
      
      protected var mModuleSprite:ModuleSprite = new ModuleSprite ();
      
      override public function UpdateAppearance ():void
      {
         mModuleSprite.visible = mVisible;
         mModuleSprite.alpha = mAlpha; 
         
         if (mNeedRebuildAppearanceObjects)
         {
            mNeedRebuildAppearanceObjects = false;
            
            // ...
            while (mModuleSprite.numChildren > 0)
               mModuleSprite.removeChildAt (0);
            
            mModuleInstance.RebuildAppearance (mModuleSprite, null);
         }
         
         if (mNeedUpdateAppearanceProperties)
         {
            mNeedUpdateAppearanceProperties = false;
         }
      }
      
//=============================================================
//   physics proxy
//=============================================================

      override protected function RebuildShapePhysicsInternal ():void
      {
         if (mPhysicsShapeProxy != null && mModuleInstance != null)
         {
            mModuleInstance.RebuildPhysicsProxy (mPhysicsShapeProxy, mLocalTransform);
         }
      }

   }
}
