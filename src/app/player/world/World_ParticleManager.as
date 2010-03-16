
//=============================================================
//   
//=============================================================

public static const NumParticlesToCreatedEachStep:int = 8;
public static const ParticlesCreateingStepInterval:Number = Define.WorldStepTimeInterval_SpeedX2 * 0.5 * 0.99;

//=============================================================
//    
//=============================================================

private var mBombs:Array = new Array ();
private var mNumBombs:int = 0;

private var mNumParticles:int; // include the ready to be createds

public function ParticleManager_Initialize ():void
{
   mNumBombs = 0;
   mNumParticles = 0;
}

public function NotifyParticleDestroy ():void
{
   -- mNumParticles;
}

public function ExplodeBomb (posX:Number, posY:Number, radius:Number, density:Number, ccat:CollisionCategory):void
{
   var worldDisplayRadius:Number = mCoordinateSystem.P2D_Length (radius);
   
   var numParticles:int = 32 * ( 0.5 + worldDisplayRadius * 2.0 * worldDisplayRadius * 2.0 / (Define.DefaultBombSquareSideLength * Define.DefaultBombSquareSideLength) );
   
   var particleDisplaySpeed:Number = 800.0 * ( 0.20 + 2.6 * worldDisplayRadius / Number (Define.DefaultBombSquareSideLength) );
   var particlePhysicsSpeed:Number = mCoordinateSystem.D2P_LinearVelocityMagnitude (particleDisplaySpeed);
   
   var particleDensity:Number = 5.0 * density;
   var particleLifeTime:Number = Define.WorldStepTimeInterval_SpeedX2 * 18 * ( 0.5 + 1.5 * worldDisplayRadius * 2.0 / Number (Define.DefaultBombSquareSideLength) );
   
   worldDisplayRadius = worldDisplayRadius - 1;
   if (worldDisplayRadius < 1)
      worldDisplayRadius = 1;
   
   CreateExplosion (posX, posY, ccat, numParticles, particleLifeTime, particleDensity, 0.8, particlePhysicsSpeed, worldDisplayRadius, Define.ColorBombObject, true);
}

public function CreateExplosion (posX:Number, posY:Number, ccat:CollisionCategory, numParticles:int, lifeDuration:Number, density:Number, restitution:Number, physicsSpeed:Number, worldDisplayRadius:Number, color:uint, isVisible:Boolean):int
{
   if (mNumParticles + numParticles > Define.MaxCoexistParticles)
   {
      trace ("Too many particles to create");
      return 0;
   }
   
   var wavePhysicsRadius:Number = mCoordinateSystem.D2P_Length (worldDisplayRadius);
   
   var minCountEachStep:int = NumParticlesToCreatedEachStep / 2;
   numParticles = int ((numParticles + minCountEachStep - 1) / minCountEachStep) * minCountEachStep;
   mNumParticles += numParticles;
   
   var bomb:Object = new Object ();
   mBombs [mNumBombs ++] = bomb;
   
   bomb.mPosX = posX;
   bomb.mPosY = posY;
   bomb.mRadius = wavePhysicsRadius;
   bomb.mCollisionCategory = ccat;
   
   bomb.mNumParticles = numParticles;
   bomb.mParticleSpeed = physicsSpeed;
   bomb.mParticleDensity = density;
   bomb.mParticleRestitution = restitution;
   bomb.mParticleLifeDuration = lifeDuration;
   bomb.mParticleStartIdInterval = GetParticleStartIdInterval (bomb.mNumParticles);
   bomb.mParticleColor = color;
   bomb.mParticleVisible = isVisible;
   
   bomb.mParticleIdCreateInterval = bomb.mNumParticles / NumParticlesToCreatedEachStep;
   bomb.mBornTime = 0;
   bomb.mLastTimeStamp = 0;
   bomb.mNumCreateParticles = 0;
   bomb.mParticleStartId = 0;
   
   return numParticles;
}

public function ParticleManager_Update (dt:Number):void
{
   for (var bombId:int = 0; bombId < mNumBombs; ++ bombId)
   {
      var bomb:Object = mBombs [bombId];
      
      if (bomb == null)
      {
         trace ("bomb == null !!!");
         return;
      }
      
      bomb.mBornTime += dt;
      if (bomb.mBornTime - bomb.mLastTimeStamp < ParticlesCreateingStepInterval)
         continue;
      
      bomb.mLastTimeStamp = bomb.mBornTime;
      
      bomb.mParticleStartId += bomb.mParticleStartIdInterval;
      bomb.mParticleStartId %= bomb.mNumParticles;
      
      var particleId:int = bomb.mParticleStartId;// ++;
      var count:int = bomb.mNumParticles - bomb.mNumCreateParticles;
      if (count > NumParticlesToCreatedEachStep) 
         count = NumParticlesToCreatedEachStep;
      var idInterval:int = int (bomb.mParticleIdCreateInterval * NumParticlesToCreatedEachStep / count + 0.5);
      
      var angle:Number;
      var cos:Number;
      var sin:Number;
      for (var i:int = 0; i < count; ++ i)
      {
         angle = mCoordinateSystem.P2D_RotationRadians (particleId * Define.kPI_x_2 / bomb.mNumParticles);
         cos = Math.cos (angle);
         sin = Math.sin (angle);
         
         EntityShape.CreateParticle (
                  this,
                  bomb.mPosX + bomb.mRadius * cos, 
                  bomb.mPosY + bomb.mRadius * sin, 
                  bomb.mParticleSpeed * cos, 
                  bomb.mParticleSpeed * sin, 
                  bomb.mParticleDensity, 
                  bomb.mParticleRestitution, 
                  bomb.mParticleLifeDuration,
                  bomb.mParticleColor,
                  bomb.mParticleVisible,
                  bomb.mCollisionCategory
               );
         
         particleId += idInterval;
         ++ bomb.mNumCreateParticles;
      }
      
      if (bomb.mNumCreateParticles >= bomb.mNumParticles)
      {
         mBombs [bombId --] = mBombs [-- mNumBombs];
         if (mNumBombs <= 0)
         {
            mNumBombs = 0;
         }
         
         mBombs [mNumBombs] = null;
      }
   }
}

private static const kPrimeNumbers:Array = [
   3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 
   109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 
   227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 
   347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 
   461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 
   599, 601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691, 701, 709, 719, 
   727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797, 809, 811, 821, 823, 827, 829, 839, 853, 857, 
   859, 863, 877, 881, 883, 887, 907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997, 
]
private function GetParticleStartIdInterval (numParticles:int):int
{
   var n:int = numParticles / (NumParticlesToCreatedEachStep + NumParticlesToCreatedEachStep);
   
   var lower:int = 0;
   var upper:int = kPrimeNumbers.length;
   var mid:int;
   var prime:int;
   
   while (lower < upper)
   {
      mid = (lower + upper) >> 1;
      prime = kPrimeNumbers [mid];
      if (prime < n)
         lower = mid + 1;
      else if (prime > n)
         upper = mid - 1;
      else
         return prime;
   }
   
   return kPrimeNumbers [lower];
}

//==============================================================
//
//==============================================================



