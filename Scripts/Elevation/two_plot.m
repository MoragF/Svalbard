function two_plot(n,fname)
    data_M = matfile(['/geos/d14/CS2/dhdt/Timeseries/Svalbard_MR',num2str(n),'_MF3D/tmsr_45_90_07_rgi60_Svalbard_corr_marine_R',num2str(n),'_3Dgrid.mat']);
    E=data_M.tmsr
    data_L = matfile(['/geos/d14/CS2/dhdt/Timeseries/Svalbard_LR',num2str(n),'_MF/tmsr_45_90_07_rgi60_Svalbard_corr_land_R',num2str(n),'.mat']);
    plot(data_L.time,data_L.Tmsr,data_M.time,E.medianHcorr,'k','Linewidth',1);  
    title(fname)
    legend('Land Terminating','Marine Terminating')
    datetick('x','yyyy');
    xlabel('Time'); ylabel('Elevation [m]');
    legend('Location','southwest');
    axis tight
    saveas(gcf,fname)
end