function updateAnimDBGUI(handles,varargin)

    dbName = getappdata(handles.figure1,'dbName');
    animDB = getappdata(handles.figure1,'animDB');
    animDat = getappdata(handles.figure1,'currAnimDat');

    assignVars(varargin)

    setappdata(handles.figure1,'currAnimDat',animDat)
    setappdata(handles.figure1,'animDB',animDB)
    setappdata(handles.figure1,'dbName',dbName)
    if isempty(animDat)
        recDat = [];
    else
        recDat = animDat.recording_data;
    end

    % Update animal list
    if isempty(animDB)
        clearAnimData(handles)
        set(handles.anim_list,'String','','Value',1)
        return;
    end
    if ~isempty(dbName)
        set(handles.dbTitle_text,'String',dbName)
    end

    animList = {animDB.animal}';
    animIdx = get(handles.anim_list,'Value');
    if animIdx>numel(animList) || animIdx<1
        animIdx = 1;
    end
    set(handles.anim_list,'String',animList,'Value',animIdx)
    set(handles.anim_panel,'Visible','on')
    

    % Update animal data panel  
    set(handles.animID_edit,'String',animDat.animal)
    set(handles.uid_edit,'String',animDat.animal_uid)
    if isnat(animDat.DOB)
        dobStr = '';
    else
        dobStr = datestr(animDat.DOB,2);
    end
    set(handles.dob_edit,'String',dobStr)
    set(handles.exp_edit,'String',animDat.experiment_dir)
    set(handles.baseWeight_edit,'String',num2str(animDat.preimplant_weight))
    set(handles.impWeight_edit,'String',num2str(animDat.implant_weight))
    if isnat(animDat.implant_date)
        impStr = '';
        set(handles.recInfo_panel,'Visible','off')
    else
        set(handles.recInfo_panel,'Visible','on')
        impStr = datestr(animDat.implant_date,2);
    end
    set(handles.impDate_edit,'String',impStr)
    set(handles.impAge_edit,'String',num2str(animDat.implant_age))

    setPopStr(handles.geno_pop,animDat.genotype)
    setPopStr(handles.project_pop,animDat.project)
    setPopStr(handles.gender_pop,animDat.gender)

    if isempty(recDat)
        clearRecData(handles)
        return;
    end
    
    % Update rec info
    dayIdx = get(handles.day_list,'Value');
    epochIdx = get(handles.epoch_list,'Value');
    dayList = getDayList(recDat);
    if dayIdx>numel(dayList)
        dayIdx = 1;
    end
    set(handles.day_list,'String',dayList,'Value',dayIdx)
    set(handles.dayData_panel,'Visible','on')

    rD = recDat(dayIdx);
    set(handles.recDate_text,'String',datestr(rD.date,2))
    if isnat(rD.time)
        timeStr = 'HH:MM';
    else
        timeStr = datestr(rD.time,'HH:MM');
    end 
    set(handles.recTime_edit,'String',timeStr)
    set(handles.recWeight_edit,'String',num2str(rD.weight))
    set(handles.recAge_edit,'String',num2str(rD.age))
    set(handles.estrus_check,'Value',rD.estrus)
    
    epoDat = rD.epochs;
    if isempty(epoDat)
        clearEpochData(handles);
        set(handles.epoch_list,'String','','Value',1)
        set(handles.epochData_panel,'Visible','off')
        return;
    end
    set(handles.epochData_panel,'Visible','on')
    epochList = getEpochList(epoDat);
    if epochIdx>numel(epochList)
        epochIdx = 1;
    end
    set(handles.epoch_list,'String',epochList,'Value',epochIdx)
    eD = epoDat(epochIdx);
    
    % Set epoch data
    if isnat(eD.ecu_start)
        tmpStr = '';
    else
        tmpStr = datestr(eD.ecu_start,'HH:MM:SS');
    end
    set(handles.ecuStart_edit,'String',tmpStr)
    
    if isnat(eD.ecu_end)
        tmpStr = '';
    else
        tmpStr = datestr(eD.ecu_end,'HH:MM:SS');
    end
    set(handles.ecuEnd_edit,'String',tmpStr)

    set(handles.injVol_edit,'String',num2str(eD.injection_volume))
    set(handles.injDose_edit,'String',num2str(eD.drug_dose))
    setPopStr(handles.epoch_pop,eD.epoch_type)
    setPopStr(handles.env_pop,eD.environment)
    setPopStr(handles.injection_pop,eD.injection)
    if ~isempty(eD.diode_num)
        set(handles.diodeNum_pop,'Value',eD.diode_num)
    else
        set(handles.diodeNum_pop,'Value',1)
    end
    setPopStr(handles.led_pop,eD.led_orientation)
    set(handles.comment_edit,'String',eD.comments,'Enable','on')


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
    set(handles.estrus_check,'Value',0)
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
    set(handles.recInfo_panel,'Visible','off')
    clearRecData(handles)

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


function outStr = getDayList(recDat)
    outStr = arrayfun(@(x) sprintf('%02i: %s',x.day,datestr(x.date,2)),recDat,'UniformOutput',false);

function outStr = getEpochList(epochDat)
    outStr = arrayfun(@(x) sprintf('%02i: %s',x.epoch,x.epoch_type),epochDat,'UniformOutput',false);
