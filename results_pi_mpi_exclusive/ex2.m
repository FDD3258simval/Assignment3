filename = input('Enter file name\n','s');
perftable = load(filename);
nruns = 10;
nproc = perftable(1:nruns:end);
times = zeros(length(nproc),1);
for i = 1:length(nproc);
   times(i) = mean(perftable(1+nrun*(i-1):nrun*i,3));
end

plot(nproc,times,'LineWidth',2)
