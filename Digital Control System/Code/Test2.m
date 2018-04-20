%ECE579Test2
%b)
num=[20];
den=[1 0 -1000];
sys1=tf(num,den);%
rlocus(sys1);

%c)
Ts=0.02;
sys2=c2d(sys1,Ts,'zoh');
rlocus(sys2)

%d)
%adding a lead compensator as sys3
a=0.5313;
b=0.093;
numc=[1 -a];
denc=[1 -b];
sys3=tf(numc,denc,Ts);% controller sys3
sys4=sys2*sys3;
rlocus(sys4);
zgrid(0.5,23*Ts/pi);
axis([-4 2.1 -2.5 2.5])
%ploting step response
plot(Position(:,1),Position(:,2),'-x',Position(:,1),Position(:,3))
grid on
xlabel('Time(s)')
ylabel('Position x(m)/Current i(A)')
title('Step Response')
legend('Output','Input')

%e
%changing m
n=1;
for m=0.001:0.001:0.1
k1=20;
k2=0.4;
nume=[k2/m]
dene=[1 0 -k1/m]
sys6=tf(nume,dene)
sys7=c2d(sys6,Ts,'zoh')
sys8=sys7*116*sys3;%controller and plant
all=1+sys8;
[numa, dena]=tfdata(all)
f=[numa{1,1}(1,1) numa{1,1}(1,2) numa{1,1}(1,3) numa{1,1}(1,4)]
p=roots(f)
pole(n,:)=p;
n=n+1;
end

%plot
zgrid
hold on
r1=real(pole(:,1));
i1=imag(pole(:,1));
plot(r1,i1,'*r')
hold on
r2=real(pole(:,2));
i2=imag(pole(:,2));
plot(r2,i2,'+g')
hold on
r3=real(pole(:,3));
i3=imag(pole(:,3));
plot(r3,i3,'xb')

%e
%changing k1
n=1;
for k1=1:0.2:30
m=0.02
k2=0.4;
nume=[k2/m]
dene=[1 0 -k1/m]
sys6=tf(nume,dene)
sys7=c2d(sys6,Ts,'zoh')
sys8=sys7*116*sys3;%controller and plant
all=1+sys8;
[numa, dena]=tfdata(all)
f=[numa{1,1}(1,1) numa{1,1}(1,2) numa{1,1}(1,3) numa{1,1}(1,4)]
p=roots(f)
pole(n,:)=p;
n=n+1;
end
%plot
zgrid
hold on
r1=real(pole(:,1));
i1=imag(pole(:,1));
plot(r1,i1,'*r')
hold on
r2=real(pole(:,2));
i2=imag(pole(:,2));
plot(r2,i2,'+g')
hold on
r3=real(pole(:,3));
i3=imag(pole(:,3));
plot(r3,i3,'xb')



