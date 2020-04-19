function varargout = convert_image_system(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @convert_image_system_OpeningFcn, ...
                   'gui_OutputFcn',  @convert_image_system_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function convert_image_system_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles.path_to_images="";
handles.choosed_file="";
handles.extension="dcm";
handles.size=512;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = convert_image_system_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in get_images_btn.
function get_images_btn_Callback(hObject, eventdata, handles)
% hObject    handle to get_images_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[files,path] = uigetfile({'*.h5;*.dcm,*.mdh,*.raw'},'MultiSelect', 'on');

if(isa(files,'double') || isa(path,'double'))
    handles.path_to_images="";
    return
elseif(isa(files,'cell'))
    set(handles.filenames_list,'string',files);
else
    set(handles.filenames_list,'string',{files});
end

handles.path_to_images=string(path);

guidata(hObject, handles);

% --- Executes on selection change in choose_extension_select.
function choose_extension_select_Callback(hObject, eventdata, handles)
% hObject    handle to choose_extension_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
allExtensions=get(hObject,'String');
handles.extension=string(allExtensions(hObject.Value));
% Hints: contents = cellstr(get(hObject,'String')) returns choose_extension_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choose_extension_select
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function choose_extension_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choose_extension_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in filenames_list.
function filenames_list_Callback(hObject, eventdata, handles)
% hObject    handle to filenames_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
allFiles=get(hObject,'String');
handles.choosed_file=string(allFiles(hObject.Value));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function filenames_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filenames_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in choose_output_folder.
function choose_output_folder_Callback(hObject, eventdata, handles)
% hObject    handle to choose_output_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = uigetdir;
if(path==0)
    path="";
end
set(handles.choosed_output_folder_path,'string',path);


function choosed_output_folder_path_Callback(hObject, eventdata, handles)
% hObject    handle to choosed_output_folder_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function choosed_output_folder_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choosed_output_folder_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'enable', 'off')
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in image_size_select.
function image_size_select_Callback(hObject, ~, handles)
% hObject    handle to image_size_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
allSizes=get(hObject,'String');
handles.size=double(string(allSizes(hObject.Value)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function image_size_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to image_size_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Convert_btn.
function Convert_btn_Callback(hObject, eventdata, handles)
% hObject    handle to Convert_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fileNames=get(handles.filenames_list,'String');
for i=1:size(fileNames,1)
    filename = string(fileNames(i));
    pathToFolder=handles.path_to_images;
    pathToFile = pathToFolder+filename;
    pathToOutputFolder = get(handles.choosed_output_folder_path,'String');
    if(isempty(pathToOutputFolder))
        pathToOutputFolder=pathToFolder;
    end
    file_extension=getExtension(pathToFile);
    choosed_extension=handles.extension;
    image_size=handles.size;
    chooseConvertMethod(file_extension,choosed_extension,filename,pathToFolder,pathToOutputFolder,image_size);
    
end

function [extension] = getExtension(pathToFile)
    extension=strsplit(pathToFile, '.');
    extension=extension(end);
     
function chooseConvertMethod(file_extension,choosed_extension,fileName,pathToFolder,pathToOutputFolder,size)

     if(strcmp(file_extension,'h5') && strcmp(choosed_extension,'dcm'))
         h52dicom(pathToFolder,fileName,pathToOutputFolder,size);
     end    

function h52dicom(pathToFolder,fileName,pathToOutputFolder,size)

pathToFile=join([pathToFolder,fileName],"");
hinfo = hdf5info(pathToFile);
metadata = dicominfo('CT-MONO2-16-ankle.dcm');

% label/raw - Datasets(1)/Datasets(2)
address_data_1 = hinfo.GroupHierarchy.Datasets(1).Name;

filename_label = join([fileName,"_label.dcm"],"");
label_file = double(hdf5read(pathToFile, address_data_1));
[label_file,error] = resize_image(label_file,size);
if(error=="")
    save_image_dcm(join([pathToOutputFolder,'\',filename_label],""), label_file, metadata);
    disp(join(['Konwersja pliku: ',filename_label,' zakoñczona']));
else
    disp(join(['Nie mo¿na dokonaæ konwersji pliku ',filename_label,'. B³¹d: ',error]));
end

if(~strcmp(address_data_1,'/predictions'))
    address_data_2 = hinfo.GroupHierarchy.Datasets(2).Name;
    filename_raw = join([fileName,"_raw.dcm"],"");
    raw_file = double(hdf5read(pathToFile, address_data_2));
    [raw_file,error] = resize_image(raw_file,size);
    if(error=="")
        save_image_dcm(join([pathToOutputFolder,'\',filename_raw],""), raw_file, metadata);
        disp(join(['Konwersja pliku: ',filename_raw,' zakoñczona']));
    else
        disp(join(['Nie mo¿na dokonaæ konwersji pliku ',filename_raw,'. B³¹d: ',error]));
    end
end


