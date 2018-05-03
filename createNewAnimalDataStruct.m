function outStruct = createNewAnimalDataStruct(varargin)
    animal = 'RW1';
    genotype = 'WT';
    gender = 'M';
    animal_uid = 'LDF222';
    DOB = NaT;
    preimplant_weight = [];
    implant_date = NaT;
    implant_age = [];
    implant_weight = [];
    project = 'rn_Schizophrenia_Project';
    experiment_dir = [animal '_' genotype '_Experiment' filesep];
    recording_data = [];
    
    assignVars(varargin)

    outStruct = struct('animal',animal,'genotype',genotype,'gender',gender,...
                       'animal_uid',animal_uid,'DOB',DOB,...
                       'project',project,'experiment_dir',experiment_dir,...
                       'preimplant_weight',preimplant_weight,...
                       'implant_date',implant_date,'implant_age',implant_age,...
                       'implant_weight',implant_weight,...
                       'recording_data',recording_data);

