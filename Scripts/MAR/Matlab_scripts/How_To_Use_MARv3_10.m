%% How to read in and plot MAR data

% The generic code below shows how to read in and plot up MAR smb data. You
% may need to change the paths to where you have data stored if required

% Load scientific colourmaps (www.fabiocrameri.ch/colourmaps.php)
load('/exports/csce/datastore/geos/groups/geos_EO/ScientificColourMaps5/bilbao/bilbao.mat');
load('/exports/csce/datastore/geos/groups/geos_EO/ScientificColourMaps5/vik/vik.mat');
load('/exports/csce/datastore/geos/groups/geos_EO/ScientificColourMaps5/batlow/batlow.mat');

%% First, read in the netcdf files
fprintf('Reading MAR Data\n'); % Display text, \n forces future stuff to be printed on the line below

% This goes to the folder in which the MAR netcdf data and saves the data
% for each file (i.e. filepath) to a structure. For example, the first MAR
% netcdf file will be images.marfiles(1), and so on. You may need to get
% access to 'ListFiles' from Noel.
images.marfiles = ListFiles('/exports/csce/datastore/geos/groups/geos_EO/development/s1659929/Cryosphere/MAR_Data/v3.10/*.nc') ;

% To view the data stored in a netcdf file, use ncdisp
ncdisp(images.marfiles(1).name); % images.marfiles(n).name is the full filepath. If using a different netcdf/nc file, you could do ncdisp('insert/path/to/file.nc') or ncfile = 'path/to/file.nc'; ncdisp(ncfile)
% On the left are the variable names (which you will need to load them in,
% and on the right are descriptions of each one (i.e. full name, fill
% value, units)

% It is important to check the variable size. Time is a 1-D vector of days.
% Lat/Lon/MSK/others are 2-D matrices (X,Y). Many of the variables are 3-D
% matrices (X,Y,Time), and some (i.e. melt production) are 4-D
% (X,Y,Sector?,Time). I'm not entirely sure which some are 4-D as the
% 'Sector' variable doesn't add anything at all (i.e. 73x135x1x366)

% Now, loop through the individual years of MAR data and load in the
% variables that you require (better to specify rather than load the lot as
% it will take ages/lots of memory and you probably dont need all of them)

fprintf('Reading Data from each MAR netcdf file\n');
for ni=length(images.marfiles):-1:1 % Looping backwards sometimes fixes a problem with matrix dimensions/size so worth trying if that ever happens during a loop  
    
    % Use ncread to read the variables you require. The variables are
    % specified by their initials which are found using ncdisp
    images.marfiles(ni).lons = ncread(images.marfiles(ni).name,'LON'); % Longitude
    images.marfiles(ni).lats = ncread(images.marfiles(ni).name,'LAT'); % Latitude
    images.marfiles(ni).MeltProd = ncread(images.marfiles(ni).name,'ME'); % Melt Production
    images.marfiles(ni).SMB = ncread(images.marfiles(ni).name,'SMB'); % SMB
    images.marfiles(ni).RF = ncread(images.marfiles(ni).name,'RF'); % Rainfall

    % Convert daily data to annual - I've kept the same names here to save
    % space but of course if you want to preserve the daily data, name them
    % images.marfiles(ni).SMB_Annual or something
    
    % Sum 4-D matrices along the fourth dimension to get an annual value of melt production (mm w.e/yr). 
    % Use nansum so it doesn't mess up if there are nans - there are 'nan' variants of all major maths functions (i.e. nanmean/nanmedian/nanstd/etc)
    images.marfiles(ni).MeltProd = nansum(images.marfiles(ni).MeltProd,4); 
    images.marfiles(ni).SMB = nansum(images.marfiles(ni).SMB,4);
    
    % Rainfall is a 3-D matrix so sum along third dimension to get annual
    images.marfiles(ni).RF = nansum(images.marfiles(ni).RF,3);
    
    % Add year to structure 
    num=ni+1979; % First year of MARv3.10 is 1980
    images.marfiles(ni).year=num;
    
    % MARv3.10 data is stored at an angle for whatever reason, so rotate 90
    % degrees. For data thats stored upside down or at 270 degrees, you can
    % stack rot90 (i.e. var = rot90(rot90(var));)
    images.marfiles(ni).lons = rot90(images.marfiles(ni).lons);
    images.marfiles(ni).lats = rot90(images.marfiles(ni).lats);
    images.marfiles(ni).MeltProd=rot90(images.marfiles(ni).MeltProd); 
    images.marfiles(ni).SMB = rot90(images.marfiles(ni).SMB);
    images.marfiles(ni).RF = rot90(images.marfiles(ni).RF);
end   


%% Basic Plotting
figure('IntegerHandle','on','Position',[200 200 600 700]); % IntegerHandle on will make sure the figure number is in sequence. Position will fix the figure size - the third and fourth arguments are xsize and ysize.
% Use imagesc to view matrix data
h = imagesc(images.marfiles(1).SMB);
% Add colourbar
c = colorbar;
% Add and format colourbar label
c.Label.String = 'SMB (mm w.e. yr^{-1})';
c.Label.FontSize = 12;
c.Label.FontName = 'Arial';
c.Label.FontWeight = 'bold';
% Colorbar limits
caxis([0 2000]);
% Change colourmap
colormap(batlow);

% To mask data in a figure, use alphadata, i.e. only show data where SMB >
% 500). This is more useful when you have a mask (i.e. if a mask value = 1
% where data is ice, set(h,'alphadata',mask == 1);)
set(h,'alphadata',images.marfiles(1).SMB > 500);
% Note that to actually remove data, you would need to do
% images.marfiles(1).SMB(images.marfiles(1).SMB < 500) = NaN;

