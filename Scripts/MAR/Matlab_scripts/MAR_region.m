function MAR_region(R,type)
%MAR_region(R, type)--> .nc all variables for the region over time
%R --> number of regions
%type --> 0 - land , 1 - marine
%remember to change files
    %creates lat and lon arrays to become coordinates in .nc (and to help with xarray in python)
    %lat and lon in MAR are 2-d grids this converts to 1-d.
    xstart = 10.7139;
    ystart = 80.4708;
    Nx = 487;
    Ny = 430;
    lon = xstart + times((0:Nx-1),0.0360);
    lat = ystart + times((0:Ny-1),-0.0090);
    if type == 0
        rgipath = '/home/s1423313/Documents/Sense_EDI/Svalbard/Regions/Region_Masks/07_rgi60_Svalbard_corr_land_R';
        svpath = '/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Svalbard_LR';
    elseif type == 1
        rgipath = '/home/s1423313/Documents/Sense_EDI/Svalbard/Regions/Region_Masks/07_rgi60_Svalbard_corr_land_M' ;
        svpath = '/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Svalbard_MR';
    end
    
    for r=1:R
        [a,m] = readfile([rgipath,num2str(R),'.tif']);
        time=[];
        x=0;
        SMB_r = zeros(430,487,6939);
        RF_r = zeros(430,487,6939);
        SF_r = zeros(430,487,6939);
        SH_r = zeros(430,487,6939);
        RU_r = zeros(430,487,6939);
        SU_r = zeros(430,487,6939);
        ME_r = zeros(430,487,6939);
        for i=0:18
            file = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Years/Svalbard_',num2str(2000+i+1),'.nc']
            SMB = ncread(file,'smb');
            RF = ncread(file,'rf');
            SF = ncread(file,'sf');
            RU = ncread(file,'ru');
            SU = ncread(file,'su');
            SH = ncread(file,'sh');
            ME = ncread(file,'me');
            t= ncread(file,'time');
            i
            time=[time ;t];
            for j=1:length(t)
                x=x+1;
                smb = SMB(:,:,j);
                rf = RF(:,:,j);
                sf = SF(:,:,j);
                sh = SH(:,:,j);
                ru = RU(:,:,j);
                su = SU(:,:,j);
                me = ME(:,:,j);
                SMB_r(:,:,x)= smb(m.data==1);
                RF_r(:,:,x)= rf(m.data==1);
                SF_r(:,:,x)= sf(m.data==1);
                SH_r(:,:,x)= sh(m.data==1);
                RU_r(:,:,x)= ru(m.data==1);
                SU_r(:,:,x)= su(m.data==1);
                ME_r(:,:,x)= me(m.data==1);
            end

        end
        file = [svpath,num2str(r),'.nc'];
        nt = length(time);
        nx = 487;
        nccreate(file,'lon','Dimensions',{'lon',1,nx},'DeflateLevel',7) ;
        ny = 430;
        nccreate(file,'lat','Dimensions',{'lat',1,ny},'DeflateLevel',7) ;
        nccreate(file,'time','Dimensions',{'time',1,nt},'DeflateLevel',7) ;
        nccreate(file,'smb_mean','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'rf_mean','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'sf_mean','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'ru_mean','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'su_mean','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'sh_mean','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'me_mean','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        
        ncwrite(file,'smb_mean',SMB_r);
        ncwrite(file,'rf_mean',RF_r);
        ncwrite(file,'ru_mean',RU_r);
        ncwrite(file,'su_mean',SU_r);
        ncwrite(file,'me_mean',ME_r);
        ncwrite(file,'sf_mean',SF_r);
        ncwrite(file,'sh_mean',SH_r);
        ncwrite(file,'time',time);
        ncwrite(file,'lon',lon);
        ncwrite(file,'lat',lat);
    end
 end
