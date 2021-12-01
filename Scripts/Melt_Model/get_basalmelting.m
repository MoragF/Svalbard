% script to estimate basal melting for glaciers structure
clear; close all;

% ice velocity data
fname = '../ice_velocity/greenland_ice_velocity_map_winter_2017_2018_v1_0/greenland_iv_500m_s1_20171228_20180228_v1_0.nc';
x = ncread(fname,'x');
y = ncread(fname,'y');
[X,Y] = meshgrid(x,y);
v = ncread(fname,'land_ice_surface_velocity_magnitude');

% constants
tau = 150e3; % Pa
L = 3.34e5; % J/kg
rho_i = 910; % kg/m3
rho_fw = 1000;  % kg/m3
v = v/86400; % m/s

% calculate frictional melt in mwe/s from tau*v = rhoi*L*mdot
M = (rho_i/rho_fw)*tau*v/(rho_i*L);
M = M';

% load drainage basins
load drainagebasins.mat

% interpolate basal melt rates onto BM3 grid
[Xbm3,Ybm3] = meshgrid(x,y);
M = interp2(X,Y,M,Xbm3,Ybm3);

% load glaciers structure
load glaciers.mat

% loop over glaciers summing basal melt for the basins
for i=1:length(glaciers),
    % get linear indices of basin
    inds = find(drainagebasins==i);    
    % sum basal melt over basin
    glaciers(i).basalmelt = 150*150*nansum(M(inds));  
end

% save structure
save glaciers.mat glaciers

