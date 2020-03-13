function [image, error] = resize_image(image,image_size)
error="";
modulo= mod(image_size,2);

if(modulo~=0)
    error = "Nieprawid³owy rozmiar pliku.";
    return;
end

if(image_size > size(image,1) || image_size > size(image,2))
    error = "Rozmiar pliku jest wiêkszy ni¿ rozmiar obrazu oryginalnego.";
    return;
end

step_height=size(image,1)/image_size;
step_width=size(image,2)/image_size;

image = image(1:step_height:end,:,:);
image = image(:,1:step_width:end,:);
end