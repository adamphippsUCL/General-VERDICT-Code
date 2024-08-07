function [dist, signals] = RiceDist(A0, Ab, sigma0, opts)

arguments
    A0 % b=0 mean signal
    Ab % b\=0 mean signal
    sigma0 % Noise standard deviation at TE=0

    % options

    opts.Nav_ratio = 1 % Ratio of signal averages between b\=0 and b=0

    % Range/Resolution of output pdf
    opts.zmin = 0
    opts.zmax = 2
    opts.dz = 0.005
end


% Define sigma
% sigma = sigma0*sqrt(1/(opts.Nav_ratio) + 1);
sigma=sigma0;

% Define mean
mu = Ab/A0;

% Check mu and sigma >0
if ~and(isscalar(mu), mu>0)
    mu=0;
end
if ~and(isscalar(sigma), sigma>0)
    sigma = 0;
end

% Make distribution
Dist = makedist('Rician', s=mu, sigma = sigma );

% Evaluate pdf at signals
N = ceil(((opts.zmax-opts.zmin)/opts.dz));
signals = linspace(opts.zmin, opts.zmax, N);
dist = Dist.pdf(signals);


end