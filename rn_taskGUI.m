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

% Last Modified by GUIDE v2.5 20-Jun-2018 17:17:48

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
    handles.DB_path = '/media/roshan/ExtraDrive1/Projects/rn_Schizophrenia_Project/metadata/animal_metadata.mat';
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
    setappdata(handles.figure1,'animDB',animDB)
    setappdata(handles.figure1,'dbName',dbName)
    setappdata(handles.figure1,'currAnimDat',[])
    if ~isempty(animDB)
        setappdata(handles.figure1,'currAnimDat',animDB(1))
    end
    handles.saved=1;
    handles.DB_saved=1;
    handles.prevAnimIdx = 1;
    updateAnimDBGUI(handles)

    % Update handles structure
    guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = rn_taskGUI_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;


% --- Executes on selection change in day_list.
function day_list_Callback(hObject, eventdata, handles)
    updateAnimDBGUI(handles)


% --- Executes during object creation, after setting all properties.
function day_list_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in addDay_push.
function addDay_push_Callback(hObject, eventdata, handles)
    animDat = getappdata(handles.figure1,'currAnimDat');
    recDat = animDat.recording_data;
    if isempty(recDat)
        day = 1;
        tet_info = [];
    else
        day = numel(recDat)+1;
        tet_info = recDat(end).tet_info;
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
    if ~isempty(animDat.DOB) && ~isnat(animDat.DOB)
        recAge = days(recDatetime - animDat.DOB);
    else
        recAge = [];
    end
    newDay = createNewRecDayStruct('day',day,'rec_date',recDatetime,'age',recAge,'tet_info',tet_info);
    recDat = [recDat newDay];
    animDat.recording_data = recDat;
    updateAnimDBGUI(handles,'animDat',animDat)
    handles.saved = 0;
    guidata(hObject,handles)


function dob_edit_Callback(hObject, eventdata, handles)
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
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function dob_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes during object creation, after setting all properties.
function gender_pop_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function animID_edit_Callback(hObject, eventdata, handles)
    animDat = getappdata(handles.figure1,'currAnimDat');
    animDat.animal = get(handles.animID_edit,'String');
    updateAnimDBGUI(handles,'animDat',animDat)
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function animID_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in geno_pop.
function geno_pop_Callback(hObject, eventdata, handles)
    animDat = getappdata(handles.figure1,'currAnimDat');
    genoStr = get(handles.geno_pop,'String');
    animDat.genotype = genoStr{get(handles.geno_pop,'Value')};
    setappdata(handles.figure1,'currAnimDat',animDat)
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function geno_pop_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in project_pop.
function project_pop_Callback(hObject, eventdata, handles)
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
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function project_pop_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes during object creation, after setting all properties.
function exp_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes during object creation, after setting all properties.
function baseWeight_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes during object creation, after setting all properties.
function impWeight_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function impDate_edit_Callback(hObject, eventdata, handles)
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
    handles.saved = 0;
    guidata(hObject,handles)
    

% --- Executes during object creation, after setting all properties.
function impDate_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function impAge_edit_Callback(hObject, eventdata, handles)
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
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function impAge_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in rmvDay_push.
function rmvDay_push_Callback(hObject, eventdata, handles)
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
    updateAnimDBGUI(handles,'animDat',animDat)
    handles.saved = 0;
    guidata(hObject,handles)

% --- Executes on selection change in epoch_list.
function epoch_list_Callback(hObject, eventdata, handles)
    updateAnimDBGUI(handles)


% --- Executes during object creation, after setting all properties.
function epoch_list_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in addEpoch_push.
function addEpoch_push_Callback(hObject, eventdata, handles)
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
    set(handles.epoch_list,'Value',numel(epoDat))
    updateAnimDBGUI(handles,'animDat',animDat)
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes on button press in rmvEpoch_push.
function rmvEpoch_push_Callback(hObject, eventdata, handles)
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
    updateAnimDBGUI(handles,'animDat',animDat)
    handles.saved = 0;
    guidata(hObject,handles)

