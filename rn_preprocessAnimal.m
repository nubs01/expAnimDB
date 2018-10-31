function out = rn_preprocessAnimal(animID,varargin)
    % Get animal data from default metadata database or given dbPath and
    % preprocess for SZ delta analysis. Requires position tracking be done and
    % that the diodenum in the database is what was used for tracking. the
    % flags doDIO and doSpikes tell it whether to preprocess spikes and dio. 
    % NAME - VALUE Pairs
    %   projDir :   path to project directory on computer i.e. '/data/Projects/'
    %   dbPath  :   path to animal metadata database
    %   doDIO   :   flag for whether to create DIO files
    %   doSpikes:   flag for whether to create Spikes files
    %   dioPulseFrameChannel : dio channel of camera strobe (leave empty if no strobe)
    %   min_suprathresh_duration : min time for ripple power to be above threshold to count as a ripple (seconds)
    %   nstd    :   ripple power threshold, number of std above baseline
    %   daysToAnalyze : list of days to analyze, leave empty to analyze all days for animal
    %   nTets   : maximum number of tetrodes on headstage (default=8)

    out = [];
    projDir = get_data_path('project_directory');
    dbPath = get_data_path('sz_metadata');
    doDIO = 0; % create DIO files
    doSpikes = 0; % create spikes files; leave as 0 if unclustered

    dioPulseFrameChannel = []; % dio channel of camera strobe pulse, empty if no strobe

    %% Variables for ripple detection/extraction
    min_suprathresh_duration = 0.015; % min time for ripple power to be above threshold to count as a ripple (in seconds)
    nstd = 3; % ripple power threshold: number of standard deviations above baseline

    daysToAnalyze = []; % will analyze all days if empty
    nTets = 8;

    assignVars(varargin)

    % Grab & Confirm directory information
    animInfo = getPreprocessData(animID,dbPath);
    animDir = [projDir animInfo.animDir filesep];
    dataDir = [projDir animInfo.expDir filesep animID '_direct' filesep];
    preproDir = [projDir animInfo.expDir filesep animID '_preprocess' filesep];
    currDir = pwd;
    logFile = [dataDir animID '_preprocess.log'];
    rawDirs = strcat(animDir,animInfo.rawDirs');
    dirCheck = cellfun(@(x) exist(x,'dir'),rawDirs);
    if ~all(dirCheck)
        disp('ERROR: Cannot find raw data directories:')
        cellfun(@(x) disp(['      ' x]),rawDirs(find(dirCheck)))
        out = -1;
        return;
    end

    % Create convenient helper variables
    if isempty(daysToAnalyze)
        daysToAnalyze = linspace(1,numel(rawDirs),numel(rawDirs));
    end
    

    %% Start log
    if exist(logFile,'file')
        HEADER = 1;
    else
        HEADER = 0;
    end
%    diary(logFile)
    if HEADER
        fprintf('\n\n')
    end
    disp(datestr(now,0))
    a = sprintf('%g ',daysToAnalyze);
    % Data check output for user
    disp(['Preparing to preprocess ' animID])
    disp(['    animal directory: ' animDir])
    disp('    day directories: ')
    cellfun(@(x) disp(['        ' x]),animInfo.rawDirs)
    disp(['    output to: ' dataDir])
    disp(['    log: ' logFile])
    disp(['    Analyzing Days : ' a])
    
    q = input('Is this ok? (y/n)','s');
    if strcmpi(q,'n')
        return;
    end
    fprintf('\n\n')

    % Save animal metadata and preprocess data to animal preprocess folder
    if ~exist(preproDir,'dir')
        mkdir(preproDir)
    end
    metadata = getAnimMetadata(animID);
    save([preproDir animID 'metadata.mat'],'metadata')
    save([preproDir animID 'preprocessData.mat'],'animInfo')
    clear metadata

    %% Process each day
    for sessionNum = daysToAnalyze
        fprintf('Processing day %02i....\n',sessionNum)
        
        dayNumStr = sprintf('%02i',sessionNum);
        dayDir = rawDirs{sessionNum};


        % Extract Binaries to matlab files
        rn_createNQPosFiles(dayDir,dataDir,animID,sessionNum,[],'diodenum',animInfo.diodenum{sessionNum})
        rn_createNQLFPFiles(dayDir,dataDir,animID,sessionNum)
        if doDIO
            mcz_createNQDIOFiles(dayDir,dataDir,animID,sessionNum)
            % createNQDIOFilesFromStateScriptLogs(rawDir, dataDir, animID, sessionNum) % if DIO needs to be extracted from statescript logs
        end
        if doSpikes
            rn_createNQSpikesFiles(dayDir,dataDir,animID,sessionNum)
        end

        % Delete dead tetrodes
        delTrodes = animInfo.deleteTrodes{sessionNum};
        if ~isempty(delTrodes)
            fprintf('    Deleting dead tetrodes: %s\n',num2str(animInfo.deleteTrodes{sessionNum}))
            eegDir = [dataDir 'EEG' filesep];
            for l=delTrodes
                delFiles = dir(sprintf('%s%s*-*-%02i.mat',eegDir,animID,l));
                delFiles = {delFiles.name};
                delFiles = strcat(eegDir,delFiles);
                cellfun(@(x) fprintf('       deleting %s\n',x),delFiles)
                cellfun(@(x) delete(x),delFiles);
            end
        end

        % Convert to EMG from EEG file
        if ~isempty(animInfo.emgList)
            emgDir = [dataDir 'EMG' filesep];
            eegDir = [dataDir 'EEG' filesep];
            if ~exist(emgDir,'dir')
                mkdir(emgDir)
            end
            for l = animInfo.emgList
                eegFiles = dir(sprintf('%s%s*-*-%02i.mat',eegDir,animID,l));
                if isempty(eegFiles)
                    continue;
                end
                eegFiles = {eegFiles.name};
                emgFiles = strrep(eegFiles,'eeg','emg');
                eegFiles = strcat(eegDir,eegFiles);
                emgFiles = strcat(emgDir,emgFiles);
                for m=1:numel(emgFiles)
                    eeg = load(eegFiles{m});
                    emg = eeg.eeg;
                    save(emgFiles{m},'emg')
                    delete(eegFiles{m})
                end
            end
        end

        % Filter and Reference EEG files
        cd(dayDir)
        epochs = getEpochs(1);
        cd(currDir)
        nEpochs = size(epochs,1);

        refData = zeros(nEpochs,nTets);
        for l=1:numel(animInfo.areas)
            for k = animInfo.tetLists{l}
                refData(:,k) = animInfo.refList{sessionNum}(l);
            end
        end
        fprintf('Creating referenced EEG files...\n')
        mcz_createRefEEG(dayDir, dataDir, animID, sessionNum, refData)

        % Create filtered eeg data files
        filterDir = [fileparts(which('mcz_deltadayprocess.m')) filesep 'filters' filesep];
        fprintf('Delta Filtering LFPs...\n')
        mcz_deltadayprocess(dayDir, dataDir, animID, sessionNum, 'f', [filterDir 'deltafilter.mat']) %can add option mcz...(...,'f',...,'ref',1) if you want to filter with eegref instead of eeg (default)
        fprintf('Gamma Filtering LFPs...\n')
        mcz_gammadayprocess(dayDir, dataDir, animID, sessionNum, 'f', [filterDir 'gammafilter.mat']) % for gamma filter default is to use eegref, can pass 'ref',0 to filter eeg instead
        fprintf('Ripple Filtering LFPs...\n')
        mcz_rippledayprocess(dayDir, dataDir, animID, sessionNum, 'f', [filterDir 'ripplefilter.mat']) % for ripple filter default is to use eegref, can pass 'ref',0 to filter eeg instead
        fprintf('Theta Filtering LFPs...\n')
        mcz_thetadayprocess(dayDir, dataDir, animID, sessionNum, 'f', [filterDir 'thetafilter.mat']) % for theta filter default is to use eeg, can pass 'ref',1 to filter eegref instead

        % extract ripples
        fprintf('Detecting and Extracting Ripples...\n')
        extractripples(dataDir,animID,sessionNum,animInfo.riptetlist{sessionNum},min_suprathresh_duration,nstd);

        % Detect EEG artifacts using all avaible tetrodes
        % TODO: Move before ripple extraction and use to help with ripple detection
        fprintf('Detecting and Marking Artifacts...\n')
        rn_createNQArtifactFiles(dataDir, animID, sessionNum)

        % Score behavioral states
        % TODO: Move before ripple extraction and use to help with ripple detection
        % TODO: Create behavioral state algorithm. Use RW6 make figures of state classificiation with EMG/Pos vs EEG.
        %if ~isempty(animInfo.emgList)
        %    fprintf('Scoring behavioral states using Position and EMG data...\n')
        %else
        %    fprintf('EMG Not Available: Scoring behavioral states using only Position data...\n')
        %end

        fprintf('Creating CWT Spectrogram Files...\n')
        createCWTFiles(dataDir,animID,sessionNum);
        %fprintf('Creating Chronux Spectra Files...\n')
        %createSpecFiles(dataDir,animID,sessionNum);
        fprintf('Creating EMG from LFP...\n')
        rn_EMGFromLFP(animID,dataDir,sessionNum);
        fprintf('Scoring sleep states using Buzsaki Algorithm...\n')
        scoreStates(animID,dataDir,sessionNum);

        fprintf('Day %02d complete!\n\n\n',sessionNum)
        close all
    end


    %% Create cell and tet info metadata structures
    disp('Creating cell & tet info structures')
    rn_createtetinfostruct(dataDir,animID);
    mcz_createcellinfostruct(dataDir,animID);

    for day=daysToAnalyze
        for i=1:numel(animInfo.areas)
            rn_addtetrodelocation(dataDir,animID,animInfo.tetLists{i},animInfo.areas{i},day);
            rn_addtetrodedescription(dataDir,animID,animInfo.refList{day}(i),[animInfo.areas{i} 'Ref'],day);
            rn_addtetrodedescription(dataDir,animID,animInfo.riptetlist{day},'riptet',day);
        end
    end

    sj_addcellinfotag2(dataDir,animID);
    disp('Preprocessing complete!')
    disp(datestr(now,0))
    diary off
    out = 1;
    cd(currDir)
