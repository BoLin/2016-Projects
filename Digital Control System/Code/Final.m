%ECE579FINAL
%a)Parameters
T=0.2;
M=20;
m=1;
k=25;
b=0.2;
% System state-space representation
f=[0 1; 0 0];
g=[0;1/(M+m)];
h=[1 0];
j=0;

% Discrete equivalent (ZOH)
[phi,gam]=c2d(f,g,T);

% Control law design with desired poles 
zd1=[.75+i*.2;.75-i*.2];
zd = zd1';
K=acker(phi,gam,zd1);

% Estimator design with desired poles 
zd2=[.3+i*.3;.3-i*.3];
zd = zd2'
lt=acker(phi',h',zd2);
lp=lt'
L=lp;
%plot step response(close loop)
A=phi;
B=gam;
C=h;
D=j;
Nbar=53.85;
Cc=C;

Ace = [(A-B*K) (B*K);
       zeros(size(A)) (A-L*C)];
Bce = [B*Nbar;
       zeros(size(B))];
Cce = [Cc zeros(size(Cc))];
Dce = [0];
sys_est_cl = ss(Ace,Bce,Cce,Dce,T);
t = 0:0.2:10;
r =ones(size(t));
[y,t,x]=lsim(sys_est_cl,r,t);
plot(t,y);grid on
title('Rigid System with Controller Step Response')
xlabel('Time (sec)')
ylabel('Position (m)')
%%
%part b
Ab=[0 0 1 0;0 0 0 1;-k/M k/M b/M 0;k/m -k/m b/m -b/m]
Bb=[0;0;1/M;0]
Hb=[0 1 0 0]
[phib,gamb]=c2d(Ab,Bb,T);
Kd=[0 K(1) 0  K(2)];
lp=[0;L(1);0;L(2)];
[Nx,Nu,Nbar] = refi(phib,gamb,Hb,Kd)%
%Nbar=53;
gk=gamb*Kd;
lph=lp*Hb; 
phic=[phib -gk;          % x(k+1)=phi*x(k)-gk*xbar(k)   
      lph phib-gk-lph];  % xbar(k+1)=lph*x(k)+(phi-gk-lph)*xbar(k) 
z=eig(phic);
zcl = z'
hec=[Hb 0 0 0 0;          
     0 0 0 0 0 -K(1) 0 -K(2)];           
d=[0;Nbar];
n=51;
gnb=gamb*Nbar;
B=[gnb;gnb];
[y,x]=dstep(phic,B,hec,d,1,n);

% Performance evaluation of step response
out=y(:,1);%output is d
u=y(:,2);
t=0:T:(n-1)*T;
plot(t,x(:,2),'-o'),grid on
ylabel('OUTPUTS')
xlabel('Time (sec)')
title('Part b Step response')
plot(t,out,'-o'),grid on



%%
%part c
Ab=[0 0 1 0;0 0 0 1;-k/M k/M b/M 0;k/m -k/m b/m -b/m]
Bb=[0;0;1/M;0]
Hc=[1 0 0 0]
[phib,gamb]=c2d(Ab,Bb,T);

Kd=[K(1) 0  K(2) 0];
lp=[L(1);0;L(2);0];
[Nx,Nu,Nbar] = refi(phib,gamb,Hc,Kd)%
%Nbar=53.8125;
gk=gamb*Kd;
lph=lp*Hc; 
phic=[phib -gk;          % x(k+1)=phi*x(k)-gk*xbar(k)   
      lph phib-gk-lph];  % xbar(k+1)=lph*x(k)+(phi-gk-lph)*xbar(k) 
z=eig(phic);
zcl = z'
hec=[Hc 0 0 0 0;          
     0 0 0 0 -K(1) 0 -K(2) 0];           
d=[0;Nbar];
n=51;
gnb=gamb*Nbar;
B=[gnb;gnb];
[y,x]=dstep(phic,B,hec,d,1,n);

% Performance evaluation of step response
e=y(:,1);
u=y(:,2);
t=0:T:(n-1)*T;
plot(t,x(:,1),'-o'),grid on

ylabel('OUTPUTS')
xlabel('Time (sec)')
title('Part c Step response')

%%
%part d
Hd=[1 0 0 0;0 0 1 0]
z=eig(phib-gamb*K*Hd)

%%
%part e

% State space matrices
T=0.2;
M=20;
m=1;
k=25;
b=0.2;
Ab=[0 0 1 0;0 0 0 1;-k/M k/M b/M 0;k/m -k/m b/m -b/m]
Bb=[0;0;1/M;0]
h=[0 1 0 0];
j=0;

% Discrete equivalent matrices 
[phib,gamb]=c2d(Ab,Bb,T);

% Control law design with desired poles
zd1=[.75+i*.2;.75-i*.2;0.4+i*0.6;0.4-i*0.6];
k=acker(phib,gamb,zd1')
z=eig(phib-gamb*k)		% show desired poles obtained

% Estimator design with desired poles
zd2=[.3+i*.3;.3-i*.3;0+i*.4;0-i*.4];
lt=acker(phib',h',zd2);
lp=lt'
z=eig(phib-lp*h)		    % show desired poles obtained

% Combined control and estimation state-space equations
%-------------------------------------------------------
[Nx,Nu,Nbar] = refi(phib,gamb,h,k)
%Nbar=41;
gk=gamb*k;
lph=lp*h; 
phic=[phib -gk;          % x(k+1)=phi*x(k)-gk*xbar(k)   
      lph phib-gk-lph];  % xbar(k+1)=lph*x(k)+(phi-gk-lph)*xbar(k) 
z=eig(phic);
zcl = z'
hec=[h 0 0 0 0;          
     0 0 0 0 -k];           
d=[0;Nbar];
n=51;
gnb=gamb*Nbar;
B=[gnb;gnb];
[y,x]=dstep(phic,B,hec,d,1,n);
%x is the states and estimated states

% Performance evaluation of step response
out=y(:,1);%system output
u=y(:,2);%system control
t=0:T:(n-1)*T;
plot(t,x(:,2),'-o',t,out,'g-*'),grid
axis([0 10 -0.5 1.5])
ylabel('OUTPUTS')
xlabel('Time (sec)')
title('Part e Step response')
text(1,0,'--o---  d')
text(1,-0.25,'--*---  y ')
%text(2.1,-3.75,'--x---  X2')
plot(t,u,'-o'),grid% control signal
ylabel('Control')
xlabel('Time (sec)')
title('Part e Step response')


%%
%part f
Af=phib-gamb*k-lp*h;
Bf=lp;
Cf=-k;
Df=0;
w=logspace(-4,1)
bode(ss(Af,Bf,Cf,Df,T))
grid on
%%
%part g
hec1=[h 0 0 0 0];           
d1=[0];
gnb=gamb*Nbar;
B=[gnb;0;0;0;0];
zgrid on
rlocus(ss(phic,B,hec1,d1))%close loop
%over all system root locus
SS1=ss(phib,gamb,h,j,T);
SS2=ss(Af,Bf,Cf,Df,T)
SSS=SS1*SS2%open loop
zgrid on
rlocus(SSS)

%transfer state space to transfer function for recheck
[Q,W,E,R]=ssdata(SSS)
[NUM,DEN]=ss2tf(Q,W,E,R)
SYS=tf(NUM,DEN)
rlocus(SYS)