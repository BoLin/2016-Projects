%%
%problem 1
clear; close;
a=7;
h=3;
num=[1 a+5/h 75/h]; den=[1 21 95 75 0];
H=tf(num,den);
rlocus(num,den); 
Zeta =0.36;
Wn = 4;
sgrid(Zeta,Wn)

%axis([-3 1 -2 2]);
A2=25.8823;
Ah=h;
b=15;
%%%%%%%%%%%%%%%%
a=7;
h=3;
c=0.02;
num=[1 a]; den=[1 21 95 75];
H=tf(num,den);
rlocus(num,den); 
%%%%%%%%%%%%%%%%%%%%%

%%
%problem 2
%%old k=1
clear; close all;
% System open-loop transfer function
K=1;
numG=[K]; 
denG=[0.002 0.05 0.4 1 0]
sys=tf(numG,denG);
%Bode plot
opts = bodeoptions
opts.YLim = {[-10,200];[-360,0]}; %{maglimits;phaselimits}
opts.YLimMode = {'auto';'auto'};
opts.XLim = {[0.01 1000]}; %{maglimits;phaselimits}
opts.XLimMode = {'manual'};
h = bodeplot(sys,opts);grid on;
%bode(sys); grid on;
%axis([-50 50 -181 0]);



%%
%new K
clear; close all;
% System open-loop transfer function
K=2.278;
numG=[K]; 
denG=[0.002 0.05 0.4 1 0]
sys=tf(numG,denG);
%Bode plot
opts = bodeoptions
opts.YLim = {[-10,200];[-360,0]}; %{maglimits;phaselimits}
opts.YLimMode = {'auto';'auto'};
opts.XLim = {[0.01 1000]}; %{maglimits;phaselimits}
opts.XLimMode = {'manual'};
h = bodeplot(sys,opts);grid on;
%bode(sys); grid on;
%axis([-50 50 -181 0]);

%%
%lead compensator
clear; close all;
% System open-loop transfer function
K=5.085;
numG=K*[1 1.876]; 
denG=[0.002 0.057374 0.584356 2.474848 3.68712 0]
sys=tf(numG,denG);
%Bode plot
opts = bodeoptions
opts.YLim = {[-10,200];[-360,0]}; %{maglimits;phaselimits}
opts.YLimMode = {'auto';'auto'};
opts.XLim = {[0.1 100]}; %{maglimits;phaselimits}
opts.XLimMode = {'manual'};
h = bodeplot(sys,opts);grid on;
%bode(sys); grid on;
%axis([-50 50 -181 0]);
numG=[1 1.876]; 
denG=[0.002 0.057374 0.584356 2.474848 3.68712 0]
sys=tf(numG,denG);
rlocus(sys);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%problem 3
numG=[1]; 
denG=[1 0 0]
sys=tf(numG,denG);
bode(sys); grid on;

numG=[1.9437 1]; 
denG=[0.13956 1 0 0]
sys=tf(numG,denG);
bode(sys); grid on;
%2
s=tf('s');
T=0.2;
G=1/s^2;
C=2.5*(1.9437*s+1)/(0.13956*s+1);
H=exp(-T/2*s);
bode(G*H);grid on;