% --- Executes on selection change in epoch_pop.
function epoch_pop_Callback(hObject, eventdata, handles)
    setEpochPopDat(handles,hObject,'epoch_type','Epoch Type?')


% --- Executes during object creation, after setting all properties.
function epoch_pop_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in env_pop.
function env_pop_Callback(hObject, eventdata, handles)
    setEpochPopDat(handles,hObject,'environment','Epoch Environment?')
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function env_pop_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in injection_pop.
function injection_pop_Callback(hObject, eventdata, handles)
    setEpochPopDat(handles,hObject,'injection','Injection Given?');
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function injection_pop_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function recAge_edit_Callback(hObject, eventdata, handles)
    setVal = str2double(get(hObject,'String'));
    if isnan(setVal)
        set(hObject,'String','');
        msgbox('Please enter a valid number in days.','Invalid Age','error')
    end
    setRecDayInfo(handles,'age',setVal)
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function recAge_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function injVol_edit_Callback(hObject, eventdata, handles)
    vol = str2double(get(hObject,'String'));
    if isnan(vol)
        set(hObject,'String','');
        msgbox('Please enter a valid number in mL.','Invalid Volume','error')
    end
    setRecEpochInfo(handles,'injection_volume',vol)
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function injVol_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function injDose_edit_Callback(hObject, eventdata, handles)
    dose = str2double(get(hObject,'String'));
    if isnan(dose)
        set(hObject,'String','');
        msgbox('Please enter a valid number in mg/kg.','Invalid Dose','error')
    end
    setRecEpochInfo(handles,'drug_dose',dose)
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function injDose_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function recWeight_edit_Callback(hObject, eventdata, handles)
    rec_weight = str2double(get(hObject,'String'));
    if isnan(rec_weight)
        set(hObject,'String','');
        msgbox('Please enter a valid weight in grams.','Invalid Weight','error')
    end
    setRecDayInfo(handles,'weight',rec_weight)
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function recWeight_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in led_pop.
function led_pop_Callback(hObject, eventdata, handles)
    ledStr = get(hObject,'String');
    setRecEpochInfo(handles,'led_orientation',ledStr{get(hObject,'Value')})
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function led_pop_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function comment_edit_Callback(hObject, eventdata, handles)
    setRecEpochInfo(handles,'comments',get(hObject,'String'))
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function comment_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in gender_pop.
function gender_pop_Callback(hObject, eventdata, handles)
    animDat = getappdata(handles.figure1,'currAnimDat');
    genderStr = get(handles.gender_pop,'String');
    animDat.gender = genderStr{get(handles.gender_pop,'Value')};
    setappdata(handles.figure1,'currAnimDat',animDat)
    handles.saved = 0;
    guidata(hObject,handles)


function exp_edit_Callback(hObject, eventdata, handles)
    animDat = getappdata(handles.figure1,'currAnimDat');
    animDat.experiment_dir = get(hObject,'String');
    setappdata(handles.figure1,'currAnimDat',animDat);
    handles.saved = 0;
    guidata(hObject,handles)


function baseWeight_edit_Callback(hObject, eventdata, handles)
    animDat = getappdata(handles.figure1,'currAnimDat');
    tmp = str2double(get(hObject,'String'));
    if isempty(tmp) || isnan(tmp)
        msgbox('Please input a valid weight.','Invalid Implant Weight','Error');
        set(hObject,'String',num2str(animDat.preimplant_weight))
        return;
    end
    animDat.preimplant_weight = get(hObject,'String');
    setappdata(handles.figure1,'currAnimDat',animDat)
    handles.saved = 0;
    guidata(hObject,handles)


