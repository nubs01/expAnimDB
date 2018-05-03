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

% Last Modified by GUIDE v2.5 03-May-2018 09:44:18

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
    dbName = animDB.dbName;
    animDB = animDB.animDB;
else
    animDB = [];
    dbName = '';
end
setappdata(handles.figure1,'baseDB',animDB)
setappdata(handles.figure1,'baseDBname',dbName)
updateGUI(handles,animDB,dbName)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rn_taskGUI wait for user response (see UIRESUME)
%uiwait(handles.figure1);


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
updateRecInfo(handles)


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
animDat = getappdata(handles.figure1,'currAnimDat');
recDat = animDat.recording_data;
if isempty(recDat)
    day = 1;
else
    day = numel(recDat)+1;
end
recDate = {};
while isempty(recDate)
    recDate = inputdlg(sprintf('Date of recording day %s (mm/dd/yy):',day),'Recording Date',1,{datestr(datetime('now'),2)});
    if isempty(recDate) || isempty(recDate{1})
        return;
    end
    recDatetime = getValidDate(recDate{1});
    if isnat(recDatetime)
        recDate = {};
    end
end
newDay = createNewRecDayStruct('day',day,'rec_date',recDatetime);
recDat = [recDat newDay];
animDat.recording_data = recDat;
setappdata(handles.figure1,'currAnimDat')
updateRecInfo(handles,recDat,0)


function dob_edit_Callback(hObject, eventdata, handles)
% hObject    handle to dob_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
animDat = getappdata(handles.figure1,'currAnimDat');
dobStr = get(handles.dob_edit,'String');
DOB = getValidDate(dobStr);
if isempty(DOB)
    if ~isnat(animDat.DOB)
        set(hObject,'String',datestr(animDat.DOB,2))
    else
        set(hObject,'String','');
    end
else
    animDat.DOB = DOB;
    if ~isnat(animDat.implant_date)
        animDat.implant_age = fix(days(animDat.implant_date-DOB));
        set(handles.impAge_edit,'String',num2str(animDat.implant_age))
    end
    setappdata(handles.figure1,'currAnimDat',animDat)
end


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
animDat = getappdata(handles.figure1,'currAnimDat');
animDat.animal = get(handles.animID_edit,'String');
setappdata(handles.figure1,'currAnimDat',animDat)


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
animDat = getappdata(handles.figure1,'currAnimDat');
genoStr = get(handles.geno_pop,'String');
animDat.genotype = genoStr{get(handles.geno_pop,'Value')};
setappdata(handles.figure1,'currAnimDat',animDat)


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
animDat = getappdata(handles.figure1,'currAnimDat');
popStr = get(hObject,'String');
if strcmpi(projStr,'other')
    newProj = inputdlg('New Project Name:','Other Project',1,{'rn_Description_Project'});
    if ~isempty(newProj)
        animDat.project = newProj{1};
    end
    setPopStr(hObject,animDat.project)
else
    animDat.project = popStr{get(hObject,'Value')};
end
setappdata(handles.figure1,'currAnimDat')


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
animDat = getappdata(handles.figure1,'currAnimDat');
tmpDate = getValidDate(get(hObject,'String'));
if ~isempty(tmpDate)
    animDat.implant_date = tmpDate;
    if isnat(tmpDate)
        animDat.implant_age = [];
        set(handles.recInfo_panel,'Visible','off')
    else
        animDat.implant_age = fix(days(tmpDate - animDat.DOB));
        set(handles.recInfo_panel,'Visible','on')
    end
end
if ~isnat(animDat.implant_date)
    set(hObject,'String',datestr(animDat.implant_date,2))
    set(handles.impAge_edit,'String',num2str(animDat.implant_age))
else
    set(hObject,'String','')
    set(handles.impAge_edit,'String','')
