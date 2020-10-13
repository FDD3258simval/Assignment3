load 'ping_pong_onthenode';
load 'ping_pong_offthenode';

size_on = ping_pong_onthenode(:,1);
size_off = ping_pong_offthenode(:,1);
time_on = ping_pong_onthenode(:,2);
time_off = ping_pong_offthenode(:,2);

% Polyfit
p_on = polyfit(size_on,time_on,1);
r_on = p_on(1);
band_on = 1/r_on;
band_on_GB = band_on/(1024^3);
latency_on = p_on(2);

p_off = polyfit(size_off,time_off,1);
r_off = p_off(1);
band_off = 1/r_off;
band_off_GB = band_off/(1024^3);
latency_off = p_off(2);

p1 = plot(size_on,r_on*size_on+latency_on,'LineWidth',2);
hold on
p2 = plot(size_off,r_off*size_off+latency_off,'LineWidth',2);
plot(size_on,time_on,'*','MarkerEdgeColor',[0, 0.4470, 0.7410],'LineWidth',2)
plot(size_off,time_off,'o','MarkerEdgeColor',[0.8500, 0.3250, 0.0980],'LineWidth',2)
%xticks(size_on)
set(gca,'TickLabelInterpreter','latex')
set(gca,'FontSize',24)
xlabel('Message size [B]','interpreter','latex')
ylabel('Execution time [s]','interpreter','latex')
legend([p1, p2],'Intra-node', 'Inter-node','interpreter','latex','Location','Best')