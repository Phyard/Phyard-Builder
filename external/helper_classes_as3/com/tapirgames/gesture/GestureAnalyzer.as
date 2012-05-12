package com.tapirgames.gesture {

   public class GestureAnalyzer
   {
      public static const kRadiansToDegrees:Number = 180.0 / Math.PI;
      
   //===================================================

      public function GestureAnalyzer (minGestureSize:Number, minPointDistance:Number, minTimerInterval:Number = 10.0, maxTimeDuration:Number = 2000.0, maxPointCount:int = 500):void
      {
         mMinAllowedGestureSize = minGestureSize;
         mMinAllowedPointDistance = minPointDistance;
         mMinTimeInterval = minTimerInterval;
         mMaxTimeDuration = maxTimeDuration;
         mMaxNumPoints = maxPointCount;
         
         mPointDistances = new Array ((mMaxNumPoints + 1) * mMaxNumPoints / 2);
      }

      private var mMinAllowedGestureSize:Number;
      private var mMinAllowedPointDistance:Number;
      private var mMinTimeInterval:Number;
      private var mMaxTimeDuration:Number;
      private var mMaxNumPoints:Number;
      
      private var mPointDistances:Array;
      
      private static const kLengthToAccLengthRatioToFindSegment :Number = Math.cos (20.0 * Math.PI / 180.0); // 0.94; // 0.94 is about cos (20 degrees)

   //===================================================

      private var mNumPoints:int = 0;

      private var mStartTime:Number;
      
      private var mStartPoint:GesturePoint = null;
      private var mEndPoint:GesturePoint = null;
      
      private var mLastPointTime:Number;

      // for AABB
      private var mMinX:Number = Number.POSITIVE_INFINITY;
      private var mMinY:Number = Number.POSITIVE_INFINITY;
      private var mMaxX:Number = Number.NEGATIVE_INFINITY;
      private var mMaxY:Number = Number.NEGATIVE_INFINITY;
      
      // for OBB
      private var mSumX:Number = 0;
      private var mSumY:Number = 0;
      private var mSumXX:Number = 0;
      private var mSumYY:Number = 0;
      private var mSumXY:Number = 0;
      
      public function RegisterPoint (newPointX:Number, newPointY:Number, time:Number):GesturePoint
      {
         if (mNumPoints >= mMaxNumPoints)
            return null;

         var newPoint:GesturePoint;

         if (mStartPoint == null)
         {
            newPoint = new GesturePoint (newPointX, newPointY, 0);

            newPoint.mAccumulatedLength = 0;
            newPoint.mDistanceValuesFromIndex = -1;

            mStartPoint = newPoint;
            mStartTime = time;
         }
         else
         {
            if (time - mStartTime >= mMaxTimeDuration)
               return null;

            // assert (mEndPoint != null)

            var lastPoint:GesturePoint = mEndPoint;
            
            var dTime:Number = time - lastPoint.mTime;
            if (dTime < mMinTimeInterval)
               return null;

            var dx:Number = newPointX - lastPoint.mX;
            var dy:Number = newPointY - lastPoint.mY;
            var distance:Number = Math.sqrt (dx * dx + dy * dy);
            if (distance < mMinAllowedPointDistance)
               return null;

            // new point

            newPoint = new GesturePoint (newPointX, newPointY, dTime);
            
            newPoint.mPrevPoint = lastPoint;
            lastPoint.mNextPoint = newPoint;
            
            newPoint.mAccumulatedLength = lastPoint.mAccumulatedLength + distance;
            
            newPoint.mDistanceValuesFromIndex = mEndPoint.mDistanceValuesFromIndex + mNumPoints;

            var distanceValueIndex:int = newPoint.mDistanceValuesFromIndex;
            var aPoint:GesturePoint = mStartPoint;
            while (aPoint != newPoint)
            {
               dx = aPoint.mX - newPoint.mX;
               dy = aPoint.mY - newPoint.mY;
               
               mPointDistances [distanceValueIndex] = Math.sqrt (dx * dx + dy * dy);
               ++ distanceValueIndex;
               
               aPoint = aPoint.mNextPoint;
            }
         }

         // ...
         
         mLastPointTime = time;
         
         mSumX += newPoint.mX;
         mSumY += newPoint.mY;
         mSumXX += newPoint.mX * newPoint.mX;
         mSumYY += newPoint.mY * newPoint.mY;
         mSumXY += newPoint.mX * newPoint.mY;

         if (newPoint.mX < mMinX)
            mMinX = newPoint.mX;
         if (newPoint.mY < mMinY)
            mMinY = newPoint.mY;
         if (newPoint.mX > mMaxX)
            mMaxX = newPoint.mX;
         if (newPoint.mY > mMaxY)
            mMaxY = newPoint.mY;
         
         // ...
         
         newPoint.mIndex = mNumPoints;
         ++ mNumPoints;

         mEndPoint = newPoint;

         return newPoint;
      }
      
      private static function GetAbsoluteAngle (dx:Number, dy:Number):Number
      {
         return (Math.atan2 (dy, dx) * kRadiansToDegrees + 360) % 360
      }
      
      private static function GetDeltaRotation (dx1:Number, dy1:Number, dx2:Number, dy2:Number):Number
      {
         var dot:Number = dx1 * dx2 + dy1 * dy2;
         var cross:Number = dx1 * dy2 - dy1 * dx2;
         
         return Math.atan2 (cross, dot) * kRadiansToDegrees;
      } 
      
      private static function GetAngleAverage (a:Number, b:Number):Number
      {
         a = a % 360;
         if (a < 0)
            a += 360;
         b = b % 360;
         if (b < 0)
            b += 360;

         if (Math.abs (b - a) < 180)
         {
            return (0.5 * (a + b)) % 360;
         }
         else
         {
            return (0.5 * (a + b) + 180.0) % 360;
         }
      }
      
      private function GetPointDistance (pointA:GesturePoint, pointB:GesturePoint):Number
      {
         // assert (pointA != null && pointB != null)
         
         var diffIndex:int = pointB.mIndex - pointA.mIndex;
         
         if (pointA.mIndex < pointB.mIndex)
            return mPointDistances [pointB.mDistanceValuesFromIndex + pointA.mIndex];
         
         if (pointA.mIndex > pointB.mIndex)
            return mPointDistances [pointA.mDistanceValuesFromIndex + pointB.mIndex];
         
         return 0;
      }
      
      private var mAabbWidth:Number;
      private var mAabbHeight:Number;
      private var mAabbSize:Number;
      private var mAabbDiagLength:Number;

      private var mObbWidth:Number;
      private var mObbHeight:Number;
      private var mObbDiagLength:Number;
      
      private function NewAnalyzeResult (type:String, angle:Number, message:String):Object
      {
         return {
                   mGestureType: type, 
                   mGestureAngle: angle, 
                   mAnalyzeMessage: message,
                   
                   mNumPoints: mNumPoints
                };
      }
      
      public function Analyze ():Object
      {
         // must have at least 2 points

         if (mStartPoint == mEndPoint) // 0 or 1 point
         {
            return NewAnalyzeResult (null, NaN, "too few points");
         }

         // aabb box

         mAabbWidth = mMaxX - mMinX;
         mAabbHeight = mMaxY - mMinY;
         mAabbSize = (mAabbWidth >= mAabbHeight ? mAabbWidth : mAabbHeight);
         mAabbDiagLength = Math.sqrt (mAabbWidth * mAabbWidth + mAabbHeight * mAabbHeight);

         if (mAabbSize < mMinAllowedGestureSize)
         {
            return NewAnalyzeResult (null, NaN, "too small");
         }
         
         var angleFromtStartToend:Number = GetAbsoluteAngle (mEndPoint.mX - mStartPoint.mX, mEndPoint.mY - mStartPoint.mY);
         
         // simple case
         
         if (GetPointDistance (mStartPoint, mEndPoint) / mEndPoint.mAccumulatedLength > kLengthToAccLengthRatioToFindSegment)
         {
            return NewAnalyzeResult ("line", angleFromtStartToend, "simplest");
         }
         
         // obb box (http://www.efunda.com/math/leastsquares/lstsqr1dcurve.cfm)
         
         var a:Number;
         var b:Number;
         if (mAabbWidth > mAabbHeight)
         {
            a = mNumPoints * mSumXY - mSumX * mSumY;
            b = mSumX * mSumX - mNumPoints * mSumXX;
         }
         else
         {
            a = mSumY * mSumY - mNumPoints * mSumYY;
            b = mNumPoints * mSumXY - mSumX * mSumY;
         }
         var d:Number = Math.sqrt (a * a + b * b);
         
         if (d == 0) // generally impossible
         {
            return NewAnalyzeResult (null, NaN, "d == 0 in fitting line");
         }
               
         var obbLeftMostPoint:GesturePoint = null;      
         var obbRightMostPoint:GesturePoint = null;      
         var obbTopMostPoint:GesturePoint = null;      
         var obbBottomMostPoint:GesturePoint = null;
         
         var obbLeft:Number = Number.POSITIVE_INFINITY;
         var obbRight:Number = Number.NEGATIVE_INFINITY;
         var obbTop:Number = Number.POSITIVE_INFINITY;
         var obbBottom:Number = Number.NEGATIVE_INFINITY;
         var distance:Number;
         
         var point:GesturePoint;
         
         point = mStartPoint;
         while (true)
         {
            distance = (a * point.mX + b * point.mY) / d;
            if (distance < obbLeft)
            {
               obbLeft = distance;
               obbLeftMostPoint = point;
            }
            if (distance > obbRight)
            {
               obbRight = distance;
               obbRightMostPoint = point;
            }
            
            distance = (b * point.mX - a * point.mY) / d;
            if (distance < obbTop)
            {
               obbTop = distance;
               obbTopMostPoint = point;
            }
            if (distance > obbBottom)
            {
               obbBottom = distance;
               obbBottomMostPoint = point;
            }
            
            if (point == mEndPoint)
               break;
            
            point = point.mNextPoint;
         }
         
         mObbWidth = obbRight - obbLeft;
         mObbHeight = obbBottom - obbTop;
         if (mObbWidth > mObbHeight) // generally, this is impossible
         {
            var temp:Number = mObbHeight;
            mObbHeight = mObbWidth;
            mObbWidth = temp;
         }
         mObbDiagLength = Math.sqrt (mObbWidth * mObbWidth + mObbHeight * mObbHeight);
         
         // find segments

         FindAllSegments ();
         
         if (mStartSegment == mEndSegment && mStartSegment.mDx == 0 && mStartSegment.mDy == 0)
         {
            return NewAnalyzeResult (null, NaN, "only one closed segment");
         }
         
         var startSegmentAbsoluteAngle:Number = GetAbsoluteAngle (mStartSegment.mDx, mStartSegment.mDy);
         var endSegmentAbsoluteAngle:Number = GetAbsoluteAngle (mEndSegment.mDx, mEndSegment.mDy);
         var directionAbsoluteAngle:Number = GetAngleAverage (startSegmentAbsoluteAngle, endSegmentAbsoluteAngle + 180);
         var invDirectionAbsoluteAngle:Number = (directionAbsoluteAngle + 180) % 360;
         
         // some simple cases
         
         var numSegments:int = mEndSegment.mIndex + 1;
         
         if (numSegments == 1)
            return NewAnalyzeResult ("line", GetAbsoluteAngle (mStartSegment.mDx, mStartSegment.mDy), "numSegments == 1");
         
         if (numSegments == 2)
         {
            var absIncludeAngle:Number = Math.abs (mEndSegment.mDeltaAngle);
            
            if (absIncludeAngle < 35)
               return NewAnalyzeResult ("line", GetAbsoluteAngle (mStartSegment.mDx, mStartSegment.mDy), "numSegments == 2");
            
            if (absIncludeAngle > 165)
               return NewAnalyzeResult ("return", directionAbsoluteAngle, "numSegments == 2");
            
            if (absIncludeAngle > 50 && absIncludeAngle < 150)
               return NewAnalyzeResult ("arrow", directionAbsoluteAngle, "numSegments >= 2");
         }
         
         if ((mObbWidth / mObbDiagLength > 0.3) && (mNumPositiveDeltaAngleSegments * mNumNegativeDeltaAngleSegments == 0))
         {
            var absFinalAccumulatedAngle:Number = Math.abs (mEndSegment.mAccumulatedAngle);

            if (numSegments >= 3)
            {
               if (absFinalAccumulatedAngle < 190)
                  return NewAnalyzeResult ("arrow", directionAbsoluteAngle, "numSegments >= 3");
            }
            
            if (numSegments == 3)
            {
               if (absFinalAccumulatedAngle > 190)
                  return NewAnalyzeResult ("triangle", invDirectionAbsoluteAngle, "numSegments == 3");
            }
            
            if (numSegments >= 5)
            {
               if (absFinalAccumulatedAngle > 190)
                  return NewAnalyzeResult ("circle", invDirectionAbsoluteAngle, "numSegments >= 5");
            }
         }
         
         // Levenshtein algorithm
         
         var deltaSegmentAngles:Array = new Array ();
         var accSegmentAngles:Array = new Array ();
         
         var segment:GestureSegment = mStartSegment;
         
         while (segment != null)
         {
            if (segment != mStartSegment)
            {
               deltaSegmentAngles.push (segment.mDeltaAngle);
               accSegmentAngles.push (segment.mAccumulatedAngle);
            }
            
            segment = segment.mNextSegment;
         }
         
         if (deltaSegmentAngles.length == 0)
            deltaSegmentAngles.push (0);
         if (accSegmentAngles.length == 0)
            accSegmentAngles.push (0);
         
         var type:String = FindBestFittedGestureType (deltaSegmentAngles, accSegmentAngles);
         var angle:Number;
         if (type == "line")
            angle = angleFromtStartToend;
         else if (type == "arrow" || type == "return")
            angle = directionAbsoluteAngle;
         else if (type == "circle" || type == "triangle")
            angle = invDirectionAbsoluteAngle;
         else
            angle = NaN;
         
         return NewAnalyzeResult (type, angle, "fitted with standard");
      }
      
      private var mStartSegment:GestureSegment = null;
      private var mEndSegment:GestureSegment = null;
      
      private var mNumPositiveDeltaAngleSegments:int;
      private var mNumNegativeDeltaAngleSegments:int;
      
      private function FindAllSegments ():void
      {
         var minSegmentLength:Number = Math.min (mEndPoint.mAccumulatedLength / 12.0, mObbDiagLength / 4.0);
         
         var startPoint:GesturePoint = mStartPoint;
         var prevSegment:GestureSegment = null;
         var segment:GestureSegment;
         
         while (startPoint != mEndPoint)
         {
            segment = FindSegmentFromPoint (startPoint, minSegmentLength, prevSegment);
            
            if (mStartSegment == null)
               mStartSegment = segment;
            
            prevSegment = segment;
            
            startPoint = segment.mEndPoint;
         }
         
         // merge too-short segment with one neighbour
         
         if (mStartSegment != null)
         {
            segment = mStartSegment;
            
            do
            {
               if (segment.mPrevSegment == null && segment.mNextSegment == null)
                  break;
               
               if (  segment.mEndPoint.mAccumulatedLength - segment.mStartPoint.mAccumulatedLength < minSegmentLength
                  || (segment.mStartPoint.mX == segment.mEndPoint.mX && segment.mStartPoint.mY == segment.mEndPoint.mY)
                  )
               {
                  var mergeWithPrev:Boolean;
                  if (segment.mPrevSegment == null)
                     mergeWithPrev = false;
                  else if (segment.mNextSegment == null)
                     mergeWithPrev = true;
                  else
                  {
                     mergeWithPrev = GetPointDistance (segment.mEndPoint, segment.mPrevSegment.mStartPoint) / (segment.mEndPoint.mAccumulatedLength - segment.mPrevSegment.mStartPoint.mAccumulatedLength)
                                     >
                                     GetPointDistance (segment.mNextSegment.mEndPoint, segment.mStartPoint) / (segment.mNextSegment.mEndPoint.mAccumulatedLength - segment.mStartPoint.mAccumulatedLength)
                                     ;
                  }

                  if (mergeWithPrev)
                  {
                     segment.mPrevSegment.mEndPoint = segment.mEndPoint;
                     segment.mPrevSegment.mNextSegment = segment.mNextSegment;
                     if (segment.mNextSegment != null)
                     {
                        segment.mNextSegment.mPrevSegment = segment.mPrevSegment;
                     }
                  }
                  else
                  {
                     segment.mEndPoint = segment.mNextSegment.mEndPoint;
                     if (segment.mNextSegment.mNextSegment != null)
                     {
                        segment.mNextSegment.mNextSegment.mPrevSegment = segment;
                     }
                     segment.mNextSegment = segment.mNextSegment.mNextSegment;
                     
                     continue; // the merged segment is still possible too short
                  }
               }
               
               segment = segment.mNextSegment;
            } while (segment != null);
         }
         
         // finalize
         
         mNumPositiveDeltaAngleSegments = 0;
         mNumNegativeDeltaAngleSegments = 0;
         
         segment = mStartSegment;
         
         while (segment != null)
         {
            mEndSegment = segment;

            segment.mDx = segment.mEndPoint.mX - segment.mStartPoint.mX;
            segment.mDy = segment.mEndPoint.mY - segment.mStartPoint.mY;
            //segment.mStartEndDistance = GetPointDistance (segment.mStartPoint, segment.mEndPoint);
            //segment.mAccumulatedLength = segment.mEndPoint.mAccumulatedLength - segment.mStartPoint.mAccumulatedLength;
            //segment.mStartEndDistanceToAccumulatedLengthRatio = segment.mStarEndDistance / segment.mAccumulatedLength;
            
            if (segment.mPrevSegment == null)
            {
               segment.mIndex = 0;
               segment.mDeltaAngle = 0;
               segment.mAccumulatedAngle = 0;
            }
            else
            {
               segment.mIndex = segment.mPrevSegment.mIndex + 1;
               segment.mDeltaAngle = GetDeltaRotation (segment.mPrevSegment.mDx, segment.mPrevSegment.mDy, segment.mDx, segment.mDy);
               segment.mAccumulatedAngle = segment.mPrevSegment.mAccumulatedAngle + segment.mDeltaAngle;
               
               if (segment.mDeltaAngle > 5)
                  ++ mNumPositiveDeltaAngleSegments;
               if (segment.mDeltaAngle < -5)
                  ++ mNumNegativeDeltaAngleSegments;
            }
            
            //startPoint = segment.mStartPoint;
            //var maxDistance:Number = 0;
            //var point:GesturePoint = startPoint.mNextPoint;
            //while (point != segment.mEndPoint)
            //{
            //   var distance:Number = (segment.mDy * (point.mX - startPoint.mX) - segment.mDx * (point.mY - startPoint.mY)) / segment.mStarEndDistance;
            //   distance = Math.abs (distance);
            //   if (maxDistance < distance)
            //      maxDistance = distance;
            //   
            //   point = point.mNextPoint;
            //}
            
trace (">> segment@" + segment.mIndex + "> delta angle: " + segment.mDeltaAngle + ", acc angle: " + segment.mAccumulatedAngle);
            
            segment = segment.mNextSegment;
         }
      }
      
      private function FindSegmentFromPoint (startPoint:GesturePoint, minSegmentLength:Number, prevSegment:GestureSegment):GestureSegment
      {
         if (startPoint.mNextPoint == null)
            return null;
         
         var gesturePoint:GesturePoint = startPoint;
         var firstPointAfterMinSegmentLength:GesturePoint = null;
         var kneePoint:GesturePoint;
         
         while (true)
         {
            gesturePoint = gesturePoint.mNextPoint;
            
            var diffAccLength:Number = gesturePoint.mAccumulatedLength - startPoint.mAccumulatedLength;
            if (diffAccLength >= minSegmentLength)
            {
               //if (firstPointAfterMinSegmentLength != null)
               //{
                  if (GetPointDistance (startPoint, gesturePoint) / diffAccLength < kLengthToAccLengthRatioToFindSegment)
                  {
                     kneePoint = FindKneePointBetweenTwoPoints (startPoint, gesturePoint); //, firstPointAfterMinSegmentLength); // should be not null
                     
                     //if (mEndPoint.mAccumulatedLength - kneePoint.mAccumulatedLength < minSegmentLength) // avoid jigglings at end
                     //   kneePoint = mEndPoint;
                     
                     break;
                  }
               //}
               //else
               //{
               //   firstPointAfterMinSegmentLength = gesturePoint; // avoid jigglings at start
               //}
            }
            
            if (gesturePoint.mNextPoint == null)
            {
               kneePoint = gesturePoint;
               break;
            }
         }
         
         var segment:GestureSegment = new GestureSegment (startPoint, kneePoint);
            
         segment.mPrevSegment = prevSegment;
         if (prevSegment != null)
            prevSegment.mNextSegment= segment;
         
         return segment;
      }
      
      private function FindKneePointBetweenTwoPoints (startPoint:GesturePoint, endPoint:GesturePoint):GesturePoint //, fromPoint:GesturePoint):GesturePoint
      {
         if (endPoint.mIndex == startPoint.mIndex)
            return null;
            
         var point:GesturePoint;
         if (startPoint.mIndex < endPoint.mIndex)
         {
            if (endPoint.mIndex == startPoint.mIndex + 1)
               return endPoint;
         }
         else
         {
            if (startPoint.mIndex == endPoint.mIndex + 1)
               return startPoint;
            
            point = startPoint;
            startPoint = endPoint;
            endPoint = point;
         }
         
         // at least one point between start and end points
         
         var maxSumDistance:Number = Number.NEGATIVE_INFINITY;
         var sumDstance:Number;
         var kneePoint:GesturePoint = null;
         
         //point = fromPoint;
         point = startPoint.mNextPoint;
         
         while (point != endPoint)
         {
            sumDstance = GetPointDistance (startPoint, point) + GetPointDistance (point, endPoint);
            if (sumDstance > maxSumDistance)
            {
               maxSumDistance = sumDstance;
               kneePoint = point;
            }
            
            point = point.mNextPoint;
         }
         
         return kneePoint;
      }
      
      private function TraceSegments (title:String):void
      {
         trace ("=================================== segments: " + title);
         var segment:GestureSegment = mStartSegment;
         while (segment != null)
         {
            trace (segment.mIndex + "> start index: " + segment.mStartPoint.mIndex + ", end index: " + segment.mEndPoint.mIndex
                     + ", dx: " + segment.mDx + ", dy: " + segment.mDy
                   //  + ", accLength: " + segment.mAccumulatedLength + ", distance: " + segment.mStarEndDistance
                     + ", delta angle: " + segment.mDeltaAngle + ", acc angle: " + segment.mAccumulatedAngle
                  );
            
            segment = segment.mNextSegment;
         }
      }
      
   //=================================
      
      private static const MaxValidMinError:Number = 128;
      
      private static function NewGestureStandard (type:String, deltaAngleData:Array, accAngleData:Array, info:String):Object
      {
         var standard:Object = new Object ();
         
         standard.mType = type;
         standard.mDeltaAngles = deltaAngleData;
         standard.mAccAngles = accAngleData;
         standard.mInfo = info;
         
         return standard;
      }
      
      private static var sGestureStandard_Line1     :Object = NewGestureStandard ("line"    , [0         ], [0                    ], "line delta angle");
      private static var sGestureStandard_Line2     :Object = NewGestureStandard ("line"    , [20        ], [20                   ], "line delta angle");
      private static var sGestureStandard_Line2N    :Object = NewGestureStandard ("line"    , [-20       ], [-20                  ], "line delta angle");
      private static var sGestureStandard_Return    :Object = NewGestureStandard ("return"  , [170       ], [170                  ], "go back delta angle");
      private static var sGestureStandard_ReturnN   :Object = NewGestureStandard ("return"  , [-170      ], [-170                 ], "- go back delta angle");
      private static var sGestureStandard_Arrow1    :Object = NewGestureStandard ("arrow"   , [150       ], [150                  ], "arrow delta angle");
      private static var sGestureStandard_Arrow1N   :Object = NewGestureStandard ("arrow"   , [-150      ], [-150                 ], "- arrow delta angle");
      //private static var sGestureStandard_Arrow2    :Object = NewGestureStandard ("arrow"   , [90        ], [90                   ], "arrow delta angle");
      //private static var sGestureStandard_Arrow2N   :Object = NewGestureStandard ("arrow"   , [-90       ], [-90                  ], "- arrow delta angle");
      private static var sGestureStandard_Arrow3    :Object = NewGestureStandard ("arrow"   , [35        ], [35                   ], "arrow delta angle");
      private static var sGestureStandard_Arrow3N   :Object = NewGestureStandard ("arrow"   , [-35       ], [-35                  ], "- arrow delta angle");
      private static var sGestureStandard_Triangle1 :Object = NewGestureStandard ("triangle", [120, 120  ], [120, 240             ], "triangle delta angle");
      private static var sGestureStandard_Triangle1N:Object = NewGestureStandard ("triangle", [-120, -120], [-120, -240           ], "- triangle delta angle");
      private static var sGestureStandard_Triangle2 :Object = NewGestureStandard ("triangle", [150, 90   ], [150, 240             ], "triangle delta angle");
      private static var sGestureStandard_Triangle2N:Object = NewGestureStandard ("triangle", [-150, -90 ], [-150, -240           ], "- triangle delta angle");
      private static var sGestureStandard_Triangle3 :Object = NewGestureStandard ("triangle", [70, 150   ], [70, 220              ], "triangle delta angle");
      private static var sGestureStandard_Triangle3N:Object = NewGestureStandard ("triangle", [-70, -150 ], [-70, -220            ], "- triangle delta angle");
      private static var sGestureStandard_Circle1    :Object = NewGestureStandard ("circle"  , [75        ], [75, 150, 225, 300    ], "circle delta angle");
      private static var sGestureStandard_Circle1N   :Object = NewGestureStandard ("circle"  , [-75       ], [-75, -150, -225, -300], "- circle delta angle");
      private static var sGestureStandard_Circle2    :Object = NewGestureStandard ("circle"  , [100       ], [100, 200, 300    ], "circle delta angle");
      private static var sGestureStandard_Circle2N   :Object = NewGestureStandard ("circle"  , [-100      ], [-100, -200, -300 ], "- circle delta angle");
      private static var sGestureStandards:Array = [
         sGestureStandard_Line1,
         sGestureStandard_Line2,
         sGestureStandard_Line2N,
         sGestureStandard_Return,
         sGestureStandard_ReturnN,
         sGestureStandard_Arrow1,
         sGestureStandard_Arrow1N,
         //sGestureStandard_Arrow2,
         //sGestureStandard_Arrow2N,
         sGestureStandard_Arrow3,
         sGestureStandard_Arrow3N,
         sGestureStandard_Triangle1,
         sGestureStandard_Triangle1N,
         sGestureStandard_Triangle2,
         sGestureStandard_Triangle2N,
         sGestureStandard_Triangle3,
         sGestureStandard_Triangle3N,
         sGestureStandard_Circle1,
         sGestureStandard_Circle1N,
         sGestureStandard_Circle2,
         sGestureStandard_Circle2N,
      ];
      
      private function FindBestFittedGestureType (deltaAngles:Array, accAngles:Array):String
      {
trace ("=========================== errors with standards: ");
         
         var minError:Number = Number.POSITIVE_INFINITY;
         var bestType:String = null;
         
         for each (var standard:Object in sGestureStandards)
         {
            var deltaError:Number = ComputeGestureDataError (standard.mDeltaAngles, deltaAngles, AngleDiff);
            var accError:Number   = ComputeGestureDataError (standard.mAccAngles, accAngles, AngleDiffWithTranc);
            var sumError:Number = deltaError + accError;
            if (sumError < MaxValidMinError && sumError < minError)
            {
               minError = sumError;
               bestType = standard.mType;
            }
            
            trace ("Error to standard '" + standard.mType + "'(" + standard.mInfo + "): delta error: " + deltaError + ", accError: " + accError + ", sumError: " + sumError);
         }
         
         return bestType;
      }
      
      private static var mErrorsTable:Array = null;
      private function ComputeGestureDataError (standardData:Array, realData:Array, DiffFunc:Function):Number
      {
         if (standardData == null || realData == null || standardData.length == 0 || realData.length == 0)
            return 0x7FFFFFFF;
         
         var numStandardValues:int = standardData.length;
         var numRealValues:int = realData.length;
         
         var numRows:int = numStandardValues + 1;
         var numCols:int = numRealValues + 1;
         var tableLength:int = numRows * numCols;
         if (mErrorsTable == null || mErrorsTable.length < tableLength)
            mErrorsTable = new Array (tableLength);

         var row:int;
         var col:int;
         for (var i:int = 0; i < tableLength; ++ i)
            mErrorsTable [i] = 0.0;
         for (col = 1; col < numCols; ++ col)
            mErrorsTable [col] = 0x7FFFFFFF;
         for (row = 1; row < numRows; ++ row)
            mErrorsTable [row * numCols] = 0x7FFFFFFF;

         // levensthein
         
         var error:int;
         i = numCols + 1;
         for (row = 0; row < numStandardValues; ++ row, ++ i)
         {
            for (col = 0; col < numRealValues; ++ col, ++ i)
            {
               error = Math.min (mErrorsTable [i - 1], mErrorsTable [i - numCols]);
               error = Math.min (mErrorsTable [i - 1 - numCols], error);
               mErrorsTable [i] = error + DiffFunc (standardData [row], realData [col]);
            }
         }
         
         return mErrorsTable [tableLength - 1] / numRealValues;
      }
      
      private static function AngleDiffWithTranc (standardValue:Number, realValue:Number):Number
      {
         var diff:Number = Math.abs (realValue - standardValue);
         if (diff > 5000)
            return diff;
         
         if (diff >= 360)
            diff = diff % 360;
         
         if (diff > 180)
            diff = 360 - diff;
         
         return diff;
      }
      
      private static function AngleDiff (standardValue:Number, realValue:Number):Number
      {
         var diff:Number = Math.abs (realValue - standardValue);
         
         return diff;
      }
   }
}
