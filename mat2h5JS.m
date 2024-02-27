clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isfolder('h5\')
    if isfile('h5\example_data.h5')
        delete('h5\example_data.h5')
    end
    output_filepath = 'h5\example_data.h5';
else
    mkdir('h5\')
    output_filepath = 'h5\example_data.h5';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read data files
load('data\data.mat');
dx = data.voxel_MR';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dx = repmat(dx,1,size(data.MR_PCA_RL,4));

vx = single(data.MR_PCA_RL./100);
vy = single(data.MR_PCA_AP./100);
vz = single(data.MR_PCA_FH./100);

vmask = abs(repmat(abs(vz(:,:,:,1))==data.VENC/100,1,1,1,size(vz,4))-1);
vx = vx.*vmask;
vy = vy.*vmask;
vz = vz.*vmask;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% we normlize the magnitude images between 0 to 4096
mag_u = single(round((data.MR_FFE_RL./max(data.MR_FFE_RL(:)))*600));
mag_v = single(round((data.MR_FFE_AP./max(data.MR_FFE_AP(:)))*600));
mag_w = single(round((data.MR_FFE_FH./max(data.MR_FFE_FH(:)))*600));

venc = repmat(data.VENC/100,1,size(data.MR_PCA_RL,4));

disp('Preparing HDF5')
colnames = {'/dx', '/u', '/v', '/w',  '/mag_u', '/mag_v', '/mag_w','/venc_u','/venc_v','/venc_w'};

h5create(output_filepath,colnames{1},size(dx),'Datatype','single');
h5create(output_filepath,colnames{2},size(vx),'Datatype','single');
h5create(output_filepath,colnames{3},size(vy),'Datatype','single');
h5create(output_filepath,colnames{4},size(vz),'Datatype','single');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h5create(output_filepath,colnames{5},size(mag_u),'Datatype','single');
h5create(output_filepath,colnames{6},size(mag_v),'Datatype','single');
h5create(output_filepath,colnames{7},size(mag_w),'Datatype','single');

h5create(output_filepath,colnames{8},size(venc),'Datatype','single');
h5create(output_filepath,colnames{9},size(venc),'Datatype','single');
h5create(output_filepath,colnames{10},size(venc),'Datatype','single');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Saving to HDF5')
h5write(output_filepath, colnames{1}, dx);
h5write(output_filepath, colnames{2}, vx);
h5write(output_filepath, colnames{3}, vy);
h5write(output_filepath, colnames{4}, vz);
h5write(output_filepath, colnames{5}, mag_v);
h5write(output_filepath, colnames{6}, mag_w);
h5write(output_filepath, colnames{7}, mag_w);
h5write(output_filepath, colnames{8}, venc);
h5write(output_filepath, colnames{9}, venc);
h5write(output_filepath, colnames{10}, venc);

disp('Done!');