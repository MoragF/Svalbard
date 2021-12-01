%loop to create multiple masks for multiply regions from one root tif.
%eg mask for all 6 regions from land only termintating glaciers on Svalbard
%preregion('.m','.tif','newfilename') see preregion.m
for i= 1:6
   preregion(['/home/s1423313/Documents/Svalbard/Regions/Polys/xy_regions/07_rgi60_Svalbard_corr_R',num2str(i),'.mat'],'/home/s1423313/Documents/Svalbard/Regions/07_rgi60_Svalbard_corr_marine.tif',['07_rgi60_Svalbard_corr_marine_R',num2str(i)]);
end