function elevmultiplot(nR,fname)
    labels= NaN(nR,1);
    colour = colormap(jet(9))
    figure();
    hold all
    for i = 1:nR
        name = ['R',num2str(i)];
        data = matfile(['/geos/d14/CS2/dhdt/Timeseries/Svalbard_LR',num2str(i),'_MF/tmsr_45_90_07_rgi60_Svalbard_corr_land_R',num2str(i),'.mat']);
        plot(data.time,data.Tmsr,'k','Linewidth',1,'DisplayName',name,'color',colour(i,:));    
    end
    datetick('x','yyyy');
    xlabel('Time','Fontsize',10); ylabel('Elevation [m]','Fontsize',10);
    legend('Location','southwest');
    title('Svalbard Land Terminating: Elevation Change')
    axis tight
    hold off
    print(fname, '-djpeg')
end

