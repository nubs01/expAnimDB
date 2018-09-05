function out = getRecMetadata(animID,sessionNum,varargin)
    % Returns recording metadata or empty if is does not exist in the database
    % can override dbPath to chose another database

    dbPath = '~/Projects/rn_Schizophrenia_Project/metadata/animal_metadata.mat';

    assignVars(varargin)

    animDat = getAnimMetadata(animID,dbPath);
    out = [];
    if isempty(animDat)
        return;
    end
    recDat = animDat.recording_data;
    if isempty(recDat) || numel(recDat)<sessionNum
        return;
    end
    out = recDat(sessionNum);

    

