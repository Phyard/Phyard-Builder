package player.entity {
   
   import common.display.ModuleSprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.world.Global;
   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import player.module.Module;
   import player.module.ModuleInstance;
   
   import player.trigger.entity.EntityEventHandler;
   
   import common.Define;
   import common.Transform2D;
   
   public class EntityShapeImageModuleGeneral extends EntityShapeImageModule
   {
      public function EntityShapeImageModuleGeneral (world:World)
      {
         super (world);
         
         mAppearanceObjectsContainer.addChild (mModuleSprite);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object, extraInfos:Object):void
      {
         super.Create (createStageId, entityDefine, extraInfos);
         
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
      
      override protected function SetModuleIndexByAPI_Internal (moduleIndex:int):Boolean
      {
         return SetModuleIndex (moduleIndex);
      }
      
      override public function GetModuleIndex ():int
      {
         return mModuleIndex;
      }
      
      override protected function GetModuleInstance ():ModuleInstance
      {
         return mModuleInstance;
      }
      
      protected var mModuleIndex:int = -1;

      protected var mModuleInstance:ModuleInstance; // should not be null
      
      // for calling in loading 
      public function SetModuleIndex (moduleIndex:int):Boolean
      {
         if (mModuleIndex == moduleIndex)
         {
            if ((mModuleIndex >= 0) == (mModuleInstance != null))
            {
               return false;
            }
         }
         
         mModuleIndex = moduleIndex;
         mModuleInstance = new ModuleInstance (Global.GetImageModuleByGlobalIndex (mModuleIndex));
         
         // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
         DelayUpdateAppearance (); 
         
         return true;
      }

//=============================================================
//   
//=============================================================
            
      private function OnModuleFrameChanged (updatePhysicsProxy:Boolean):void
      {
         // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
         DelayUpdateAppearance ();
         
         if (updatePhysicsProxy)
         {
            OnShapeGeomModified (this);
         }
      }
      
//=============================================================
//   
//=============================================================
      
      //public function OnModuleAppearanceChanged ():void
      //{
      //   // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
      //   DelayUpdateAppearance ();
      //}
      
//=============================================================
//   update
//=============================================================
      
      override protected function UpdateInternal (dt:Number):void
      {
         if (mModuleInstance != null)
            mModuleInstance.Step (OnModuleReachesSequeunceEnd, OnModuleFrameChanged);
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
            
            if (mModuleInstance != null)
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
