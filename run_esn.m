x = [0.5];
step_size=0.1;
[output,states] = ff_step(x, states,step_size,layer_sizes, layersff, layersrcn);

output_series = zeros(layer_sizes(end),length(time)-1);
output_series_omega = zeros(layer_sizes(end),length(time)-1);
output_series_zeta = zeros(layer_sizes(end),length(time)-1);
%runge katta integration
for i=1:(length(time)-1)
    h = (time(i+1)-time(i))/1000;
    %meas = [temp(i),force(i),omega(i),zeta(i)]';
    meas = [temp(i)]';
    [output_k1,states_k1] = ff_step(meas,states, h, layer_sizes, layersff, layersrcn);
    [output_k2,states_k2] = ff_step(meas,states_k1, h/2, layer_sizes, layersff, layersrcn);
    [output_k3,states_k3] = ff_step(meas,states_k2, h/2, layer_sizes, layersff, layersrcn);
    [output_k4,states_k4] = ff_step(meas,states_k3, h, layer_sizes, layersff, layersrcn);
    %reconstruct the output and states
    output=(1/6)*(output_k1+2*output_k2+2*output_k3+output_k4);
    for j=1:length(states)
        states{j}=(1/6)*(states_k1{j}+2*states_k2{j}+2*states_k3{j}+states_k4{j});
    end
    output_series(:,i)=output(1:88);
    output_series_omega(:,i)=output*omega(i);
    output_series_zeta(:,i)=output*zeta(i);
end
clear i j output_k1 output_k2 output_k3 output_k4 states_k1 states_k2 states_k3 states_k4 h sizes;
output_series_concat=[output_series;output_series_omega];%;output_series_zeta];%(88+88+88)xlength


function [output,states] = ff_step(x,states, step_size, layer_sizes, layersff, layersrcn)
    %size(layersff{1})
    %size(layersrcn{1})
    states{1} = states{1}+step_size*(tanh(layersff{1}*x)-layersrcn{1}*states{1});
    for i=1:length(layer_sizes)-2
        states{i+1} = states{i+1}+step_size*(tanh(layersff{i+1}*states{i})-layersrcn{i+1}*states{i+1});
    end
    output = tanh(states{end});
end

