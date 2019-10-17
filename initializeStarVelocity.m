function [s] = initializeStarVelocity(n, r, v, s_r, s_a, cw)
% n: Number of stars per core.
% r: Core initial positions.
% v: Core initial velocities.
% s_r: Star initial positions.
% s_a: star initial accelerations.
% cw: determine star orbit direction
    N = size(r,1);
    s = zeros(N, 3);
    for core = 1:N
        corePos = r(core,:);
        xcore = corePos(1);
        ycore = corePos(2);
        vcore = v(core,:);
        clockwise = cw(core);
        for i = 1:n
            num = n*(core-1) + i;
            starPos = s_r(num,:);
            xpos = starPos(1);
            ypos = starPos(2);
            xdiff = xcore - xpos;
            ydiff = ycore - ypos;
            if (xdiff < 0)
                direction = -null([xdiff, ydiff]).';
            else
                direction = null([xdiff, ydiff]).';
            end
            if (~clockwise)
                direction = -direction;
            end
            acceleration = norm(s_a(num,:));
            distance = norm(corePos - starPos);
            speed = sqrt(acceleration * distance);
            velocity = direction / norm(direction) * speed;
            s(num,:) = [velocity(1), velocity(2), 0] + vcore;
        end
    end
end