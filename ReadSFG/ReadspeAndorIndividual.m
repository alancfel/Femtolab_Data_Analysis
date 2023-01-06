function [dat] = ReadspeAndorIndividual(file)
% Individual backup frames are saved as 'uint16' format
fid=fopen(file); 
Im1=fread(fid,'int32'); % reads the entire file, including metadata

px=Im1(2);
py=Im1(3);

Im=Im1(4:end);
Z=reshape(Im,px,py);
% Z=reshape(Im1(2:end-4),1280,1080);

dat=double(Z);

fclose(fid);
end