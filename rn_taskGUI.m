function varargout = rn_taskGUI(varargin)
% RN_TASKGUI MATLAB code for rn_taskGUI.fig
%      RN_TASKGUI, by itself, creates a new RN_TASKGUI or raises the existing
%      singleton*.
%
%      H = RN_TASKGUI returns the handle to a new RN_TASKGUI or the handle to
%      the existing singleton*.
%
%      RN_TASKGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RN_TASKGUI.M with the given input arguments.
%
%      RN_TASKGUI('Property','Value',...) creates a new RN_TASKGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rn_taskGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rn_taskGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rn_taskGUI

% Last Modified by GUIDE v2.5 02-Apr-2018 14:19:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rn_taskGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @rn_taskGUI_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before rn_taskGUI is made visible.
function rn_taskGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rn_taskGUI (see VARARGIN)

% Choose default command line output for rn_taskGUI
handles.output = hObject;

% Load DB or create new one
handles.DB_path = 'media/roshan/ExtraDrive1/Projects/rn_Schizophrenia_Project/animal_metadata.mat';
if exist(handles.DB_path,'file')
    animDB = load(handles.DB_path);
else
    animDB = [];
end
if isempty(animDB)
    set(handles.anim_panel,'Visible','off')
else
    set(handles.anim_panel,'Visible','off')
end
setappdata(handles.figure1,'baseDB',animDB)
setappdata(handles.figure1,'animDB',animDB)
updateGUI(handles,animDB)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rn_taskGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rn_taskGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in day_list.
function day_list_Callback(hObject, eventdata, handles)
% hObject    handle to day_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns day_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from day_list


% --- Executes during object creation, after setting all properties.
function day_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to day_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addDay_push.
function addDay_push_Callback(hObject, eventdata, handles)
% hObject    handle to addDay_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function dob_edit_Callback(hObject, eventdata, handles)
% hObject    handle to dob_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dob_edit as text
%        str2double(get(hObject,'String')) returns contents of dob_edit as a double


% --- Executes during object creation, after setting all properties.
function dob_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dob_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function gender_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gender_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function animID_edit_Callback(hObject, eventdata, handles)
% hObject    handle to animID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of animID_edit as text
%        str2double(get(hObject,'String')) returns contents of animID_edit as a double


% --- Executes during object creation, after setting all properties.
function animID_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to animID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in geno_pop.
function geno_pop_Callback(hObject, eventdata, handles)
% hObject    handle to geno_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns geno_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from geno_pop


% --- Executes during object creation, after setting all properties.
function geno_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to geno_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in project_pop.
function project_pop_Callback(hObject, eventdata, handles)
% hObject    handle to project_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns project_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from project_pop


% --- Executes during object creation, after setting all properties.
function project_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to project_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function exp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function baseWeight_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baseWeight_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function impWeight_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to impWeight_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function impDate_edit_Callback(hObject, eventdata, handles)
% hObject    handle to impDate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of impDate_edit as text
%        str2double(get(hObject,'String')) returns contents of impDate_edit as a double


% --- Executes during object creation, after setting all properties.
function impDate_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to impDate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function impAge_edit_Callback(hObject, eventdata, handles)
% hObject    handle to impAge_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of impAge_edit as text
%        str2double(get(hObject,'String')) returns contents of impAge_edit as a double


% --- Executes during object creation, after setting all properties.
function impAge_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to impAge_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rmvDay_push.
function rmvDay_push_Callback(hObject, eventdata, handles)
% hObject    handle to rmvDay_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in epoch_list.
function epoch_list_Callback(hObject, eventdata, handles)
% hObject    handle to epoch_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns epoch_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from epoch_list


