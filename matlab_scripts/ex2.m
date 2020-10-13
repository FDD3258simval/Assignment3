% stringvec = ["normal","btree","nonblock","gather","reduce"];
nruns = 10;
stringvec = ["normal"];
for i=1:length(stringvec)
    mpimode = stringvec{i};
    filename = (strcat('perf_pi_',mpimode));
    perftable = load(filename);
    nproc = perftable(1:nruns:end,1);
    times = zeros(length(nproc),1);
    variance = zeros(length(nproc),1);
    for j = 1:length(nproc)
        times(j) = mean(perftable(1+nruns*(j-1):nruns*j,3));
        variance(j) = std(perftable(1+nruns*(j-1):nruns*j,3));
    end
    figure(i)
    errorbar(nproc,times,variance,'LineWidth',2)
    %set(gca,'Yscale','log')
    xticks(nproc)
    set(gca,'TickLabelInterpreter','latex')
    set(gca,'FontSize',24)
    xlabel('Number of processes','interpreter','latex')
    ylabel('Execution time [s]','interpreter','latex')
end


