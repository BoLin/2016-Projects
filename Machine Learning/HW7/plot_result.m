%% ECE 593 HW7 Plotting Result
figure
plot(state_num,mean(meanloglik1,1),'-ro','MarkerSize',8,'LineWidth',2)
xlabel('Number of Hidden States');
ylabel('Average Validation Likelihood')
title('Process 1');
grid on;
box on;

figure
plot(state_num,mean(meanloglik2,1),'-bo','MarkerSize',8,'LineWidth',2)
xlabel('Number of Hidden States');
ylabel('Average Validation Likelihood')
title('Process 2');
grid on;
box on;

figure
plot(class,'o','MarkerSize',12,'linewidth',4)
ylim([0 3])
xlabel('Matrices Number');
ylabel('Process Number')
title('Classification of Process');