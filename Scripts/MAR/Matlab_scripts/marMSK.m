function marMSK(tifname)
%marMSK (root tif (eg RGI mask for Svalbard))--> masks MAR data --> .nc file
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
    for nj = 10:20
        MARf = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/MARv3.11.5/MARv3.11.5-6km-daily-ERA5-',num2str(2000+nj),'.nc'];
        sc = ncread(MARf,'ZN4');
        sm = ncread(MARf,'ZN5');
        smb = ncread(MARf, 'SMB');
        rf = ncread(MARf, 'RF');
        sf = ncread(MARf, 'SF');
        me = ncread(MARf, 'ME');
        tsh = ncread(MARf, 'ZN6'); 
        su = ncread(MARf,'SU');
        ru = ncread(MARf,'RU');
        ru(ru==max(ru(:)))=NaN;
        mlat = ncread(MARf, 'LAT');
        mlon = ncread(MARf, 'LON');
        t = ncread(MARf, 'TIME');
        nt = length(t);
        %Preallocation of memory, increases speed of loop.
        SC = zeros(Ny,Nx,nt);
        SM = zeros(Ny,Nx,nt);
        SMB = zeros(Ny,Nx,nt);
        RF = zeros(Ny,Nx,nt);
        SF = zeros(Ny,Nx,nt);
        ME = zeros(Ny,Nx,nt);
        TSH = zeros(Ny,Nx,nt);
        SU = zeros(Ny,Nx,nt);
        RU = zeros(Ny,Nx,nt);
        for ni = 1:nt
            %project variable on to the mesh of RGI mask(tifname),
            %interpolating to RGI resolution
            SMB(:,:,ni) =griddata(double(mlon),double(mlat),smb(:,:,1,ni),double(xx),double(yy),'linear');
            RF(:,:,ni) = griddata(double(mlon),double(mlat),rf(:,:,ni),double(xx),double(yy),'linear'); 
            SF(:,:,ni) = griddata(double(mlon),double(mlat),sf(:,:,ni),double(xx),double(yy),'linear');
            ME(:,:,ni) = griddata(double(mlon),double(mlat),me(:,:,1,ni),double(xx),double(yy),'linear');
            TSH(:,:,ni) = griddata(double(mlon),double(mlat),double(tsh(:,:,1,ni)),double(xx),double(yy),'linear');
            SU(:,:,ni) = griddata(double(mlon),double(mlat),su(:,:,1,ni),double(xx),double(yy),'linear');
            RU(:,:,ni) = griddata(double(mlon),double(mlat),ru(:,:,1,ni),double(xx),double(yy),'linear');
            SC(:,:,ni) = griddata(double(mlon),double(mlat),double(sc(:,:,1,ni)),double(xx),double(yy),'linear');
            SM(:,:,ni) = griddata(double(mlon),double(mlat),double(sm(:,:,1,ni)),double(xx),double(yy),'linear');
            ni
        end
        nj
        %creating .nc file,dimensions and then writing variables in
        file = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Years/Sval_MARv3.11.5-6km-daily-ERA5-',num2str(2000+nj),'.nc'];
        nccreate(file,'lon','Dimensions',{'lon',1,Nx},'DeflateLevel',7) ;
        nccreate(file,'lat','Dimensions',{'lat',1,Ny},'DeflateLevel',7) ;
        nccreate(file,'time','Dimensions',{'time',1,nt},'DeflateLevel',7) ;
        nccreate(file,'smb','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'rf','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'sf','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'su','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'me','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'tsh','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'ru','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'sc','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'sm','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
 
        ncwriteatt(file,'sc','units','m');
        ncwriteatt(file,'sm','units','m');
        ncwriteatt(file,'smb','units','mmWE/day');
        ncwriteatt(file,'rf','units','mmWE/day');
        ncwriteatt(file,'sf','units','mmWE/day');
        ncwriteatt(file,'su','units','mmWE/day');
        ncwriteatt(file,'me','units','mmWE/day');
        ncwriteatt(file,'tsh','units','m');
        ncwriteatt(file,'ru','units','mmWE/day');
        ncwriteatt(file,'smb','long_name','Surface Mass Balance (SMB~SF+RF-RU-SU-SW)');
        ncwriteatt(file,'rf','long_name','Rainfall');
        ncwriteatt(file,'sf','long_name','Snowfall');
        ncwriteatt(file,'su','long_name','Sublimation and evaporation');
        ncwriteatt(file,'me','long_name','Meltwater production');
        ncwriteatt(file,'tsh','long_name','Total snowheight change (compaction + melt)');
        ncwriteatt(file,'ru','long_name','Run-off of meltwater and rain water');
        ncwriteatt(file,'sm','long_name','Snowheight change due to melt');
        ncwriteatt(file,'sc','long_name','Snowheight change due to compac');
        
        ncwrite(file,'tsh',TSH);
        ncwrite(file,'ru',RU);
        ncwrite(file,'su',SU);
        ncwrite(file,'sf',SF);
        ncwrite(file,'me',ME);
        ncwrite(file,'smb',SMB);
        ncwrite(file,'rf',RF);
        ncwrite(file,'time',t);
        ncwrite(file,'lon',lon);
        ncwrite(file,'lat',lat);
        ncwrite(file,'sm',SM);
        ncwrite(file,'sc',SC);
    end
end
