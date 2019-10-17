function [a] = starAcceleration(s_r, r, N, n, m)
% s_r: N*n x 3 array containing the star positions
% r: N x 3 array containing the core positions
% N: Number of cores.
% n: Number of stars.
% m: core masses.
    a = zeros(N*n, 3);
    for i = 1:n*N
        for core = 1:N
            corepos = r(core,:);
            starpos = s_r(i,:);
            posdiff = corepos - starpos;
            acceleration = m(core) / norm(posdiff)^2;
            unit_vector = posdiff / norm(posdiff);
            a(i,:) = a(i,:) + acceleration * unit_vector;
        end
    end
end