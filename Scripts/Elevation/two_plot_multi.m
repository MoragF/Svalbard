function two_plot_multi(n,fname)
    %title(['Svalbard: Elevation Change'])
    labels = ["(SE)","(N)","(C)", "(NW)", "(SW)", "(S)"];
    for i=2:n
        subplot(3,2,i);
        data_M = matfile(['/geos/d14/CS2/dhdt/Timeseries/Svalbard_MR',num2str(i),'_MF/tmsr_45_90_07_rgi60_Svalbard_corr_marine_R',num2str(i),'.mat']);
        data_L = matfile(['/geos/d14/CS2/dhdt/Timeseries/Svalbard_LR',num2str(i),'_MF/tmsr_45_90_07_rgi60_Svalbard_corr_land_R',num2str(i),'.mat']);
        
        plot(data_L.time,data_L.Tmsr,data_M.time,data_M.Tmsr,'k','Linewidth',1);
        title(['R',num2str(i)]);
        legend('Land Terminating','Marine Terminating');
        legend('Location','southwest');
        datetick('x','yyyy');
        xlabel('Time'); ylabel('Elevation [m]');
        axis tight
        ylim([-8 2])
    end
   
    saveas(gcf,fname)
end