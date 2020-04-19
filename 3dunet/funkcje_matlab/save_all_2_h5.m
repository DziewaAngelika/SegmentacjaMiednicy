patientSize=20;

for j=1:patientSize
    pathToFolder_Original = strcat('D:\Magisterka\Dane\3Dircadb\Original_dcm\', num2str(j), '.dcm');
    pathToFolder_Mask = strcat('D:\Magisterka\Dane\3Dircadb\Mask_dcm\', num2str(j), '.dcm');
    pathToOutputFolder = strcat('D:\Magisterka\Dane\3Dircadb\Converted_h5_128\', num2str(j), '.h5');

    image_size=128;
    raw_image = dicomread(pathToFolder_Original);
    raw_image = resize_image(raw_image,image_size);
    label_image = dicomread(pathToFolder_Mask);
    label_image = resize_image(label_image,image_size);
    
    save_hdf5(raw_image, label_image, pathToOutputFolder);
    
    disp('Konwersja zakoñczona');
    disp(pathToOutputFolder);
end
