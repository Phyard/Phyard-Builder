
package common {
   
   public class GestureIDs
   {
      // virtual any key
      public static const VirtualAnyGestures:int = 0;

      public static const LongPress:int = 1;

      public static const Circle:int = 10;
      public static const Triangle:int = 15;
      public static const FivePointStar:int = 20;
      
      public static const Line0:int = 30;
      public static const Line45:int = 31;
      public static const Line90:int = 32;
      public static const Line135:int = 33;
      public static const Line180:int = 34;
      public static const Line225:int = 35;
      public static const Line270:int = 36;
      public static const Line315:int = 37;
      
      public static const LineArrow0:int = 40;
      public static const LineArrow45:int = 41;
      public static const LineArrow90:int = 42;
      public static const LineArrow135:int = 43;
      public static const LineArrow180:int = 44;
      public static const LineArrow225:int = 45;
      public static const LineArrow270:int = 46;
      public static const LineArrow315:int = 47;
      
      public static const Arrow0:int = 50;
      public static const Arrow45:int = 51;
      public static const Arrow90:int = 52;
      public static const Arrow135:int = 53;
      public static const Arrow180:int = 54;
      public static const Arrow225:int = 55;
      public static const Arrow270:int = 56;
      public static const Arrow315:int = 57;
      
      public static const ZigzagZ:int = 60;
      public static const ZigzagN:int = 62;
      
      public static const ZigzagS:int = 65;
      public static const ZigzagLighting:int = 67; 

      public static const Pool0:int = 70; 
      public static const Pool90:int = 72;
      public static const Pool180:int = 74;
      public static const Pool270:int = 76;

      public static const Wave0:int = 80; 
      public static const Wave90:int = 82;
      public static const Wave180:int = 84;
      public static const Wave270:int = 86;
      
      //
      public static const kNumGestures:int = 100;
         // if new gesture is added later, don't forget to push it in sAnyGestureIDs
      
      //
      private static var sAnyGestureIDs:Array = null;
      public static function GetGestureIDsFromSelectedGestureIDs (selectedGestures:Array):Array
      {
         var returnGestureIDs:Array;
         
         if (selectedGestures == null)
         {
            returnGestureIDs = [];
         }
         else if (selectedGestures.indexOf (VirtualAnyGestures) < 0)
         {
            returnGestureIDs = selectedGestures.concat ();
         }
         else
         {
            if (sAnyGestureIDs == null)
            {
               sAnyGestureIDs = new Array ();
               
               sAnyGestureIDs.push (LongPress);

               sAnyGestureIDs.push (Circle);
               sAnyGestureIDs.push (Triangle);
               sAnyGestureIDs.push (FivePointStar);

               var i:int;
               
               for (i = 0; i < 8; ++ i)
                  sAnyGestureIDs.push (Line0 + i);
               
               for (i = 0; i < 8; ++ i)
                  sAnyGestureIDs.push (LineArrow0 + i);
               
               for (i = 0; i < 8; ++ i)
                  sAnyGestureIDs.push (Arrow0 + i);
               
               sAnyGestureIDs.push (ZigzagZ);
               sAnyGestureIDs.push (ZigzagN);
               
               sAnyGestureIDs.push (ZigzagS);
               sAnyGestureIDs.push (ZigzagLighting);
               
               for (i = 0; i < 8; i+= 2)
                  sAnyGestureIDs.push (Pool0 + i);
               
               for (i = 0; i < 8; i+= 2)
                  sAnyGestureIDs.push (Wave0 + i);
            }
            
            returnGestureIDs = sAnyGestureIDs.concat ();
         }
         
         return returnGestureIDs;
      }
      
      // DON'T change these values for 2 reasons:
      // 1. for compatibility
      // 2. they must be the same as the ones in GestureAnalyzer.as
      
      public static const kGestureName_LongPress:String = "longpress";
      public static const kGestureName_Line:String = "line";
      public static const kGestureName_LineArrow:String = "line-arrow";
      public static const kGestureName_LineZigzag:String = "line-zigzag";
      public static const kGestureName_Arrow:String = "arrow";
      public static const kGestureName_Zigzag:String = "zigzag"; 
      public static const kGestureName_MirrorZigzag:String = "mirror-zigzag";
      public static const kGestureName_Wave:String = "wave";
      public static const kGestureName_Pool:String = "pool";
      public static const kGestureName_Triangle:String = "triangle";
      public static const kGestureName_Circle:String = "circle";
      public static const kGestureName_FivePointStar:String = "five-point-star";
      
      public static function GetGestureID (gestureType:String, gestureAngle:Number):int
      {
         if (gestureType == kGestureName_LongPress)
            return LongPress;
         else if (gestureType == kGestureName_Line)
         {
            gestureAngle = (gestureAngle + 360.0 + 22.5) % 360.0;
            
            if (gestureAngle >= 315)
               return Line315;
            else if (gestureAngle > 270)
               return Line270;
            else if (gestureAngle >= 225)
               return Line225;
            else if (gestureAngle > 180)
               return Line180;
            else if (gestureAngle >= 135)
               return Line135;
            else if (gestureAngle > 90)
               return Line90;
            else if (gestureAngle >= 45)
               return Line45;
            else // if (gestureAngle < 45)
               return Line0;
         }
         else if (gestureType == kGestureName_LineArrow)
         {
            gestureAngle = (gestureAngle + 360.0 + 22.5) % 360.0;
            
            if (gestureAngle >= 315)
               return LineArrow315;
            else if (gestureAngle > 270)
               return LineArrow270;
            else if (gestureAngle >= 225)
               return LineArrow225;
            else if (gestureAngle > 180)
               return LineArrow180;
            else if (gestureAngle >= 135)
               return LineArrow135;
            else if (gestureAngle > 90)
               return LineArrow90;
            else if (gestureAngle >= 45)
               return LineArrow45;
            else // if (gestureAngle < 45)
               return LineArrow0;
         }
         else if (gestureType == kGestureName_LineZigzag)
         {
            return -1; // not supported now
         }
         else if (gestureType == kGestureName_Arrow)
         {
            gestureAngle = (gestureAngle + 360.0 + 22.5) % 360.0;
            
            if (gestureAngle >= 315)
               return Arrow315;
            else if (gestureAngle > 270)
               return Arrow270;
            else if (gestureAngle >= 225)
               return Arrow225;
            else if (gestureAngle > 180)
               return Arrow180;
            else if (gestureAngle >= 135)
               return Arrow135;
            else if (gestureAngle > 90)
               return Arrow90;
            else if (gestureAngle >= 45)
               return Arrow45;
            else // if (gestureAngle < 45)
               return Arrow0;
         }
         else if (gestureType == kGestureName_Zigzag)
         {
            gestureAngle = (gestureAngle + 360.0 + 22.5) % 360.0;
            
            if (gestureAngle > 270)
               return ZigzagN;
            else if (gestureAngle > 180)
               return ZigzagZ;
            else if (gestureAngle > 90)
               return ZigzagN;
            else // if (gestureAngle < 45)
               return ZigzagZ;
         }
         else if (gestureType == kGestureName_MirrorZigzag)
         {
            gestureAngle = (gestureAngle + 360.0 + 22.5) % 360.0;
            
            if (gestureAngle > 270)
               return ZigzagLighting;
            else if (gestureAngle > 180)
               return ZigzagS;
            else if (gestureAngle > 90)
               return ZigzagLighting;
            else // if (gestureAngle < 45)
               return ZigzagS;
         }
         else if (gestureType == kGestureName_Wave)
         {
            gestureAngle = (gestureAngle + 360.0 + 22.5) % 360.0;
            
            if (gestureAngle > 270)
               return Wave270;
            else if (gestureAngle > 180)
               return Wave180;
            else if (gestureAngle > 90)
               return Wave90;
            else // if (gestureAngle < 45)
               return Wave0;
         }
         else if (gestureType == kGestureName_Pool)
         {
            gestureAngle = (gestureAngle + 360.0 + 22.5) % 360.0;
            
            if (gestureAngle > 270)
               return Pool270;
            else if (gestureAngle > 180)
               return Pool180;
            else if (gestureAngle > 90)
               return Pool90;
            else // if (gestureAngle < 45)
               return Pool0;
         }     
         else if (gestureType == kGestureName_Triangle)
         {
            return Triangle;
         }
         else if (gestureType == kGestureName_Circle)
         {
            return Circle;
         }
         else if (gestureType == kGestureName_FivePointStar)
         {
            return FivePointStar;
         }
         
         return -1;
      }
   }
}
