function optionPrice=EuropeanOptionCRR(F0,K,B,T,sigma,N,flag)
%European option price with a CRR tree approach
%
%INPUT
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% N:     number of time steps (knots for CRR tree)
% flag:  1 call, -1 put

dt = T/N;

u = exp(sigma * sqrt(dt)); % Up factor
d = exp(-sigma * sqrt(dt)); % Down factor
p = (1 - d) / (u - d); % Risk-neutral probability

% Initialize forward prices at maturity
FT = zeros(N+1, 1);
for i = 0:N
    FT(i+1) = F0 * d^i * u^(N-i);
end

% Calculate option values at maturity
if flag == 1
    V = max(0, FT - K);
else
    V = max(0, K - FT);
end

l = N;
% Backward induction
for j = N:-1:1
    V = p * V(1:l) + (1 - p) * V(2:l+1); % Update option values
    l = l-1;
end 

optionPrice= B * V;

end % function EuropeanOptionCRR

