package player.entity {
   
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;

   import player.design.Global;
   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import player.image.ImageBitmap;
   
   import common.DataFormat2;
   
   import common.Define;
   import common.Transform2D;
   
   public class EntityShape_WithBodyTexture extends EntityShape
   {
      public function EntityShape_WithBodyTexture (world:World)
      {
         super (world);
      }

//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            var bodyTextureDefine:Object = entityDefine.mBodyTextureDefine;
            if (bodyTextureDefine != null && bodyTextureDefine.mModuleIndex >= 0)
            {
               SetBodyTextureModuleIndex (bodyTextureDefine.mModuleIndex);
               mBodyTextureTransform = new Transform2D (bodyTextureDefine.mPosX, bodyTextureDefine.mPosY, 
                                                        bodyTextureDefine.mScale, bodyTextureDefine.mIsFlipped, bodyTextureDefine.mRotation)
            }
         }
      }
      
      override public function ToEntityDefine (entityDefine:Object):Object
      {
         super.ToEntityDefine (entityDefine);
         
         if (mBodyTextureModule != null)
         {
            entityDefine.mBodyTextureDefine = DataFormat2.Texture2TextureDefine (mBodyTextureModuleIndex, mBodyTextureTransform);
         }
         
         return entityDefine;
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mBodyTextureModuleIndex:int = -1;
         protected var mBodyTextureModule:ImageBitmap = null;
      protected var mBodyTextureTransform:Transform2D;
      
      // for calling in loading 
      public function SetBodyTextureModuleIndex (bodyTextureModuleIndex:int):void
      {
         if (mBodyTextureModuleIndex == bodyTextureModuleIndex)
         {
            return;
         }
         
         mBodyTextureModuleIndex = bodyTextureModuleIndex;
         mBodyTextureModule = Global.GetImageModuleByGlobalIndex (mBodyTextureModuleIndex) as ImageBitmap;
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance (); 
      }
   }
}
