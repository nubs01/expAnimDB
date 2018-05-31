function outStruct = createNewRecEpochStruct(varargin)
    epoch = [];
    epoch_type = '';
    environment = '';
    led_orientation = '';
    ecuStart = NaT;
    ecuEnd = NaT;
    diode_num = 1;
    injection = '';
    injection_volume = [];
    drug_dose = [];
    comments = [];

    assignVars(varargin)

    outStruct = struct('epoch',epoch,'epoch_type',epoch_type,...
                       'environment',environment,'ecu_start',ecuStart,...
                       'ecu_end',ecuEnd,'diode_num',diode_num,...
                       'led_orientation',led_orientation,'injection',injection,...
                       'injection_volume',injection_volume,'drug_dose',drug_dose,...
                       'comments',comments);
