%ECE593 HW2 Bo Lin
%Press "run" 
%For running the HW2 code, just input training set and testing set size%
%result is shown in command window



clc
prompt='Training set data size [50~500] =';
N=input(prompt); 
prompt='Testing set data size [50~500] =';
C=input(prompt);   % no. of check data points
clc
fprintf('--------------Raw Data Information-------------------\n');
fprintf('|             Total Data Point = %g                |\n',N+C);%G1 error
fprintf('|        Training Datset Ratio = %g percent         |\n',100*N/(N+C));%G2 error
fprintf('-----------------------------------------------------\n');


%%
f1=figure(1);
movegui(f1,'northeast')
figure(1)
xa=2; xb=4; ya=1; yb=3;         % coordinates of the rectangle C
hold on;
plot([xa xb xb xa xa],[ya ya yb yb ya],'-');    % draw it
ds=zeros(N,2); ls=zeros(N,1);       % labels
for i=1:N
x=rand(1,1)*5; y=rand(1,1)*5;
ds(i,1)=x; ds(i,2)=y;
% +ve if falls in the rectangle, -ve otherwise
if ((x > xa) && (y > ya) && (y < yb) && ( x < xb)) ls(i)=1;%inside rec
else ls(i)=0; end;
if (ls (i)==1) plot(x,y,'+'); else plot(x,y,'go'); end;
end;
%%
%initial Hypothesis class H
% to get the Specific boundary
hxas=5; hxbs=0; hyas=5; hybs=0;         % coordinates of the rectangle C
for i=1:N
if ((ds(i,1) > xa) && (ds(i,2) > ya) && (ds(i,2)< yb) && ( ds(i,1) < xb)) %inside rec
  hxas=min([hxas ds(i,1)]);
  hxbs=max([hxbs ds(i,1)]);
  hyas=min([hyas ds(i,2)]);
  hybs=max([hybs ds(i,2)]);
end
end;
% hold on;
% plot([hxas hxbs hxbs hxas hxas],[hyas hyas hybs hybs hyas],'--r');    % draw S

%%
%to get the General boundary
hxag=0; hxbg=5; hyag=0; hybg=5;  
for i=1:N
    
if ((ds(i,1) < hxas)&& (ds(i,2) > hyas) && (ds(i,2) < hybs) )%first extend in one direction
    hxag=max([ds(i,1) hxag]);
end
if ((ds(i,1) > hxbs)&& (ds(i,2) > hyas) && (ds(i,2) < hybs) )
    hxbg=min([ds(i,1) hxbg]);
end

end
for i=1:N
    
if ((ds(i,2) < hyas)&& (ds(i,1) > hxag) && (ds(i,1) < hxbg) )
    hyag=max([ds(i,2) hyag]);
end

if ((ds(i,2) > hybs)&& (ds(i,1) > hxag) && (ds(i,1) < hxbg) )
    hybg=min([ds(i,2) hybg]);
end
end

hold on;
rectangle('Position',[hxag,hyag,hxbg-hxag,hybg-hyag],'FaceColor',[1 1 0],'EdgeColor','k','LineStyle','--')
%plot([hxag hxbg hxbg hxag hxag],[hyag hyag hybg hybg hyag],'--k');    % draw G
rectangle('Position',[hxas,hyas,hxbs-hxas,hybs-hyas],'FaceColor',[1 1 1],'EdgeColor','r','LineStyle','--')
plot([xa xb xb xa xa],[ya ya yb yb ya],'-');    % draw it
for i=1:N
x=ds(i,1); y=ds(i,2);
if (ls (i)==1) 
    plot(x,y,'+');
else
    plot(x,y,'go');
