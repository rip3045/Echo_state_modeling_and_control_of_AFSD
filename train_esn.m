%this program takes the output series data and separates it from training,
%as different damping parameters can be used
clc;close all;
beta=0.01;
%output_series_concat=[output_series;output_series_omega;output_series_zeta];%(88+88+88)xlength
output_series_concat=[output_series_concatt2,output_series_concatt3,output_series_concatt4,output_series_concatt5,...
    output_series_concatt6,output_series_concatt7,output_series_concatt8,output_series_concatt9,output_series_concatt10];
sizes = size(output_series_concat);
%y_target=[temp_dot,force_dot]';
y_target=[temp_dott2;temp_dott3;temp_dott4;temp_dott5;temp_dott6;temp_dott7;temp_dott8;temp_dott9;temp_dott10]';
%size(output_series*output_series');
W_out=y_target*output_series_concat'*((output_series_concat*output_series_concat'+beta*eye(sizes(1)))^-1);

%validate
prediction = W_out*output_series_concatt1;
time=timet1;
temp_dot=temp_dott1;
figure()
hold on
set(gca,'fontname','times')
set(gca,'XMinorTick','on','YMinorTick','on')
plot(time(1:length(time)-1)/1000,temp_dot)
plot(time(1:length(time)-1)/1000,prediction(1,:))
xlabel('Time,t (sec)')
ylabel('$\dot{T}$ ($^{\circ}$C/sec)', 'Interpreter','latex')
legend('$\dot{T}$ data', '$\dot{T}$ ESN','Interpreter','latex')
%{
figure()
hold on
set(gca,'fontname','times')
plot(time(1:length(time)-1)/1000,force_dot)
plot(time(1:length(time)-1)/1000,prediction(2,:))
xlabel('time(sec)')
ylabel('$\dot{F}$ (lbf/sec)', 'Interpreter','latex')
legend('$\dot{F}$ data', '$\dot{F}$ ESN','Interpreter','latex')
%}
%RMSE temp
err_temp = abs(temp_dot-prediction(1,:)');
figure()
plot(time(1:length(time)-1)/1000,err_temp)
xlabel('Time,t (sec)')
ylabel('$\dot{T}$ Error ($^{\circ}$C/sec)', 'Interpreter','latex')
set(gca,'fontname','times')
set(gca,'XMinorTick','on','YMinorTick','on')
rmse_temp = sqrt(mean(err_temp).^2)
max_err_temp=max(abs(err_temp))
%{
%rmse force
err_force = abs(force_dot-prediction(2,:)');
figure()
plot(time(1:length(time)-1)/1000,err_force)
rmse_force = sqrt(mean(err_force).^2)
max_err_force=max(abs(err_force))

figure()
subplot(2,1,1)
hold on
grid on
set(gca,'fontname','times')
plot(time(1:length(time)-1)/1000,temp_dot)
plot(time(1:length(time)-1)/1000,prediction(1,:))
xlabel('time (sec)')
ylabel('$\dot{T}$ ($^{\circ}$C/sec)', 'Interpreter','latex')
legend('$\dot{T}$ data', '$\dot{T}$ ESN','Interpreter','latex')

subplot(2,1,2)
hold on
set(gca,'fontname','times')
grid on
plot(time(1:length(time)-1)/1000,force_dot)
plot(time(1:length(time)-1)/1000,prediction(2,:))
xlabel('time (sec)')
ylabel('$\dot{F}$ (lbf/sec)', 'Interpreter','latex')
legend('$\dot{F}$ data', '$\dot{F}$ ESN','Interpreter','latex')

figure()
subplot(2,1,1)
hold on
grid on
set(gca,'fontname','times')
plot(time(1:length(time)-1)/1000,err_temp)
xlabel('time (sec)')
ylabel('$\dot{T}$ Error ($^{\circ}$C/sec)', 'Interpreter','latex')

subplot(2,1,2)
hold on
set(gca,'fontname','times')
grid on
plot(time(1:length(time)-1)/1000,err_force)
xlabel('time (sec)')
ylabel('$\dot{F}$ Error (lbf/sec)', 'Interpreter','latex')
%}


