load 'perf_pi';
load 'perf_pi_btree';
load 'perf_pi_nonblock';
load 'perf_pi_gather';
load 'perf_pi_reduce';

nruns = 10;
nproc = perftable(1:nruns:end);
times = zeros(length(nproc),1);
for i = 1:length(nproc);
   times(i) = mean(perftable(1+nrun*(i-1):nrun*i,3));
end

plot(nproc,times,'LineWidth',2)
