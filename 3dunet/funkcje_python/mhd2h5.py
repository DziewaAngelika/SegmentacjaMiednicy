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
    pathToMaskFolder = 'C:\\Users\\Sylwia\\Desktop\\SegmentacjaMiednicy\\Silver07\\training\\'
    pathToOriginalsFolder = 'C:\\Users\\Sylwia\\Desktop\\SegmentacjaMiednicy\\Silver07\\after_conversion_raw\\'
    outputPathToFolder = 'C:\\Users\\Sylwia\\Desktop\\SegmentacjaMiednicy\\Silver07\\after_conversion_all\\'
    mhd_extension='.mhd'
    dcm_extension='.dcm'
    final_extension='.h5'
    numbers=['001', '002', '003', '004', '005', '006', '007', '008', '009', '010',
    '011', '012', '013', '014', '015', '016', '017', '018', '019', '020']

    for number in enumerate(numbers):
        fileName = 'liver-orig' + number[1]
        print('Konwersja pliku:' + fileName)
        pathToMaskFile = pathToMaskFolder + fileName + mhd_extension
        pathToOriginalFile = pathToOriginalsFolder + fileName + "_raw" + dcm_extension
        savePath = outputPathToFolder + fileName+final_extension

        
        labels_array = load_itk(pathToMaskFile)
        labels = labels_array[0]
        raw_array = load_itk(pathToOriginalFile)
        raw = raw_array[0]

        hf = h5py.File(savePath,'w')
        hf.create_dataset('raw', data=raw, compression="gzip", compression_opts=2)
        hf.create_dataset('label', data=labels, compression="gzip", compression_opts=2)
        hf.close()


        # raw_array = load_itk(pathToMaskFile)
        # raw = raw_array[0]
        # labels = np.ones(raw.shape)
        # hf = h5py.File(savePath,'w')
        # hf.create_dataset('raw', data=raw, compression="gzip", compression_opts=2)
        # hf.create_dataset('label', data=labels, compression="gzip", compression_opts=2)
        # hf.close()

    print("Konwersja wszystkich plikow zakonczona")

if __name__ == '__main__':
    main()