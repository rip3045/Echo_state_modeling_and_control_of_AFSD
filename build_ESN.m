%clearvars -except datalog; 
close all; clc;
rng(42)
%set up the echo state network construction, the construction is controlled
%entirely by the layer sizes vector
layer_sizes = [1,35,88];
%layer_sizes = [4,7,17];
%layer_sizes = [4,9];
states = {};
layersff = {};
layersrcn = {};
for i=1:(length(layer_sizes)-1)
    if i<length(layer_sizes)
        layersff{i}=normrnd(0,2,layer_sizes(i+1),layer_sizes(i));
        layersff{i}=layersff{i}/abs(max(svd(layersff{i})));
        states{i} = rand(layer_sizes(i+1),1);
        layersrcn{i} = rand(layer_sizes(i+1),layer_sizes(i+1))+8*eye(layer_sizes(i+1));
        %layersrcn{i} = 1*eye(layer_sizes(i+1));
        layersrcn{i} = layersrcn{i}/abs(max(eig(layersrcn{i})));
    end
end

%checking dimensions
%{
length(layersrcn)
length(layersff)
length(states)
%}
%try out the feedforward

%{
for i:length(time)-1
    h = time(i+1)-time(i-1);
    states = [temp(i),force(i),omega(i),zeta(i);
    k_1 = h*ff_step(x,state4s,layer_sizes, layersff, layersrcn)

%set up runge_katta
%}
