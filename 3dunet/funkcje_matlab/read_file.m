function [file] = read_file(pathToFile)
    init_size=512;
    
    fid = fopen(pathToFile,'r');
    pCT_read = fread(fid);
    len_width = init_size*init_size;
    size_z = floor((size(pCT_read,1)/2)/len_width);
    fclose(fid);

    fid2 = fopen(pathToFile,'r');
    pCT = fread(fid2, [init_size*init_size*size_z,1], 'int16');
    pCT_p = reshape(pCT, [init_size init_size size_z]);
    fclose(fid2);

    file=permute(pCT_p,[2 1 3]);

    
end