function [a] = initializeStarAcceleration(n, r, m, s_r)
% n: Number of stars per core.
% r: Core initial positions.
% m: Core masses.
% s_r: Star initial positions
% a: star initial accelerations.
    N = size(r,1);
    a = zeros(N, 3);
    for core = 1:N
        corepos = r(core,:);
        for i = 1:n
            num = n*(core-1) + i;
            starpos = s_r(num,:);
            posdiff = corepos - starpos;
            acceleration = m(core) / norm(posdiff)^2;
            unit_vector = posdiff / norm(posdiff);
            a(num,:) = acceleration * unit_vector;
        end
    end
end