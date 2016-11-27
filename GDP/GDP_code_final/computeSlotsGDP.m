function [ slots ] = computeSlotsGDP( Hstart, Hend, HNoReg, PAAR, AAR )
%COMPUTESLOTSGDP - Calcular el n�mero de slots que son necesarias para el GDP
%Desde HStart a Hend esta funci�n generar� slots para establecer los vuelos
%cuando se inicia el GDP

% Cambio de horas a minutos
Hstart_minutos = minute(Hstart,0);
Hend_minutos = minute(Hend,0);
HNoReg_minutos = minute(HNoReg,0);


% Creaci�n de un factor de seguridad para asegurarse de que a�n cuando el
% GDP ha terminado permanecen slots
Factor_seguridad = 1.1;

PAAR = 60/PAAR; %Slots cada t1 minutos
AAR = 60/AAR ; %Slots cada t2 minutos

%El n�mero de slots en el PAAR ser� igual a los minutos entre HStart y Hend
%dividido por el tiempo de cada slot
slots_PAAR = ceil((Hend_minutos - Hstart_minutos)/PAAR); 

% El n�mero de slots de la AAR ser� igual a los minutos entre Hend y HNoReg
% dividido por el tiempo de cada slot
slots_AAR = fix((HNoReg_minutos - (Hstart_minutos+2*slots_PAAR ))/AAR);

n = 1;
% Mientras que n es menor que el n�mero total de slots
    while(n<=((slots_PAAR + slots_AAR)* Factor_seguridad ))

     if(n <= slots_PAAR)  %Mientras que n no sea superior al PAAR, voy a�adiendo
        slotsmin(n) = Hstart_minutos + (n-1)*PAAR; %Hora de inicio + el tiempo de cada slot en la PAAR
     else
        slotsmin(n) =  (Hstart_minutos + (slots_PAAR*PAAR)) + (n-(slots_PAAR+1))*AAR; %  + el tiempo de cada slot en la AAR
     end

    %Construcci�n de la matriz de slots con los par�metros [horas, minutos, asignacion]
         
    slots(n,1)= fix(slotsmin(n)/60); %horas GDP;
    slots(n,2)= (slotsmin(n)/60 - fix(slotsmin(n)/60))*60; %minutos GDP;
    slots(n,3)= 0; %asignacion  GDP;

    n = n+1;
    end

end

