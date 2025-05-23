function [m, a] = ab2v(v1, v2)
% Magnitude of vector is its norm
for i=1:length(v1)
    m(1) = norm(v1(i));
    m(2) = norm(v2(i));
    a(i) = acosd(dot(v1(i), v2(i)) / m(1) / m(2));
end

AB = A-B;
CB = C-B;
ang = atan2(abs(det([AB;CB])),dot(AB,CB));