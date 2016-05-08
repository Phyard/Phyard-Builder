
package editor.entity {

   import flash.display.Sprite;
   import flash.display.BitmapData;
   
   import flash.geom.Point;

   import editor.selection.SelectionProxy;

   import editor.image.AssetImageShapeModule;
   import editor.image.AssetImageBitmapModule;
   
   import editor.image.vector.*;
   import common.shape.*;
   
   import common.Transform2D;
   import common.Define;

   public class EntityVectorShapeArea extends EntityVectorShape
   {
      
      protected var mVectorShapeArea:VectorShapeArea;

//====================================================================
//
//====================================================================

      public function EntityVectorShapeArea (container:Scene, vectorShapeArea:VectorShapeArea)
      {
         super (container, vectorShapeArea);
         
         mVectorShapeArea = vectorShapeArea;
      }

//======================================================
// appearance
//======================================================

      override public function SetBuildBorder (build:Boolean):void
      {
         mVectorShapeArea.SetBuildBorder (build);
      }

      override public function IsBuildBorder ():Boolean
      {
         //return mBuildBorder;
         return mVectorShapeArea.IsBuildBorder ();
      }

      override public function SetDrawBorder (draw:Boolean):void
      {
         //mDrawBorder = draw;
         mVectorShapeArea.SetDrawBorder (draw);
      }

      override public function IsDrawBorder ():Boolean
      {
         //return mDrawBorder;
         return mVectorShapeArea.IsDrawBorder ();
      }

      override public function SetBorderColor (color:uint):void
      {
         //mBorderColor = color;
         mVectorShapeArea.SetBorderColor (color);
      }

      override public function GetBorderColor ():uint
      {
         //return mBorderColor;
         return mVectorShapeArea.GetBorderColor ();
      }

      override public function SetBorderThickness (thinkness:uint):void
      {
         //mBorderThickness = thinkness;
         return mVectorShapeArea.SetBorderThickness (thinkness);
      }

      override public function GetBorderThickness ():Number
      {
         //if (mBorderThickness < 0)
         //   return 0;
         //
         //return mBorderThickness;
         return mVectorShapeArea.GetBorderThickness ();
      }

      override public function SetBorderTransparency (transparency:uint):void
      {
         //mBorderTransparency = transparency;
         mVectorShapeArea.SetBorderOpacity100 (transparency);
      }

      override public function GetBorderTransparency ():uint
      {
         //return mBorderTransparency;
         return mVectorShapeArea.GetBorderOpacity100 ();
      }

//======================================================
// 
//======================================================
      
      public function AlignTextureCenterWithShapeCenter ():Boolean
      {
         if (mVectorShape != null)
         {
            var bitmapModule:AssetImageBitmapModule = mVectorShape.GetBodyTextureModule () as AssetImageBitmapModule;
            if (bitmapModule == null)
               return false;
            
            var bitmapData:BitmapData = bitmapModule.GetBitmapData ();
            if (bitmapData == null)
               return false;
            
            var localTransform:Transform2D = mVectorShape.GetBodyTextureTransform (); // in shape space
            if (localTransform == null)
               localTransform = new Transform2D ();
            
            var textureCenter:Point = localTransform.TransformPointXY (0.5 * bitmapData.width, 0.5 * bitmapData.height);
            localTransform.mOffsetX -= textureCenter.x;
            localTransform.mOffsetY -= textureCenter.y;
            
            mVectorShape.SetBodyTextureTransform (localTransform);
            
            UpdateAppearance ();
            
            /*
            NotifyModifiedForReferers ();
            */
            
            return true;
         }
         
         return false;
      }

   }
}
