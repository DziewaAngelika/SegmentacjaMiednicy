
folders_in_Obrysowane = dir('dane_abdominal/Innomed/Obrysowane czêœæ 1/');
folders_in_Obrysowane = folders_in_Obrysowane(3:end);
for folder_idx = 1:numel(folders_in_Obrysowane)
    
    folders = dir([folders_in_Obrysowane(folder_idx).folder '/' folders_in_Obrysowane(folder_idx).name]);
    folders = folders(3:end);
    
    for i = 1:numel(folders)
        if(folders(i).isdir)
            subfolders = dir([folders(folder_idx).folder '/' folders(folder_idx).name]);
            subfolders = subfolders(3:end);
            
            files = dir([subfolders.folder '/' subfolders.name]);
            files = files(3:end);
            
            for file_idx = 1:numel(files)
            
                [V,info]=read_mhd([files(file_idx).folder '/' files(file_idx).name]);   
               
                
            end
        

            
        end
    end
end


 