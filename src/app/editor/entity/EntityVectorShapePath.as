
package editor.entity {

   import flash.display.Sprite;

   import editor.selection.SelectionProxy;

   import editor.image.AssetImageShapeModule;
   
   import editor.image.vector.*;
   import common.shape.*;

   import common.Define;

   public class EntityVectorShapePath extends EntityVectorShape
   {
      
      protected var mVectorShapePath:VectorShapePath;

//====================================================================
//
//====================================================================

      public function EntityVectorShapePath (container:Scene, vectorShapePath:VectorShapePath)
      {
         super (container, vectorShapePath);
         
         mVectorShapePath = vectorShapePath;
      }

//======================================================
// appearance
//======================================================
      
      public function SetCurveThickness (thickness:uint):void
      {
         //mCurveThickness = thickness;
         mVectorShapePath.SetPathThickness (thickness);
      }

      public function GetCurveThickness ():uint
      {
         //return mCurveThickness;
         return mVectorShapePath.GetPathThickness ();
      }

      public function SetRoundEnds (roundEnds:Boolean):void
      {
         //mIsRoundEnds = roundEnds;
         mVectorShapePath.SetRoundEnds (roundEnds);
      }

      public function IsRoundEnds ():Boolean
      {
         //return mIsClosed || mIsRoundEnds;
         return mVectorShapePath.IsRoundEnds () || IsClosed ();
      }

      public function SetClosed (closed:Boolean):void
      {
         //mIsClosed = closed;
         mVectorShapePath.SetClosed (closed);
      }

      public function IsClosed ():Boolean
      {
         //return mIsClosed;
         return mVectorShapePath.IsClosed ();
      }

   }
}