function impWeight_edit_Callback(hObject, eventdata, handles)
    animDat = getappdata(handles.figure1,'currAnimDat');
    tmp = str2double(get(hObject,'String'));
    if isempty(tmp) || isnan(tmp)
        msgbox('Please input a valid weight.','Invalid Implant Weight','Error');
        set(hObject,'String',num2str(animDat.implant_weight))
        return;
    end
    animDat.implant_weight = get(hObject,'String');
    setappdata(handles.figure1,'currAnimDat',animDat)
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes on selection change in anim_list.
function anim_list_Callback(hObject, eventdata, handles)
    if ~handles.saved
        q = questdlg('The are unsaved changes to animal data. Are you sure you want to switch animals? Unsaved changes will be lost.','Unsaved Changes','Continue','Cancel',{'Cancel'});
        if strcmpi(q,'cancel')
            set(handles.anim_list,'Value',handles.prevAnimIdx)
            return;
        else
            handles.prevAnimIdx = get(hObject,'Value');
        end
    end
    animDB = getappdata(handles.figure1,'animDB');
    animDat = animDB(get(hObject,'Value'));
    updateAnimDBGUI(handles,'animDat',animDat)
    handles.saved = 1;
    guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function anim_list_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in save_push.
function save_push_Callback(hObject, eventdata, handles)
    animDat = getappdata(handles.figure1,'currAnimDat');
    animDB = getappdata(handles.figure1,'animDB');
    animIdx = get(handles.anim_list,'Value');
    animDB(animIdx) = animDat;
    updateAnimDBGUI(handles,'animDB',animDB)
    handles.saved = 1;
    guidata(hObject,handles)


% --- Executes on button press in reset_push.
function reset_push_Callback(hObject, eventdata, handles)
    animDB = getappdata(handles.figure1,'animDB');
    q = questdlg('Are you sure you want to reset animal data to last save?','Reset Animal Data','Yes','No','No');
    if strcmpi(q,'No')
        return;
    end
    animIdx = get(handles.anim_list,'Value');
    animDat = animDB(animIdx);
    updateAnimDBGUI(handles,'animDat',animDat)
    handles.saved = 1;
    guidata(hObject,handles)


% --------------------------------------------------------------------
function exportTask_menu_Callback(hObject, eventdata, handles)
    animDat = getappdata(handles.figure1,'currAnimDat');
    if isempty(animDat) || isempty(animDat.recording_data)
        return;
    end
    recDat = animDat.recording_data;
    if any(arrayfun(@(x) isempty(x.epochs),recDat))
        errordlg('Missing some epoch data.','Insufficient Data')
        return;
    end
    task = createNewRNTaskStruct('animal',animDat.animal,'dob',animDat.DOB,'genotype',animDat.genotype,'gender',animDat.gender);
    nDays = numel(recDat);
    rntask = cell(1,nDays);
    for l=1:nDays
        rD = recDat(l);
        tmpT = task;
        epoDat = rD.epochs;
        task.age = rD.age;
        d = rD.date;
        t = rD.time;
        d.Hour = t.Hour;
        d.Minute = t.Minute;
        tmpT.date_time = d;
        tmpT.estrus = rD.estrus;
        tmpT.weight = rD.weight;
        nEpochs = numel(epoDat);
        rntask{l} = cell(1,nEpochs);
        for m=1:nEpochs
            tmpT2 = tmpT;
            eD = epoDat(m);
            fn = fieldnames(eD);
            fn2 = fieldnames(tmpT);
            for n=1:numel(fn)
                if any(strcmpi(fn2,fn{n}))
                    tmpT2.(fn{n}) = eD.(fn{n});
                end
            end
            rntask{l}{m} = tmpT2;
            clear tmpT2
        end
        clear tmpT
    end
    saveFile = [animDat.animal 'rntask.mat'];
    [fName,fPath] = uiputfile(saveFile);
    if ~fName
        return;
    end
    saveFile = [fPath fName];
    save(saveFile,'rntask')


% --- Executes on button press in addAnim_push.
function addAnim_push_Callback(hObject, eventdata, handles)
    animDB = getappdata(handles.figure1,'animDB');
    anim = {animDB.animal};
    pat = '(?<num>\d*$)';
    A = regexp(anim,pat,'names');
    B = cellfetch(A,'num');
    C = str2double(B.values);
    D = max(C);
    animDat = createNewAnimalDataStruct('animal',['RW' num2str(D+1)]);
    animDB = [animDB animDat];
    if handles.saved
        set(handles.anim_list,'Value',numel(animDB))
        updateAnimDBGUI(handles,'animDB',animDB,'animDat',animDat)
    else
        updateAnimDBGUI(handles,'animDB',animDB)
    end
    handles.DB_saved = 0;
    guidata(hObject,handles)


