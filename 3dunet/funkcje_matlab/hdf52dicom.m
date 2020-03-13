pathToFolder = 'D:\Magisterka\Dane\Silver07\converted_h5\';
pathToOutputFolder = 'D:\Magisterka\Dane\Silver07\po_konwersji\';
all_files = dir(pathToFolder);

for i=1:size(all_files,1)
file=all_files(i);
    if(file.isdir==1)
        continue
    end
fileName = file.name;
pathToFile = join([pathToFolder,fileName]);

hinfo = hdf5info(pathToFile);
metadata = dicominfo('CT-MONO2-16-ankle.dcm');

% label/raw - Datasets(1)/Datasets(2)
address_data_1 = hinfo.GroupHierarchy.Datasets(1).Name;
address_data_2 = hinfo.GroupHierarchy.Datasets(2).Name;

filename_raw = join([fileName,'_raw.dcm']);
raw_file = double(hdf5read(pathToFile, address_data_2));
[raw_file,error] = resize_image(raw_file,255);
if(isempty(error))
    save_image_dcm(join([pathToOutputFolder,filename_raw]), raw_file, metadata);
else
    disp(join(['Nie mo�na dokona� konwersji pliku ',filename_raw,'. B��d: ',error]));
end

filename_label = join([fileName,'_label.dcm']);
label_file = double(hdf5read(pathToFile, address_data_1));
[label_file,error] = resize_image(label_file,1024);
if(isempty(error))
    save_image_dcm(join([pathToOutputFolder,filename_label]), raw_file, metadata);
else
    disp(join(['Nie mo�na dokona� konwersji pliku ',filename_label,'. B��d: ',error]));
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

disp('Konwersja wszystkich plik�w zakonczona')