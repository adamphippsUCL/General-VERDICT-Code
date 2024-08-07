% Function to call MATLAB MLP networks
function x = callMLP(signals, modeltype, schemename, opts)


arguments
    
    signals % Input signals
    modeltype % Define model type
    schemename % Define scheme
    
    % Options

    opts.language = 'MATLAB'
    
    % Noise
    opts.noisetype = 'Rice'
    opts.sigma0train = 0.025 % 
    opts.T2train = 10000 % (ms) 


    % Folders
    opts.ModelFolder = 'C:\Users\adam\OneDrive - University College London\UCL PhD\PhD Year 1\Projects\Short VERDICT Project\Code\Short-VERDICT-Project\Model Fitting\MLP\MLP Models'


end


% Load MLP, scaling information, and meta data
folder = [char(opts.ModelFolder) '/' modeltype '/' schemename '/' opts.noisetype '/T2_' num2str(opts.T2train) '/sigma_' num2str(opts.sigma0train)];
load([folder '/Meta.mat']);
load([folder '/mlp.mat']);
load([folder '/paramscaling.mat']);
load([folder '/signalscaling.mat']);


% Apply scaling to signals
scaledsignals = apply_scaling(signals, signalscaling);

% Call MLP
pred = minibatchpredict(mlp, scaledsignals);

% Apply inverse scaling
x = apply_inv_scaling(pred, paramscaling);


end


% Min Max scaler function
function scaledData = apply_scaling(data, scaling)

    N = length(scaling);
    minVal = scaling(1:N/2);
    maxVal = scaling(N/2+1:end);
    % Scale the data to the range [0, 1]
    scaledData = (data - minVal) ./ (maxVal - minVal);
end


% Inverse Min Max scaler function
function data = apply_inv_scaling(Data, scaling)
    
    N = length(scaling);
    minVal = scaling(1:N/2);
    maxVal = scaling(N/2+1:end);  

    data = Data*(maxVal-minVal) + minVal;
end

