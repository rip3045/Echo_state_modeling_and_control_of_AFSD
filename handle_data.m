clearvars -except datalog data; close all; clc;
%convert
%datalog = table2array(datalog);
%trim the samples
%datalog = datalog(4668:11683,:)
%data=table2array(datalog);

%load in the variables
time = data(:,1);
temp = data(:,28);       %may need to be adjusted
force = data(:,10);
zeta = data(:,7);
max_zeta=max(zeta)
min_zeta=min(zeta)
omega = data(:,3);
max_omega=max(omega)
min_omega=min(omega)

%{
%compute the temp and force derivatives
temp_dot = zeros(length(temp)-1,1);
force_dot = zeros(length(force)-1,1);
for i=1:(length(temp)-1)
    temp_dot(i)=(temp(i+1)-temp(i))/(time(i+1)-time(i));
    force_dot(i)=(force(i+1)-force(i))/(time(i+1)-time(i));
end
%}
figure()
hold on
plot(time/1000,temp)
%polynomial fit
temp_fit=polyfit(time/1000,temp,12);
fitted_temp=polyval(temp_fit,time/1000);
max_temp=max(fitted_temp)
plot(time/1000,fitted_temp)

figure()
hold on
plot(time/1000,force)
force_fit=polyfit(time/1000,force,10);
fitted_force=polyval(force_fit,time/1000);
max_force=max(fitted_force)
plot(time/1000,fitted_force)
%{
temp_dot = zeros(length(temp)-1,1);
force_dot = zeros(length(force)-1,1);
for i=1:(length(temp)-1)
    temp_dot(i)=(temp(i+1)-temp(i))/(time(i+1)-time(i));
    if temp_dot(i)==0 && i>1
        temp_dot(i)=temp_dot(i-1);
    end
    force_dot(i)=(force(i+1)-force(i))/(time(i+1)-time(i));
end
%}
temp_dot = zeros(length(temp)-1,1);
temp_vals=[0];
temp_indices=[1];
force_dot = zeros(length(force)-1,1);
for i=1:(length(temp)-1)
    temp_dot(i)=(temp(i+1)-temp(i))/(time(i+1)-time(i));
    if temp_dot(i)~=0 && i>1
        temp_vals=[temp_vals,temp_dot(i)];
        temp_indices=[temp_indices,i];
    end
    force_dot(i)=(force(i+1)-force(i))/(time(i+1)-time(i));
end
temp_vals=[temp_vals,0];
temp_indices=[temp_indices,length(temp_dot)];
count=1;
for i=1:(length(temp)-1)
    temp_dot(i)=(temp(i+1)-temp(i))/(time(i+1)-time(i));
    if temp_dot(i)==0 
       temp_dot(i)=temp_vals(count)+((temp_vals(count+1)-temp_vals(count))*(i-temp_indices(count))/ (temp_indices(count+1)-temp_indices(count)));
    else
        count=count+1;
    end
end

figure()
plot(time/1000,omega)
title('omega')

figure()
plot(time/1000,zeta)
title('zeta')
%filtering
temp_filt_c = 100;
temp_filt = (1/temp_filt_c)*ones(1,temp_filt_c);
force_filt_c = 100;
force_filt = (1/force_filt_c)*ones(1,force_filt_c);
temp_dot = filter(temp_filt,1,temp_dot);
force_dot=filter(force_filt,1,force_dot);

%temp_dot=smoothdata(temp_dot);
%normalize input data
temp = temp-420;
temp = 2*temp/(460-380);
force = force-550;
force = 2*force/(700-400);
%{
omega = omega-225;
omega = 2*omega/(400-150);
zeta = zeta-1.75;
zeta = 2*zeta/3.5;
%}


%{
figure()
plot(temp_dot)
figure()
plot(force_dot)
%}
