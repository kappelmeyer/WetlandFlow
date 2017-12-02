function [DateNum, Uranine_mv, Temperature] = read(flu_file)
% Reads and re-formats fluorometer (experimental) data
fid = fopen(flu_file);
T = textscan(fid, '%*s %s %*s %f %f %f %f %f %f %f %*s', 'headerlines', 3); 
fclose(fid);

Date = T{1};
DateNum = datenum(Date, 'dd/mm/yy-HH:MM:SS');     % Generate numerical date
Uranine_mv = T{2};
Temperature = T{8}; 