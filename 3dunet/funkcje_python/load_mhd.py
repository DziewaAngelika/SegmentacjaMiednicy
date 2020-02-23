import SimpleITK as sitk
import numpy as np
import h5py
import os
'''
This funciton reads a '.mhd' file using SimpleITK and return the image array, origin and spacing of the image.
'''

def load_itk(filename):
    # Reads the image using SimpleITK
    itkimage = sitk.ReadImage(filename)

    # Convert the image to a  numpy array first and then shuffle the dimensions to get axis in the order z,y,x
    ct_scan = sitk.GetArrayFromImage(itkimage)

    # Read the origin of the ct_scan, will be used to convert the coordinates from world to voxel and vice versa.
    origin = np.array(list(reversed(itkimage.GetOrigin())))

    # Read the spacing along each dimension
    spacing = np.array(list(reversed(itkimage.GetSpacing())))

    return ct_scan, origin, spacing

def main():
   #patche muszą być większe lub rowne od  [32, 64, 64]

   # NALEŻY PAMIĘTAĆ UŁOŻENIU PACJENTA W URZĄDZENIU -> KOLEJNOŚĆ SLICÓW ORAZ ORIENTACJA
   # PRZYJĘTO: STÓŁ NA DOLE, PRZEKROJE OD GŁOWY (1) DO STÓP (END), WIDOK NA PACJENTA OD STÓP

   # ----- Nazwy plików obrazu i masek -----
   mainFolder = 'C:\\Users\\Sylwia\\Desktop\\SegmentacjaMiednicy\\Silver07\\training\\'

   """ patients = 
      ['kostka01',
                'kostka04',
                'kostka05',
                'kostka06',
                'kostka07',
                'kostka08',
                'kostka09',
                'kostka10',
                'kostka12',
                'kostka13',
                'P27',
                'P30',
                'P32',
                'P33',
                'P34',
                'P35'] """

   patients=['abc']
  
   mainImageFile = 'badanie3Dv0.mhd'
   listOfMaskFiles = ['badanie3Dv0-label-Jama brzuszna Caly narzad.mhd',
                     'badanie3Dv0-label-Sledziona Caly narzad.mhd',
                     'badanie3Dv0-label-Watroba Caly narzad.mhd']#

   maskCount = len(listOfMaskFiles)

   for patient in enumerate(patients):
      
      print('Rozpoczęto pacjent: ' + patient[1])
     
      # patient = 'kostka01'
      # ----- Przeszukanie wybranego folderu pacjenta -----
      specificFolder = mainFolder + patient[1]
      pathToFiles = "C:\\Users\\mati\\Documents\\pytorch-3dunet-master\\dane_abdominal\\Innomed\\" + specificFolder
      root, dirs, files = os.walk(pathToFiles)

      # ----- Załadowanie obrazu głównego -----
      raw_array = load_itk(files[0] + "\\" + mainImageFile)
      raw = raw_array[0]
      raw = np.transpose(raw, (0, 2, 1))
      # raw = np.flip(raw, axis=1)
      raw = raw[::-1]
      raw = raw[1::2,1::2,1::2]


      if(raw.shape[0] >= 16):
         newSaveFolder = "C:\\Users\\mati\\Documents\\dydaktyka\\zspd_proj\\pytorch-3dunet-master\\dane_abdominal\\Innomed\\" + mainFolder + patient[1] + "_3_maski_h5"
         if not (os.path.exists(newSaveFolder)):
            os.mkdir(newSaveFolder)
         # ----- Załadowanie poszczególnych masek, o ile istnieją w folderze -----
         index = 0
         temp = [maskCount, raw.shape[0], raw.shape[1], raw.shape[2]]
         labels = np.ones(temp)*2
         
         for maskName in enumerate(listOfMaskFiles):
            if(os.path.exists(files[0] + "\\" + maskName[1])):
               label_array = load_itk(files[0] + "\\" + maskName[1])
               label = label_array[0]
               label[label != 0] = 1
               label = np.transpose(label, (0, 2, 1))
               label = label[::-1]
               labels[index,:,:,:] = label[1::2,1::2,1::2]
               # label = label[1::2,1::2,1::2]

               # hf = h5py.File(newSaveFolder + "\\" + maskName[1] + ".h5",'w')
               # hf.create_dataset('raw', data=raw, compression="gzip", compression_opts=2)
               # hf.create_dataset('label', data=label, compression="gzip", compression_opts=2)
               # hf.close()

               # hf = h5py.File("C:\\Users\\mati\\Documents\\dydaktyka\\zspd_proj\\pytorch-3dunet-master\\dane_abdominal\\Innomed\\" + mainFolder + "\\" + patient[1] + '.h5','w')
               # hf.create_dataset('raw', data=raw, compression="gzip", compression_opts=2)
               # hf.create_dataset('label', data=labels, compression="gzip", compression_opts=2)
               # hf.close()

            index = index + 1
         
         hf = h5py.File(newSaveFolder + "\\" + patient[1] + '_jama_sledziona_watroba.h5','w')
         hf.create_dataset('raw', data=raw, compression="gzip", compression_opts=2)
         hf.create_dataset('label', data=labels, compression="gzip", compression_opts=2)
         hf.close()

         # ----- Logowanie -----
         print('Zapisano pacjent: ' + patient[1])


if __name__ == '__main__':
    main()
