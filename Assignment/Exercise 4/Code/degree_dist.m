function [ max_possible_degree, elements ] = degree_dist( A )
%DEGREE_DIST Summary of this function goes here
%   Detailed explanation goes here
    deg = degree(A);

    % degree distribution
    possible_degrees = unique(deg);
    max_possible_degree = max(possible_degrees);
    elements = histc(full(deg), full(1: max_possible_degree));
    elements = elements ./ size(A,1);
end

