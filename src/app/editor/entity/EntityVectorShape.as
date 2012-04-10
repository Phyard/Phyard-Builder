
package editor.entity {

   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;

   import com.tapirgames.util.GraphicsUtil;
   
   import editor.selection.SelectionProxy;
   
   import editor.asset.ControlPoint;
   import editor.asset.ControlPointModifyResult;
   
   import editor.image.vector.*;
   import common.shape.*;

   import common.Transform2D;
   import common.Define;

   public class EntityVectorShape extends EntityShape
   {
   // C.I.

      protected var mAiType:int = Define.ShapeAiType_Unknown;

   // appearance

      //protected var mDrawBorder:Boolean = true;
      //protected var mDrawBackground:Boolean = true;
      //
      //protected var mBorderColor:uint = Define.BorderColorUnselectedObject;
      //protected var mBorderThickness:uint = 1; // from v1.04
      //protected var mBorderTransparency:uint = 100; // from v1.05
      //
      //protected var mFilledColor:uint = 0xFFFFFF;
      //
      //protected var mTransparency:uint = 100; // from v1.04
      
      protected var mVectorShape:VectorShape;

//====================================================================
//
//====================================================================

      public function EntityVectorShape (container:Scene, vectorShape:VectorShape)
      {
         super (container);
         
         mVectorShape = vectorShape;
      }

      override public function GetVisibleAlphaForEditing ():Number
      {
         return 0.39 + GetTransparency () * 0.01 * 0.40;
      }

      override public function GetTypeName ():String
      {
         return "Shape";
      }

      override public function IsBasicVectorShapeEntity ():Boolean
      {
         return true;
      }
      
//====================================================================
//   
//====================================================================
      
      public function GetVectorShape ():VectorShapeForEditing
      {
         return mVectorShape as VectorShapeForEditing;
      }
      
      public function IsValid ():Boolean
      {
         return mVectorShape.IsValid ();
      }
      
      // return position
      public function OnCreating (points:Array):Point
      {
         return (mVectorShape as VectorShapeForEditing).OnCreating (points);
      }

//====================================================================
//   appearacne and selection proxy
//====================================================================
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         GraphicsUtil.Clear (this);

         if (mAiType >= 0)
         {
            SetFilledColor (Define.GetShapeFilledColor (mAiType));
            SetBorderColor (Define.ColorObjectBorder);
            SetDrawBackground (true);
         }
         
         var shapeSprite:DisplayObject = (mVectorShape as VectorShapeForEditing).CreateSprite (IsSelected ());
         addChild (shapeSprite);
         
         SetVisibleForEditing (mVisibleForEditing); //  recal alpha
         
         /*
         if (IsSelected ())
         {
            var shape:Shape = new Shape ();
            shape.alpha = 0.5;
            
            var rectangle:Rectangle = this.getBounds (this);
            GraphicsUtil.DrawRect (shape, rectangle.left, rectangle.top, rectangle.width, rectangle.height,
                                       0x0000FF, -1, true, 0xC0C0FF, false);
            
            addChild (shape);
         }
         */
            
         if (AreControlPointsVisible ())
         {
            addChild (mControlPointsContainer);
         }
      }

      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mAssetManager.GetSelectionEngine ().CreateProxyGeneral ();
            mSelectionProxy.SetUserData (this);
         }
         
         mSelectionProxy.Rebuild (GetPositionX (), GetPositionY (), 0.0);
         (mVectorShape as VectorShapeForEditing).BuildSelectionProxy (mSelectionProxy, new Transform2D (0.0, 0.0, GetScale (), IsFlipped (), GetRotation ()), mEntityContainer.GetScale () * GetScale ());
      }
      
//=============================================================
//   control points
//=============================================================
      
      protected var mControlPointsContainer:Sprite = new Sprite ();
      protected var mControlPoints:Array = null;
      
      override public function GetControlPointContainer ():Sprite
      {
         return mControlPointsContainer; // to override
      }
      
      override protected function UpdateControlPoints_Internal ():void
      {
         if (mControlPoints == null)
            return;
         
         for each (var cp:ControlPoint in mControlPoints)
         {
            cp.Refresh ();
         }
      }
      
      override protected function RebuildControlPoints ():void
      {
         if (mControlPoints != null)
            DestroyControlPoints ();
         
         addChild (mControlPointsContainer);
         mControlPoints = (mVectorShape as VectorShapeForEditing).CreateControlPointsForAsset (this);
         
         mAssetManager.RegisterShownControlPoints (mControlPoints);
      }
      
      override protected function DestroyControlPoints ():void
      {
         for (var i:int = mControlPoints.length - 1; i >= 0; -- i)
         {
            (mControlPoints [i] as ControlPoint).Destroy ();
         }
         
         mControlPoints = null;
         if (mControlPointsContainer.parent != null) // should be this
            mControlPointsContainer.parent.removeChild (mControlPointsContainer);
            
         mAssetManager.UnregisterShownControlPointsOfAsset (this);
      }
      
      override public function OnSoloControlPointSelected (controlPoint:ControlPoint):void
      {
         super.OnSoloControlPointSelected (controlPoint);
         
         var secondarySelectedControlPointIndex:int = (mVectorShape as VectorShapeForEditing).GetSecondarySelectedControlPointId (controlPoint.GetIndex ());
         if (secondarySelectedControlPointIndex >= 0 && mControlPoints != null && secondarySelectedControlPointIndex < mControlPoints.length)
         {
            (mControlPoints [secondarySelectedControlPointIndex] as ControlPoint).SetSelectedLevel (ControlPoint.SelectedLevel_Secondary);
         }
      }
      
      protected function OnControlPointsModified (result:ControlPointModifyResult, actionDone:Boolean):void
      {
         if (result == null)
            return;
         
         if (result.mToDeleteAsset)
         {
         }
         else
         {
            var localAssetDisplayment:Point = new Point (result.mAssetPosLocalAdjustX, result.mAssetPosLocalAdjustY);
            var globalAssetDisplayment:Point = AssetToManager (localAssetDisplayment, false);
            SetPosition (GetPositionX () + globalAssetDisplayment.x, GetPositionY () + globalAssetDisplayment.y);

            if (actionDone)
            {
               UpdateSelectionProxy ();
               RebuildControlPoints ();
               var selectedControlPointIndex:int = result.mNewSelectedControlPointIndex;
               if (selectedControlPointIndex >= 0 && selectedControlPointIndex < mControlPoints.length)
               {
                  OnSoloControlPointSelected (mControlPoints [selectedControlPointIndex] as ControlPoint);
               }
            }
            
            UpdateAppearance ();
         }
         
         if (actionDone)
         {
            NotifyModifiedForReferers ();
         }
      }

      override public function MoveControlPoint (controlPoint:ControlPoint, dx:Number, dy:Number, done:Boolean):void
      {
         var localDisplayment:Point = ManagerToAsset (new Point (dx, dy), false); 
         
         var result:ControlPointModifyResult = (mVectorShape as VectorShapeForEditing).OnMoveControlPoint (mControlPoints, controlPoint.GetIndex (), localDisplayment.x, localDisplayment.y);
         OnControlPointsModified (result, done);
      }

      override public function DeleteControlPoint (controlPoint:ControlPoint):void
      {
         var result:ControlPointModifyResult = (mVectorShape as VectorShapeForEditing).DeleteControlPoint (mControlPoints, controlPoint.GetIndex ());
         OnControlPointsModified (result, true);
      }

      override public function InsertControlPointBefore (controlPoint:ControlPoint):void
      {
         var result:ControlPointModifyResult = (mVectorShape as VectorShapeForEditing).InsertControlPointBefore (mControlPoints, controlPoint.GetIndex ());
         OnControlPointsModified (result, true);
      }

