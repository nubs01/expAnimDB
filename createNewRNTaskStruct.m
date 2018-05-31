function outStruct = createNewRNTaskStruct(varargin)
    animal = '';
    age = [];
    dob = NaT;
    genotype = '';
    gender = '';
    date_time = NaT;
    age = [];
    weight = [];
    estrus = 0;
    epoch_type = '';
    environment = '';
    ecu_start = [];
    ecu_end = [];
    diode_num = [];
    led_orientation = '';
    injection = '';
    injection_volume = [];
    drug_dose = [];
    comments = '';

    assignVars(varargin)

    v = who;
    idx = cellfun(@(x) ~strcmpi(x,'varargin'),v);
    v = v(idx);
    a = cellfun(@(x) ['''' x ''',' x],v,'UniformOutput',false);
    b = ['outStruct =  struct(' strjoin(a,',') ');'];
    eval(b);



