package player.world {
   
   import com.tapirgames.util.Logger;
   
   import player.entity.EntityParticle;
   
   import common.Define;
   
   public class ParticleManager 
   {
      public static const NumParticlesToCreatedEachStep:int = 8;
      public static const ParticlesCreateingStepInterval:Number = Define.WorldStepTimeInterval * 0.5 * 0.99;
      
      private var mWorld:World;
      
      private var mBombs:Array = new Array ();
      private var nNumBombs:int;
      
      public function ParticleManager (world:World)
      {
         mWorld = world;
         
         nNumBombs = 0;
      }
      
      public function AddBomb (posX:Number, posY:Number, radius:Number):void
      {
         var bomb:Object = new Object ();
         mBombs [nNumBombs ++] = bomb;
         
         var numParticles:int = 32 * radius * 2.0 * radius * 2.0 / (Define.DefaultBombSquareSideLength * Define.DefaultBombSquareSideLength);
         var particleSpeed:Number = 10.0 * ( 0.5 + 0.75 * radius / Number (Define.DefaultBombSquareSideLength) );
         var particleDensity:Number = 5.0;
         var particleLifeTime:Number = Define.WorldStepTimeInterval * 9 * ( 1.0 + 1.5 * radius / Number (Define.DefaultBombSquareSideLength) );
         
         trace ("numParticles = " + numParticles);
         trace ("particleSpeed = " + particleSpeed);
         trace ("particleLifeTime = " + particleLifeTime);
         
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
         
         bomb.mParticleIdCreateInterval = bomb.mNumParticles / NumParticlesToCreatedEachStep;
         bomb.mBornTime = 0;
         bomb.mLastTimeStamp = 0;
         bomb.mNumCreateParticles = 0;
         bomb.mParticleStartId = 0;
      }
      
      public function Update (dt:Number):void
      {
         for (var bombId:int = 0; bombId < nNumBombs; ++ bombId)
         {
            var bomb:Object = mBombs [bombId];
            
            if (bomb == null)
            {
               Logger.Trace ("bomb == null !!!");
               return;
            }
            
            bomb.mBornTime += dt;
            if (bomb.mBornTime - bomb.mLastTimeStamp < ParticlesCreateingStepInterval)
               continue;
            
            bomb.mLastTimeStamp = bomb.mBornTime;
            
            var particleId:int = bomb.mParticleStartId ++;
            var count:int = bomb.mNumParticles - bomb.mNumCreateParticles;
            if (count > NumParticlesToCreatedEachStep) 
               count = NumParticlesToCreatedEachStep;
            
            for (var i:int = 0; i < count; ++ i)
            {
               var params:Object = new Object ();
               
               params.mAngle = particleId * Math.PI * 2 / bomb.mNumParticles;
               params.mPosX = bomb.mPosX + bomb.mRadius * Math.cos (params.mAngle);
               params.mPosY = bomb.mPosY + bomb.mRadius * Math.sin (params.mAngle);
               params.mSpeed = bomb.mParticleSpeed;
               params.mDenstiy = bomb.mParticelDensity;
               params.mLifeDuration = bomb.mParticelLifeDuration;
               
               mWorld.CreateEntityParticle (params).Update (0);
               
               particleId += bomb.mParticleIdCreateInterval;
               ++ bomb.mNumCreateParticles;
            }
            
            if (bomb.mNumCreateParticles >= bomb.mNumParticles)
            {
               mBombs [bombId --] = mBombs [-- nNumBombs];
               mBombs [nNumBombs] = null;
            }
         }
      }
      
      
      
   }
}