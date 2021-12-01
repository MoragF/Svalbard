% region('.tif','newfilename'): uses ginput to cute a olygon out of oringal tif to create a tif of
% wanted region, it also saves the polygon co-ords (to be used again in preregion)
%tifname : root tif
%rname : name of saved output tif of new region

function region(tifname,rname)
    [a,m]= readfile(tifname);
    set(gcf,'Units', 'Normalized','OuterPosition',[0 0 1 1])
    figure;showigram(m);
   
    [x,y]=ginput;
    hold on
    plot(x,y,'r')
    [xx,yy]=readfile2meshgrid(m);
    IN=inpolygon(xx,yy,x,y);
    mnew=m;
    mnew.data=m.data.*IN;
    figure;imagesc(mnew.data)
    %opt.outfile= rname;
    %writefile(mnew,opt)
    save(rname,'x','y')
end
