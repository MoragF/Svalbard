{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 19,
   "metadata": {},
   "outputs": [],
   "source": [
    "import numpy as np\n",
    "import pandas as pd\n",
    "import struct\n",
    "import xarray as xr"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 20,
   "metadata": {},
   "outputs": [],
   "source": [
    "grids = {}\n",
    "\n",
    "for i in ['lon','lat']:\n",
    "\n",
    "    grid = np.array(pd.read_csv(f'grids/{i}grid.dat',header=None, delim_whitespace=True))\n",
    "\n",
    "    flat_grid = grid.ravel()\n",
    "\n",
    "    shaped_grid = flat_grid.reshape(360,120)\n",
    "    \n",
    "    grids[i] = shaped_grid\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 21,
   "metadata": {},
   "outputs": [],
   "source": [
    "def process_piomass(year):\n",
    "    \n",
    "    binary_dir = f'binaries/heff.H{year}'\n",
    "    \n",
    "    ############################################################\n",
    "    \n",
    "    # Read File\n",
    "    \n",
    "    with open(binary_dir, mode='rb') as file:\n",
    "    \n",
    "        fileContent = file.read()\n",
    "        data = struct.unpack(\"f\" * (len(fileContent)// 4), fileContent)\n",
    "        \n",
    "    ############################################################\n",
    "    \n",
    "    # Put it in a 3D array\n",
    "        \n",
    "        native_data = np.full((12,360,120),np.nan)\n",
    "\n",
    "        for month in range(1,13):\n",
    "            \n",
    "            start = (month-1)*(360*120)\n",
    "            end = month*(360*120)\n",
    "            thickness_list = np.array(data[start:end])\n",
    "            \n",
    "            gridded = thickness_list.reshape(360,120)\n",
    "            native_data[month-1,:,:] = gridded\n",
    "            \n",
    "          \n",
    "    ############################################################\n",
    "        \n",
    "    # Output to NetCDF4\n",
    "        \n",
    "        ds = xr.Dataset( data_vars={'thickness':(['t','x','y'],native_data)},\n",
    "\n",
    "                         coords =  {'lon':(['x','y'],grids['lon']),\n",
    "                                    'lat':(['x','y'],grids['lat']),\n",
    "                                    'month':(['t'],np.array(range(1,13)))})\n",
    "        \n",
    "        ds.attrs['data_name'] = 'Monthly mean Piomass sea ice thickness data'\n",
    "        \n",
    "        ds.attrs['description'] = 'Sea ice thickness in meters on the native 360x120 grid, \\\n",
    "                                    data produced by University of Washington Polar Science Center'\n",
    "        \n",
    "        ds.attrs['year'] = f'these data are for the year {year}'\n",
    "        \n",
    "        ds.attrs['citation'] = 'When using this data please use the citation:\\\n",
    "                                Zhang, Jinlun and D.A. Rothrock: Modeling global sea \\\n",
    "                                ice with a thickness and enthalpy distribution model \\\n",
    "                                in generalized curvilinear coordinates, \\\n",
    "                                Mon. Wea. Rev. 131(5), 681-697, 2003.'\n",
    "        \n",
    "        ds.attrs['code to read'] = \"\"\"  # Example code to read a month of this data\n",
    "        \n",
    "                                        def regrid_piomass_to_EASE(year,month):\n",
    "    \n",
    "                                            data_dir = 'output/'\n",
    "\n",
    "                                            with xr.open_dataset(f'{data_dir}{year}.nc') as data:\n",
    "\n",
    "                                                ds_month = data.where(int(month) == data.month, drop=True)\n",
    "\n",
    "                                                return(ds_month)\"\"\"\n",
    "        \n",
    "        \n",
    "\n",
    "        output_dir = f'output/'\n",
    "\n",
    "        ds.to_netcdf(f'{output_dir}{year}.nc','w')\n",
    "        "
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 22,
   "metadata": {},
   "outputs": [],
   "source": [
    "for year in range(1993,1994):\n",
    "    \n",
    "    process_piomass(year)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.7.6"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
