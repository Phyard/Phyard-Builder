package player.entity {
   
   import flash.display.SimpleButton;
   
   import common.display.ModuleSprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.design.Global;
   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import player.module.Module;
   import player.module.ModuleInstance;
   
   import common.Define;
   import common.Transform2D;
   
   public class EntityShapeImageModuleButton extends EntityShape
   {
      public function EntityShapeImageModuleButton (world:World)
      {
         super (world);
         
         mPhysicsShapePotentially = true;
         
         mAppearanceObjectsContainer.addChild (mSimpleButton);
         
         mSimpleButton.hitTestState = mModuleSpriteUp;
         mSimpleButton.upState = mModuleSpriteUp;
               
         mSimpleButton.enabled = IsEnabled ();
         mSimpleButton.useHandCursor = true;
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mModuleIndexUp != undefined)
               SetModuleIndexUp (entityDefine.mModuleIndexUp);
            if (entityDefine.mModuleIndexOver != undefined)
               SetModuleIndexOver (entityDefine.mModuleIndexOver);
            if (entityDefine.mModuleIndexDown != undefined)
               SetModuleIndexDown (entityDefine.mModuleIndexDown);
         }
      }
      
      override public function ToEntityDefine (entityDefine:Object):Object
      {
         super.ToEntityDefine (entityDefine);
         
         entityDefine.mModuleIndexUp = mModuleIndexUp;
         entityDefine.mModuleIndexOver = mModuleIndexOver;
         entityDefine.mModuleIndexDown = mModuleIndexDown;
         
         entityDefine.mEntityType = Define.EntityType_ShapeImageModuleButton;
         return entityDefine;
      }
      
//=============================================================
//   initialize
//=============================================================
      
      override protected function InitializeInternal ():void
      {
         super.InitializeInternal ();
         
         mAppearanceObjectsContainer.mouseChildren = true; // !!! important
      }
      
