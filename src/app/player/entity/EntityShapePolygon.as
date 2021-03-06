package player.entity {
   
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;

   import flash.geom.Point;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   import common.Transform2D;
   
   public class EntityShapePolygon extends EntityShapePolyShape
   {
      public function EntityShapePolygon (world:World)
      {
         super (world);
         
         mPhysicsShapePotentially = true;
         
         mAppearanceObjectsContainer.addChild (mBackgroundShape);
         mAppearanceObjectsContainer.addChild (mBorderShape);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object, extraInfos:Object):void
      {
         super.Create (createStageId, entityDefine, extraInfos);
         
         if (createStageId == 0)
         {
            if (entityDefine.mLocalPoints != undefined)
               SetLocalDisplayVertexPoints (entityDefine.mLocalPoints);
         }
      }
      
      override public function ToEntityDefine (entityDefine:Object):Object
      {
         super.ToEntityDefine (entityDefine);
         
         // vetexes handled on parent class
         
         entityDefine.mEntityType = Define.EntityType_ShapePolygon;
         
         return entityDefine;
      }
      
//=============================================================
//   appearance
//=============================================================
      
      private var mBackgroundShape:Shape = new Shape ();
      private var mBorderShape    :Shape = new Shape ();
      
      override public function UpdateAppearance ():void
      {
         mAppearanceObjectsContainer.visible = mVisible;
         mAppearanceObjectsContainer.alpha = mAlpha; 
         
         if (mNeedRebuildAppearanceObjects)
         {
            mNeedRebuildAppearanceObjects = false;
            
            var displayBorderThickness:Number = mWorld.GetCoordinateSystem ().P2D_Length (mBorderThickness);
            
            // todo: body texture (remember add texture define in ToEntityDefine)
            
            GraphicsUtil.ClearAndDrawPolygon (
                     mBackgroundShape,
                     mLocalDisplayPoints,
                     mBorderColor,
                     -1, // not draw border
                     true, // draw background
                     GetFilledColor (), 
                     mBodyTextureModule == null ? null : mBodyTextureModule.GetBitmapData (),
                     mBodyTextureTransform == null ? null : mBodyTextureTransform.ToMatrix ()
                  );
            
            GraphicsUtil.ClearAndDrawPolygon (
                     mBorderShape,
                     mLocalDisplayPoints,
                     mBorderColor,
                     displayBorderThickness, // draw border
                     false // not draw background
                  );
         }
         
         if (mNeedUpdateAppearanceProperties)
         {
            mNeedUpdateAppearanceProperties = false;
            
            mBackgroundShape.visible = IsDrawBackground ();
            mBackgroundShape.alpha = GetTransparency () * 0.01;
            mBorderShape.visible = IsDrawBorder ();
            mBorderShape.alpha = GetBorderTransparency () * 0.01;
         }
      }
     
//=============================================================
//   physics proxy
//=============================================================
     
      override protected function RebuildShapePhysicsInternal ():void
      {
         if (mPhysicsShapeProxy != null)
         {
            //mPhysicsShapeProxy.AddPolygon (mIsStatic, mLocalPoints, mBuildInterior, mBuildBorder, mBorderThickness);
            var accTrans:Transform2D = mWorld.GetCoordinateSystem ().As_D2P_Vector_Transform_CombineByTransform (mLocalTransform);
            mPhysicsShapeProxy.AddPolygon (accTrans, 
                                           mLocalDisplayPoints, // mLocalPoints, 
                                           mBuildInterior, 
                                           mBuildBorder, 
                                           mWorld.GetCoordinateSystem ().P2D_Length(mBorderThickness)
                                           );
         }
      }
      
      
      
   }
}