end
setappdata(handles.figure1,'currAnimDat',animDat)
    

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
animDat = getappdata(handles.figure1,'currAnimDat');
tmpAge = str2double(hObject,'String');
if ~isnan(tmpAge)
    animDat.implant_age = tmpAge;
    if isnat(animDat.DOB) && ~isnat(animDat.implant_date)
        animDat.DOB = animDat.implate_date - days(tmpAge);
        set(handles.dob_edit,'String',datestr(animDat.DOB,2))
    elseif ~isnat(animDat.DOB)
        animDat.implant_date = animDat.DOB + days(tmpAge);
        set(handles.impDate_edit,'String',datestr(animDat.implant_date,2))
    end
elseif isempty(get(hObject,'String'))
    animDat.implant_age = [];
    animDat.implant_date = NaT;
    set(handles.impDate_edit,'String','')
else
    set(handles.impAge_edit,'String',num2str(animDat.implant_age))
    msgbox('Please enter valid age in days','Invalid Age','error')
end
setappdata(handles.figure1,'currAnimDat',animDat)


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
animDat = getappdata(handles.figure1,'currAnimDat');
recDat = animDat.recording_data;
if isempty(recDat)
    return;
end
q = questdlg('Are you sure you want to remove day data?','Remove Recording Day','Yes','No','No');
if strcmpi(q,'No')
    return;
end
idx = get(hObject,'Value');
dayNum = recDat(idx).day;
if idx==numel(recDat)
    recDat(idx) = [];
else
    for k=dayNum+1:numel(recDat)
        recDat(k).day = recDat(k).day-1;
    end
    recDat(idx) = [];
end
animDat.recording_data = recDat;
setappdata(handles.figure1,'currAnimDat',animDat)
updateRecInfo(handles,recDat,0)


% --- Executes on selection change in epoch_list.
function epoch_list_Callback(hObject, eventdata, handles)
% hObject    handle to epoch_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateRecInfo(handles)


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
animDat = getappdata(handles.figure1,'currAnimDat');
recDat = animDat.recording_data;
if isempty(recDat)
    return; % needs to add days first
end
dayIdx = get(handles.day_list,'Value');
epoDat = recDat(dayIdx).epochs;
if isempty(epoDat)
    epoN = 1;
else
    epoN = numel(epoDat)+1;
end
tmpEpo = createNewRecEpochStruct('epoch',epoN);
epoDat = [epoDat tmpEpo];
recDat(dayIdx).epochs = epoDat;
animDat.recording_data = recDat;
setappdata(handles.figure1,'currAnimDat',animDat)
set(handles.epoch_list,'Value',numel(epoDat))
updateRecInfo(handles,recDat,0)


% --- Executes on button press in rmvEpoch_push.
function rmvEpoch_push_Callback(hObject, eventdata, handles)
% hObject    handle to rmvEpoch_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
animDat = getappdata(handles.figure1,'currAnimDat');
recDat = animDat.recording_data;
dayIdx = get(handles.day_list,'Value');
idx = get(handles.epoch_list,'Value');
if isempty(recDat)
    return; % Can't remove an epoch if no days exist
end
epoDat = recDat(dayIdx).epochs;
if isempty(epoDat)
    return; % Can't remove epochs that aren't there
end
q = questdlg('Are you sure you want to delete epoch data?','Remove Epoch','Yes','No','No');
if strcmpi(q,'No')
    return;
end
if numel(epoDat) == 1
    epoDat = [];
elseif idx == numel(epoDat)
    epoDat(idx) = [];
else
    for k=idx+1:numel(epoDat)
        epoDat(k).epoch = epoDat(k).epoch-1;
    end
    epoDat(idx) = [];
end
recDat(dayIdx).epochs = epoDat;
animDat.recording_data = recDat;
setappdata(handles.figure1,'currAnimDat',animDat)
updateRecInfo(handles,recDat,0)


% --- Executes on selection change in epoch_pop.
function epoch_pop_Callback(hObject, eventdata, handles)
% hObject    handle to epoch_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setEpochPopDat(handles,hObject,'epoch_type','Epoch Type?')


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
setEpochPopDat(handles,hObject,'environment','Epoch Environment?')


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
setEpochPopDat(handles,hObject,'injection','Injection Given?');


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
if isempty(get(hObject,'String'))
    return;
