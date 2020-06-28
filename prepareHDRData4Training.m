function [normalization_param] = prepareHDRData4Training(input_dir, output_dir, new_min, new_max)
%% This function prepares the HDR dataset for training. 

% preparation requires the conversion of HDR images to EXR images and
% calculating the mean of the whole dataset divided by the standard
% deviation of the whole dataset

    filelist = dir(fullfile(input_dir, '*.hdr'));
    
    parfor i = 1 : numel(filelist)
        filename = filelist(i).name;
        
        hdr = hdrread(fullfile(filelist(i).folder, filelist(i).name));
        hdr = ClampImg(hdr, 1e-6, 1);
        
        % scale the HDR image for data augmentation
        current_min = min(hdr(:));
        current_max = max(hdr(:));
        hdr_scaled =double(((hdr-current_min)*(new_max-new_min))/(current_max-current_min) + new_min);
        
        % calculate mean and standard deviation of each image
        s = calculateNormParameters(hdr_scaled);
        norm_array(i) = s;
        % write output to output directory
        [name, ~] = split(filename, '.');
        [basename, ~] = split(name{1}, '_prediction');
        exrwrite(hdr_scaled, fullfile(output_dir, [basename{1} '.exr']));
        fprintf('\n File %s written to disk', [basename{1} '.exr']);                
    end
    
    % this is a really crappy code but who cares as long as it does what is
    % supposed to do
    md = mean([norm_array.meanIMG]);
    sd = mean([norm_array.stdIMG]);
%     mr = mean([norm_array.meanR]);
%     mg = mean([norm_array.meanG]);
%     mb = mean([norm_array.meanB]);
%     
%     sdr = mean([norm_array.stdR]);
%     sdg = mean([norm_array.stdG]);
%     sdb = mean([norm_array.stdB]);
    normalization_param = [md/sd];
%     normalization_param = [mr/sdr, mg/sdg, mb/sdb];    
    
end

function s = calculateNormParameters(hdr)
%% This function obtains the mean and standard deviation of each channel

    s.meanIMG = mean(hdr(:)); 
    s.stdIMG = std(hdr(:));
    
%     s.meanR = meanIMG(1);
%     s.meanG = meanIMG(2);
%     s.meanB = meanIMG(3);
%     
%     s.stdR = stdIMG(1);
%     s.stdG = stdIMG(2);
%     s.stdB = stdIMG(3);
end