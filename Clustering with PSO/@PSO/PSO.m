classdef PSO
    properties
        numberOfParticles; 
        dimensionOfParticle;
        positionsOfParticles;
        velocitiesOfParticles
        fitnessOfParticles;
        numberOfIterations;
        lowerBounds;
        higherBounds;
        c1;                      % Acceleration constant 1
        c2;                      % Acceleration constant 2
        bestLocalParticles;
        bestLocalFitness;
        bestGlobalParticle;
        bestGlobalFitness;
        iterationFitness;
    end
    
    methods
        function pso=PSO(numberOfParticles,dimensionOfParticle,lowerBounds,higherBounds,numberOfIterations,c1,c2)
            % Read user input and initialize the algorithm
            pso.numberOfParticles=numberOfParticles; 
            pso.dimensionOfParticle=dimensionOfParticle;
            pso.positionsOfParticles=repmat(lowerBounds,numberOfParticles,1)+...
                repmat(higherBounds-lowerBounds,numberOfParticles,1).*rand(numberOfParticles,dimensionOfParticle);
            pso.velocitiesOfParticles=zeros(numberOfParticles,dimensionOfParticle);
            pso.fitnessOfParticles=zeros(numberOfParticles,1);
            pso.numberOfIterations=numberOfIterations;
            pso.c1=c1;
            pso.c2=c2;
            pso.iterationFitness=zeros(1,numberOfIterations);
            pso.lowerBounds=lowerBounds;
            pso.higherBounds=higherBounds;
        end
        [pso,sol,fitVal]=RunAlgorithm(pso,termnationRatio);
        costVal=ObjectiveFunction(pso,particle); 
    end
end
