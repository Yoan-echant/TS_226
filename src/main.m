clear
clc

%% Parametres
% -------------------------------------------------------------------------
K = 1024; % Nombre de bits de message
N = 1024; % Nombre de bits codés par trame (codée)

R = K/N; % Rendement de la communication

M = 2;   % Modulation BPSK <=> 2 symboles

EbN0dB_min  = -2; % Minimum de EbN0
EbN0dB_max  = 10; % Maximum de EbN0
EbN0dB_step = 0.5;% Pas de EbN0

nbrErreur  = 100;  % Nombre d'erreurs à observer avant de calculer un BER
nbrBitMax = 100e6;% Nombre de bits max à simuler
TEBMin     = 1e-5; % BER min

EbN0dB  = EbN0dB_min:EbN0dB_step:EbN0dB_max;     % Points de EbN0 en dB à simuler
EbN0    = 10.^(EbN0dB/10);% Points de EbN0 à simuler
EsN0    = R*log2(M)*EbN0; % Points de EsN0
sigmaz2 = 1./(2 * EsN0);  % Variance de bruit pour chaque EbN0

%% Initialisation des vecteurs de résultats
TEP1 = zeros(1,length(EbN0dB));
TEP2 = zeros(1,length(EbN0dB));
TEP3 = zeros(1,length(EbN0dB));
TEP4 = zeros(1,length(EbN0dB));

TEB1= zeros(1,length(EbN0dB));
TEB2= zeros(1,length(EbN0dB));
TEB3= zeros(1,length(EbN0dB));
TEB4= zeros(1,length(EbN0dB));

Pb_u = qfunc(sqrt(2*EbN0)); % Probabilité d'erreur non codée
Pe_u = 1-(1-Pb_u).^K;

%% Préparation de l'affichage
figure(1)
semilogy(EbN0dB,Pb_u,'--', 'LineWidth',1.5,'DisplayName','Pb (BPSK théorique)');
hold all
semilogy(EbN0dB,Pe_u,'--', 'LineWidth',1.5,'DisplayName','Pe (BPSK théorique)');
hTEB1 = semilogy(EbN0dB,TEB1,'LineWidth',1.5,'XDataSource','EbN0dB', 'YDataSource','TEB1', 'DisplayName','TEB1 Monte Carlo');
hTEB2 = semilogy(EbN0dB,TEB2,'LineWidth',1.5,'XDataSource','EbN0dB', 'YDataSource','TEB2', 'DisplayName','TEB2 Monte Carlo');
hTEB3 = semilogy(EbN0dB,TEB3,'LineWidth',1.5,'XDataSource','EbN0dB', 'YDataSource','TEB3', 'DisplayName','TEB3 Monte Carlo');
hTEB4 = semilogy(EbN0dB,TEB4,'LineWidth',1.5,'XDataSource','EbN0dB', 'YDataSource','TEB4', 'DisplayName','TEB4 Monte Carlo');

hTEP1 = semilogy(EbN0dB,TEP1,'LineWidth',1.5,'XDataSource','EbN0dB', 'YDataSource','TEP1', 'DisplayName','TEP1 Monte Carlo');
hTEP2 = semilogy(EbN0dB,TEP2,'LineWidth',1.5,'XDataSource','EbN0dB', 'YDataSource','TEP2', 'DisplayName','TEP2 Monte Carlo');
hTEP3 = semilogy(EbN0dB,TEP3,'LineWidth',1.5,'XDataSource','EbN0dB', 'YDataSource','TEP3', 'DisplayName','TEP3 Monte Carlo');
hTEP4 = semilogy(EbN0dB,TEP4,'LineWidth',1.5,'XDataSource','EbN0dB', 'YDataSource','TEP4', 'DisplayName','TEP4 Monte Carlo');
ylim([1e-6 1])
grid on
xlabel('$\frac{E_b}{N_0}$ en dB','Interpreter', 'latex', 'FontSize',14)
ylabel('TEB / TEP','Interpreter', 'latex', 'FontSize',14)
legend()

%% Préparation de l'affichage en console

line       =  '|------------|---------------|------------|------------|----------|----------|------------------|-------------------|--------------|\n';
msg_header =  '|  Eb/N0 dB  |    Bit nbr    |  Bit err   |  Pqt err   |   TEB    |   TEP    |     Debit Tx     |      Debit Rx     | Tps restant  |\n';
msgFormat  =  '|   %7.2f  |   %9d   |  %9d |  %9d | %2.2e | %2.2e |  %10.2f MO/s |   %10.2f MO/s |   %8.2f s |\n';
fprintf(line      );
fprintf(msg_header);
fprintf(line      );


