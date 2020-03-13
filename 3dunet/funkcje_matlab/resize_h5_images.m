pathToFolder = 'D:\Magisterka\Dane\Silver07\converted_h5\';
pathToOutputFolder = 'D:\Magisterka\Dane\Silver07\resize_h5\';
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

outputPathToWrite= join([pathToOutputFolder,fileName]);

output_raw = double(hdf5read(pathToFile, address_data_2));
output_raw = output_raw(1:2:end,1:2:end,:);

output_label = double(hdf5read(pathToFile,address_data_1));
output_label = output_label(1:2:end,1:2:end,:);

imshow(output_label(:,:,40),[])

h5create(outputPathToWrite,address_data_1,output_label);

disp(join(['Konwersja pliku ',fileName,' zakonczona']))
end

disp('Konwersja wszystkich plików zakonczona')