function [raw, label] = load_hdf5(filename)

hinfo = hdf5info(filename);

address_data_1 = hinfo.GroupHierarchy.Datasets(1).Name;
label = double(hdf5read(filename,address_data_1));

address_data_2 = hinfo.GroupHierarchy.Datasets(2).Name;
raw = double(hdf5read(filename,address_data_2));


