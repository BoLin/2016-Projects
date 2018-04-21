%HW6
clc;clear all;
x=linspace(0,10,1000000);
y1=sinc(x/2).*sinc(x/2);
plot(x,y1);grid on;
axis([0 10 -0.1 1.1])
xlabel wT 
ylabel G(jw)
legend('First Order Hold Frequency Response')

y2=sinc((x-1)/2).*sinc((x-1)/2);
plot(x,y2);grid on;
axis([0 10 -0.1 1.1])
xlabel wT 
ylabel G(jw)
legend('Causal First Order Hold Frequency Response')

y3=exp(-x).*sinc(x/2).*sinc(x/2);
plot(x,y3);grid on;
axis([0 10 -0.1 2])
xlabel wT 
ylabel G(jw)
legend('Causal First Order Hold Frequency Response')

%problem 2 addition
s=0.01:0.01:10
for i=1:length(s)
    h(i)=sqrt(1+4*pi^2*s(i)^2)*(abs(sinc(s(i))))^2;
end
plot(s,h);grid on;
xlabel w/ws 
ylabel G(jw)/T
legend('Causal First Order Hold Frequency Response')



%problem 3
%a
h = tf([1],[1 0 0]);
hd = c2d(h,1)

%b
h = tf([1],[1 1],'IODelay',1.5);
hd = c2d(h,1)




