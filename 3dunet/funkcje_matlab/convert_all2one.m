clc; clear all;
patientSize=20;
imageSize=[129,172,200,91,139,135,151,124,111,122,132,260,122,113,125,155,119,74,124,225];
metadata = dicominfo('CT-MONO2-16-ankle.dcm');

% pathToFolder = 'D:\Magisterka\Dane\3Dircadb\3Dircadb1.19\PATIENT_DICOM\';
% pathToOutputFolder = 'D:\Magisterka\Dane\3Dircadb\Original_dcm\19.dcm';

% pathToFolder = 'D:\Magisterka\Dane\3Dircadb\3Dircadb1.9\MASKS_DICOM\liver\';
% pathToOutputFolder = 'D:\Magisterka\Dane\3Dircadb\Mask_dcm\19.dcm';

for j=1:patientSize
    pathToFolder = strcat('D:\Magisterka\Dane\3Dircadb\3Dircadb1.', num2str(j), '\MASKS_DICOM\liver\');
    pathToOutputFolder = strcat('D:\Magisterka\Dane\3Dircadb\Mask_dcm\', num2str(j), '.dcm');
    
    all_files = dir(pathToFolder);
    image_3d = [];
    counter=0;
    size_counter=0;
    size_files=imageSize(j);
    
    for i=1:size(all_files,1)
    file=all_files(i);
        if(file.isdir==1)
            continue
        end
    
    fileName = strcat('image_', num2str(size_counter));
    pathToFile = join([pathToFolder,fileName]);

    counter=counter+1;
    image = dicomread(pathToFile);
    image_3d(:,:,counter)=image;
    size_counter=size_counter+1;
    end

    output=reshape(image_3d(:,:,:,1),[size(image_3d,1) size(image_3d,2) 1 size(image_3d,3)]);
    dicomwrite(output, pathToOutputFolder, metadata, 'CreateMode', 'copy');
    disp('Konwersja zakoñczona');
    disp(pathToOutputFolder);

end