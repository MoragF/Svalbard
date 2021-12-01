function MAR_tmsr
%MAR_tmsr--> .nc of tmsr for all variables for the region over time
    [a,b] = readfile(['/exports/csce/datastore/geos/groups/geos_EO/L0data/GLIMS/RGI_6.0/Svalbard_Masks/uncorr/07_rgi60_Svalbard.tif']);
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
    for i=10:20
        file = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Years/Sval_MARv3.11.5-6km-daily-ERA5-',num2str(2000+i),'.nc'];
        SMB = ncread(file,'smb');
        RF = ncread(file,'rf');
        SF = ncread(file,'sf');
        RU = ncread(file,'ru');
        RU(RU==max(RU(:)))=NaN;
        SU = ncread(file,'su');
        TSH = ncread(file,'sh');
        ME = ncread(file,'me');
        SM = ncread(file,'sm');
        SC = ncread(file,'sc');
        t= ncread(file,'time');
        
        i
        time=[time ;t];
        for j=1:length(t)
            x=x+1;
            smb = SMB(:,:,j);
            rf = RF(:,:,j);
            sf = SF(:,:,j);
            tsh = TSH(:,:,j);
            ru = RU(:,:,j);
            su = SU(:,:,j);
            sc = SC(:,:,j);
            sm = SM(:,:,j);
            me = ME(:,:,j);
            SMB_tmsr(x)= mean(smb(b.data==1),'omitnan');
            RF_tmsr(x)= mean(rf(b.data==1),'omitnan');
            SF_tmsr(x)= mean(sf(b.data==1),'omitnan');
            TSH_tmsr(x)= mean(tsh(b.data==1),'omitnan');
            RU_tmsr(x)= mean(ru(b.data==1),'omitnan');
            SU_tmsr(x)= mean(su(b.data==1),'omitnan');
            SC_tmsr(x)= mean(sc(b.data==1),'omitnan');
            SM_tmsr(x)= mean(sm(b.data==1),'omitnan');
            ME_tmsr(x)= mean(me(b.data==1),'omitnan');
        end

    end
        file = '/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked_IceArea/Svalbard.nc';
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