end
setVal = str2double(get(hObject,'String'));
if isnan(setVal)
    set(hObject,'String','');
    msgbox('Please enter a valid number in days.','Invalid Age','error')
end
setRecDayInfo(handles,'age',setVal)


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
if isempty(get(hObject,'String'))
    return;
end
vol = str2double(get(hObject,'String'));
if isnan(vol)
    set(hObject,'String','');
    msgbox('Please enter a valid number in mL.','Invalid Volume','error')
end
setRecEpochInfo(handles,'injection_volume',vol)


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
if isempty(get(hObject,'String'))
    return;
end
dose = str2double(get(hObject,'String'));
if isnan(dose)
    set(hObject,'String','');
    msgbox('Please enter a valid number in mg/kg.','Invalid Dose','error')
end
setRecEpochInfo(handles,'drug_dose',dose)


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
if isempty(get(hObject,'String'))
    return;
end
rec_weight = str2double(get(hObject,'String'));
if isnan(rec_weight)
    set(hObject,'String','');
    msgbox('Please enter a valid weight in grams.','Invalid Weight','error')
end
setRecDayInfo(handles,'weight',rec_weight)


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
ledStr = get(hObject,'String');
setRecEpochInfo(handles,'led_orientation',ledStr{get(hObject,'Value')})


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
setRecEpochInfo(handles,'comments',get(hObject,'String'))


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
animDat = getappdata(handles.figure1,'currAnimDat');
genderStr = get(handles.gender_pop,'String');
animDat.gender = genderStr{get(handles.gender_pop,'Value')};
setappdata(handles.figure1,'currAnimDat',animDat)


function exp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to exp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
animDat = getappdata(handles.figure1,'currAnimDir');
animDat.experiment_dir = get(hObject,'String');
setappdata(handles.figure1,'currAnimDat',animDat);


function baseWeight_edit_Callback(hObject, eventdata, handles)
% hObject    handle to baseWeight_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
animDat = getappdata(handles.figure1,'currAnimDat');
tmp = str2double(get(hObject,'String'));
if isempty(tmp) || isnan(tmp)
    msgbox('Please input a valid weight.','Invalid Implant Weight','Error');
    set(hObject,'String',num2str(animDat.preimplant_weight))
    return;
end
animDat.preimplant_weight = get(hObject,'String');
setappdata(handles.figure1,'currAnimDat',animDat)


function impWeight_edit_Callback(hObject, eventdata, handles)
% hObject    handle to impWeight_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
animDat = getappdata(handles.figure1,'currAnimDat');
tmp = str2double(get(hObject,'String'));
if isempty(tmp) || isnan(tmp)
    msgbox('Please input a valid weight.','Invalid Implant Weight','Error');
    set(hObject,'String',num2str(animDat.implant_weight))
    return;
end
animDat.implant_weight = get(hObject,'String');
setappdata(handles.figure1,'currAnimDat',animDat)

% --- Executes on selection change in anim_list.
function anim_list_Callback(hObject, eventdata, handles)
% hObject    handle to anim_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateAnimalPanel(handles)

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
animDat = getappdata(handles.figure1,'currAnimDat');
animDB = getappdata(handles.figure1,'animDB');
animIdx = get(handles.anim_list,'Value');
animDB(animIdx) = animDat;
setappdata(handles.figure1,'animDB',animDB)

% --- Executes on button press in reset_push.
function reset_push_Callback(hObject, eventdata, handles)
% hObject    handle to reset_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
animDB = getappdata(handles.figure1,'animDB');
q = questdlg('Are you sure you want to reset animal data to last save?','Reset Animal Data','Yes','No','No');
if strcmpi(q,'No')
    return;
end
animIdx = get(handles.anim_list,'Value');
animDat = animDB(animIdx);
updateAnimalPanel(handles,animDat)


