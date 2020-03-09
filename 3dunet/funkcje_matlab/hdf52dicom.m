pathToFolder = 'C:\Users\Sylwia\Desktop\SegmentacjaMiednicy\Dane\Silver07\converted_h5\';
pathToOutputFolder = 'C:\Users\Sylwia\Desktop\SegmentacjaMiednicy\Dane\Silver07\converted_dcm\';
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
% address_data_2 = hinfo.GroupHierarchy.Datasets(2).Name;

% % save raw file
% outputFileName='_raw.dcm';
% outputPathToWrite= join([pathToOutputFolder,fileName,outputFileName]);
% output = double(hdf5read(pathToFile, address_data_2));
% output=reshape(output(:,:,:,1),[size(output,1) size(output,2) 1 size(output,3)]);
% dicomwrite(output, outputPathToWrite, metadata, 'CreateMode', 'copy');

% save label file
outputFileName='_label.dcm';
outputPathToWrite= join([pathToOutputFolder,fileName,outputFileName]);
output = hdf5read(pathToFile,address_data_1);
output = double(output);
output=reshape(output(:,:,:,1),[size(output,1) size(output,2) 1 size(output,3)]);
dicomwrite(output, outputPathToWrite, metadata, 'CreateMode', 'copy');


disp(join(['Konwersja pliku ',fileName,' zakonczona']))
end

disp('Konwersja wszystkich plików zakonczona')