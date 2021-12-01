
    [a,m]=readfile(tifname);
    [xx,yy]=readfile2meshgrid(m);
    %creates lat and lon arrays to become coordinates in .nc (and to help with xarray in python)
    %lat and lon in MAR are 2-d grids this converts to 1-d.
    xstart = -8.3911; %10.7139;
    ystart = 80.4708; %80.4708;
    Nx = 1164; %487
    Ny = 1053; %430
    lon = xstart + times((0:Nx-1),0.0360);
    lat = ystart + times((0:Ny-1),-0.0090);
    %Creates mesh for the RGI mask
    MARf = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/MARv3.11.5/MARv3.11.5-6km-daily-ERA5-',num2str(2000+nj),'.nc'];
mask = ncread(MARf,'MASK');
        mlat = ncread(MARf, 'LAT');
        mlon = ncread(MARf, 'LON');
        MSK = zeros(Ny,Nx);
        MSK(:,:) =griddata(double(mlon),double(mlat),mask(:,:),double(xx),double(yy),'nearest');
        
  file = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Years/Sval_MARv3.11.5-6km-daily-ERA5-2010.nc'];
nccreate(file,'icemsk','Dimensions',{'lat','lon'},'DeflateLevel',7) ; 
ncwriteatt(file,'icemsk','units','%');
ncwriteatt(file,'icemsk','long_name','Ice Coverage');
ncwrite(file,'icemsk',MSK);