% --- Executes during object creation, after setting all properties.
function epoch_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epoch_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addEpoch_push.
function addEpoch_push_Callback(hObject, eventdata, handles)
% hObject    handle to addEpoch_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in rmvEpoch_push.
function rmvEpoch_push_Callback(hObject, eventdata, handles)
% hObject    handle to rmvEpoch_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in epoch_pop.
function epoch_pop_Callback(hObject, eventdata, handles)
% hObject    handle to epoch_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns epoch_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from epoch_pop


% --- Executes during object creation, after setting all properties.
function epoch_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epoch_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in env_pop.
function env_pop_Callback(hObject, eventdata, handles)
% hObject    handle to env_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns env_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from env_pop


% --- Executes during object creation, after setting all properties.
function env_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to env_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in injection_pop.
function injection_pop_Callback(hObject, eventdata, handles)
% hObject    handle to injection_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns injection_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from injection_pop


% --- Executes during object creation, after setting all properties.
function injection_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to injection_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function recAge_edit_Callback(hObject, eventdata, handles)
% hObject    handle to recAge_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of recAge_edit as text
%        str2double(get(hObject,'String')) returns contents of recAge_edit as a double


% --- Executes during object creation, after setting all properties.
function recAge_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recAge_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function injVol_edit_Callback(hObject, eventdata, handles)
% hObject    handle to injVol_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of injVol_edit as text
%        str2double(get(hObject,'String')) returns contents of injVol_edit as a double


% --- Executes during object creation, after setting all properties.
function injVol_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to injVol_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function injDose_edit_Callback(hObject, eventdata, handles)
% hObject    handle to injDose_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of injDose_edit as text
%        str2double(get(hObject,'String')) returns contents of injDose_edit as a double


% --- Executes during object creation, after setting all properties.
function injDose_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to injDose_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function recWeight_edit_Callback(hObject, eventdata, handles)
% hObject    handle to recWeight_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of recWeight_edit as text
%        str2double(get(hObject,'String')) returns contents of recWeight_edit as a double


% --- Executes during object creation, after setting all properties.
function recWeight_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recWeight_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in led_pop.
function led_pop_Callback(hObject, eventdata, handles)
% hObject    handle to led_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns led_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from led_pop


% --- Executes during object creation, after setting all properties.
function led_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to led_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function comment_edit_Callback(hObject, eventdata, handles)
% hObject    handle to comment_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comment_edit as text
%        str2double(get(hObject,'String')) returns contents of comment_edit as a double


% --- Executes during object creation, after setting all properties.
function comment_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comment_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in gender_pop.
function gender_pop_Callback(hObject, eventdata, handles)
% hObject    handle to gender_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns gender_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gender_pop



function exp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to exp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of exp_edit as text
%        str2double(get(hObject,'String')) returns contents of exp_edit as a double



function baseWeight_edit_Callback(hObject, eventdata, handles)
% hObject    handle to baseWeight_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of baseWeight_edit as text
%        str2double(get(hObject,'String')) returns contents of baseWeight_edit as a double



function impWeight_edit_Callback(hObject, eventdata, handles)
% hObject    handle to impWeight_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of impWeight_edit as text
%        str2double(get(hObject,'String')) returns contents of impWeight_edit as a double


% --- Executes on selection change in anim_list.
function anim_list_Callback(hObject, eventdata, handles)
% hObject    handle to anim_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns anim_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from anim_list


% --- Executes during object creation, after setting all properties.
function anim_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to anim_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_push.
function save_push_Callback(hObject, eventdata, handles)
% hObject    handle to save_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in reset_push.
function reset_push_Callback(hObject, eventdata, handles)
% hObject    handle to reset_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function exportTask_menu_Callback(hObject, eventdata, handles)
% hObject    handle to exportTask_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in addAnim_push.
function addAnim_push_Callback(hObject, eventdata, handles)
% hObject    handle to addAnim_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in rmvAnim_push.
function rmvAnim_push_Callback(hObject, eventdata, handles)
% hObject    handle to rmvAnim_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    uiresume(hObject);
else
    delete(hObject);
end
