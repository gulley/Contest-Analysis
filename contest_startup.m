% Make sure this directory is on the path

f = which(mfilename);
[pathstr,name,ext] = fileparts(f);
addpath(pathstr)
% addpath([pathstr filesep notes])
% addpath([pathstr filesep doc])
% addpath([pathstr filesep test])