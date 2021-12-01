function Runoff_MM(tif,percentage)
%MAR_tmsr_icemsk(percentage of icecover)--> average timeseries for all MAR
%variables
%NOTE: this code uses ice mask that has been interpolated on the rgi grid
    [a,b] = readfile(tif);
    time=[];
    x=0;

    RU_tmsr = zeros(4018,1);
    msk = ncread('/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Years/Sval_MARv3.11.5-6km-daily-ERA5-2010.nc','icemsk');
    mask = msk>percentage;
    comb_mask = mask.* b.data==1;
    for i=10:20
        file = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Years/Sval_MARv3.11.5-6km-daily-ERA5-',num2str(2000+i),'.nc'];

        RU = ncread(file,'ru');
        RU(RU==max(RU(:)))=NaN;
        t= ncread(file,'time');       
        i
        time=[time ;t];
        for j=1:length(t)
            x=x+1;
            ru = RU(:,:,j);
            RU_tmsr(x)= nansum(ru(comb_mask==1));

        end

    end
        file = '/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/MeltModel/GlaciersRO.nc';
        nt = length(time);
        nccreate(file,'time','Dimensions',{'time',1,nt},'DeflateLevel',7) ;
        nccreate(file,'Glacier_26','Dimensions',{'time'},'DeflateLevel',7) ;

        ncwriteatt(file,'Glacier_26','units','mmWE/day');
        ncwriteatt(file,'Glacier_26','long_name','Run-off of meltwater and rain water');


        ncwrite(file,'Glacier_26',RU_tmsr);

        ncwrite(file,'time',time);
    end
 

   
     