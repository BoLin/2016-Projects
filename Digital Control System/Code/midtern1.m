s=tf('s');
a=5;
b=30;
Ah=10;
A2=80;
H=A2*(1.7/((1+.2*s)*(1+s)))*1/s*(1+0.2*Ah*(s+a)/(s+b)*s);
rlocus(H)