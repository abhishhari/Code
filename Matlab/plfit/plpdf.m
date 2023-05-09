function [pdf, x] = plpdf(data, xmin, alpha)
% PLPDF Estimate the probability density function of data assuming a power-law distribution.
%
%   [PDF, X] = PLPDF(DATA, XMIN, ALPHA) estimates the probability density function (PDF) of the
%   data vector DATA assuming a power-law distribution with lower bound XMIN and exponent ALPHA.
%
%   The output PDF is a vector of estimated PDF values for each of the unique values in the input
%   data vector, and the output X is a vector of corresponding unique values. The PDF and X
%   vectors are sorted in descending order by PDF values.
%
%   This function requires the POWERLAW toolbox (http://www.santafe.edu/~aaronc/powerlaws/).
%
%   Author: E. Sheridan (2021)
    % Ensure data is a column vector
    data = data(:);
    
    % Remove any non-positive values and values less than xmin
    data = data(data > 0 & data >= xmin);
    
    % Compute the number of unique values in the data vector
    n = length(unique(data));
    
    % Compute the maximum value in the data vector
    xmax = max(data);
    
    % Generate a range of values from xmin to xmax
    x = linspace(xmin, xmax, n)';
    
    % Estimate the power-law PDF using the maximum likelihood method
    pdf = (alpha - 1) / xmin * (x / xmin).^(-alpha);
end