% --------------------------------------------------------------------
function exportTask_menu_Callback(hObject, eventdata, handles)
% hObject    handle to exportTask_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% TODO: Create rntask struct for animal and save in animal direct folder

% --- Executes on button press in addAnim_push.
function addAnim_push_Callback(hObject, eventdata, handles)
% hObject    handle to addAnim_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
animDB = getappdata(handles.figure1,'animDB');
animDB = [animDB createNewAnimalDataStruct()];
updateGUI(handles,animDB)
set(handles.anim_list,'Value',numel(animDB))
anim_list_Callback(handles.anim_list,[],handles)

% --- Executes on button press in rmvAnim_push.
function rmvAnim_push_Callback(hObject, eventdata, handles)
% hObject    handle to rmvAnim_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
animDB = getappdata(handles.figure1,'animDB');
if isempty(animDB)
    return;
end
q = questdlg('Are you sure you want to remove all data for this animal?','Remove Animal','Yes','No','No');
if strcmpi(q,'No')
    return;
end
idx = get(handles.anim_list,'Value');
if idx == numel(animDB)
    set(handles.anim_list,'Value',idx-1)
end
animDat(idx) = [];
updateGUI(handles,animDB)

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


% function to update all GUI fields based on animDB structure
function updateGUI(handles,animDB,dbName)
    if ~exist('animDB','var')
        animDB = getappdata(handles.figure1,'animDB');
    else
        setappdata(handles.figure1,'animDB',animDB)
    end 
    if ~exist('dbName','var')
        dbName = getappdata(handles.figure1,'dbName');
    else
        setappdata(handles.figure1,'dbName',dbName)
    end
    if isempty(dbName)
        set(handles.dbTitle_text,'String','Unnamed Animal Database')
    else
        set(handles.dbTitle_text,'String',dbName)
    end
    if isempty(animDB)
        set(handles.anim_panel,'Visible','off')
        set(handles.anim_list,'String',{},'Value',1)
        return;
    end
    set(handles.anim_panel,'Visible','on')
    animList = {animDB.animal};
    animListValue = get(handles.anim_list,'Value');
    set(handles.anim_list,'String',animList)
    set(handles.anim_list,'Value',animListValue)

    animDat = animDB(animListValue);

    % set fields in anim panel
    updateAnimalPanel(handles,animDat)

% function to update all fields in the animal panel
function updateAnimalPanel(handles,animDat)
    if ~exist('animDat','var')
        animIdx = get(handles.anim_list,'Value');
        animDB = getappdata(handles.figure1,'animDB');
        if isempty(animDB)
            return;
        end
        animDat = animDB(animIdx);
    end
    setappdata(handles.figure1,'currAnimDat',animDat)
    set(handles.animID_edit,'String',animDat.animal)
    if isnat(animDat.DOB)
        set(handles.dob_edit,'String','')
    else
        set(handles.dob_edit,'String',datestr(animDat.DOB,2))
    end
    set(handles.baseWeight_edit,'String',num2str(animDat.preimplant_weight))
    set(handles.impWeight_edit,'String',num2str(animDat.implant_weight))
    if isnat(animDat.implant_date)
        set(handles.impDate_edit,'String','')
        % hide rec data if no implant date
    else
        set(handles.impDate_edit,'String',datestr(animDat.implant_date,2))
    end
    set(handles.impAge_edit,'String',num2str(animDat.implant_age))
    set(handles.exp_edit,'String',animDat.experiment_dir)
    
    % get genotype index, add if it doesn't exist in list
    setPopStr(handles.geno_pop,animDat.genotype)

    % set gender
    set(handles.gender_pop,'Value',find(strcmp(get(handles.gender_pop,'String'),animDat.gender)))

    % set project and add it if it isn't in list
    setPopStr(handles.project_pop,animDat.project)

    recDat = animDat.recording_data;
    updateRecInfo(handles,recDat,1)

