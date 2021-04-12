function [g]=sigmoid(data)
    g=1./(1+exp(-data));
end