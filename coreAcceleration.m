function [a] = coreAcceleration(m, r)
% m: Vector of length N containing the particle masses
% r: N x 3 array containing the particle positions
% a: N x 3 array containing the computed particle accelerations
    N = size(r,1);
    a = zeros(N, 3);
    for i = 1:N
        for j = 1:N
            if (i ~= j)
                m_j = m(j);
                r_i = r(i,:);
                r_j = r(j,:);
                r_ij = r_j - r_i;
                x_ij = norm(r_ij);
                a(i,:) = a(i,:) + r_ij * (m_j / x_ij^3);
            end
        end
    end
end