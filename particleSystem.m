function [t, r, v, s_r, s_v, s_a] = particleSystem(tmax, level, coreNum, starNum, r0, v0, m, rmin, rmax, clockwise)
%  
%  Input arguments
%
%      tmax:       (real scalar) Final solution time.
%      level:      (integer scalar) Discretization level.
%      coreNum:    (integer scalar) Number of cores, use as N.
%      starNum:    (integer scalar) Number of stars, use as n.
%      r0:         (N x 3 array) Initial positions.
%      v0:         (N x 3 array) Initial velocity.
%      m:          (Vector of length N) particle masses
%      rmin:       (integar scalar) the minimum radius of the star distribution
%      rmax:       (integar scalar) the minimum radius of the star distribution
%      clockwise:  (boolean) true then stars move in clockwise
%
%  Output arguments
%
%      t:      (real vector) Vector of length nt = 2^level + 1 containing
%              discrete times (time mesh).
%      r:      (N x 3 array) Vector of length nt containing computed 
%              3D position of cores at discrete times t(n).
%      v:      (N x 3 array) Vector of length nt containing computed
%              3D velocity of cores at discrete times t(n).
%      s_r:    (N*n x 3 array) Vector of length nt containing computed
%              3D position of stars at discrete times t(n).
%      s_v:    (N*n x 3 array) Vector of length nt containing computed
%              3D velocity of stars at discrete times t(n).
%      s_a:    (N*n x 3 array) Vector of length nt containing computed
%              3D acceleration of stars at discrete times t(n).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Tracing control: if 7th arg is supplied base tracing on that input,
   % otherwise use local defaults.
   if nargin > 10
      if tracefreq == 0
         trace = 0;
      else
         trace = 1;
      end
   else
      trace = 1;
      tracefreq = 100;
   end

   if trace
      fprintf('In pendulum: Argument dump follows\n');
      tmax, level, r0, v0
   end
   
   % Define number of time steps and create t, position r and velocity v
   % arrays of appropriate size for efficiency (rather than "growing" 
   % them element by element)
   nt = 2^level + 1;
   t = linspace(0.0, tmax, nt);
   r = zeros(coreNum, 3, nt);
   v = zeros(coreNum, 3, nt);
   s_r = zeros(coreNum*starNum, 3, nt);
   s_v = zeros(coreNum*starNum, 3, nt);
   s_a = zeros(coreNum*starNum, 3, nt);
   
   % Determine discrete time step from t array.
   deltat = t(2) - t(1);

   % Initialize first two values of the particle's displacement.
   r(:,:,1) = r0;
   r(:,:,2) = r0 + deltat * v0 + 0.5 * deltat^2 * coreAcceleration(m, r0);
   
   % Initialize stars inital position
   s_r(:,:,1) = initializeStarPosition(starNum, r0, rmin, rmax);
   
   % Initialize stars initial acceleration
   s_a(:,:,1) = initializeStarAcceleration(starNum, r0, m, s_r(:,:,1));
   
   % Initialize stars initial velocity
   s_v(:,:,1) = initializeStarVelocity(starNum, r0, v0, s_r(:,:,1), s_a(:,:,1), clockwise);
   
   if trace 
      for i=1:coreNum
      fprintf('deltat=%g core=%i r(1)[x]=%g r(2)[x]=%g\n',...
              deltat, i, r(i,1,1), r(i,1,2));
      fprintf('deltat=%g core=%i r(1)[y]=%g r(2)[y]=%g\n',...
              deltat, i, r(i,2,1), r(i,2,2));
      fprintf('deltat=%g core=%i r(1)[z]=%g r(2)[z]=%g\n',...
              deltat, i, r(i,3,1), r(i,3,2));
      end
   end
   
   % Initialize first value of the velocity.
   v(:,:,1) = v0;

   % Evolve the system to the final time using the discrete equations
   % of motion.  Also compute an estimate of the velocity at 
   % each time step.
   for n = 2 : nt - 1
      % This generates tracing output every 'tracefreq' steps.
      if rem(n, tracefreq) == 0
         fprintf('system: Step %g of %g\n', n, nt);
      end

      r(:,:,n+1) = 2 * r(:,:,n) - r(:,:,n-1) + deltat^2 * coreAcceleration(m, r(:,:,n));
      
%       s_r(:,:,n) = s_r(:,:,n-1) + s_v(:,:,n-1) * deltat;
%       
%       s_a(:,:,n) = starAcceleration(s_r(:,:,n-1), r(:,:,n-1), coreNum, starNum, m);
%       
%       s_v(:,:,n) = s_v(:,:,n-1) + s_a(:,:,n-1)*deltat;
      s_a(:,:,n) = starAcceleration(s_r(:,:,n-1), r(:,:,n-1), coreNum, starNum, m);
      s_v(:,:,n) = s_v(:,:,n-1) + s_a(:,:,n)*deltat;
      s_r(:,:,n) = s_r(:,:,n-1) + s_v(:,:,n) * deltat;

      v(:,:,n) = (r(:,:,n+1) - r(:,:,n-1)) / (2 * deltat);
   end
   % Use linear extrapolation to determine the value of omega at the 
   % final time step.
   v(:,:,nt) = 2 * v(:,:,nt-1) - v(:,:,nt-2);
end
