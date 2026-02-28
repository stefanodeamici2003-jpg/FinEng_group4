function optionPrice=EuropeanOptionMC(F0,K,B,T,sigma,N,flag)
%European option price with a Monte Carlo approach
%
%INPUT
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% N:     number of simulations in MC
% flag:  1 call, -1 put

% Generate random paths for the underlying forward price
FT = zeros(N, 1);
for i = 1:N
    FT(i) = F0 * exp((- 0.5 * sigma^2) * T + sigma * sqrt(T) * randn);
end

% Calculate the option payoff for each path
payoffs = max(flag * (FT - K), 0);

% Discount the payoffs to present value
optionPrice = B * mean(payoffs);

end

