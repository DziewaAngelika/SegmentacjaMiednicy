function save_image_dcm(outputPathToWrite, image, metadata)

metadata.Width=size(image,1);
metadata.Height=size(image,2);

image=reshape(image(:,:,:,1),[size(image,1) size(image,2) 1 size(image,3)]);
dicomwrite(image, outputPathToWrite, metadata, 'CreateMode', 'copy');

end