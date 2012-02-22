package editor.image.vector
{
   import flash.display.DisplayObject;
   import flash.geom.Point;

   import editor.selection.SelectionProxy;

   import editor.asset.Asset;
   import editor.asset.ControlPoint;
   import editor.asset.ControlPointModifyResult;
   
   import editor.image.AssetImageBitmapModule;

   import common.Transform2D;

   public interface VectorShapeForEditing
   {
      function OnCreating (points:Array):Point;
      
      function GetBodyTextureModule ():AssetImageBitmapModule;
      function SetBodyTextureModule (bitmapModule:AssetImageBitmapModule):void;

      function CreateSprite ():DisplayObject;
      function BuildSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void;

      function CreateControlPointsForAsset (asset:Asset):Array;
      function GetSecondarySelectedControlPointId (primaryControlPointIndex:int):int;
      
      function OnMoveControlPoint (controlPoints:Array, movedControlPointIndex:int, dx:Number, dy:Number):ControlPointModifyResult;
      function DeleteControlPoint (controlPoints:Array, toDeleteControlPointIndex:int):ControlPointModifyResult;
      function InsertControlPointBefore (controlPoints:Array, insertBeforeControlPointIndex:int):ControlPointModifyResult;
   }
}
