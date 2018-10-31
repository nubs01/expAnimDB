function outData = getPreprocessData(animID,dbPath)
    % Searches animal metadata database and gathers info needed for
    % preprocessing such as target area for tetrodes, references and diodenum

    % load animal database
    if ~exist('dbPath','var')
        dbPath = '~/Projects/rn_Schizophrenia_Project/metadata/animal_metadata.mat';
    end
    animDB = load(dbPath);
    animDB = animDB.animDB;

    % find animal
    animIdx = find(strcmpi({animDB.animal},animID));
    if isempty(animIdx)
        disp('Animal not found in database');
        outData = [];
        return;
    end
    animDat = animDB(animIdx);
    recDat = animDat.recording_data;
    days = numel(recDat);
    if days==0
        outData = [];
        return;
    end
    for l=1:days
        tetDat(:,l) = recDat(l).tet_info'; %struct array with tetrodes as rows and days as columns
    end

    % look through tet data and collect info:
    % - areas
    % - tet's targeting each area
    % - riptets
    % - depths
    % - EMG 
    % - reference tetrode each day
    % - tetrodes that should be delete (dead/LFPchan = 0 in DB)
    % - tracking diode num (recData)

    expDir = [animDat.project filesep animDat.experiment_dir];
    if strcmp(expDir(end),filesep)
        expDir = expDir(1:end-1);
    end
    animDir = [expDir filesep animID];

    tetAreas = {tetDat(:,1).target};
    areas = unique(tetAreas);
    tetLists = cell(1,numel(areas));
    for l=1:numel(areas)
       tetLists{l} = find(strcmpi(tetAreas,areas{l}));
    end 

    % remove  EMG and make separate
    emgIdx = find(strcmpi(areas,'EMG'));
    if ~isempty(emgIdx)
        emgList  = tetLists{emgIdx};
        tetLists(emgIdx) = [];
        areas(emgIdx) = [];
    else
        emgList = [];
    end

    % start outData structure
    outData.animal = animID;
    outData.expDir = expDir;
    outData.animDir = animDir;
    outData.areas = areas;
    outData.tetLists = tetLists;
    outData.emgList = emgList;

    % find refs and riptets
    refList = cell(1,days);
    riptetlist = cell(1,days);
    depths = zeros(size(tetDat,1),days);
    diodenum = cell(1,days);
    deleteTrodes = cell(1,days);
    rawDirs = cell(1,days);
    for l=1:days
        rawDirs{l} = sprintf('%02i_%s',recDat(l).day,datestr(recDat(l).date,'YYmmDD'));
        riptetlist{l} = find([tetDat(:,l).riptet]);
        refList{l} = zeros(1,numel(areas));
        for k=1:numel(areas)
            tetsInArea = find(strcmpi(tetAreas,areas{k}));
            tmp = find([tetDat(tetsInArea,l).ref]);
            if ~isempty(tmp)
                refList{l}(k) = tetsInArea(tmp);
            end
        end
        for k=1:numel(tetAreas)
            tmp = tetDat(k,l).depth;
            if isempty(tmp)
                depths(k,l) = nan;
            else
                depths(k,l) = tmp;
            end
        end
        diodenum{l} = [recDat(l).epochs.diode_num]; % diodenum{day}(epoch) gives diodes to use in pos extraction, TODO: adjust preprocess
        deleteTrodes{l} = strfind([tetDat(:,l).lfp_channel],'0');
    end

    outData.rawDirs = rawDirs;
    outData.refList = refList;
    outData.riptetlist = riptetlist;
    outData.depths = depths;
    outData.diodenum = diodenum;
    outData.deleteTrodes = deleteTrodes; % tetrodes to delete because they are dead and were not removed from recording
end
