package common.trigger.define
{
   public class PackageDefine // from v2.05
   {
      public var mKey:String  = null; 
      public var mTimeModified:Number = 0; 
      public var mToLoadNewData:Boolean = false; // from v2.01. A temp runtime value, not saved in file.
      
      public var mName:String; 
      public var mPosX:int; 
      public var mPosY:int; 
      
      public var mPackageIndices:Array = null;
   }
   
}