function updateRecInfo(handles,recDat,changeAnimal)
    if ~exist('recDat','var')
        changeAnimal = 0;
        animDat = getappdata(handles.figure1,'currAnimDat');
        recDat = animDat.recording_data;
    end
    % Set recording info
    dayIdx = get(handles.day_list,'Value');
    if isempty(recDat) || isempty(recDat(dayIdx).epochs)
        % Clear fields if no recording data
        if isempty(recDat)
            set(handles.day_list,'String',{})
            set(handles.recDate_text,'')
            set(handles.recTime_edit,'')
        else
            set(handles.day_list,'String',getDayList(recDat))
            set(handles.recDate_text,'String',datestr(recDat(dayIdx),2))
            set(handles.recTime_edit,'String',[recDat(dayIdx).Hour ':' recDat(dayIdx).Minute])
        end
        set(handles.epoch_list,'String',{})
        set(handles.epoch_pop,'Value',1)
        set(handles.env_pop,'Value',1)
        set(handles.recAge_edit,'String','')
        set(handles.recWeight_edit,'String','')
        set(handles.injection_pop,'Value',1)
        set(handles.injVol_edit,'String','')
        set(handles.injDose_edit,'String','')
        set(handles.led_pop,'Value',1)
        set(handles.comment_edit,'String','')
        set(findall(handles.epochData_panel, '-property', 'enable'), 'enable', 'off')
        set(handles.comment_edit,'enable','off')
        return;
    elseif ~isempty(recDat(dayIdx).epochs)
        set(findall(handles.epochData_panel,'-property','enable'),'enable','on')
        set(handles.comment_edit,'enable','on')
    end
    % compile recording data
    epochIdx = get(handles.epoch_list,'Value');
    if numel(recDat)<dayIdx || changeAnimal
        dayIdx = 1;
    end
    if numel(recDat(dayIdx).epochs)<epochIdx || changeAnimal
        epochIdx = 1;
    end
    
    % make day list
    dayStr = getDayList(recDat);
    set(handles.day_list,'String',dayStr,'Value',dayIdx)
    epoStr = getEpochList(recDat(dayIdx).epochs);
    set(handles.epoch_list,'String',epoStr,'Value',epochIdx)

    epochDat = recDat(dayIdx).epochs(epochIdx);

    % set epoch type
    setPopStr(handles.epoch_pop,epochDat.epoch_type)

    % set environment
    setPopStr(handles.env_pop,epochDat.environment)

    set(handles.recAge_edit,'String',num2str(epochDat.age))
    set(handles.recWeight_edit,'String',num2str(epochDat.weight))
    setPopStr(handles.injection_pop,epochDat.injection)
    if strcmpi(epochDat.injection,'none')
        set([handles.injVol_edit handles.injDose_edit],'Enable','off')
    else
        set([handles.injVol_edit handles.injDose_edit],'Enable','on')
    end
    set(handles.injVol_edit,'String',num2str(epochDat.injection_volume))
    set(handles.injDose_edit,'String',num2str(epochDat.drug_dose))
    set(handles.diodeNum_pop,'Value',epochDat.diode_num)
    setPopStr(handles.led_pop,epochDat.led_orientation)
    set(handles.comment_edit,'String',epochDat.comments)



function outStr = getDayList(recDat)
    outStr = arrayfun(@(x) sprintf('%02i: %s',x.day,datestr(x.date)),recDat,'UniformOutput',false);

function outStr = getEpochList(epochDat)
    outStr = arrayfun(@(x) sprintf('%02i: %s',x.epoch,x.epoch_type),epochDat,'UniformOutput',false);

% set popmenu value to a specific string
function setPopStr(h_pop,h_val)
    % setPopStr(popmenu_handle,target_str), adds string to popmenu if it does
    % not already exist
    pStr = get(h_pop,'String');
    tmpIdx = find(strcmpi(pStr,h_val));
    if isempty(tmpIdx)
        pStr{end+1} = h_val;
        if strcmpi(pStr{end-1},'other')
            pStr{end-1} = pStr{end};
            pStr{end} = 'other';
            tmpIdx = numel(pStr)-1;
        else
            tmpIdx = numel(pStr);
        end
        set(h_pop,'String',pStr)
    end
    set(h_pop,'Value',tmpIdx)

