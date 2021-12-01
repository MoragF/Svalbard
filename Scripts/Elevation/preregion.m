%preregion('.m','.tif','newfilename') : uses saved coords of already processed polygons to use on
%other root tifs
%prexy : preexisting x,y from .m
%tifname : name of root tif
%rname: wanted name of output tif
function preregion(prexy,tifname,rname)  
    prer=matfile(prexy);
    x=prer.x;
    y=prer.y;
    [a,m]= readfile(tifname);
    figure;showigram(m);
    hold on
    plot(x,y,'r')
    [xx,yy]=readfile2meshgrid(m);
    IN=inpolygon(xx,yy,x,y);
    mnew=m;
    mnew.data=m.data.*IN;
    figure;imagesc(mnew.data)
    opt.outfile= rname;
    writefile(mnew,opt)
  
end



%loop to create multiple masks for multiply regions from one root tif.
%eg mask for all 6 regions from land only termintating glaciers on Svalbard
%preregion('.m','.tif','newfilename') see preregion.m

