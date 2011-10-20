package editor.image.vector
{
   import flash.display.DisplayObject; 
   import flash.geom.Point;
   
   import editor.selection.SelectionProxy;
   
   import editor.asset.Asset;
   import editor.asset.ControlPoint;
   
   import common.Transform2D;
   
   public interface VectorShapeForEditing
   {
      function OnCreating (points:Array):Point;
      
      function CreateSprite ():DisplayObject;
      function BuildSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void;
      
      function CreateControlPointsForAsset (asset:Asset):Array;
      function GetSecondarySelectedControlPointId (primaryControlPoint:ControlPoint):int;
      // return asset displacement caused by the moving, in asset space.
      function OnMoveControlPoint (controlPoints:Array, movedControlPointIndex:int, dx:Number, dy:Number):Array;
      function DeleteControlPoint (controlPoint:ControlPoint):int; // return negative values means fails, otherwise return the old index of the CP deleted.
      function InsertControlPointBefore (controlPoint:ControlPoint):int; // return negative values means fails, otherwise return the new index of the old selected CP (the CP inserted before).
   }
}
