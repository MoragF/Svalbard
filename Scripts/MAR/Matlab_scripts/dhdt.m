function dhdt(tifname)
%marMSK (root tif (eg RGI mask for Svalbard['/exports/csce/datastore/geos/groups/geos_EO/L0data/GLIMS/RGI_6.0/Svalbard_Masks/uncorr/07_rgi60_Svalbard.tif']))--> masks MAR data --> .nc file
%outputing 
    %Creates mesh for the RGI mask
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
    %Read in MAR files, loop through all years and picks out the wanted
    %variables. To see full list ncdisp and or go to Timeseries notebook.

    dhdt = ['/exports/csce/datastore/geos/groups/geos_EO/PROCESS/Svalbard_dhdt/dhdt.nc'];
    rate = ncread(dhdt,'rate');
    mlat = ncread(dhdt, 'lat');
    mlon = ncread(dhdt, 'lon');
    %Preallocation of memory, increases speed of loop.
    RATE = zeros(Ny,Nx);

    %project variable on to the mesh of RGI mask(tifname),
    %interpolating to RGI resolution
    RATE(:,:) =griddata(double(mlon),double(mlat),rate(:,:,1),double(xx),double(yy),'linear');
    
   
    r = RATE.* m.data;
        
        
     %creating .nc file,dimensions and then writing variables in
     file = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/dhdt.nc'];
     nccreate(file,'lon','Dimensions',{'lon',1,Nx},'DeflateLevel',7) ;
     nccreate(file,'lat','Dimensions',{'lat',1,Ny},'DeflateLevel',7) ;
     nccreate(file,'rate','Dimensions',{'lat','lon'},'DeflateLevel',7) ;

     ncwriteatt(file,'rate','units','m/year');
     ncwriteatt(file,'rate','long_name','Elevation Change');

     ncwrite(file,'rate',r);
     
     ncwrite(file,'lat',lat);
     ncwrite(file,'lon',lon);
end