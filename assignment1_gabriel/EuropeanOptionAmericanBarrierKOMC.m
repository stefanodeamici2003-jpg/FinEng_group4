function optionPrice=EuropeanOptionAmericanBarrierKOMC(F0,K,KO,B,T,sigma,q,N)
%European barrier option price with a Monte Carlo approach
%
%INPUT
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% N:     number of simulations in MC
% KO:    threshold

dt = T/N;

% Simulate Forward GBM paths
Z = randn(N, N);
logR = (-0.5*sigma^2)*dt + sigma*sqrt(dt).*Z;
logF = [log(F0)*ones(N,1), cumsum(logR,2) + log(F0)];
F = exp(logF);

% Spot paths
r = -log(B)/T;
timeGrid = linspace(0,T,N+1);
adjFactor = exp(-(r-q)*(T - timeGrid));
S = F .* adjFactor;

% Check knock-out barrier
hitBarrier = any(S > KO, 2);
FT = F(:, end);
FT(hitBarrier) = 0;

% Payoff and discount
payoffs = max(FT - K, 0);
optionPrice = B * mean(payoffs);
end