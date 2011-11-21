package player.entity {
   
   import common.display.ModuleSprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.design.Global;
   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import player.module.Module;
   import player.module.ModuleInstance;
   
   import player.trigger.entity.EntityEventHandler;
   
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

//=============================================================
//   
//=============================================================

      protected var mModuleInstance:ModuleInstance; // should not be null
            
      protected var mLoopToEndEventHandler:EntityEventHandler = null;
      
      public function SetModuleIndex (moduleIndex:int, loopToEndEventHandler:EntityEventHandler = null):void
      {
         mModuleIndex = moduleIndex;
         mModuleInstance = new ModuleInstance (Global.GetImageModuleByGlobalIndex (mModuleIndex));
         
         mLoopToEndEventHandler = loopToEndEventHandler;
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance (); 
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
         if (mModuleInstance.Step ())
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
