% script to get ocean properties to glaciers
clear; close all;

product = 'ORAS5'; % ORAS5 or EN4 or ASTE or CHORE

% load glaciers structure to this point
load glaciers.mat

% load ocean output
if strcmp(product,'ORAS5'),
    load ocean_ORAS5_glaciers.mat
elseif strcmp(product,'EN4'),
    load ocean_EN4_glaciers.mat
elseif strcmp(product,'ASTE'),
    load ocean_ASTE_glaciers.mat
elseif strcmp(product,'CHORE'),
    load ocean_CHORE_glaciers.mat
end

% loop over glaciers and assign ocean properties
for ii=1:length(glaciers),

    if glaciers(ii).ocean.(product).effdepth<-25,
        
        ind = find(morlighem_n==glaciers(ii).morlighem_number);        
        Tii = squeeze(potentialT(ind,:,:));
        Sii = squeeze(practicalS(ind,:,:));
        z_inds = find(z>glaciers(ii).ocean.(product).effdepth);
        glaciers(ii).ocean.(product).z = single([z(z_inds)';glaciers(ii).ocean.(product).effdepth;glaciers(ii).gldepth]);

        for j=1:length(t),

            interpinds = [z_inds';z_inds(end)+1];
            effdepth_potentialT = interp1(z(interpinds),squeeze(Tii(interpinds,j)),glaciers(ii).ocean.(product).effdepth,'linear',NaN);
            effdepth_practicalS = interp1(z(interpinds),squeeze(Sii(interpinds,j)),glaciers(ii).ocean.(product).effdepth,'linear',NaN);
            glaciers(ii).ocean.(product).potentialT(:,j) = single([Tii(z_inds,j);effdepth_potentialT;effdepth_potentialT]);
            glaciers(ii).ocean.(product).practicalS(:,j) = single([Sii(z_inds,j);effdepth_practicalS;effdepth_practicalS]);
            glaciers(ii).ocean.(product).potentialT_GL(j) = single(glaciers(ii).ocean.(product).potentialT(end,j));
            glaciers(ii).ocean.(product).practicalS_GL(j) = single(glaciers(ii).ocean.(product).practicalS(end,j));

        end
        
        glaciers(ii).ocean.(product).t = single(t);
        
    else
        
        glaciers(ii).ocean.(product).z = NaN;
        glaciers(ii).ocean.(product).potentialT = NaN;
        glaciers(ii).ocean.(product).practicalS = NaN;
        glaciers(ii).ocean.(product).t = NaN;
        glaciers(ii).ocean.(product).potentialT_GL = NaN;
        glaciers(ii).ocean.(product).practicalS_GL = NaN;    
    
    end

end

save glaciers.mat glaciers