% --- Executes on button press in rmvAnim_push.
function rmvAnim_push_Callback(hObject, eventdata, handles)
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
    updateAnimDBGUI(handles,'animDB',animDB)
    handles.DB_saved = 0;
    guidata(hObject,handles)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
    try
        if ~handles.DB_saved || ~handles.saved
            q = questdlg('The database is not saved. Changes will be lost. Continue?','Unsaved Changes','Continue','Cancel',{'Cancel'});
            if strcmpi(q,'cancel')
                return;
            end
        end
    catch
        disp('Error Closing')
    end
    delete(hObject);

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
    setappdata(handles.figure1,'baseDBname',dbName)
    save(DB_path,'animDB','dbName')
    handles.DB_saved = 1;
    guidata(hObject,handles)


% --- Executes on button press in resetDB_push.
function resetDB_push_Callback(hObject, eventdata, handles)
    q = questdlg('Are you sure you want to reset the database to the last saved database?','Reset Database','Yes','No','No');
    if strcmpi(q,'No')
        return;
    end
    animDB = getappdata(handles.figure1,'baseDB');
    dbName = getappdata(handles.figure1,'baseDBname');
    animIdx = get(handles.anim_list,'Value');
    if animIdx>numel(animDB)
        animIdx = 1;
    end
    animDat = animDB(animIdx);
    handles.DB_saved = 1;
    updateAnimDBGUI(handles,'animDB',animDB,'dbName',dbName,'animDat',animDat)
    guidata(hObject,handles)


% --- Executes on selection change in diodeNum_pop.
function diodeNum_pop_Callback(hObject, eventdata, handles)
    setRecEpochInfo(handles,'diode_num',get(hObject,'Value'))
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function diodeNum_pop_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in daySort_push.
function daySort_push_Callback(hObject, eventdata, handles)
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
        for l=1:numel(recDat)
            recDat(l).day = l;
        end
    end
    animDat.recording_data = recDat;
    updateAnimDBGUI(handles,'animDat',animDat)
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes on button press in epochSort_push.
function epochSort_push_Callback(hObject, eventdata, handles)
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
        for l=1:numel(epoDat)
            epoDat(l).epoch = l;
        end
    end
    recDat(dayIdx).epochs = epoDat;
    animDat.recording_data = recDat;
    updateAnimDBGUI(handles,'animDat',animDat)
    handles.saved = 0;
    guidata(hObject,handles)


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
    recDat = animDat.recording_data;
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
    recDat = animDat.recording_data;
    dayIdx = get(handles.day_list,'Value');
    if isempty(recDat)
        return;
    end
    recDat(dayIdx).(infoField) = newVal;
    animDat.recording_data = recDat;
    setappdata(handles.figure1,'currAnimDat',animDat)


% --- Executes on button press in expDir_push.
function expDir_push_Callback(hObject, eventdata, handles)
    expDir = uigetdir(pwd,'Choose Experiment Directory');
    if ~expDir
        return;
    end
    animDat = getappdata(handles.figure1,'currAnimDat');
    proj =  animDat.project;
    a = strfind(expDir,proj);
    if isempty(a)
        q = questdlg('Experiment Directory is not in correct project directory, is this correct?','Wrong Project','yes','no','no');
        if strcmpi(q,'no')
            expDir = '';
        end
    else
        [~,expDir] = fileparts(expDir(a:end));
        expDir = [expDir filesep];
    end
    animDat.experiment_dir = expDir;
    set(handles.exp_edit,'String',expDir)
    setappdata(handles.figure1,'currAnimDat',animDat)
    handles.saved = 0;
    guidata(hObject,handles)


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
        setVal = setVal{1};
        popStr{end} = setVal;
        popStr{end+1} = 'Other';
        set(hObject,'String',popStr,'Value',numel(popStr)-1)
    end
    setRecEpochInfo(handles,setField,setVal)


