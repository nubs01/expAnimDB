function outStruct = createNewRecDayStruct(varargin)

    day = [];
    rec_date = NaT;
    rec_time = NaT;
    epochs = [];
    weight = [];
    age = [];

    assignVars(varargin)

    outStruct = struct('day',day,'date',rec_date,'time',rec_time,...
                       'weight',weight,'age',age,'epochs',epochs);

