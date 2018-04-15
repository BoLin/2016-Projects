%%
% twoLinePlot
figure
t=0:0.05:2*pi
plot(t,sin(t))
hold on
plot(t,cos(t),'r--')
xlabel('Time')
ylabel('Value')
title('Sin and Cos functions')
legend('Sin','Cos')
xlim([0 2*pi])
ylim([-1.4 1.4])

