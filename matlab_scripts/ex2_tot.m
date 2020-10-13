stringvec = ["normal","btree","nonblock","gather","reduce"];
nruns = 10;

for i=1:length(stringvec)
    mpimode = stringvec{i};
    perftable.(mpimode) = load(strcat('perf_pi_',mpimode));
    nproc.(mpimode) = perftable.(mpimode)(1:nruns:end,1);
    for j = 1:length(nproc.(mpimode))
        times.(mpimode)(j) = mean(perftable.(mpimode)(1+nruns*(j-1):nruns*j,3));
        variance.(mpimode)(j) = std(perftable.(mpimode)(1+nruns*(j-1):nruns*j,3));
    end
end 
for i=1:length(stringvec)
     errorbar(nproc.(stringvec{i}),times.(stringvec{i}),variance.(stringvec{i}),'LineWidth',2)
     hold on
     xticks(nproc.(stringvec{i}))
     set(gca,'TickLabelInterpreter','latex')
     set(gca,'FontSize',24)
     xlabel('Number of processes','interpreter','latex')
     ylabel('Execution time [s]','interpreter','latex')
     
end
legend(stringvec,'interpreter','latex')
