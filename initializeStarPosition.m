function [s] = initializeStarPosition(n, r, r_min, r_max)
% n: Number of stars per core.
% r: Core initial positions.
% rmin: core minimum radius.
% rmax: core maximum radius.
% s: randomly generated stars.
    N = size(r,1);
    s = zeros(N, 3);
    for core = 1:N
        rmin = r_min(core);
        rmax = r_max(core);
        rdiff = rmax - rmin;
        for i = 1:n
            r_rand = rand() * rdiff + rmin;
            theta = rand() * 2 * pi;
            num = n*(core-1) + i;
            s(num,:) = [r_rand * cos(theta) + r(core,1); r_rand * sin(theta) + r(core,2); 0];
        end
    end
end