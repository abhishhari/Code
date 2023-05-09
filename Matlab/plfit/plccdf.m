function [F, X] = plccdf(x, xmin, alpha)
% PLCCDF Empirical complementary cumulative distribution function (ccdf)
%    for the power-law distribution.
%
%    [F, X] = PLCCDF(X, XMIN, ALPHA) returns the empirical ccdf of the
%    power-law distribution with parameters XMIN and ALPHA, evaluated at the
%    values in X. The input vector X should contain the range of values at
%    which to evaluate the ccdf. XMIN and ALPHA are the estimated parameters
%    of the power-law distribution. The output vectors F and X contain the
%    ccdf values and the corresponding X values, respectively.

% Reshape input vector
x = reshape(x, numel(x), 1);

% Compute ccdf
n = numel(x);
x = sort(x(x >= xmin));
n_x = numel(x);
F = (1:n_x) ./ n;
X = x;

end
