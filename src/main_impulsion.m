%% Parametres
% -------------------------------------------------------------------------
K = 1024; % Nombre de bits de message
N = 1024; % Nombre de bits codés par trame (codée)

R = K/N; % Rendement de la communication

M = 2;   % Modulation BPSK <=> 2 symboles

EbN0dB_min  = 0; % Minimum de EbN0
EbN0dB_max  = 10; % Maximum de EbN0
EbN0dB_step = 1;% Pas de EbN0


TEBMin     = 1e-5; % BER min

EbN0dB  = EbN0dB_min:EbN0dB_step:EbN0dB_max;     % Points de EbN0 en dB à simuler
EbN0    = 10.^(EbN0dB/10);% Points de EbN0 à simuler
EsN0    = R*log2(M)*EbN0; % Points de EsN0
sigmaz2 = 1./(2 * EsN0);  % Variance de bruit pour chaque EbN0

%% Initialisation des vecteurs de résultats
TEP1=zeros(size(EbN0));
TEP2=zeros(size(EbN0));
TEP3=zeros(size(EbN0));
TEP4=zeros(size(EbN0));

Pb_u = qfunc(sqrt(2*EbN0)); % Probabilité d'erreur non codée
Pe_u = 1-(1-Pb_u).^K;

%% Préparation de l'affichage
figure(1)
semilogy(EbN0dB,Pb_u,'--', 'LineWidth',1.5,'DisplayName','Pb (BPSK théorique)');
hold all
semilogy(EbN0dB,Pe_u,'--', 'LineWidth',1.5,'DisplayName','Pe (BPSK théorique)');
hTEP1 = semilogy(EbN0dB,TEP1,'LineWidth',1.5,'XDataSource','EbN0dB', 'YDataSource','TEP1', 'DisplayName','TEP1 Impulsion');
hTEP2 = semilogy(EbN0dB,TEP2,'LineWidth',1.5,'XDataSource','EbN0dB', 'YDataSource','TEP2', 'DisplayName','TEP2 Impulsion');
hTEP3 = semilogy(EbN0dB,TEP3,'LineWidth',1.5,'XDataSource','EbN0dB', 'YDataSource','TEP3', 'DisplayName','TEP3 Impulsion');
hTEP4 = semilogy(EbN0dB,TEP4,'LineWidth',1.5,'XDataSource','EbN0dB', 'YDataSource','TEP4', 'DisplayName','TEP4 Impulsion');
ylim([1e-6 1])
grid on
xlabel('$\frac{E_b}{N_0}$ en dB','Interpreter', 'latex', 'FontSize',14)
ylabel('TEB / TEP','Interpreter', 'latex', 'FontSize',14)
legend()

%% Simulation
s_i = 0;                        %Défintion de l'état initial
closed = false;
   
trellis1=poly2trellis(2,[2,3]); %Définition du trellis
trellis2=poly2trellis(3,[5,7]);
trellis3=poly2trellis(4,[13,15]);
trellis4=poly2trellis(7,[133,171]);


for i=1:length(EbN0)
    TEP1(i)=Methode_imp(K,N,R,EbN0(i),trellis1,s_i,closed);
    TEP2(i)=Methode_imp(K,N,R,EbN0(i),trellis2,s_i,closed);
    TEP3(i)=Methode_imp(K,N,R,EbN0(i),trellis3,s_i,closed);
    TEP4(i)=Methode_imp(K,N,R,EbN0(i),trellis4,s_i,closed);
    refreshdata(hTEP1);
    refreshdata(hTEP2);
    refreshdata(hTEP3);
    refreshdata(hTEP4);
    
end

refreshdata(hTEP1);
refreshdata(hTEP2);
refreshdata(hTEP3);
refreshdata(hTEP4);
drawnow limitrate
    
