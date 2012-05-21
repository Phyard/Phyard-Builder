
package editor.asset {
   
   import flash.display.Sprite;
   
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxy;
   
   import common.Transform2D;
   import common.Define;
   
   public class ControlPoint extends Sprite 
   {
      public static const SelectedLevel_None:int = 0;
      public static const SelectedLevel_Primary:int = 1;
      public static const SelectedLevel_Secondary:int = 2;
      
      protected var mOwnerAsset:Asset;
      protected var mIndex:int;
      protected var mPosX:Number; // in mOwnerAsset space
      protected var mPosY:Number;
      protected var mSelectedLevel:int = 0;
      
      public function ControlPoint (owner:Asset, index:int)
      {
         mOwnerAsset = owner;
         mIndex = index;
         
         mOwnerAsset.GetControlPointContainer ().addChild (this);
         //RebuildAppearance ();
      }
      
      public function GetOwnerAsset ():Asset
      {
         return mOwnerAsset;
      }
      
      public function GetIndex ():int
      {
         return mIndex;
      }
      
      public function SetPosition (posX:Number, posY:Number):void
      {
         mPosX = posX;
         mPosY = posY;
         
         x = mPosX;
         y = mPosY;
      }
      
      public function GetPositionX ():Number
      {
         return mPosX;
      }
      
      public function GetPositionY ():Number
      {
         return mPosY;
      }
      
      public function GetSelectedLevel ():int
      {
         return mSelectedLevel;
      }
      
      public function SetSelectedLevel (level:int):void
      {
         if (mSelectedLevel != level)
         {
            mSelectedLevel = level;
            
            RebuildAppearance ();
         }
      }
      
      public function RebuildAppearance ():void
      {
         var borderColor:uint;
         var borderSize:Number;
         var filledColor:uint = 0xFFFFFF;
         var halfSize:Number = 4.0;
         
         if (mSelectedLevel == SelectedLevel_Primary)
         {
            borderColor = Define.BorderColorSelectedObject;
            borderSize  = 3.0;
         }
         else if (mSelectedLevel == SelectedLevel_Secondary)
         {
            borderColor = 0x008000;
            borderSize  = 3.0;
         }
         else
         {
            borderColor = 0x0;
            borderSize  = 1.0;
         }
         
         var zoomScale:Number = mOwnerAsset.GetScale () * mOwnerAsset.GetAssetManager ().GetScale ();
         halfSize /= zoomScale;
         borderSize /= zoomScale;
         
         GraphicsUtil.ClearAndDrawRect (this, - halfSize, - halfSize, halfSize + halfSize, halfSize + halfSize, borderColor, borderSize, true, filledColor);
      }
      
      protected var mSelectionProxy:SelectionProxy = null;
      
      public function RebuildSelectionProxy ():void
      {  
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mOwnerAsset.GetAssetManager ().GetSelectionEngine ().CreateProxyGeneral ();
            
            mSelectionProxy.SetSelectable (true, false);
            mSelectionProxy.SetUserData (this);
         }
         
         var halfSize:Number = 4.0;
         var zoomScale:Number = mOwnerAsset.GetScale () * mOwnerAsset.GetAssetManager ().GetScale ();
         halfSize /= zoomScale;
         var size:Number = halfSize + halfSize;
         
         mSelectionProxy.Rebuild (mOwnerAsset.GetPositionX (), mOwnerAsset.GetPositionY (), 0.0);
         mSelectionProxy.AddRectangleShape (mPosX - halfSize, mPosY - halfSize, size, size, 
                                           new Transform2D (0.0, 0.0, mOwnerAsset.GetScale (), mOwnerAsset.IsFlipped (), mOwnerAsset.GetRotation ()));
         
      }
      
      public function Refresh (ipdateSelectionProxy:Boolean = true):void
      {
         RebuildAppearance ();
         if (ipdateSelectionProxy)
         {
            RebuildSelectionProxy ();
         }
      }
      
      public function Destroy ():void
      {
         if (parent != null) // mOwnerAsset.GetControlPointContainer ()
            parent.removeChild (this);
         
         if (mSelectionProxy != null)
            mSelectionProxy.Destroy ();
      }
   }
}
