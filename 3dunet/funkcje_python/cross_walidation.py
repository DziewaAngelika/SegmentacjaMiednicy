from os import listdir
from os.path import isfile, join

class CrossValidation:
    
    def __init__(self, path_to_folder, train_group_number=1, test_group_number=2, validation_group_number=3):

        if path_to_folder is None:
            assert 'Path to folder with files is required'

        self._path_to_folder=path_to_folder

        if train_group_number < 1 | train_group_number > 3:
            assert 'Train group number should has value from 1 to 3'
        self._train_group_number=train_group_number

        if test_group_number < 1 | test_group_number > 3:
            assert 'Test group number should has value from 1 to 3'
        self._test_group_number=test_group_number

        if validation_group_number < 1 | validation_group_number > 3:
            assert 'Validation group number should has value from 1 to 3'
        self._validation_group_number=validation_group_number

        self.__split_files_to_group()

    @property
    def train_filepaths(self):
        return self.__get_equivalent_group(self._train_group_number)

    @property
    def test_filepaths(self):
        return self.__get_equivalent_group(self._test_group_number)

    @property
    def validation_filepaths(self):
        return self.__get_equivalent_group(self._validation_group_number)


    def __split_files_to_group(self):
        filenames = self.__get_all_filenames(self._path_to_folder)
        files_count = len(filenames)
        file_count_in_one_group=int(files_count/3)
        self._group_I = filenames[0:file_count_in_one_group]
        self._group_II = filenames[file_count_in_one_group:file_count_in_one_group*2]
        self._group_III = filenames[file_count_in_one_group*2:file_count_in_one_group*3]

        rest_files_count=int(files_count % 3)

        if rest_files_count>0:
            self._group_I.append(filenames[file_count_in_one_group*3:file_count_in_one_group*3+1][0])
        
        if rest_files_count==2:
            self._group_II.append(filenames[file_count_in_one_group*3+1:file_count_in_one_group*3+2][0])

        self._group_I=self.__join_filenames_with_path(self._group_I, self._path_to_folder)
        self._group_II=self.__join_filenames_with_path(self._group_II, self._path_to_folder)
        self._group_III=self.__join_filenames_with_path(self._group_III, self._path_to_folder)

    def __get_all_filenames(self, path_to_folder):
        filenames = []
        filenames = [f for f in listdir(path_to_folder) if isfile(join(path_to_folder, f))]
        return list(filenames)

    def __join_filenames_with_path(self, filenames, path_to_folder):
        joined=[]
        for filename in filenames:
            joined.append(path_to_folder+filename)

        return joined
    
    def __get_equivalent_group(self, number):
        files={
            1:self._group_I,
            2:self._group_II,
            3:self._group_III 
            }
        return files[number]

