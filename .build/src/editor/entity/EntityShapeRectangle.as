
package editor.entity {
   
   import flash.display.Sprite;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.setting.EditorSetting;
   
   public class EntityShapeRectangle extends EntityShape 
   {
   // geom
      
      public var mHalfWidth:Number;
      public var mHalfHeight:Number;
      
      public function EntityShapeRectangle (world:World)
      {
         super (world);
         
         SetHalfWidth (0);
         SetHalfHeight (0);
      }
      
      override public function UpdateAppearance ():void
      {
         var borderColor:uint;
         var borderSize :int;
         
         if ( IsSelected () )
         {
            borderColor = EditorSetting.BorderColorSelectedObject;
            borderSize  = 3;
         }
         else
         {
            borderColor = mDrawBorder ? mBorderColor : mFilledColor;
            borderSize  = mDrawBorder ? 1 : 0;
         }
         
         alpha = 0.7;
         
         GraphicsUtil.ClearAndDrawRect (this, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, borderSize, true, mFilledColor);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mWorld.mSelectionEngine.CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
         }
         
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle ( GetRotation (), GetPositionX (), GetPositionY (), GetHalfWidth (), GetHalfHeight () );
      }
      
      
      public function SetHalfWidth (halfWidth:Number):void
      {
         mHalfWidth = halfWidth;
      }
      
      public function SetHalfHeight (halfHeight:Number):void
      {
         mHalfHeight = halfHeight;
      }
      
      public function GetHalfWidth ():Number
      {
         return mHalfWidth;
      }
      
      public function GetHalfHeight ():Number
      {
         return mHalfHeight;
      }
      
      override public function ScaleSelf (ratio:Number):void
      {
         var halfWidth:Number  = mHalfWidth * ratio;
         var halfHeight:Number = mHalfHeight * ratio;
         
         if (halfWidth < EditorSetting.MinRectSideLength)
            halfWidth =  EditorSetting.MinRectSideLength;
         if (halfWidth > EditorSetting.MaxRectSideLength)
            halfWidth =  EditorSetting.MaxRectSideLength;
         
         if (halfHeight < EditorSetting.MinRectSideLength)
            halfHeight =  EditorSetting.MinRectSideLength;
         if (halfHeight > EditorSetting.MaxRectSideLength)
            halfHeight =  EditorSetting.MaxRectSideLength;
         
         SetHalfWidth (halfWidth);
         SetHalfHeight (halfHeight);
      }
      
      
//========================================================================
// vertex controllers
//========================================================================
      
      private var mVertexController0:VertexController = null;
      private var mVertexController1:VertexController = null;
      private var mVertexController2:VertexController = null;
      private var mVertexController3:VertexController = null;
      
      override public function SetVertexControllersVisible (visible:Boolean):void
      {
         // mVertexControlPointsVisible = visible;
         super.SetVertexControllersVisible (visible);
         
      // create / destroy controllers
         
         if ( AreVertexControlPointsVisible () )
         {
            if (mVertexController0 == null)
            {
               mVertexController0 = new VertexController (mWorld, this);
               addChild (mVertexController0);
            }
            
            if (mVertexController1 == null)
            {
               mVertexController1 = new VertexController (mWorld, this);
               addChild (mVertexController1);
            }
            
            if (mVertexController2 == null)
            {
               mVertexController2 = new VertexController (mWorld, this);
               addChild (mVertexController2);
            }
            
            if (mVertexController3 == null)
            {
               mVertexController3 = new VertexController (mWorld, this);
               addChild (mVertexController3);
            }
            
            UpdateVertexControllers ();
         }
         else
         {
            if (mVertexController0 != null)
            {
               mVertexController0.Destroy ();
               if (contains (mVertexController0))
                  removeChild (mVertexController0);
               
               mVertexController0 = null;
            }
            
            if (mVertexController1 != null)
            {
               mVertexController1.Destroy ();
               if (contains (mVertexController1))
                  removeChild (mVertexController1);
               
               mVertexController1 = null;
            }
            
            if (mVertexController2 != null)
            {
               mVertexController2.Destroy ();
               if (contains (mVertexController2))
                  removeChild (mVertexController2);
               
               mVertexController2 = null;
            }
            
            if (mVertexController3 != null)
            {
               mVertexController3.Destroy ();
               if (contains (mVertexController3))
                  removeChild (mVertexController3);
               
               mVertexController3 = null;
            }
         }
      }
      
      private function UpdateVertexControllers ():void
      {
         if (mVertexController0 != null)
         {
            mVertexController0.SetPosition (- GetHalfWidth (), - GetHalfHeight ());
            mVertexController0.UpdateSelectionProxy ();
         }
         
         if (mVertexController1 != null)
         {
            mVertexController1.SetPosition ( GetHalfWidth (), - GetHalfHeight ());
            mVertexController1.UpdateSelectionProxy ();
         }
         
         if (mVertexController2 != null)
         {
            mVertexController2.SetPosition ( GetHalfWidth (), GetHalfHeight ());
            mVertexController2.UpdateSelectionProxy ();
         }
         
         if (mVertexController3 != null)
         {
            mVertexController3.SetPosition (- GetHalfWidth (), GetHalfHeight ());
            mVertexController3.UpdateSelectionProxy ();
         }
      }
      
      
      override public function OnMovingVertexController (vertexController:VertexController, localOffsetX:Number, localOffsetY:Number):void
      {
      // ...
      
         var vertexIndex:int = -1;
         if (vertexController == mVertexController0) vertexIndex = 0;
         if (vertexController == mVertexController1) vertexIndex = 1;
         if (vertexController == mVertexController2) vertexIndex = 2;
         if (vertexController == mVertexController3) vertexIndex = 3;
         
         if (vertexIndex < 0)
            return;
      
         var vertexIndex2:int = (vertexIndex + 2) % 4;
         var vertexController2:VertexController = null;
         if (vertexIndex2 == 0) vertexController2 = mVertexController0;
         if (vertexIndex2 == 1) vertexController2 = mVertexController1;
         if (vertexIndex2 == 2) vertexController2 = mVertexController2;
         if (vertexIndex2 == 3) vertexController2 = mVertexController3;
         
         if (vertexController2 == null)
            return;
      
         var x1:Number;
         var y1:Number;
         var x2:Number;
         var y2:Number;
         
         if (vertexController.x < vertexController2.x)
         {
            x1 = vertexController.x + localOffsetX;
            x2 = vertexController2.x;
         }
         else
         {
            x1 = vertexController2.x;
            x2 = vertexController.x + localOffsetX;
         }
         if (vertexController.y < vertexController2.y)
         {
            y1 = vertexController.y + localOffsetY;
            y2 = vertexController2.y;
         }
         else
         {
            y1 = vertexController2.y;
            y2 = vertexController.y + localOffsetY;
         }
         
         var halfWidth:Number  = (x2 - x1) * 0.5;
         var halfHeight:Number = (y2 - y1) * 0.5;
      
         if (halfWidth < EditorSetting.MinRectSideLength)
            return;
         if (halfWidth > EditorSetting.MaxRectSideLength)
            return;
         
         if (halfHeight < EditorSetting.MinRectSideLength)
            return;
         if (halfHeight > EditorSetting.MaxRectSideLength)
            return;
         
         SetHalfWidth  (halfWidth);
         SetHalfHeight (halfHeight);
         
         var worldPos:Point = World.LocalToLocal (this, mWorld, new Point ( (x2 + x1) * 0.5, (y2 + y1) * 0.5) );
         
         SetPosition (worldPos.x, worldPos.y);
         
      // ...
         
         UpdateAppearance ();
         UpdateSelectionProxy ();
         UpdateVertexControllers ();
      }
      
      override public function Move (offsetX:Number, offsetY:Number):void
      {
         super.Move (offsetX, offsetY);
         
         UpdateVertexControllers ();
      }
      
      override public function Rotate (centerX:Number, centerY:Number, dRadians:Number):void
      {
         super.Rotate (centerX, centerY, dRadians);
         
         UpdateVertexControllers ();
      }
      
      override public function Scale (centerX:Number, centerY:Number, ratio:Number):void
      {
         super.Scale (centerX, centerY, ratio);
         
         UpdateVertexControllers ();
      }
      
      
   }
}
