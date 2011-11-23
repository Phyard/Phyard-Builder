
package editor.entity {

   import flash.display.Sprite;
   import flash.display.Shape;
   
   import flash.geom.Rectangle;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;

   import com.tapirgames.util.GraphicsUtil;

   import editor.world.World;

   import editor.selection.SelectionProxy;
   
   import editor.core.EditorObject;
   import editor.core.ReferPair;

   import editor.image.AssetImageModule;
   import editor.image.AssetImageNullModule;

   import common.Define;
   import common.Transform2D;

   public class EntityShapeImageModuleButton extends EntityShape
   {
      
      public static const kText_ChangeModule:String = "Change To The Current Module";
      
      protected var mContextMenu:ContextMenu;
      protected var mContextMenuItem_ChangeModule:ContextMenuItem;
      
      //============================================
      
      protected var mAssetImageModuleForMouseUp:AssetImageModule;
      protected var mAssetImageModuleForMouseOver:AssetImageModule;
      protected var mAssetImageModuleForMouseDown:AssetImageModule;
      
//====================================================================
//
//====================================================================

      public function EntityShapeImageModuleButton (world:World)
      {
         super (world);
         
         SetAssetImageModuleForMouseUp (null);
         SetAssetImageModuleForMouseOver (null);
         SetAssetImageModuleForMouseDown (null);
      }

      override public function GetTypeName ():String
      {
         return "Module Button";
      }

      override public function IsBasicVectorShapeEntity ():Boolean
      {
         return false;
      }
      
//====================================================================
//   
//====================================================================

      // up .
      
      public function GetAssetImageModuleForMouseUp ():AssetImageModule
      {
         return mAssetImageModuleForMouseUp;
      }

      public function SetAssetImageModuleForMouseUp (imageModule:AssetImageModule):void
      {
         if (mReferPairForMouseUp != null)
         {
            mReferPairForMouseUp.Break ();
            mAssetImageModuleForMouseUp = null;
         }
         
         if (imageModule == null)
            imageModule = new AssetImageNullModule ();
         
         if (imageModule != null)
         {
            mAssetImageModuleForMouseUp = imageModule;
            mReferPairForMouseUp = ReferObject (mAssetImageModuleForMouseUp);
         }
      }
      
      // for loading
      public function SetAssetImageModuleForMouseUpByIndex (index:int):void
      {
         SetAssetImageModuleForMouseUp (mWorld.GetImageModuleByIndex (index));
      }
      
      // over .
      
      public function GetAssetImageModuleForMouseOver ():AssetImageModule
      {
         return mAssetImageModuleForMouseOver;
      }

      public function SetAssetImageModuleForMouseOver (imageModule:AssetImageModule):void
      {
         if (mReferPairForMouseOver != null)
         {
            mReferPairForMouseOver.Break ();
            mAssetImageModuleForMouseOver = null;
         }
         
         if (imageModule == null)
            imageModule = new AssetImageNullModule ();
         
         if (imageModule != null)
         {
            mAssetImageModuleForMouseOver = imageModule;
            mReferPairForMouseOver = ReferObject (mAssetImageModuleForMouseOver);
         }
      }
      
      // for loading
      public function SetAssetImageModuleForMouseOverByIndex (index:int):void
      {
         SetAssetImageModuleForMouseOver (mWorld.GetImageModuleByIndex (index));
      }
      
      // down .
      
      public function GetAssetImageModuleForMouseDown ():AssetImageModule
      {
         return mAssetImageModuleForMouseDown;
      }

      public function SetAssetImageModuleForMouseDown (imageModule:AssetImageModule):void
      {
         if (mReferPairForMouseDown != null)
         {
            mReferPairForMouseDown.Break ();
            mAssetImageModuleForMouseDown = null;
         }
         
         if (imageModule == null)
            imageModule = new AssetImageNullModule ();
         
         if (imageModule != null)
         {
            mAssetImageModuleForMouseDown = imageModule;
            mReferPairForMouseDown = ReferObject (mAssetImageModuleForMouseDown);
         }
      }
      
      // for loading
      public function SetAssetImageModuleForMouseDownByIndex (index:int):void
      {
         SetAssetImageModuleForMouseDown (mWorld.GetImageModuleByIndex (index));
      }
      
//=============================================================
//   
//=============================================================
      
      private var mReferPairForMouseUp:ReferPair;
      private var mReferPairForMouseOver:ReferPair;
      private var mReferPairForMouseDown:ReferPair;
      
      override public function OnReferingModified (referPair:ReferPair, info:Object = null):void
      {
         super.OnReferingModified (referPair, info);
         
         if (referPair == mReferPairForMouseUp
            || referPair == mReferPairForMouseOver
            || referPair == mReferPairForMouseDown)
         {
            UpdateAppearance ();
            UpdateSelectionProxy ();
         }
      }

      override public function OnReferingDestroyed (referPair:ReferPair):void
      {
         super.OnReferingDestroyed (referPair);
         
         var toUpdate:Boolean = false;
         
         if (referPair == mReferPairForMouseUp)
         {
            SetAssetImageModuleForMouseUp (null);
            
            toUpdate = true;
         }
         
         if (referPair == mReferPairForMouseOver)
         {
            SetAssetImageModuleForMouseOver (null);
            
            toUpdate = true;
         }
         
         if (referPair == mReferPairForMouseDown)
         {
            SetAssetImageModuleForMouseDown (null);
            
            toUpdate = true;
         }
         
         if (toUpdate)
         {
            UpdateAppearance ();
            UpdateSelectionProxy ();
         }
      }
      
//=============================================================
//   temp. When Entity is extended from Asset, remove these
//=============================================================
      
      override public function RotateSelf (dRadians:Number):void
      {
         if (IsFlipped ())
            dRadians = - dRadians;
         
         SetRotation (GetRotation () + dRadians);
      }
      
      override public function ScaleSelf (ratio:Number):void
      {
         if (ratio < 0)
            ratio = - ratio;
         
         SetScale (GetScale () * ratio);
      }
      
      override public function FlipSelfHorizontally ():void
      {
         SetFlipped (! IsFlipped ());
      }
      
      override public function FlipSelfVertically ():void
      {
         FlipSelfHorizontally ();
         RotateSelf (Math.PI);
      }
      
//=============================================================
//   
//=============================================================
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         GraphicsUtil.Clear (this);
         
         mAssetImageModuleForMouseUp.BuildImageModuleAppearance (this);
         alpha = 0.70;
         
         if (IsSelected ())
         {
            var shape:Shape = new Shape ();

            var rectangle:Rectangle = this.getBounds (this);
            GraphicsUtil.DrawRect (shape, rectangle.left, rectangle.top, rectangle.width, rectangle.height,
                                       0x0000FF, -1, true, 0xC0C0FF, false);
            
            addChild (shape);
         }
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mWorld.mSelectionEngine.CreateProxyGeneral ();
            mSelectionProxy.SetUserData (this);
         }
         
         mSelectionProxy.Rebuild (GetPositionX (), GetPositionY (), 0.0);
         mAssetImageModuleForMouseUp.BuildImageModuleSelectionProxy (mSelectionProxy, 
               //new Transform2D (0.0, 0.0, 1.0, false, GetRotation ()), mWorld.GetZoomScale ());
               new Transform2D (0.0, 0.0, GetScale (), IsFlipped (), GetRotation ()), mWorld.GetZoomScale () * GetScale ());
      }

//====================================================================
//   clone
//====================================================================

      // to override
      override protected function CreateCloneShell ():Entity
      {
         return new EntityShapeImageModuleButton (mWorld);
      }

      // to override
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);

         var imageModuleButtonShape:EntityShapeImageModuleButton = entity as EntityShapeImageModuleButton;
         imageModuleButtonShape.SetAssetImageModuleForMouseUp (GetAssetImageModuleForMouseUp ());
         imageModuleButtonShape.SetAssetImageModuleForMouseOver (GetAssetImageModuleForMouseOver ());
         imageModuleButtonShape.SetAssetImageModuleForMouseDown (GetAssetImageModuleForMouseDown ());
      }
      
//==============================================================================================================
//
//==============================================================================================================
      
      public function ChangeToCurrentAssetImageModule ():void
      {
         SetAssetImageModuleForMouseUp (AssetImageModule.mCurrentAssetImageModule);
         SetAssetImageModuleForMouseOver (AssetImageModule.mCurrentAssetImageModule);
         SetAssetImageModuleForMouseDown (AssetImageModule.mCurrentAssetImageModule);
         
         UpdateAppearance ();
         UpdateSelectionProxy ();
      }
   }
}
