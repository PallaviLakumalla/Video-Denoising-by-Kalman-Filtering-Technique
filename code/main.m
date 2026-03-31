clc; clear; close all;

%% PARAMETERS
noiseDensity   = 0.1;
displayFrames  = true;
saveOutput     = true;
outputFileName = 'combined_denoised_output.avi';

%% LOAD VIDEO
try
    vid = VideoReader('moon.avi');
catch
    error('moon.avi not found in current folder.');
end

totalFrames = vid.NumFrames;
prompt = sprintf('Enter number of frames to process (max: %d): ', totalFrames);
numFrames = input(prompt);

if numFrames < 1 || numFrames > totalFrames
    error('Frame count must be between 1 and %d.', totalFrames);
end

frameHeight = vid.Height;
frameWidth  = vid.Width;
frameRate   = vid.FrameRate;

%% STORAGE
origVideo     = zeros(frameHeight, frameWidth, 3, numFrames);
noisyVideo    = zeros(frameHeight, frameWidth, 3, numFrames);
wienerVideo   = zeros(frameHeight, frameWidth, 3, numFrames);
kalmanVideo   = zeros(frameHeight, frameWidth, 3, numFrames);
P             = repmat(10, frameHeight, frameWidth, 3);

psnr_vals = zeros(numFrames, 4); % [Original, Noisy, Wiener, Kalman]
ssim_vals = zeros(numFrames, 4);
mse_vals  = zeros(numFrames, 4);

% Kalman parameters
Q = 5;   % Process noise
R = 10;  % Measurement noise

%% VIDEO WRITER
if saveOutput
    writer = VideoWriter(outputFileName, 'Motion JPEG AVI');
    writer.FrameRate = frameRate;
    open(writer);
end

%% MAIN LOOP
for k = 1:numFrames
    orig  = im2double(read(vid, k));
    noisy = imnoise(orig, 'salt & pepper', noiseDensity);

    origVideo(:,:,:,k)  = orig;
    noisyVideo(:,:,:,k) = noisy;

    % Wiener Filter
    wienerDenoised = zeros(size(orig));
    for c = 1:3
        wienerDenoised(:,:,c) = wiener2(noisy(:,:,c), [5 5]);
    end
    wienerVideo(:,:,:,k) = wienerDenoised;

    % Kalman Filter
    if k == 1
        % Use Wiener as initial state
        kalmanVideo(:,:,:,k) = wienerDenoised;
    else
        for c = 1:3
            X_prev  = kalmanVideo(:,:,c,k-1);
            Y_noisy = medfilt2(noisy(:,:,c), [3 3]);  % smoothed measurement
            P_prev  = P(:,:,c);

            K = P_prev ./ (P_prev + R);   % Kalman gain
            X_new = X_prev + K .* (Y_noisy - X_prev);

            kalmanVideo(:,:,c,k) = X_new;
            P(:,:,c) = (1 - K) .* P_prev + Q;
        end
    end

    % METRICS
    psnr_vals(k,1) = psnr(orig, orig);
    psnr_vals(k,2) = psnr(noisy, orig);
    psnr_vals(k,3) = psnr(wienerDenoised, orig);
    psnr_vals(k,4) = psnr(kalmanVideo(:,:,:,k), orig);

    ssim_vals(k,1) = ssim(orig, orig);
    ssim_vals(k,2) = ssim(noisy, orig);
    ssim_vals(k,3) = ssim(wienerDenoised, orig);
    ssim_vals(k,4) = ssim(kalmanVideo(:,:,:,k), orig);

    mse_vals(k,1) = immse(orig, orig);
    mse_vals(k,2) = immse(noisy, orig);
    mse_vals(k,3) = immse(wienerDenoised, orig);
    mse_vals(k,4) = immse(kalmanVideo(:,:,:,k), orig);

    % DISPLAY
    if displayFrames
        figure(1); clf;
        subplot(2,2,1); imshow(orig); title(sprintf('Original Frame %d', k));
        subplot(2,2,2); imshow(noisy); title(sprintf('Noisy Frame %d', k));
        subplot(2,2,3); imshow(wienerDenoised); title(sprintf('Wiener Output %d' ,k));
        subplot(2,2,4); imshow(kalmanVideo(:,:,:,k)); title(sprintf('Kalman Output %d',k));
        sgtitle(sprintf('Frame %d\nWiener → PSNR: %.2f | SSIM: %.4f | MSE: %.5f\nKalman → PSNR: %.2f | SSIM: %.4f | MSE: %.5f', ...
            k, psnr_vals(k,3), ssim_vals(k,3), mse_vals(k,3), ...
            psnr_vals(k,4), ssim_vals(k,4), mse_vals(k,4)), 'FontWeight', 'bold');
        pause(0.1);
    end

    if saveOutput
        frameOut = insertText(im2uint8(kalmanVideo(:,:,:,k)), [10 10], ...
            sprintf('Frame %d | Kalman PSNR: %.2f | SSIM: %.2f', ...
            k, psnr_vals(k,4), ssim_vals(k,4)), 'FontSize', 16, ...
            'BoxColor', 'black', 'TextColor', 'white', 'BoxOpacity', 0.6);
        writeVideo(writer, frameOut);
    end
end

if saveOutput
    close(writer);
    fprintf(' Video saved as "%s"\n', outputFileName);
end

%% CONSOLE PERFORMANCE REPORT

%% Kalman
avg_psnr_kalman = mean(psnr_vals(:,4));
avg_ssim_kalman = mean(ssim_vals(:,4));
avg_mse_kalman  = mean(mse_vals(:,4));

fprintf('\n====== Kalman vs Original (Input Video) Metrics ======\n');
fprintf('Average PSNR : %.4f dB\n', avg_psnr_kalman);
fprintf('Average SSIM : %.4f\n', avg_ssim_kalman);
fprintf('Average MSE  : %.6f\n', avg_mse_kalman);
fprintf('======================================================\n');

%% Wiener
avg_psnr_wiener = mean(psnr_vals(:,3));
avg_ssim_wiener = mean(ssim_vals(:,3));
avg_mse_wiener  = mean(mse_vals(:,3));

fprintf('\n====== Wiener vs Original (Input Video) Metrics ======\n');
fprintf('Average PSNR : %.4f dB\n', avg_psnr_wiener);
fprintf('Average SSIM : %.4f\n', avg_ssim_wiener);
fprintf('Average MSE  : %.6f\n', avg_mse_wiener);
fprintf('======================================================\n');