% --- Executes on button press in saveDB_push.
function saveDB_push_Callback(hObject, eventdata, handles)
% hObject    handle to saveDB_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DB_path = handles.DB_path;
if isempty(DB_path)
    [a,b] = uiputfile('*.mat','Save database as:');
    if isempty(a)
        return;
    end
    handles.DB_path = [b a];
    DB_path = [b a];
end
animDB = getappdata(handles.figure1,'animDB');
dbName = getappdata(handles.figure1,'dbName');
setappdata(handles.figure1,'baseDB',animDB)
setappdata(handles.figure1,'baseDBname',dbname)
save(DB_path,'animDB','dbName')
handles.saved = 1;
guidata(hObject,handles)

% --- Executes on button press in resetDB_push.
function resetDB_push_Callback(hObject, eventdata, handles)
% hObject    handle to resetDB_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
q = questdlg('Are you sure you want to reset the database to the last saved database?','Reset Database','Yes','No','No');
if strcmpi(q,'No')
    return;
end
animDB = getappdata(handles.figure1,'baseDB');
dbName = getappdata(handles.figure1,'baseDBname');
handles.saved = 1;
updateGUI(handles,animDB,dbName)
guidata(hObject,handles)

% --- Executes on selection change in diodeNum_pop.
function diodeNum_pop_Callback(hObject, eventdata, handles)
% hObject    handle to diodeNum_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns diodeNum_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from diodeNum_pop
setRecEpochInfo(handles,'diode_num',get(hObject,'Value'))


% --- Executes during object creation, after setting all properties.
function diodeNum_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diodeNum_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in daySort_push.
function daySort_push_Callback(hObject, eventdata, handles)
% hObject    handle to daySort_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
animDat = getappdata(handles.figure1,'currAnimDat');
recDat = animDat.recording_data;
if isempty(recDat)
    return;
end
dayStr = get(handles.day_list,'String');
dayStr = strtrim(split(dayStr,':'));
dayStr = dayStr(:,2);
[~,idx] = ListGUI(dayStr,'Reorder Days');
if ~isempty(idx)
    recDat = recDat(idx);
end
animDat.recording_data = recDat;
setappdata(handles.figure1,'currAnimDat',animDat)
updateRecInfo(handles,recDat)


% --- Executes on button press in epochSort_push.
function epochSort_push_Callback(hObject, eventdata, handles)
% hObject    handle to epochSort_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
animDat = getappdata(handles.figure1,'currAnimDat');
recDat = animDat.recording_data;
if isempty(recDat)
    return;
end
dayIdx = get(handles.day_list,'Value');
epoDat = recDat(dayIdx).epochs;
if isempty(epoDat)
    return;
end
epoStr = get(handles.epoch_list,'String');
epoStr = strtrim(split(epoStr,':'));
epoStr = epoStr(:,2);
[~,idx] = ListGUI(epoStr,'Reorder Epochs');
if ~isempty(idx)
    epoDat = epoDat(idx);
end
recDat(dayIdx).epochs = epoDat;
animDat.recording_data = recDat;
setappdata(handles.figure1,'currAnimDat',animDat)
updateRecInfo(handles,recDat,0)


% Function to check validity of a date string and return a datetime object
function outDate = getValidDate(dateStr)
    try
        outDate = datetime(dateStr,'Format','MM/dd/uu');
    catch
        outDate = [];
        msgbox('Please input valid date: MM/DD/YY','Invalid Date','error')
        return;
    end
    if outDate.Year < 100
        currDate = datetime('now');
        currCent = fix(currDate.Year/100)*100;
        outDate.Year = outDate.Year + currCent;
    end

