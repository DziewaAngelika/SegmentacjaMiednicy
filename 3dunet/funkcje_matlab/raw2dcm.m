pathToFolder = 'C:\Users\Sylwia\Desktop\SegmentacjaMiednicy\Silver07\training\';
outputFolder = 'C:\Users\Sylwia\Desktop\SegmentacjaMiednicy\Silver07\after_conversion_raw\';
fileName = 'liver-orig020';
extention='.raw';
pathToFile = join([pathToFolder,fileName,extention]);

fid3 = fopen(pathToFile,'r');
pCT_read = fread(fid3);
len_width = 512*512;
size_z = (size(pCT_read,1)/2)/len_width;
fclose(fid3);

fid3 = fopen(pathToFile,'r');
pCT = fread(fid3, [512*512*size_z,1], 'int16');
pCT_p = reshape(pCT, [512 512 size_z]);
fclose(fid3);

new_pCT1=permute(pCT_p,[2 1 3]);

metadata = dicominfo('CT-MONO2-16-ankle.dcm');

outputPathToWrite=join([outputFolder,fileName,'_raw.dcm']);

after_reshape=reshape(new_pCT1(:,:,:,1),[size(new_pCT1,1) size(new_pCT1,2) 1 size(new_pCT1,3)]);
after_reshape=int16(after_reshape);
for j =1:size(after_reshape,4)
      after_reshape(:,:,1,j)=int16(after_reshape(:,:,1,j)+1000);
end

dicomwrite(after_reshape, outputPathToWrite, metadata, 'CreateMode', 'copy');
disp('Zakoñczono konwersjê')

% 
% for j =1:size(new_pCT1,3)
%       file=int16(new_pCT1(:,:,j)+1000);
%       dicomwrite(file,['CT_' int2str(j) '.dcm'], metadata, 'CreateMode', 'copy');
% end