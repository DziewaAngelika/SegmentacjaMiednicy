
file = 'sciezka do pliku h5'

file = 'C:\Users\mati\Documents\dydaktyka\zspd_proj\pytorch-3dunet-master\dane_abdominal\Innomed\Obrysowane_czesc_1\kostka13_4_maski_h5\kostka13_aorta_dwunastnica_trzustka_watroba.h5'


hinfo = hdf5info(file);
% label/raw - Datasets(1)/Datasets(2)
address_data_1 = hinfo.GroupHierarchy.Datasets(1).Name;
output = double(hdf5read(file,address_data_1));



metadata = dicominfo('CT-MONO2-16-ankle.dcm');
dicomwrite(reshape(output(:,:,:,1),[size(output,1) size(output,2) 1 size(output,3)]), 'obraz_wyjsciowy.dcm', metadata, 'CreateMode', 'copy');

