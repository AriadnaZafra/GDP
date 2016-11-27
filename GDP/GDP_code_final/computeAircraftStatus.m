function [NotAffected ExcludedRadius ExcludedInternational ExcludedFlying Excluded Controlled Aviones] = computeAircraftStatus(ETA,ETD,Distances,International,Hdef,Hstart,HNoReg,radius)
% COMPUTEAIRCRAFTSATUS - Calcularemos el estado del vuelo
%   Calcular el estado de la aeronave, si el avión si ve afectada o no por
%   el GDP, en función de diferentes parámetros como la hora de llegada, hora de salida, la distancia, si el vuelo es internacional o no, 
%   el GDP y su radio de aplicación

%Cambio de horas a minutos
Hdef_min=minute(Hdef, 0);
Hstart_min=minute(Hstart, 0);
HNoReg_min=minute(HNoReg, 0);
ETA_min=minute(ETA, 0);
ETD_min=minute(ETD, 0);

Aviones=[];

%Comprovar el estado de la aeronave  
%Declaración de las variables para crear el vector de los vuelos afectados
%o no afectados por el GDP
NA=1; RA=1; EF=1; EI=1; C=1; E=1;
% "ex" será la variable bool para saber si el vuelo está controlado
ex=0;
% "a" será el vuelo
a=1;
Excluded = [];
Controlled = [];

    while(a<size(ETA,1))

    Aviones(a,1) = a; %ID
    Aviones(a,2)=ETA(a,1); %Hota ETA
    Aviones(a,3)=ETA(a,2); %Min ETA
    Aviones(a,4)=0; %Tipo 0 Controlaod 1 Internaciones 2 Extraradios 3 Hora Salida , >0 No afectado
    % comprobar si la ETA afecta el vuelo debido a su ETA está fuera del intervalo HStart - HNoReg
        if((ETA_min(a)<Hstart_min)||(HNoReg_min <= ETA_min(a) ))
            NotAffected(NA)=a;
            NA=NA+1;
        else
        % De lo contrario el vuelo será controlado o excluido
        % CONTROLADO
           if(radius<Distances(a))%Excluidos por radio
                ExcludedRadius(RA)=a; %%%%GDP();
                RA=RA+1;
                ex=1;
                Aviones(a,4)=2;
           end
           if(ETD_min(a)<Hdef_min) %Quedan excluidos debido a su hora de salida
                ExcludedFlying(EF)=a; %%%%%GDP();
                EF=EF+1;        
                ex=1;
                Aviones(a,4)=3;
           end  
           if(International(a)==1) %Han excluido por su vuelo internacional
                ExcludedInternational(EI)=a; %%%%%GDP();
                EI=EI+1;
                ex=1;
                Aviones(a,4)=1;
           end

           if(ex==1) %Si se excluye el vuelo hay que guardarlo en la matriz de excluidos
                 
                 Excluded(E,1)=a;%Guardamos las ID del avion %%%GDP();
                 Excluded(E,2)=ETA_min(a);%Guardamos la ETA del avion %%%GDP();
                 E=E+1;
                 
           else % Y si no está excluido hay que guardar en la matriz de controlado
                 
                 Controlled(C,1)=a;%Mantener la aeronave ID %%%GDP();
                 Controlled(C,2)=ETA_min(a);% Mantener las aeronaves ETA %%%%GDP();
                 C=C+1;
               
           end

        end

        ex=0;
        a=a+1;
    end
  % En el caso de que el radio sea demasiado grande y todos los vuelos
  % esten en el interior, excepto los internacionales, regregrasemos:
    if(RA==1 || EI==1 || EF==1)
    ExcludedRadius=0;
    ExcludedInternational=0;
    ExcludedFlying=0;
    end
    
end