//====================================================================
//   clone
//====================================================================

      // to override
      override protected function CreateCloneShell ():Entity
      {
         return null;
      }

      // to override
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);

         var shape:EntityVectorShape = entity as EntityVectorShape;

         shape.SetAiType (mAiType);

         shape.SetFilledColor ( GetFilledColor () );
         shape.SetBorderColor ( GetBorderColor () );
         shape.SetDrawBorder ( IsDrawBorder () );
         shape.SetDrawBackground ( IsDrawBackground () );
         shape.SetBorderThickness (GetBorderThickness ());
         shape.SetTransparency (GetTransparency ());
         shape.SetBorderTransparency (GetBorderTransparency ());

         //shape.SetHollow (IsHollow ());
         //shape.SetBuildBorder (IsBuildBorder ());
      }

//======================================================
// C.I. special
//======================================================

      public function GetAiType ():int
      {
         return mAiType;
      }

      public function SetAiType (aiType:int):void
      {
         mAiType = aiType;
      }

//======================================================
// appearance
//======================================================

      public function SetDrawBackground (draw:Boolean):void
      {
         //mDrawBackground = draw;
         mVectorShape.SetDrawBackground (draw);
      }

      public function IsDrawBackground ():Boolean
      {
         //return mDrawBackground;
         return mVectorShape.IsDrawBackground ();
      }

      public function SetFilledColor (color:uint):void
      {
         //mFilledColor = color;
         mVectorShape.SetBodyColor (color);
      }

      public function GetFilledColor ():uint
      {
         //return mFilledColor;
         return mVectorShape.GetBodyColor ();
      }

      public function SetTransparency (transparency:uint):void
      {
         //mTransparency = transparency;
         mVectorShape.SetBodyOpacity100 (transparency);
      }

      public function GetTransparency ():uint
      {
         //return mTransparency;
         return mVectorShape.GetBodyOpacity100 ();
      }

      public function SetDrawBorder (draw:Boolean):void
      {
         //mDrawBorder = draw;
         // to override
      }

      public function IsDrawBorder ():Boolean
      {
         //return mDrawBorder;
         return true; // to override
      }

      public function SetBorderColor (color:uint):void
      {
         //mBorderColor = color;
         // to override
      }

      public function GetBorderColor ():uint
      {
         //return mBorderColor;
         return Define.BorderColorUnselectedObject; // to override
      }

      public function SetBorderThickness (thinkness:uint):void
      {
         //mBorderThickness = thinkness;
         // to override
      }

      public function GetBorderThickness ():Number
      {
         //if (mBorderThickness < 0)
         //   return 0;
         //
         //return mBorderThickness;
         return 1; // to override
      }

      public function SetBorderTransparency (transparency:uint):void
      {
         //mBorderTransparency = transparency;
         // to override
      }

      public function GetBorderTransparency ():uint
      {
         //return mBorderTransparency;
         return 100; // to override
      }

//======================================================
// physics
//======================================================

      override public function SetStatic (isStatic:Boolean):void
      {
         var oldIsStatic:Boolean = IsStatic ();
         
         if (oldIsStatic && ! isStatic && mAiType == Define.ShapeAiType_Static)
         {
            SetAiType (Define.ShapeAiType_Movable);
            SetFilledColor (Define.ColorMovableObject);
            SetDrawBorder (true);
            UpdateAppearance ();
         }

         if (! oldIsStatic && isStatic && mAiType == Define.ShapeAiType_Movable)
         {
            SetAiType (Define.ShapeAiType_Static);
            SetFilledColor (Define.ColorStaticObject);
            SetDrawBorder (false);
            UpdateAppearance ();
         }

         super.SetStatic (isStatic);
      }

   }
}
