function [M,stdEstim]=PlotErrorMC(F0,K,B,TTM,sigma)
%Plot of the error with a MC approach
%
%INPUT
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility

flag = 1;
M = zeros(1, 20); % Initialize the M array
stdEstim = zeros(1, 20); % Initialize the stdEstim array

for m = 1:20
    M(m) = 2^m;
    % Generate random paths for the underlying asset price
    paths = zeros(M(m), 1);
    for i = 1:M(m)
        paths(i) = F0 * exp((- 0.5 * sigma^2) * TTM + sigma * sqrt(TTM) * randn);
    end
    % Calculate the discounted option payoff for each path
    disc_payoffs = B * max(flag * (paths - K), 0);
    % Standard deviation
    s = std(disc_payoffs);   
    
    % error
    stdEstim(m) = s / sqrt(M(m));
end

end