//=============================================================
//   
//=============================================================
      
      override public function SetEnabled (enabled:Boolean):void
      {
         super.SetEnabled (enabled);
         
         mSimpleButton.enabled = IsEnabled ();
      }
      
      private var mUsingHandCurcor:Boolean = true;
      
      public function UsingHandCursor ():Boolean
      {
         return mUsingHandCurcor;
      }
      
      public function SetUsingHandCursor (usingHandCursor:Boolean):void
      {
         mUsingHandCurcor = usingHandCursor;
         
         mSimpleButton.useHandCursor = mUsingHandCurcor;
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mModuleIndexUp:int = -1;
      protected var mModuleIndexOver:int = -1;
      protected var mModuleIndexDown:int = -1;

      protected var mModuleInstanceUp:ModuleInstance = null;
      protected var mModuleInstanceOver:ModuleInstance = null;
      protected var mModuleInstanceDown:ModuleInstance = null;
      
      public function SetModuleIndexUp (moduleIndex:int):void
      {
         mModuleIndexUp = moduleIndex;
         mModuleInstanceUp = new ModuleInstance (Global.GetImageModuleByGlobalIndex (mModuleIndexUp));
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance (); 
      }

      public function SetModuleIndexOver (moduleIndex:int):void
      {
         // mModuleIndexUp should be set earlier than this
         mModuleIndexOver = moduleIndex;
         if (mModuleIndexOver >= 0)
            mModuleInstanceOver = new ModuleInstance (Global.GetImageModuleByGlobalIndex (mModuleIndexOver));
         else
         {
            mModuleInstanceOver = null;
            mModuleIndexOver = -1;
         }
         
         if (mWorld.GetBuildingStatus () != 0)
         {
            RebuildAppearanceForOverState ();
         }
      }

      public function SetModuleIndexDown (moduleIndex:int):void
      {
         // mModuleIndexUp should be set earlier than this
         mModuleIndexDown = moduleIndex;
         if (mModuleIndexDown >= 0)
            mModuleInstanceDown = new ModuleInstance (Global.GetImageModuleByGlobalIndex (mModuleIndexDown));
         else
         {
            mModuleInstanceDown = null;
            mModuleIndexDown = -1;
         }
         
         if (mWorld.GetBuildingStatus () != 0)
         {
            RebuildAppearanceForDownState ();
         }
      }
      
//=============================================================
//   
//=============================================================
      
      //public function OnModuleAppearanceChanged ():void
      //{
      //   mNeedRebuildAppearanceObjects = true;
      //   DelayUpdateAppearance ();
      //   
      //   if (mModuleIndexOver >= 0)
      //   {
      //      mModuleInstanceOver.RebuildAppearance (mModuleSpriteOver, null);
      //   }
      //   
      //   if (mModuleIndexDown >= 0)
      //   {
      //      mModuleInstanceDown.RebuildAppearance (mModuleSpriteDown, null);
      //   }
      //}
      
      private function RebuildAppearanceForOverState ():void
      {
         if (mModuleSpriteOver != null)
         {
            while (mModuleSpriteOver.numChildren > 0)
               mModuleSpriteOver.removeChildAt (0);
         }
         
         if (mModuleIndexOver >= 0)
         {
            if (mModuleSpriteOver == null)
               mSimpleButton.overState = mModuleSpriteOver = new ModuleSprite ();
            
            mModuleInstanceOver.RebuildAppearance (mModuleSpriteOver, null);
         }
         else
         {
            mModuleSpriteOver = null;
            mSimpleButton.overState = mModuleSpriteOver = mModuleSpriteUp;
         }
      }
      
      private function RebuildAppearanceForDownState ():void
      {
         if (mModuleSpriteDown != null)
         {
            while (mModuleSpriteDown.numChildren > 0)
               mModuleSpriteDown.removeChildAt (0);
         }
         
         if (mModuleIndexDown >= 0)
         {
            if (mModuleSpriteDown == null)
               mSimpleButton.downState = mModuleSpriteDown = new ModuleSprite ();
               
            mModuleInstanceDown.RebuildAppearance (mModuleSpriteDown, null);
         }
         else
         {
            mModuleSpriteDown = null;
            mSimpleButton.downState = mModuleSpriteDown = mModuleSpriteUp;
         }
      }
      
//=============================================================
//   update
//=============================================================
      
      override protected function UpdateInternal (dt:Number):void
      {
         if (mModuleInstanceUp.Step ())
         {
            mNeedRebuildAppearanceObjects = true;
            DelayUpdateAppearance ();
            
            OnShapeGeomModified (this);
         }
         
         // for over and down, waste time in most cases
         
         if (mModuleIndexOver >= 0 && mModuleInstanceOver.Step ())
         {
            RebuildAppearanceForOverState ();
         }
         
         if (mModuleIndexDown >= 0 && mModuleInstanceDown.Step ())
         {
            RebuildAppearanceForDownState ();
         }
      }
      
//=============================================================
//   appearance
//=============================================================
      
      protected var mSimpleButton:SimpleButton = new SimpleButton ();
      
      protected var mModuleSpriteUp:ModuleSprite = new ModuleSprite ();
      protected var mModuleSpriteOver:ModuleSprite = null;
      protected var mModuleSpriteDown:ModuleSprite = null;
      
      override public function UpdateAppearance ():void
      {
         mSimpleButton.visible = mVisible;
         mSimpleButton.alpha = mAlpha;
         
         if (mNeedRebuildAppearanceObjects)
         {
            mNeedRebuildAppearanceObjects = false;
            
            // ...
            while (mModuleSpriteUp.numChildren > 0)
               mModuleSpriteUp.removeChildAt (0);
            
            mModuleInstanceUp.RebuildAppearance (mModuleSpriteUp, null);
         }
         
         if (mNeedUpdateAppearanceProperties)
         {
            mNeedUpdateAppearanceProperties = false;
         }
         
         // the following is special for over and down, it is only really called at in World.Initialize.
         
         if (mWorld.GetSimulatedSteps () == 0)
         {
            RebuildAppearanceForOverState ();
            RebuildAppearanceForDownState ();
         }
      }
      
//=============================================================
//   physics proxy
//=============================================================

      override protected function RebuildShapePhysicsInternal ():void
      {
         // only mModuleInstanceUp is reponsiible for physics building
         if (mPhysicsShapeProxy != null && mModuleInstanceUp != null)
         {
            mModuleInstanceUp.RebuildPhysicsProxy (mPhysicsShapeProxy, mLocalTransform);
         }
      }

   }
}
