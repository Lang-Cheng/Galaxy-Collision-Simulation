%-----------------------------------------------------------
% Set up time step
%-----------------------------------------------------------
tmax = 100;
level = 13;
nt = 2^level + 1;
deltat = tmax / nt;
%-----------------------------------------------------------
% Set up initial condition (case 2 cores)
% N: number of cores
% n: number of stars
% r0: initial core positions
% v0: initial core velocities
% m: core mass
% rmin: core minimum radius
% rmax: core maximum radius
% clockwise: core rotation direction
%-----------------------------------------------------------
N = 2;
n = 2500;
r0 = [400 500 0; -400 -500 0];
v0 = [-38 -10 0; 38 10 0];
m = [8*10^5; 8*10^5];
rmin = [200; 200];
rmax = [500; 500];
clockwise = [false; false];
%-----------------------------------------------------------
% Set up initial condition (case 2 cores rotate in z-plane)
%-----------------------------------------------------------
% N = 2;
% n = 1;
% r0 = [-1 0 0; 1 0 0];
% v0 = [0.2575 0.2543 0; 0.8407 0.8143 0];
% m = [1; 1];
% rmin = [200; 200];
% rmax = [500; 500];
% clockwise = [false; false];
%-----------------------------------------------------------
% Set up initial condition (case 1 core)
%-----------------------------------------------------------
% N = 1;
% n = 2500;
% r0 = [0 0 0];
% v0 = [0 0 0];
% m = 4*10^6;
% rmin = 400;
% rmax = 1500;
% clockwise = true;

%-----------------------------------------------------------
% Compute results
%-----------------------------------------------------------
[t, r, v, s_r, s_v, s_a] = particleSystem(tmax, level, N, n, r0, v0, m, rmin, rmax, clockwise);

%-----------------------------------------------------------
% Set avienable to a non-zero value to make an AVI movie.
%-----------------------------------------------------------
avienable = 1;
plotenable = 1;

% Set it to 0 for maximum animation speed.
%-----------------------------------------------------------
pausesecs = 0;

% Name of avi file.
avifilename = 'test1.avi';

% Presumed AVI playback rate in frames per second.
aviframerate = 25;

dlim = 2500;

if avienable
   aviobj = VideoWriter(avifilename);
   open(aviobj);
end

for it=1:20:nt
   if plotenable
      clf;
      hold on;
      axis square;
      box on;
      % normal
      xlim([-dlim, dlim]);
      ylim([-dlim, dlim]);
      % Two cores z-plane
%       xlim([-3, 30]);
%       ylim([-3, 10]);
      set(gca, 'Color', 'k');

      % Make and display title. 
      titlestr = sprintf('Two Core Z-plane \n Step: %d   Time: %.1f', ...
         fix(it / deltat), it);
      title(titlestr, 'FontSize', 16, 'FontWeight', 'bold', ...
         'Color', [0.25, 0.42, 0.31]);
     
      % plot graph (2 cores)
      plot(s_r(1:n,1,it), s_r(1:n,2,it), 'r.');
      plot(s_r(n+1:2*n,1,it), s_r(n+1:2*n,2,it), 'g.');
      plot(r(:,1,it), r(:,2,it), 'b.', 'MarkerSize', 20);

      % plot graph (1 core)
%       plot(s_r(:,1,it), s_r(:,2,it), 'r.');
%       plot(r(:,1,it), r(:,2,it), 'b.');
    
      % Force update of figure window.
      drawnow;

      % Record video frame if AVI recording is enabled and record 
      % multiple copies of the first frame.  Here we record 5 seconds
      % worth which will allow the viewer a bit of time to process 
      % the initial scene before the animation starts.
      if avienable
         if t == 0
            framecount = 5 * aviframerate ;
         else
            framecount = 1;
         end
         for iframe = 1 : framecount
            writeVideo(aviobj, getframe(gcf));
         end
      end

      % Pause execution to control interactive visualization speed.
      pause(pausesecs);
      %%-----------------------
      %% End Graphics section
      %%-----------------------
   end
end
