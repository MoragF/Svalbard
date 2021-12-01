function MAR_1_var
    [a,b] = readfile(['/exports/csce/datastore/geos/groups/geos_EO/L0data/GLIMS/RGI_6.0/Svalbard_Masks/uncorr/07_rgi60_Svalbard.tif']);
    [xx,yy]=readfile2meshgrid(b);
    
    xstart = -8.3911; %10.7139;
    ystart = 80.4708; %80.4708;
    Nx = 1164; %487
    Ny = 1053; %430
    lon = xstart + times((0:Nx-1),0.0360);
    lat = ystart + times((0:Ny-1),-0.0090);
    
    file1 = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/MARv3.11.5/MARv3.11.5-6km-daily-ERA5-2010.nc']
    sh = ncread(file1,'SH');
    mlat = ncread(file1, 'LAT');
    mlon = ncread(file1, 'LON');
    SH = zeros(Ny,Nx);
    SH(:,:) =griddata(double(mlon),double(mlat),double(sh(:,:)),double(xx),double(yy),'linear');
    
    file2 = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Years/Sval_MARv3.11.5-6km-daily-ERA5-2010.nc'];    
    nccreate(file2,'sh','Dimensions',{'lat','lon'},'DeflateLevel',7) ;
    ncwriteatt(file2,'sh','units','m');
    
    ncwriteatt(file2,'sh','long_name','Surface Height');
    ncwrite(file2,'sh',SH);
end