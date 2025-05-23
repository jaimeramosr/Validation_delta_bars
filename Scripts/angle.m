function [ang] = angle(A,B,C)
% Magnitude of vector is its norm
AB = A'-B';
CB = C'-B';
for i=1:length(A)
    ang(i) = atan2(abs(det([AB(i,:);CB(i,:)])),dot(AB(i,:),CB(i,:)));
    ang(i) = ang(i)*180/pi;
end
plot(ang)
hold on
