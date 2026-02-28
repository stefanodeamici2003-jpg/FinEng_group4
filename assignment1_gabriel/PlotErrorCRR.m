function [M,errorCRR]=PlotErrorCRR(F0,K,B,TTM,sigma)
%Plot of the error with a CRR approach
%
%INPUT
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility

flag = 1;
M = zeros(1, 10); % Initialize the M array
errorCRR = zeros(1, 10); % Initialize the errorCRR array

X = EuropeanOptionClosed(F0,K,B,TTM,sigma,flag);
for m = 1:10
    M(m) = 2^m;
    % option priced with CRR
    pricingMode=2;
    Y = EuropeanOptionPrice(F0,K,B,TTM,sigma,pricingMode,M(m),flag);   
    % error
    errorCRR(m) = abs(X - Y);
end

end