function dhdtMSK(tifname)
%marMSK (root tif (eg RGI mask for Svalbard))--> masks MAR data --> .nc file
%outputing 
    %Creates mesh for the RGI mask
    [a,m]=readfile(tifname);
    [xx,yy]=readfile2meshgrid(m);
    %creates lat and lon arrays to become coordinates in .nc (and to help with xarray in python)
    %lat and lon in MAR are 2-d grids this converts to 1-d.
    xstart = 10.7139;
    ystart = 80.4708;
    Nx = 487;
    Ny = 430;
    lon = xstart + times((0:Nx-1),0.0360);
    lat = ystart + times((0:Ny-1),-0.0090);
    %Read in MAR files, loop through all years and picks out the wanted
    %variables. To see full list ncdisp and or go to Timeseries notebook.
   
    dhdtf = ['/exports/csce/datastore/geos/groups/geos_EO/PROCESS/Svalbard_dhdt/dhdt.nc'];
    rate = ncread(dhdtf, 'rate');
    rf = ncread(dhdtf, 'RF');
    sf = ncread(dhdtf, 'SF');
    me = ncread(dhdtf, 'ME');
    tsh = ncread(dhdtf, 'ZN6'); 
 
    mlat = ncread(dhdtf, 'LAT');
    mlon = ncread(dhdtf, 'LON');
    t = ncread(dhdtf, 'TIME');
     %Preallocation of memory, increases speed of loop.
    RATE = zeros(430,487,nt);
    RF = zeros(430,487,nt);
    SF = zeros(430,487,nt);
    ME = zeros(430,487,nt);

        
        
         %project variable on to the mesh of RGI mask(tifname),
         %interpolating to RGI resolution
     RATE(:,:,ni) =griddata(double(mlon),double(mlat),rate(:,:),double(xx),double(yy),'linear');
     RF(:,:,ni) = griddata(double(mlon),double(mlat),rf(:,:,ni),double(xx),double(yy),'linear'); 
     SF(:,:,ni) = griddata(double(mlon),double(mlat),sf(:,:,ni),double(xx),double(yy),'linear');
     ME(:,:,ni) = griddata(double(mlon),double(mlat),me(:,:,1,ni),double(xx),double(yy),'linear');
      
    
        %creating .nc file,dimensions and then writing variables in
     file = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Years/Sval_MARv3.11.5-6km-daily-ERA5-',num2str(2000+nj),'.nc'];
     nx = 487;
     nccreate(file,'lon','Dimensions',{'lon',1,nx},'DeflateLevel',7) ;
     ny = 430;
     nccreate(file,'lat','Dimensions',{'lat',1,ny},'DeflateLevel',7) ;
     nccreate(file,'time','Dimensions',{'time',1,t},'DeflateLevel',7) ;
     nccreate(file,'smb','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
     nccreate(file,'rf','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
     nccreate(file,'sf','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;

        
     ncwriteatt(file,'rate','units','m/year');
     ncwriteatt(file,'rf','units','mmWE/day');
     ncwriteatt(file,'sf','units','mmWE/day');
     ncwriteatt(file,'su','units','mmWE/day');
     ncwriteatt(file,'me','units','mmWE/day');

        
     ncwriteatt(file,'rate','long_name','Elevation Change Rate');
     ncwriteatt(file,'rf','long_name','Rainfall');
     ncwriteatt(file,'sf','long_name','Snowfall');
     ncwriteatt(file,'su','long_name','Sublimation and evaporation');
    
        
        
     ncwrite(file,'sh',TSH);
     ncwrite(file,'ru',RU);
     ncwrite(file,'su',SU);
     ncwrite(file,'sf',SF);
     ncwrite(file,'me',ME);
     ncwrite(file,'smb',RATE);
        ncwrite(file,'rf',RF);
        ncwrite(file,'time',t);
        ncwrite(file,'lon',lon);
        ncwrite(file,'lat',lat);
    end
end