% --- Executes on button press in title_push.
function title_push_Callback(hObject, eventdata, handles)
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
    handles.DB_saved = 0;
    guidata(hObject,handles)


function recTime_edit_Callback(hObject, eventdata, handles)
    tStr = get(hObject,'String');
    timeExp = '(?<hour>\d{2}):(?<minute>\d{2})';
    tokens = regexp(tStr,timeExp,'names');
    if isempty(tokens)
        set(hObject,'String','')
        errordlg('Please enter a valid time in 24hr format HH:MM','Invalid Time')
        return;
    end
    animDat = getappdata(handles.figure1,'currAnimDat');
    dayIdx = get(handles.day_list,'Value');
    dayDat = animDat.recording_data(dayIdx);
    tmpDate = dayDat.date;
    tmpDate.Hour = str2double(tokens.hour);
    tmpDate.Minute = str2double(tokens.minute);
    set(hObject,'String',datestr(tmpDate,'HH:MM'))
    setRecDayInfo(handles,'time',tmpDate)
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function recTime_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function ecuEnd_edit_Callback(hObject, eventdata, handles)
    tStr = get(hObject,'String');
    timeExp = '(?<hour>\d{2}):(?<minute>\d{2}):(?<second>\d{2})';
    tokens = regexp(tStr,timeExp,'names');
    if isempty(tokens)
        set(hObject,'String','')
        errordlg('Please enter a valid time in format HH:MM:SS','Invalid Time')
        return;
    end
    animDat = getappdata(handles.figure1,'currAnimDat');
    dayIdx = get(handles.day_list,'Value');
    dayDat = animDat.recording_data(dayIdx);
    tmpDate = dayDat.date;
    tmpDate.Hour = str2double(tokens.hour);
    tmpDate.Minute = str2double(tokens.minute);
    tmpDate.Second = str2double(tokens.second);
    set(hObject,'String',datestr(tmpDate,'HH:MM:SS'))
    setRecEpochInfo(handles,'ecu_end',tmpDate)
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function ecuEnd_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function ecuStart_edit_Callback(hObject, eventdata, handles)
    tStr = get(hObject,'String');
    timeExp = '(?<hour>\d{2}):(?<minute>\d{2}):(?<second>\d{2})';
    tokens = regexp(tStr,timeExp,'names');
    if isempty(tokens)
        set(hObject,'String','')
        errordlg('Please enter a valid time in format HH:MM:SS','Invalid Time')
        return;
    end
    animDat = getappdata(handles.figure1,'currAnimDat');
    dayIdx = get(handles.day_list,'Value');
    dayDat = animDat.recording_data(dayIdx);
    tmpDate = dayDat.date;
    tmpDate.Hour = str2double(tokens.hour);
    tmpDate.Minute = str2double(tokens.minute);
    tmpDate.Second = str2double(tokens.second);
    set(hObject,'String',datestr(tmpDate,'HH:MM:SS'))
    setRecEpochInfo(handles,'ecu_start',tmpDate)
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function ecuStart_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function uid_edit_Callback(hObject, eventdata, handles)
    animDat = getappdata(handles.figure1,'currAnimDat');
    animDat.animal_uid = get(hObject,'String');
    setappdata(handles.figure1,'currAnimDat',animDat)
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function uid_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in estrus_check.
function estrus_check_Callback(hObject, eventdata, handles)
    setRecDayInfo(handles,'estrus',get(hObject,'Value'))
    handles.saved = 0;
    guidata(hObject,handles)


% --- Executes on button press in tet_push.
function tet_push_Callback(hObject, eventdata, handles)
    animDat = getappdata(handles.figure1,'currAnimDat');
    if isempty(animDat) || isempty(animDat.recording_data)
        return;
    end
    dayIdx = get(handles.day_list,'Value');
    recDat = animDat.recording_data;
    tetInfo = recDat(dayIdx).tet_info;
    newInf = tetInfoGUI(tetInfo);
    recDat(dayIdx).tet_info = newInf;
    animDat.recording_data = recDat;
    setappdata(handles.figure1,'currAnimDat',animDat)
