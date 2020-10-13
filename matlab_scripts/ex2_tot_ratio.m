stringvec = ["normal","btree","nonblock","gather","reduce"];
nruns = 10;

for i=1:length(stringvec)
    mpimode = stringvec{i};
    perftable.(mpimode) = load(strcat('perf_pi_',mpimode));
    nproc.(mpimode) = perftable.(mpimode)(1:nruns:end,1);
    for j = 1:length(nproc.(mpimode))
        times.(mpimode)(j) = mean(perftable.(mpimode)(1+nruns*(j-1):nruns*j,3));
    end
    for j = 1:length(nproc.(mpimode))
        variance.(mpimode)(j) = std((times.(stringvec{i})./times.normal));
    end
end 
for i=2:length(stringvec)
%      errorbar(nproc.(stringvec{i}),times.(stringvec{i})./times.normal,...
%               variance.(stringvec{i}),'LineWidth',2)
     plotvector(i-1) = plot(nproc.(stringvec{i}),times.(stringvec{i})./(times.normal),'LineWidth',2);
     hold on
     xticks(nproc.(stringvec{i}))
     set(gca,'TickLabelInterpreter','latex')
     set(gca,'FontSize',24)
     xlabel('Number of processes','interpreter','latex')
     ylabel('Execution time [s]','interpreter','latex')
end
plot(nproc.normal,times.normal./(times.normal),'k--','LineWidth',2)
stringvec_mod = ["Binary tree","Non-blocking","Collective gather","Collective reduce"];
legend([plotvector(1:4)],stringvec_mod,'interpreter','latex','Location','Best')
