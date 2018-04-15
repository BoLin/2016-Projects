%%
%HW1 MIT Assignment 2

%1 Semilog plot
f=figure(1)
movegui(f,'northwest')
number=[15 25 55 115 144]
semilogy(1:5,number,'ms','LineWidth',4,'MarkerSize',10)
xlabel('year')
ylabel('number')
xlim([0 6])
title('Semilog plot')



pause
%3 Bar graph
f=figure(2)
movegui(f,'north')
bar(rand(1,5),'r')
title('Bar Graph of 5 Random Values')

%4 Interpolation and surface plots
%randomSurface.m here
pause
f=figure(3)
movegui(f,'southwest')
Z0=rand(5,5)% on the open interval(0,1) not [0,1]

Z0=(2*eps).*round(rand(5)./(2*eps))% Matlab actually generates random numbers on the closed interval, [2^(-53), 1-2^(-53)],this should contain [0,1]
X0=1:5
Y0=1:5
[X,Y]=meshgrid(X0,Y0)
Z=Z0(X0,Y0)
surf(X,Y,Z)

pause%for smoother surface
f=figure(4)
movegui(f,'south')
X1=1:.1:5
Y1=1:.1:5
[X,Y]=meshgrid(X1,Y1)
Z=interp2(X0,Y0,Z0,X,Y,'cubic')
surf(X,Y,Z)
colormap('hsv')
shading interp
colorbar
caxis([0 1])
title('Interpolation and surface plots')