%% Simulation
for iSNR = 1:length(EbN0dB)
    reverseStr1 = ''; % Pour affichage en console stat_erreur
    reverseStr2 = '';
    reverseStr3 = '';
    reverseStr4 = '';
    
    pqtNbr  = 0; % Nombre de paquets envoyés
    bitErr1  = 0; % Nombre de bits faux
    bitErr2  = 0;
    bitErr3  = 0;
    bitErr4  = 0;
    pqtErr1  = 0; % Nombre de paquets faux
    pqtErr2  = 0;
    pqtErr3  = 0;
    pqtErr4  = 0;
    
    T_rx1 = 0;
    T_tx1 = 0;
    T_rx2 = 0;
    T_tx2 = 0;
    T_rx3 = 0;
    T_tx3 = 0;
    T_rx4 = 0;
    T_tx4 = 0;
    general_tic = tic;
    while (bitErr1 < nbrErreur && pqtNbr*K < nbrBitMax)
        pqtNbr = pqtNbr + 1;
        
        %% Emetteur
        tx_tic  = tic;                 % Mesure du débit d'encodage
        u       = randi([0,1],K,1);    % Génération du message aléatoire

        trellis1 = poly2trellis(2,[2,3]);
        trellis2=poly2trellis(3,[5,7]); %Définition du trellis
        trellis3 = poly2trellis(4,[13,15]);
        trellis4 = poly2trellis(7,[133,171]);
        s_i = 0;                        %Défintion de l'état initial
        closed = true;
        c1      = cc_encode(u,trellis1,s_i,closed);                   % Encodage
        T_tx1    = T_tx1+toc(tx_tic);    % Mesure du débit d'encodage
        c2      = cc_encode(u,trellis2,s_i,closed);
        T_tx2    = T_tx2+toc(tx_tic);    % Mesure du débit d'encodage
        c3     = cc_encode(u,trellis3,s_i,closed);
        T_tx3    = T_tx3+toc(tx_tic);    % Mesure du débit d'encodage
        c4      = cc_encode(u,trellis4,s_i,closed);
        T_tx4    = T_tx4+toc(tx_tic);    % Mesure du débit d'encodage
        
         
        

        x1       = 1-2*c1;               % Modulation QPSK
        x2       = 1-2*c2;
        x3       = 1-2*c3;
        x4       = 1-2*c4;
        
        debitTX1 = pqtNbr*K/8/T_tx1/1e6;
        debitTX2 = pqtNbr*K/8/T_tx2/1e6;
        debitTX3 = pqtNbr*K/8/T_tx3/1e6;
        debitTX4 = pqtNbr*K/8/T_tx4/1e6;
        %% Canal
        z1 = sqrt(sigmaz2(iSNR)) * randn(size(x1)); % Génération du bruit blanc gaussien
        z2 = sqrt(sigmaz2(iSNR)) * randn(size(x2)); 
        z3 = sqrt(sigmaz2(iSNR)) * randn(size(x3)); 
        z4 = sqrt(sigmaz2(iSNR)) * randn(size(x4)); 
        y1 = x1 + z1;                          % Ajout du bruit blanc gaussien
        y2 = x2 + z2; 
        y3 = x3 + z3; 
        y4 = x4 + z4; 
        
        %% Recepteur
        rx_tic = tic;                  % Mesure du débit de décodage
        Lc1      = 2*y1/sigmaz2(iSNR);   % Démodulation (retourne des LLRs)
        Lc2      = 2*y2/sigmaz2(iSNR);
        Lc3      = 2*y3/sigmaz2(iSNR);
        Lc4      = 2*y4/sigmaz2(iSNR);
        u_rec1   =viterbi_decode(Lc1,trellis1,s_i,closed);
        T_rx1    = T_rx1 + toc(rx_tic);  % Mesure du débit de décodage
        u_rec2   =viterbi_decode(Lc2,trellis2,s_i,closed);
        T_rx2    = T_rx2 + toc(rx_tic);  % Mesure du débit de décodage
        u_rec3   =viterbi_decode(Lc3,trellis3,s_i,closed);
        T_rx3   = T_rx3 + toc(rx_tic);  % Mesure du débit de décodage
        u_rec4   =viterbi_decode(Lc4,trellis4,s_i,closed);
        T_rx4    = T_rx4 + toc(rx_tic);  % Mesure du débit de décodage
