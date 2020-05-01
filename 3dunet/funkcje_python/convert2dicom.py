import h5py
import numpy as np
import SimpleITK as sitk
from pydicom import dcmread
from pydicom.data import get_testdata_file

def main():
    pathToFolder = "wyniki\\predictions\\"
    pathToOutputFolder = "wyniki\\dicom\\"
    filename = "1588179836_prediction_1"
    pathToFile =  pathToFolder + filename +'.h5'
    pathToOutputFile =  pathToOutputFolder + filename +'.dcm'
    random_dcm = "wyniki\\dicom\\random.dcm"

    with h5py.File(pathToFile, "r") as f:
        a_group_key = list(f.keys())[0]

        # Get the data
        data = list(f[a_group_key])
        matrix = np.array(data)*4095
        matrix = np.asarray(matrix, dtype='uint16')
        new_matrix = np.reshape(matrix, (matrix.shape[1], matrix.shape[2], matrix.shape[3]))
        new_matrix = np.rot90(new_matrix, k=3, axes=(1, 2))
        new_matrix = np.flip(new_matrix, 2)
        new_matrix = np.ascontiguousarray(new_matrix)
        
        ds = dcmread(random_dcm, force=True)
        ds.PixelData = new_matrix
        ds.Rows = new_matrix.shape[1]
        ds.Columns = new_matrix.shape[2]
        ds.save_as(pathToOutputFile)


if __name__ == '__main__':
    main()