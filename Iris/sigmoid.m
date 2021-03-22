function [g]=sigmoid(x, W, W0)
    g=1./(1+exp(-(W*x+W0)));
end