function out = getAnimMetadata(animID,dbPath)
    % returns the animal metadata entry from the database. Can provide location
    % for alternate database


    if ~exist('dbPath','var')
        dbPath = '~/Projects/rn_Schizophrenia_Project/matadata/animal_metadata.mat';
    end
    animDB = load(dbPath,'animDB');
    animDB = animDB.animDB;
    animNames = {animDB.animal};
    out = animDB(strcmpi(animNames,animID));
