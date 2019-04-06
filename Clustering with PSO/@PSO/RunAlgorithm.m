function [pso,sol,fitVal]=RunAlgorithm(pso,termnationRatio)
global numOfTrueIterations
% Check the validity of initial particles and compute fitness values
 termnCount=0;
for i=1:pso.numberOfParticles
    pso.fitnessOfParticles(i)=pso.ObjectiveFunction(pso.positionsOfParticles(i,:));
end

% Set the initial particles as the best local particles
pso.bestLocalParticles=pso.positionsOfParticles;
pso.bestLocalFitness=pso.fitnessOfParticles;

% Find the initial best global particle
index=find(pso.fitnessOfParticles==min(pso.bestLocalFitness),1);
pso.bestGlobalParticle=pso.positionsOfParticles(index,:);
pso.bestGlobalFitness=pso.fitnessOfParticles(index);

% Start iterations
for j=1:pso.numberOfIterations
    clc
    
    pso.bestGlobalFitness
    % Compute the new velocities
    pso.velocitiesOfParticles=0.5*pso.velocitiesOfParticles+...
        pso.c1*rand(size(pso.velocitiesOfParticles)).*(pso.bestLocalParticles-pso.positionsOfParticles)+...
        pso.c2*rand(size(pso.velocitiesOfParticles)).*(repmat(pso.bestGlobalParticle,[pso.numberOfParticles 1])...
        -pso.positionsOfParticles);    
   
    % Update the particles
    pso.positionsOfParticles=pso.positionsOfParticles+pso.velocitiesOfParticles;
      
    % Check the particles and compute fitness values
    for i=1:pso.numberOfParticles
        index1=pso.positionsOfParticles(i,:)<pso.lowerBounds;
        index2=pso.positionsOfParticles(i,:)>pso.higherBounds;
        pso.positionsOfParticles(i,index1)=pso.lowerBounds(index1);
        pso.positionsOfParticles(i,index2)=pso.higherBounds(index2);
        pso.fitnessOfParticles(i)=pso.ObjectiveFunction(pso.positionsOfParticles(i,:));
    end
    
    % Update best local particles
    index=pso.bestLocalFitness>pso.fitnessOfParticles;
    pso.bestLocalParticles(index,:)=pso.positionsOfParticles(index,:);
    pso.bestLocalFitness(index)=pso.fitnessOfParticles(index);
    
    % Update best global particle
    [fitVal,index]=min(pso.bestLocalFitness);
    if fitVal<pso.bestGlobalFitness
        pso.bestGlobalParticle=pso.bestLocalParticles(index,:);
        pso.bestGlobalFitness=fitVal;
    end
    
    % Save the fitness of the best particle
    pso.iterationFitness(j)=pso.bestGlobalFitness;
    %% termination condition 
    if j>1
         if pso.iterationFitness(j-1)==0
             break;
         elseif abs(pso.iterationFitness(j-1)-pso.bestGlobalFitness)/pso.iterationFitness(j-1) <termnationRatio
        termnCount = termnCount+1;
         else
        termnCount=0;
         end
         
    end
    if termnCount>5
        break;
        disp('termination condition')
        disp(numOfTrueIterations)
    end
end
numOfTrueIterations = j;
% Return the best of best particles
sol=pso.bestGlobalParticle;
fitVal=pso.bestGlobalFitness;
end