% Function that adds info to the current epoch data structure
function setRecEpochInfo(handles,infoField,newVal)
    animDat = getappdata(handles.figure1,'currAnimDat');
    recDat = animDat.reocrding_data;
    dayIdx = get(handles.day_list,'Value');
    epochIdx = get(handles.epoch_list,'Value');
    if isempty(recDat)
        return;
    end
    epoDat = recDat(dayIdx).epochs;
    if isempty(epoDat)
        return;
    end
    epoDat(epochIdx).(infoField) = newVal;
    recDat(dayIdx).epochs = epoDat;
    animDat.recording_data = recDat;
    setappdata(handles.figure1,'currAnimDat',animDat)


% Function that adds info to the current epoch data structure
function setRecDayInfo(handles,infoField,newVal)
    animDat = getappdata(handles.figure1,'currAnimDat');
    recDat = animDat.reocrding_data;
    dayIdx = get(handles.day_list,'Value');
    epochIdx = get(handles.epoch_list,'Value');
    if isempty(recDat)
        return;
    end
    epoDat = recDat(dayIdx).epochs;
    if isempty(epoDat)
        return;
    end
    epoDat(epochIdx).(infoField) = newVal;
    recDat(dayIdx).epochs = epoDat;
    animDat.recording_data = recDat;
    setappdata(handles.figure1,'currAnimDat',animDat)


% --- Executes on button press in expDir_push.
function expDir_push_Callback(hObject, eventdata, handles)
% hObject    handle to expDir_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
expDir = uigetdir(pwd,'Choose Experiment Directory');
if ~expDir
    return;
end
animDat = getappdata(handles.figure1,'currAnimDat');
animDat.experiment_dir = expDir;
set(handles.expDir_edit,'String',expDir)
setappdata(handles.figure1,'currAnimDat',animDat)


% Updates rec info to match pop_list, and handles "other" selection
function setEpochPopDat(handles,hObject,setField,customPrompt)
popStr = get(hObject,'String');
idx = get(hObject,'Value');
setVal = popStr{idx};
if strcmpi(setVal,'other')
    setVal = inputdlg(customPrompt,['Other ' setField],1);
    if isempty(setVal{1})
        updateRecInfo(handles)
        return;
    end
    popStr{end} = setVal;
    popStr{end+1} = 'Other';
    set(hObject,'String',popStr,'Value',numel(popStr)-1)
end
setRecEpochInfo(handles,setField,setVal)


% --- Executes on button press in title_push.
function title_push_Callback(hObject, eventdata, handles)
% hObject    handle to title_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dbName = inputdlg('Enter Database Name','Edit Database Name',1,{getappdata(handles.figure1,'dbName')});
if isempty(dbName)
    return;
else
    setappdata(handles.figure1,'dbName',dbName{1})
    set(handles.dbTitle_text,'String',dbName{1})
    if isempty(dbName{1})
        set(handles.dbTitle_text,'String','Unnamed Animal Database')
    end
end



function recTime_edit_Callback(hObject, eventdata, handles)
% hObject    handle to recTime_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of recTime_edit as text
%        str2double(get(hObject,'String')) returns contents of recTime_edit as a double


% --- Executes during object creation, after setting all properties.
function recTime_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recTime_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ecuEnd_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ecuEnd_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ecuEnd_edit as text
%        str2double(get(hObject,'String')) returns contents of ecuEnd_edit as a double


% --- Executes during object creation, after setting all properties.
function ecuEnd_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ecuEnd_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ecuStart_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ecuStart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ecuStart_edit as text
%        str2double(get(hObject,'String')) returns contents of ecuStart_edit as a double


% --- Executes during object creation, after setting all properties.
function ecuStart_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ecuStart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function uid_edit_Callback(hObject, eventdata, handles)
% hObject    handle to uid_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uid_edit as text
%        str2double(get(hObject,'String')) returns contents of uid_edit as a double


% --- Executes during object creation, after setting all properties.
function uid_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uid_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
