function resizeIMDB(ldr_input_path, hdr_input_path, hdr_output_path)
%% Function required to resize predicted HDRs based on original LDRs
% Author: Ratnajit Mukherjee, INESCTEC, Portugal, 2018
% Project: HDR4TT, ONR, London

%% Main body of the function

    directoryCheck(ldr_input_path, hdr_input_path, hdr_output_path);

    ldr_filelist = dir(fullfile(ldr_input_path, '*.jpg'));
    hdr_filelist = dir(fullfile(hdr_input_path, '*.exr'));
    
    fprintf('\n Starting to resize... \n');
    
    parfor i = 1 : numel(ldr_filelist)
        % read both ldr and hdr images
        ldr = imread(fullfile(ldr_filelist(i).folder, ldr_filelist(i).name));
        hdr = exrread(fullfile(hdr_filelist(i).folder, hdr_filelist(i).name));
        
        % resize hdr image based on the ldr image and clamp it to [0, 1]
        % range
        hdr_res = imresize(hdr, [size(ldr, 1) size(ldr, 2)], 'bicubic');
        hdr_res = ClampImg(hdr_res, 1e-6, 1);
        
        % write out the hdr image
        exrwrite(hdr_res, fullfile(hdr_output_path, hdr_filelist(i).name));
        
        % print the status
        fprintf('\n Writing file: %s to %s', hdr_filelist(i).name, hdr_output_path);
    end
    
    fprintf('Resize complete and all files dumped to output folder');
end

function directoryCheck(ldr_input_path, hdr_input_path, hdr_output_path)
%% This functions checks whether all directories are in place.    
    if ~exist(ldr_input_path, 'dir')        
        error('\n Directory does not exist. Please re-check the inputs');
    else
        fprintf('\n LDR input directory exists');
    end
    
    if ~exist(hdr_input_path, 'dir')        
        error('\n Directory does not exist. Please re-check the inputs');
    else
        fprintf('\n HDR input directory exists');
    end
    
    if ~exist(hdr_output_path, 'dir')        
        warning('\n Directory does not exist. Creating directory'); 
        mkdir(hdr_output_path);        
    end
end