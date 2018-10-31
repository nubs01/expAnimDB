function outStruct = createNewRecDayStruct(varargin)

    day = [];
    rec_date = NaT;
    rec_time = NaT;
    epochs = [];
    weight = [];
    age = [];
    estrus = 0;
    tet_info = [];

    assignVars(varargin)

    outStruct = struct('day',day,'date',rec_date,'time',rec_time,...
                       'weight',weight,'age',age,'estrus',estrus,'epochs',epochs,'tet_info',tet_info);