%% Extracting Data at a Location
centre_lat = 68.9; % Centre latitude of window
centre_lon = -47.7; % Centre longitude of window

% Define window size - the way I have coded this up, the window size is
% winsize_x*2+1 by winsize_y*2+1 (i.e. so both x and y size = 2 would give
% a 5*5 window)
winsize_x = 2;
winsize_y = 2;

% Get image coordinates from input lat/lon
D = sqrt((images.marfiles(1).lons(:)-centre_lon).^2 + (images.marfiles(1).lats(:)-centre_lat).^2); % Find nearest location to input coordinates
[~,tmp_index] = min(D);
[x_ind,y_ind] = ind2sub([size(images.marfiles(1).SMB,1),size(images.marfiles(1).SMB,2)],tmp_index); % Extract x+y indices for closest location to input coords, just use first marfile for all this as they are all the same size

% Create output arrays
out_years = NaN(length(images.marfiles),1);
out_smb = NaN(length(images.marfiles),1);

for ni = 1:length(images.marfiles)
    x_px = x_ind - winsize_x:1:x_ind + winsize_x; % winsize_x pixels either side of central pixel
    y_px = y_ind - winsize_y:1:y_ind + winsize_y; % winsize_y pixels either side of central pixel
    % Extract SMB at these pixels
    smb = images.marfiles(ni).SMB(x_px,y_px);
    % Calculate mean
    mean_smb = nanmean(smb(:));
    
    % Append to output arrays
    out_years(ni) = images.marfiles(ni).year;
    out_smb(ni) = mean_smb;
end
    
%% Plotting
% Scatter plot of data
figure('IntegerHandle','on');
scatter(out_years,out_smb,'filled');
xlabel('Year','FontWeight','bold','FontSize',12,'FontName','Arial');
ylabel('SMB (mm w.e. yr^{-1})','FontWeight','bold','FontSize',12,'FontName','Arial');

% Figure with red rectangle showing window where data was extracted from
figure('IntegerHandle','on');
imagesc(images.marfiles(1).SMB); colormap(batlow); caxis([0 2000]);
rectangle('Position',[min(y_px) min(x_px) length(y_px) length(x_px)],'EdgeColor','r');