%         double(Lc(1:K) < 0); % Message reçu
        
        BE1      = sum(u(:) ~= u_rec1(:)); % Nombre de bits faux sur cette trame
        BE2      = sum(u(:) ~= u_rec2(:));
        BE3      = sum(u(:) ~= u_rec3(:));
        BE4      = sum(u(:) ~= u_rec4(:));
        bitErr1  = bitErr1 + BE1;
        bitErr2  = bitErr2 + BE2;
        bitErr3  = bitErr3 + BE3;
        bitErr4  = bitErr4 + BE4;
        
        pqtErr1  = pqtErr1 + double(BE1>0);
        pqtErr2  = pqtErr2 + double(BE2>0);
        pqtErr3  = pqtErr3 + double(BE3>0);
        pqtErr4  = pqtErr4 + double(BE4>0);
        
        debitRX1 = pqtNbr*K/8/T_rx1/1e6;
        debitRX2 = pqtNbr*K/8/T_rx2/1e6;
        debitRX3 = pqtNbr*K/8/T_rx3/1e6;
        debitRX4 = pqtNbr*K/8/T_rx4/1e6;
        %% Affichage du résultat
        if mod(pqtNbr,100) == 1
            pct11 = bitErr1/nbrErreur;
            pct12 = bitErr2/nbrErreur;
            pct13 = bitErr3/nbrErreur;
            pct14 = bitErr4/nbrErreur;
            
            pct21 = pqtNbr*K/nbrBitMax;
            pct1  = max(pct11, pct21);
            pct2  = max(pct12, pct21);
            pct3  = max(pct13, pct21);
            pct4  = max(pct14, pct21);
            
            display_str1 = sprintf(msgFormat,...
                EbN0dB(iSNR),               ... % EbN0 en dB
                pqtNbr*K,                   ... % Nombre de bits envoyés
                bitErr1,                     ... % Nombre d'erreurs observées
                pqtErr1,                     ... % Nombre d'erreurs observées
                bitErr1/(pqtNbr*K),          ... % TEB
                pqtErr1/pqtNbr,              ... % TEP
                debitTX1,                    ... % Débit d'encodage
                debitRX1,                    ... % Débit de décodage
                toc(general_tic)/pct1*(1-pct1)); % Temps restant
            
           display_str2 = sprintf(msgFormat,...
                EbN0dB(iSNR),               ... % EbN0 en dB
                pqtNbr*K,                   ... % Nombre de bits envoyés
                bitErr2,                     ... % Nombre d'erreurs observées
                pqtErr2,                     ... % Nombre d'erreurs observées
                bitErr2/(pqtNbr*K),          ... % TEB
                pqtErr2/pqtNbr,              ... % TEP
                debitTX2,                    ... % Débit d'encodage
                debitRX2,                    ... % Débit de décodage
                toc(general_tic)/pct2*(1-pct2)); % Temps restant
            
            display_str3 = sprintf(msgFormat,...
                EbN0dB(iSNR),               ... % EbN0 en dB
                pqtNbr*K,                   ... % Nombre de bits envoyés
                bitErr3,                     ... % Nombre d'erreurs observées
                pqtErr3,                     ... % Nombre d'erreurs observées
                bitErr3/(pqtNbr*K),          ... % TEB
                pqtErr3/pqtNbr,              ... % TEP
                debitTX3,                    ... % Débit d'encodage
                debitRX3,                    ... % Débit de décodage
                toc(general_tic)/pct3*(1-pct3)); % Temps restant
            
            
            display_str4 = sprintf(msgFormat,...
                EbN0dB(iSNR),               ... % EbN0 en dB
                pqtNbr*K,                   ... % Nombre de bits envoyés
                bitErr4,                     ... % Nombre d'erreurs observées
                pqtErr4,                     ... % Nombre d'erreurs observées
                bitErr4/(pqtNbr*K),          ... % TEB
                pqtErr4/pqtNbr,              ... % TEP
                debitTX4,                    ... % Débit d'encodage
                debitRX4,                    ... % Débit de décodage
                toc(general_tic)/pct4*(1-pct4)); % Temps restant
            
                
            lr1 = length(reverseStr1);
            lr2 = length(reverseStr2);
            lr3 = length(reverseStr3);
            lr4 = length(reverseStr4);
            
            msg_sz1 =  fprintf([reverseStr1, display_str1]);
            msg_sz2 =  fprintf([reverseStr2, display_str2]);
            msg_sz3 =  fprintf([reverseStr3, display_str3]);
            msg_sz4 =  fprintf([reverseStr4, display_str4]);
            
            reverseStr1 = repmat(sprintf('\b'), 1, msg_sz1-lr1);
            reverseStr2 = repmat(sprintf('\b'), 1, msg_sz2-lr2);
            reverseStr3 = repmat(sprintf('\b'), 1, msg_sz3-lr3);
            reverseStr4 = repmat(sprintf('\b'), 1, msg_sz4-lr4);
            
            TEB1(iSNR) = bitErr1/(pqtNbr*K);
            TEB2(iSNR) = bitErr2/(pqtNbr*K);
            TEB3(iSNR) = bitErr3/(pqtNbr*K);
            TEB4(iSNR) = bitErr4/(pqtNbr*K);
            
            TEP1(iSNR) = pqtErr1/pqtNbr;
            TEP2(iSNR) = pqtErr2/pqtNbr;
            TEP3(iSNR) = pqtErr3/pqtNbr;
            TEP4(iSNR) = pqtErr4/pqtNbr;
            
            refreshdata(hTEB1);
            refreshdata(hTEB2);
            refreshdata(hTEB3);
            refreshdata(hTEB4);
            refreshdata(hTEP1);
            refreshdata(hTEP2);
            refreshdata(hTEP3);
            refreshdata(hTEP4);
        end
        
    end
    
    display_str1 = sprintf(msgFormat, EbN0dB(iSNR), pqtNbr*K, bitErr1, pqtErr1, bitErr1/(pqtNbr*K), pqtErr1/pqtNbr, debitTX1, debitRX1, 0);
    fprintf(reverseStr1);
    msg_sz1 =  fprintf(display_str1);
    reverseStr1 = repmat(sprintf('\b'), 1, msg_sz1-lr1);
    
      display_str2 = sprintf(msgFormat, EbN0dB(iSNR), pqtNbr*K, bitErr2, pqtErr2, bitErr2/(pqtNbr*K), pqtErr2/pqtNbr, debitTX2, debitRX2, 0);
    fprintf(reverseStr2);
    msg_sz2 =  fprintf(display_str2);
    reverseStr2 = repmat(sprintf('\b'), 1, msg_sz2-lr2);
    
      display_str3 = sprintf(msgFormat, EbN0dB(iSNR), pqtNbr*K, bitErr3, pqtErr3, bitErr3/(pqtNbr*K), pqtErr3/pqtNbr, debitTX3, debitRX3, 0);
    fprintf(reverseStr3);
    msg_sz3 =  fprintf(display_str3);
    reverseStr3 = repmat(sprintf('\b'), 1, msg_sz3-lr3);
    
      display_str4 = sprintf(msgFormat, EbN0dB(iSNR), pqtNbr*K, bitErr4, pqtErr4, bitErr4/(pqtNbr*K), pqtErr4/pqtNbr, debitTX4, debitRX4, 0);
    fprintf(reverseStr4);
    msg_sz4 =  fprintf(display_str4);
    reverseStr4 = repmat(sprintf('\b'), 1, msg_sz4-lr4);
    
    TEB1(iSNR) = bitErr1/(pqtNbr*K);
    TEP1(iSNR) = pqtErr1/pqtNbr;
    refreshdata(hTEB1);
    refreshdata(hTEP1);
    drawnow limitrate
    
    if TEB1(iSNR) < TEBMin
        break
    end
    
    TEB2(iSNR) = bitErr2/(pqtNbr*K);
    TEP2(iSNR) = pqtErr2/pqtNbr;
    refreshdata(hTEB2);
    refreshdata(hTEP2);
    drawnow limitrate
    
    if TEB2(iSNR) < TEBMin
        break
    end
    
    TEB3(iSNR) = bitErr3/(pqtNbr*K);
    TEP3(iSNR) = pqtErr3/pqtNbr;
    refreshdata(hTEB3);
    refreshdata(hTEP3);
    drawnow limitrate
    
    if TEB3(iSNR) < TEBMin
        break
    end
    
    TEB4(iSNR) = bitErr4/(pqtNbr*K);
    TEP4(iSNR) = pqtErr4/pqtNbr;
    refreshdata(hTEB4);
    refreshdata(hTEP4);
    drawnow limitrate
    
    if TEB4(iSNR) < TEBMin
        break
    end
    
end
fprintf(line      );
%%
save('NC1.mat','EbN0dB','TEB1', 'TEP1', 'R', 'K', 'N', 'Pb_u', 'Pe_u')
save('NC2.mat','EbN0dB','TEB2', 'TEP2', 'R', 'K', 'N', 'Pb_u', 'Pe_u')
save('NC3.mat','EbN0dB','TEB3', 'TEP3', 'R', 'K', 'N', 'Pb_u', 'Pe_u')
save('NC4.mat','EbN0dB','TEB4', 'TEP4', 'R', 'K', 'N', 'Pb_u', 'Pe_u')