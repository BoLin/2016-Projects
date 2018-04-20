%ECE579HW7
T=0.25;
w=3;
z=exp(i*w*T);

%%
%Forward rule
num=[10 -7.5];
den=[1 1.5];
zplane(num,den);
HZ1=tf(num,den);
a=evalfr(HZ1,z);
phase=(180/pi)*angle(a);

%%
%Backward rule
num=[12.5 -10];
den=[3.5 -1];
zplane(num,den)
HZ2=tf(num,den);
a=evalfr(HZ2,z);
phase=(180/pi)*angle(a)


%%
%Bilinear
num=[22.5 -17.5];
den=[4.5 0.5];
zplane(num,den)
HZ3=tf(num,den);
a=evalfr(HZ3,z);
phase=(180/pi)*angle(a)

%%
%Bilinear with prewarping
num=[3.394 -2.6064];
den=[0.694 0.09363];
zplane(num,den)
HZ4=tf(num,den);
a=evalfr(HZ4,z);
phase=(180/pi)*angle(a)

%%
%Zero pole mapping
num=4.15*[1 -0.7788];
den=[1 -0.082085];
zplane(num,den)
HZ5=tf(num,den);
a=evalfr(HZ5,z);
phase=(180/pi)*angle(a)

%%
%zero order hold
num=[10 -9.082085];
den=[1 -0.082085];
zplane(num,den)
HZ6=tf(num,den);
a=evalfr(HZ6,z);
phase=(180/pi)*angle(a)

%%
%first order hold
num=[21.52247 -16.933];
den=[5 -0.410425];
zplane(num,den)
HZ7=tf(num,den);
a=evalfr(HZ7,z);
phase=(180/pi)*angle(a)

%%
T=0.25;
w=3;
snum=[1 1];
sden=[0.1 1];
[A,B,C,D]=tf2ss(snum,sden);
sysb=ss(A,B,C,D);%bilin

sysc=tf(snum,sden);%c2d

sys1=bilin(sysb,1,'FwdRec',T)
sys2=bilin(sysb,1,'BwdRec',T)
sys3=c2d(sysc,T,'tustin')
sys4=c2d(sysc,T,'prewarp',2*pi/w)
sys5=c2d(sysc,T,'matched')
sys6=c2d(sysc,T,'zoh')
sys7=c2d(sysc,T,'foh')

ww=logspace(-1,2,50);
bode(sys,sys1,sys2,sys3,sys4,sys5,sys6,sys7,ww);grid on;
legend('Continuous','Forward','Backward','Bilinear','Prewarp','Zero-Pole mapping','Zero order','First order','Location','SouthWest')
