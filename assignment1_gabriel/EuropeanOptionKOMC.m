function optionPrice=EuropeanOptionKOMC(F0,K,KO,B,T,sigma,N)
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

% Generate random paths for the underlying forward price
FT = zeros(N, 1);
for i = 1:N
    FT(i) = F0 * exp((- 0.5 * sigma^2) * T + sigma * sqrt(T) * randn);
end

% Calculate the option payoff for each path (ST = FT)
payoffs = max((FT - K), 0);
% Check knock-out barrier
payoffs(FT>KO)=0;

% Discount the payoffs to present value
optionPrice = B * mean(payoffs);

end