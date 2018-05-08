function updateAnimDBGUI(handles,varargin)

    animDB = getappdata(handles.figure1,'animDB');
    animDat = getappdata(handles.figure1,'currAnimDat');
    recDat = animDat.recording_data;

    assignVars(varargin)

    animDat.recording_data = recDat;
    setappdata(handles.figure1,'currAnimDat',animDat)
    setappdata(handles.figure1,'animDB',animDB)

    % Update animal list
    if isempty(animDB)
        clearAnimData(handles)
        set(handles.animal_list,'String','','Value',1)
        return;
    end

    animList = {animDB.animal}';
    animIdx = get(handles.animal_list,'Value',1);
    if animIdx>numel(animList) || animIdx<1
        animIdx = 1;
    end
    set(handles.animal_list,'String',animList,'Value',1)
    set(handles.animal_panel,'Visible','on')
    










function clearEpochData(handles)
% Function to clear all Epoch Data in GUI
set(handles.comment_edit,'String','')
set(handles.ecuStart_edit,'String','')
set(handles.ecuEnd_edit,'String','')
set(handles.injVol_edit,'String','')
set(handles.injDose_edit,'String','')

set(handles.diodeNum_pop,'Value',1)
set(handles.epoch_pop,'Value',1)
set(handles.env_pop,'Value',1)
set(handles.injection_pop,'Value',1)
set(handles.led_pop,'Value',1)


function clearDayData(handles)
% Function to clear all Day Data in GUI
set(handles.recDate_text,'String','')
set(handles.recTime_edit,'String','HH:MM')
set(handles.recAge_edit,'String','')
set(handles.recWeight_edit,'String','')
clearEpochData(handles)

function clearRecData(handles)
% Function to clear all recording data in GUI
set(handles.day_list,'String','','Value',1)
set(handles.epoch_list,'String','','Value',1)
set(handles.dayData_panel,'Visible','off')
set(handles.epochData_panel,'Visible','off')
set(handles.comment_edit,'Enable','off')
clearDayData(handles)

function clearAnimData(handles)
    % Function to clear all animal data in GUI
    set(handles.animID_edit,'String','')
    set(handles.uid_edit,'String','')
    set(handles.dob_edit,'String','')
    set(handles.exp_edit,'String','')
    set(handles.baseWeight_edit,'String','')
    set(handles.impWeight_edit,'String','')
    set(handles.impAge_edit,'String','')
    set(handles.impDate_edit,'String','')
    set(handles.gender_pop,'Value',1)
    set(handles.geno_pop,'Value',1)
    set(handles.project_pop,'Value',1)
    clearRecData(handles)
