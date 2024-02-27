%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_path = 'data\data.mat';
h5_result_HR_path = 'result\example_result.h5';

RL = double(h5read(h5_result_HR_path,'/u'))*100; % change to cm/s
AP = double(h5read(h5_result_HR_path,'/v'))*100; % change to cm/s
FH = double(h5read(h5_result_HR_path,'/w'))*100; % change to cm/s

load(data_path)

MAG = zeros(size(FH));
for n=1:size(FH,4)
    MAG(:,:,:,n) = imresize3(data.MR_FFE_FH(:,:,:,n),[size(FH,1) size(FH,2) size(FH,3)], "cubic");
end

data_new = data;
data_new.MR_FFE_AP = MAG;
data_new.MR_FFE_RL = MAG;
data_new.MR_FFE_FH = MAG;
data_new.MR_PCA_AP = AP;
data_new.MR_PCA_RL = RL;
data_new.MR_PCA_FH = FH;
data_new.voxel_MR = data.voxel_MR/2;

mkdir('dataHR/')
save('dataHR/data.mat','data','-v7.3')