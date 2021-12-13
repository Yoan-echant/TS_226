close all
clear

load NC1
load NC2
load NC3
load NC4
figure(1)
semilogy(EbN0dB,Pb_u,'--', 'LineWidth',1.5,'DisplayName','$P_b$ (BPSK th\''eorique)');
hold all
semilogy(EbN0dB,Pe_u,'--', 'LineWidth',1.5,'DisplayName','$P_e$ (BPSK th\''eorique)');


semilogy(EbN0dB,TEB1,       'LineWidth',1.5, 'DisplayName','TEB1 MC non cod\''ee'  );
semilogy(EbN0dB,TEP1,       'LineWidth',1.5, 'DisplayName','TEP1 MC non cod\''ee'  );
semilogy(EbN0dB,TEB2,       'LineWidth',1.5, 'DisplayName','TEB2 MC non cod\''ee'  );
semilogy(EbN0dB,TEP2,       'LineWidth',1.5, 'DisplayName','TEP2 MC non cod\''ee'  );
semilogy(EbN0dB,TEB3,       'LineWidth',1.5, 'DisplayName','TEB3 MC non cod\''ee'  );
semilogy(EbN0dB,TEP3,       'LineWidth',1.5, 'DisplayName','TEP3 MC non cod\''ee'  );
semilogy(EbN0dB,TEB4,       'LineWidth',1.5, 'DisplayName','TEB4 MC non cod\''ee'  );
semilogy(EbN0dB,TEP4,       'LineWidth',1.5, 'DisplayName','TEP4 MC non cod\''ee'  );
ylim([1e-6 1])
xlim([0 15])
grid on
xlabel('$\frac{E_b}{N_0}$ en dB','Interpreter', 'latex', 'FontSize',14)
ylabel('TEB / TEP','Interpreter', 'latex', 'FontSize',14)
legend('Interpreter', 'latex', 'FontSize',14);