end;
end;
str1=sprintf('S,G(1) and VersionSpace @%d data points',N);
title(str1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%another G hypothesis


    %plot([hxas hxbs hxbs hxas hxas],[hyas hyas hybs hybs hyas],'--r');    % draw S

    hxag2=0; hxbg2=5; hyag2=0; hybg2=5;  
    for i=1:N
    
        if ((ds(i,2) < hyas)&& (ds(i,1) > hxas) && (ds(i,1) < hxbs) )
    hyag2=max([ds(i,2) hyag2]);
        end
     if ((ds(i,2) > hybs)&& (ds(i,1) > hxas) && (ds(i,1) < hxbs) )
    hybg2=min([ds(i,2) hybg2]);
        end
    end

    for i=1:N
    
    if ((ds(i,1) < hxas)&& (ds(i,2) > hyag2) && (ds(i,2) < hybg2) )%first extend in one direction
    hxag2=max([ds(i,1) hxag2]);
    end
	if ((ds(i,1) > hxbs)&& (ds(i,2) > hyag2) && (ds(i,2) < hybg2) )
    hxbg2=min([ds(i,1) hxbg2]);
    end

    end
    
 if ((hxag2~=hxag)||(hxbg2~=hxbg)||(hyag2~=hyag)||(hybg2~=hybg))

    f2=figure(2);
    movegui(f2,'northwest')
    hold on

% plot([hxag2 hxbg2 hxbg2 hxag2 hxag2],[hyag2 hyag2 hybg2 hybg2 hyag2],':m');    % draw G
rectangle('Position',[hxag2,hyag2,hxbg2-hxag2,hybg2-hyag2],'FaceColor',[1 1 0],'EdgeColor','k','LineStyle','--')
rectangle('Position',[hxas,hyas,hxbs-hxas,hybs-hyas],'FaceColor',[1 1 1],'EdgeColor','r','LineStyle','--')
plot([xa xb xb xa xa],[ya ya yb yb ya],'-');    % draw it

for i=1:N
x=ds(i,1); y=ds(i,2);
if (ls (i)==1) 
    plot(x,y,'+');
else
    plot(x,y,'go');
end;
end;
str2=sprintf('S,G(2) and VersionSpace @%d data points',N);
title(str2)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Validation:
figure(3)
dt=zeros(C,2); lt=zeros(C,1);       % labels

error1=0;%error for g1
error2=0;%error for g2
error3=0;%error for s
hold on
for i=1:C
x=rand(1,1)*5; y=rand(1,1)*5;
dt(i,1)=x; dt(i,2)=y;

if ((x > xa) && (y > ya) && (y < yb) && ( x < xb)) 
    lt(i)=1;%inside rec
    if ((x < hxas) && (y < hyas) && (y > hybs) && ( x > hxbs))
        error3=error3+1;
    end
    
else % ourside rec
    lt(i)=0; 
   if ((x > hxag) && (y > hyag) && (y < hybg) && ( x < hxbg)) %inside g1
       error1=error1+1;
        plot(x,y,'r*'); 
   end
   
  if ((x > hxag2) && (y > hyag2) && (y < hybg2) && ( x < hxbg2)) %inside g2
       error2=error2+1;
       plot(x,y,'c*'); 
   end
   
end;
if (lt (i)==1)
    plot(x,y,'+'); 
else
    plot(x,y,'go'); 
end;


end;
plot([xa xb xb xa xa],[ya ya yb yb ya],'-');    % draw it
rectangle('Position',[hxag2,hyag2,hxbg2-hxag2,hybg2-hyag2],'EdgeColor','k','LineStyle','--')
rectangle('Position',[hxag,hyag,hxbg-hxag,hybg-hyag],'EdgeColor','k','LineStyle','--')
rectangle('Position',[hxas,hyas,hxbs-hxas,hybs-hyas],'EdgeColor','r','LineStyle','--')
str3=sprintf('S,G1,G2 and VersionSpace @%d data points test',C);
title(str3)

fprintf('---------------------Result of %g Data---------------------\n',N+C);
fprintf('|            Empirical Error of G1 = %g                   |\n',error1);%G1 error
fprintf('|            Empirical Error of G2 = %g                   |\n',error2);%G2 error
fprintf('|            Empirical Error of S = %g                    |\n',error3);%G2 error
fprintf('-----------------------------------------------------------\n');
