function mat2nc(n)
%Convert matfile into an nc file
% input list of files to be  converted
file = ['/home/s1423313/Documents/Sense_EDI/Svalbard/Scripts/Elevation/Grid_elevation_M.nc'];
d = matfile('/geos/d14/CS2/dhdt/Timeseries/Svalbard_uncorr_MF/Svalbard_MR1_MF_grid/tmsr_rgi60_Svalbard_marine_R1_3Dgrid.mat');
t=d.time;
nt=length(t);

nccreate(file,'time','Dimensions',{'time',1,nt},'DeflateLevel',7) ;
ncwrite(file,'time',t);

for i=1:n
    data = matfile(['/geos/d14/CS2/dhdt/Timeseries/Svalbard_uncorr_MF/Svalbard_MR',num2str(i),'_MF_grid/tmsr_rgi60_Svalbard_marine_R',num2str(i),'_3Dgrid.mat']);
    data_timeseries=data.tmsr;
    elev= data_timeseries.meanHcorr;
    nccreate(file,['LR',num2str(i)],'Dimensions',{'time'},'DeflateLevel',7) ;
    ncwriteatt(file,['LR',num2str(i)],'units','m');
    ncwriteatt(file,['LR',num2str(i)],'long_name','Grid method elevation change');
       
    ncwrite(file,['LR',num2str(i)],elev);
end
        
        
end

