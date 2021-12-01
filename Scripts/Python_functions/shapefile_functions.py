#This function relies on
import pyproj
from shapely.ops import transform

def reprojpoly(s_epsg,t_epsg,poly):
    """ Reprojects polygon from source epsg to target epsg and returns a 
    polygon """
    
    project = lambda x, y: pyproj.transform(pyproj.Proj(init=s_epsg)
                                        ,pyproj.Proj(init=t_epsg), x, y) 
    reproj_poly = transform(project, poly)
    return reproj_poly


