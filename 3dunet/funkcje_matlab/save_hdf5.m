function save_hdf5(raw, mask, filename)

h5create(filename, '/raw', size(raw));
h5create(filename, '/label', size(mask));
h5write(filename, '/raw', raw);
h5write(filename, '/label', mask);
