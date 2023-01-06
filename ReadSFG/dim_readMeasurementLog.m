function [ loginfo ] = dim_readMeasurementLog( filename )
% Reads a measurement log containing all image filenames and supporting information
%   you can supply an empty filename to get the default structure

if(~isempty(filename))
    logdata = fileread(filename);
    logdata = strrep(logdata, ',', '.'); % replace comma by dot, should not be necessary if LabView settings specify to always use a dot
    loglines = strsplit(logdata, '\n');
    
    j = 1;
    loginfo = [];
    names = {};
    values = {};
    N = length(loglines)+1; % number of iterations = loginfo entries + 1
           
    % last iteration is used to add last chunk in case last line is not empty
    for i=1:N
        if(i==N || (strcmp(loglines{i}, '') || (double(loglines{i}(1)) == 13))) % check for CR character or empty line
            j = 1;
            
            if(~isempty(names)) % add next chunk to structure array
                % check if known format and convert into structure
                idxFile = find(contains(names, 'File'), 1);
                idxDelay = find(contains(names, 'Delay'), 1);
                idxPower = find(contains(names, 'Amplitude'), 1);
                if(idxFile >= 0 && idxDelay >= 0 && idxPower >= 0)
                    loginfo = [loginfo; struct(...
                        'File', values{idxFile},...
                        'Delay', values{idxDelay},...
                        'Power', values{idxPower}...
                        )];
                end
            end
            
            names = {};
            values = {};
        else
            tmp = strsplit(loglines{i}, ' = ');
            tmp2 = tmp{2};
            names{j} = tmp{1};
            values{j} = str2num(tmp2);
            if(isempty(values{j})) % in case it was not a numeric value, it should be the filename
                values{j} = strtrim(tmp2); % remove trailing linefeed
            end
            j = j+1;
        end
    end
else
    loginfo = struct('File', '','Delay', 0,'Power', 0);
end

