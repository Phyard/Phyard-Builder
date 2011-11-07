package player.entity {
   
   import common.display.ModuleSprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.design.Global;
   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import player.module.Module;
   import player.module.ModuleInstance;
   
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

      public function SetModuleIndex (moduleIndex:int):void
      {
         mModuleIndex = moduleIndex;
         mModuleInstance = new ModuleInstance (Global.GetImageModuleByGlobalIndex (mModuleIndex));
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance (); 
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mModuleInstance:ModuleInstance = null;
      
      public function OnModuleappearanceChanged ():void
      {
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance ();
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
            mModuleInstance.RebuildPhysicsProxy (mPhysicsShapeProxy, 
                           //new Transform2D (mLocalPositionX, mLocalPositionY, mScale, mFlipped, mRelativeRotation)
                           // if mFlipped is true, mRelativeRotation should be changed to "PI - mRelativeRotation"?
                           new Transform2D (mLocalPositionX, mLocalPositionY, mScale, false, mRelativeRotation)
                        );
         }
      }

   }
}
