function [A1] = append(E1, points, a, b)
% Append experimental flowtest data at hourly intervals

[x,y] = size(E1);
tail_data = (x + points);

A1 = zeros(tail_data,2);
% A1(:,1) = hrs after injection
% A1(:,2) = conc.

for n = 1:119790;
    A1(n,1) = E1(n,3);            
    A1(n,2) = E1(n,2);  
end
for q = 119790:x;
    A1(q,1) = A1(q-1,1) + 0.0028;
    A1(q,2) = a*exp(b*A1(q,1));
for m = x : tail_data;
    A1(m,1) = A1(m-1,1) + 0.0028;
    A1(m,2) = a*exp(b*A1(m,1));
end

end
