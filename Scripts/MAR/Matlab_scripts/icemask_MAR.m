function icemask_MAR(percentage)
%icemask_MAR(percentage of icecover)--> average timeseries for all MAR
%variables
%NOTE: this code uses original MAR data that has not been interpolated ice mask 
    time=[];
    x=0;
    SMB_tmsr = zeros(4018,1);
    RF_tmsr = zeros(4018,1);
    SF_tmsr = zeros(4018,1);
    TSH_tmsr = zeros(4018,1);
    RU_tmsr = zeros(4018,1);
    SU_tmsr = zeros(4018,1);
    ME_tmsr = zeros(4018,1);
    SC_tmsr = zeros(4018,1);
    SM_tmsr = zeros(4018,1);
    %excluded russian arctic using start and count
    startloc = [1,92];
    count = [97,inf];
    %for 3D variable
    startloc2 = [1,92,1];
    count2 = [97,inf,inf];
    %for 4D variable
    startloc1 = [1,92,1,1];
    count1 = [97, inf,inf,inf];
    msk = ncread('/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/MARv3.11.5/MARv3.11.5-6km-daily-ERA5-2010.nc','MSK',startloc,count);
    mask = msk>percentage;
    for i=10:20
        file = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/MARv3.11.5/MARv3.11.5-6km-daily-ERA5-',num2str(2000+i),'.nc'];
        SMB = ncread(file,'SMB',startloc1,count1);
        RF = ncread(file,'RF',startloc2,count2);
        SF = ncread(file,'SF',startloc2,count2);
        RU = ncread(file,'RU',startloc1,count1);
        RU(RU==max(RU(:)))=NaN;
        SU = ncread(file,'SU',startloc1,count1);
        TSH = ncread(file,'ZN6',startloc1,count1);
        ME = ncread(file,'ME',startloc1,count1);
        SM = ncread(file,'ZN5',startloc1,count1);
        SC = ncread(file,'ZN4',startloc1,count1);
        t= ncread(file,'TIME');
        i
        time=[time ;t];
        for j=1:length(t)
            x=x+1;
            smb = SMB(:,:,1,j);
            rf = RF(:,:,j);
            sf = SF(:,:,j);
            tsh = TSH(:,:,1,j);
            ru = RU(:,:,1,j);
            su = SU(:,:,1,j);
            sc = SC(:,:,1,j);
            sm = SM(:,:,1,j);
            me = ME(:,:,1,j);
            SMB_tmsr(x)= mean(smb(mask==1),'omitnan');
            RF_tmsr(x)= mean(rf(mask==1),'omitnan');
            SF_tmsr(x)= mean(sf(mask==1),'omitnan');
            TSH_tmsr(x)= mean(tsh(mask==1),'omitnan');
            RU_tmsr(x)= mean(ru(mask==1),'omitnan');
            SU_tmsr(x)= mean(su(mask==1),'omitnan');
            SC_tmsr(x)= mean(sc(mask==1),'omitnan');
            SM_tmsr(x)= mean(sm(mask==1),'omitnan');
            ME_tmsr(x)= mean(me(mask==1),'omitnan');
        end

    end
        file = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_IceArea/Original/Svalbard_',num2str(percentage),'.nc'];
        nt = length(time);
        nccreate(file,'time','Dimensions',{'time',1,nt},'DeflateLevel',7) ;
        nccreate(file,'smb_mean','Dimensions',{'time'},'DeflateLevel',7) ;
        nccreate(file,'rf_mean','Dimensions',{'time'},'DeflateLevel',7) ;
        nccreate(file,'sf_mean','Dimensions',{'time'},'DeflateLevel',7) ;
        nccreate(file,'ru_mean','Dimensions',{'time'},'DeflateLevel',7) ;
        nccreate(file,'su_mean','Dimensions',{'time'},'DeflateLevel',7) ;
        nccreate(file,'sc_mean','Dimensions',{'time'},'DeflateLevel',7) ;
        nccreate(file,'sm_mean','Dimensions',{'time'},'DeflateLevel',7) ;
        nccreate(file,'tsh_mean','Dimensions',{'time'},'DeflateLevel',7) ;
        nccreate(file,'me_mean','Dimensions',{'time'},'DeflateLevel',7) ;
        
        ncwriteatt(file,'smb_mean','units','mmWE/day');
        ncwriteatt(file,'rf_mean','units','mmWE/day');
        ncwriteatt(file,'sf_mean','units','mmWE/day');
        ncwriteatt(file,'su_mean','units','mmWE/day');
        ncwriteatt(file,'me_mean','units','mmWE/day');
        ncwriteatt(file,'tsh_mean','units','m');
        ncwriteatt(file,'ru_mean','units','mmWE/day');
        ncwriteatt(file,'sm_mean','units','m');
        ncwriteatt(file,'sc_mean','units','m');
        
        ncwriteatt(file,'smb_mean','long_name','Surface Mass Balance (SMB~SF+RF-RU-SU-SW)');
        ncwriteatt(file,'rf_mean','long_name','Rainfall');
        ncwriteatt(file,'sf_mean','long_name','Snowfall');
        ncwriteatt(file,'su_mean','long_name','Sublimation and evaporation');
        ncwriteatt(file,'me_mean','long_name','Meltwater production');
        ncwriteatt(file,'tsh_mean','long_name','Total snowheight change (compaction + melt)');
        ncwriteatt(file,'ru_mean','long_name','Run-off of meltwater and rain water');
        ncwriteatt(file,'sc_mean','long_name','Snowheight change (compaction)');
        ncwriteatt(file,'sm_mean','long_name','Snowheight change (melt)');
       
        ncwrite(file,'smb_mean',SMB_tmsr);
        ncwrite(file,'rf_mean',RF_tmsr);
        ncwrite(file,'ru_mean',RU_tmsr);
        ncwrite(file,'su_mean',SU_tmsr);
        ncwrite(file,'sc_mean',SC_tmsr);
        ncwrite(file,'sm_mean',SM_tmsr);
        ncwrite(file,'me_mean',ME_tmsr);
        ncwrite(file,'sf_mean',SF_tmsr);
        ncwrite(file,'tsh_mean',TSH_tmsr);
        ncwrite(file,'time',time);
    end