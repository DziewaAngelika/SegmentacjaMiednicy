a=dicomread('Series_80452_CORONALS.dcm');
b=dicomread('Series_mask.dcm');
im1=squeeze(a(:,:,1,:));
mask1=squeeze(b(:,:,1,:));
% save_hdf5(im1, mask1, 'uterus.h5');
[raw, label] = load_hdf5('uterus.h5');
imshow(imfuse(raw(:,:,30),label(:,:,30)))