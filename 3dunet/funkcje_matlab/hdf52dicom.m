pathToFolder = '..\wyniki\predictions\';
pathToOutputFolder = '..\wyniki\dicom\';
all_files = dir(pathToFolder);

for i=1:size(all_files,1)
file=all_files(i);
    if(file.isdir==1)
        continue
    end
    
error="";
fileName = file.name;
pathToFile = join([pathToFolder,fileName]);

hinfo = hdf5info(pathToFile);
metadata = dicominfo('CT-MONO2-16-ankle.dcm');

% label/raw - Datasets(1)/Datasets(2)
address_data_1 = hinfo.GroupHierarchy.Datasets(1).Name;
% address_data_2 = hinfo.GroupHierarchy.Datasets(2).Name;

% filename_raw = join([fileName,'_raw.dcm']);
% raw_file = double(hdf5read(pathToFile, address_data_2));
% [raw_file,error] = resize_image(raw_file,128);
% if(strcmp(error,""))
%     save_image_dcm(join([pathToOutputFolder,filename_raw]), raw_file, metadata);
% else
%     disp(join(['Nie mo¿na dokonaæ konwersji pliku ',filename_raw,'. B³¹d: ',error]));
% end

filename_label = join([fileName,'_label.dcm']);
label_file = double(hdf5read(pathToFile, address_data_1));
error = "";
%[label_file,error] = resize_image(label_file,128);
if(strcmp(error,""))
    save_image_dcm(join([pathToOutputFolder,filename_label]), label_file, metadata);
else
    disp(join(['Nie mo¿na dokonaæ konwersji pliku ',filename_label,'. B³¹d: ',error]));
end

% % save raw file
% outputFileName='_raw.dcm';
% outputPathToWrite = join([pathToOutputFolder,fileName,outputFileName]);
% output = double(hdf5read(pathToFile, address_data_2));
% %resize
% output = output(1:2:end,1:2:end,:);
% metadata.Width=size(output,1);
% metadata.Height=size(output,2);
% 
% output=reshape(output(:,:,:,1),[size(output,1) size(output,2) 1 size(output,3)]);
% dicomwrite(output, outputPathToWrite, metadata, 'CreateMode', 'copy');

% % save label file
% outputFileName='_label.dcm';
% outputPathToWrite= join([pathToOutputFolder,fileName,outputFileName]);
% output = double(hdf5read(pathToFile,address_data_1));
% 
% %resize
% output = output(1:2:end,1:2:end,:);
% metadata.Width=size(output,1);
% metadata.Height=size(output,2);
% 
% output=reshape(output(:,:,:,1),[size(output,1) size(output,2) 1 size(output,3)]);
% dicomwrite(output, outputPathToWrite, metadata, 'CreateMode', 'copy');


end

disp('Konwersja wszystkich plików zakonczona')