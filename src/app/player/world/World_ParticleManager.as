
//=============================================================
//   
//=============================================================

public static const NumParticlesToCreatedEachStep:int = 8;
public static const ParticlesCreateingStepInterval:Number = Define.WorldStepTimeInterval * 0.5 * 0.99;

//=============================================================
//    
//=============================================================

private var mBombs:Array = new Array ();
private var mNumBombs:int = 0;

private var mParticlesToCreate:int;

public function ParticleManager_Initialize ():void
{
   mNumBombs = 0;
}

public function ParticleManager_AddBomb (posX:Number, posY:Number, radius:Number):void
{
   var numParticles:int = 32 * ( 0.5 + radius * 2.0 * radius * 2.0 / (Define.DefaultBombSquareSideLength * Define.DefaultBombSquareSideLength) );
   
   if (mParticlesToCreate + numParticles > Define.MaxCoexistParticles)
   {
      trace ("Too many particles to create");
      return;
   }
   
   var bomb:Object = new Object ();
   mBombs [mNumBombs ++] = bomb;
   
   var particleSpeed:Number = 8.0 * ( 0.25 + 1.0 * radius * 2.0 / Number (Define.DefaultBombSquareSideLength) );
   var particleDensity:Number = 5.0;
   var particleLifeTime:Number = Define.WorldStepTimeInterval * 18 * ( 0.5 + 1.5 * radius * 2.0 / Number (Define.DefaultBombSquareSideLength) );
   
   if (radius > 12) radius = 12;
   if (radius < 5 ) radius = 5;
   
   bomb.mPosX = posX;
   bomb.mPosY = posY;
   bomb.mRadius = radius;
   
   var minCountEachStep:int = NumParticlesToCreatedEachStep / 2;
   bomb.mNumParticles = int ((numParticles + minCountEachStep - 1) / minCountEachStep) * minCountEachStep;
   bomb.mParticleSpeed = particleSpeed;
   bomb.mParticelDensity = particleDensity;
   bomb.mParticelLifeDuration = particleLifeTime;
   bomb.mParticleStartIdInterval = GetParticleStartIdInterval (bomb.mNumParticles);
   
   bomb.mParticleIdCreateInterval = bomb.mNumParticles / NumParticlesToCreatedEachStep;
   bomb.mBornTime = 0;
   bomb.mLastTimeStamp = 0;
   bomb.mNumCreateParticles = 0;
   bomb.mParticleStartId = 0;
   
   mParticlesToCreate += bomb.mNumParticles;
}

public function CreateExplosion ():void
{
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
      
      mParticlesToCreate -= count;
      
      var angle:Number;
      var cos:Number;
      var sin:Number;
      for (var i:int = 0; i < count; ++ i)
      {
         angle = particleId * Define.kPI_x_2 / bomb.mNumParticles;
         cos = Math.cos (angle);
         sin = Math.sin (angle);
         
         CreateEntityParticle (
                  bomb.mPosX + bomb.mRadius * cos, 
                  bomb.mPosY + bomb.mRadius * sin, 
                  bomb.mParticleSpeed * cos, 
                  bomb.mParticleSpeed * sin, 
                  bomb.mParticelDensity, 
                  bomb.mParticelLifeDuration);
         
         particleId += idInterval;
         ++ bomb.mNumCreateParticles;
      }
      
      if (bomb.mNumCreateParticles >= bomb.mNumParticles)
      {
         mBombs [bombId --] = mBombs [-- mNumBombs];
         if (mNumBombs <= 0)
         {
            mNumBombs = 0;
            //trace ("mParticlesToCreate = " + mParticlesToCreate);
            mParticlesToCreate = 0; // remove this line when new particle type objects are intruduced in later versions
         }
         
         mBombs [mNumBombs] = null;
      }
   }
}

private function GetParticleStartIdInterval (numParticles:int):int
{
   if (numParticles >= 92)
      return 569;
   if (numParticles >= 88)
      return 1669;
   else if (numParticles >= 72)
      return 569;
   else if (numParticles >= 50)
      return 389;
   else if (numParticles >= 32)
      return 569;
   else
      return 859;
}

//==============================================================
//
//==============================================================


private function CreateEntityParticle (posX:Number, posY:Number, velocityX:Number, velocityY:Number, density:Number, lifeDuration:Number):EntityShape_Particle
{
   var particle:EntityShape_Particle = new EntityShape_Particle (this, lifeDuration);
   particle.SetPositionX (posX);
   particle.SetPositionY (posY);
   particle.SetLinearVelocityX (velocityX);
   particle.SetLinearVelocityY (velocityY);
   particle.SetDensity (density);
   
   var body:EntityBody = new EntityBody (this);
   particle.SetBody (body);
   
   RegisterEntity (particle);
   RegisterEntity (body);
   
   return particle;
}

