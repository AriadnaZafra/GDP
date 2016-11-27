function [HNoReg totaldelay ] = agregateDemand( ETA, Hstart, Hend, PAAR, AAR )
% AGREGATEDEMAND - Calculamos AgregateDemand
% AgregateDemand es el n�mero total de aeronaves que llega al aeropuerto en un per�odo de tiempo

% Conversi�n de la tasa de aeronaves a la duraci�n slot
PAAR = PAAR/60;
AAR = AAR/60;

% Conversi�n de horas a minutos
Hstart_minutos = minute(Hstart,0); % Las variables que introducimos a la funci�n tienen un 0 por una especificaci�n de la funci�n
Hend_minutos = minute(Hend,0);

% Conversi�n de hora de ETA a minutos de ETA
ETA_minuto = minute(ETA, 0);
 
%Definicion de las matrices
Demandaagregada = [];
Capacidadreducida = [];

dervDemandaagregada = [];

% El retraso inicial ser� cero
totaldelay = 0;

% n es el contador de minutos
n = 1; % El valor de "n" tiene de 1 a (max (ETA_minuto) - min (ETA_minuto) 1)
a = 0; % valor inicial se determina por la forma del c�digo (line57)
acabado = false;
while(n <= (max(ETA_minuto)-min(ETA_minuto)+1))    

    avionesnuevos=0;
   % Cuenta los vuelos que llega en este minuto
    for m=1:size(ETA_minuto,2) 
        if (ETA_minuto(m) == (n+ min(ETA_minuto)-1))
            avionesnuevos = avionesnuevos + 1;    
        end
    end
    % Actualiza la demanda en el mismo minuto que antes
    % Tiempo
    Demandaagregada(n,1) = n + min(ETA_minuto)- 1;
    dervDemandaagregada(n,1)= n + min(ETA_minuto)- 1;
    dervAirport(n,1)= n + min(ETA_minuto)- 1;
    dervAirport(n,2)=AAR;
    
    %Capacidad
    if(n==1)% En el primer bucle de los nuevos aviones son el n�mero inicial de aeronaves
      Demandaagregada(n,2) = avionesnuevos;
      dervDemandaagregada(n,2)=0;
      dervAirport(n,2)=0;
    else
   % asigna valores al agregar en funci�n de demanda
    Demandaagregada(n,2) = Demandaagregada(n-1,2) + avionesnuevos; % La nueva demanda ser� el anterior y el nuevo n�mero de aeronaves
    dervDemandaagregada(n,2)= Demandaagregada(n,2) - Demandaagregada(n-1,2);
    end
        
    % asigna valores a la funci�n de durante el GDP
    if(n == (Hstart_minutos-min(ETA_minuto)+1)) % Valor inicial de capacidad reducida
      a=a+1;
      Capacidadreducida(a,1)=Demandaagregada(n,1); %minuteos
      Capacidadreducida(a,2)=Demandaagregada(n,2); %capacidad         
    end

    if( (n > (Hstart_minutos - min(ETA_minuto)+1 )) && (n <= (Hend_minutos - min(ETA_minuto)+ 1 ))) % reducci�n de la capacidad, mientras que el PAAR se est� aplicando
      a=a+1;
      Capacidadreducida(a,1)=Demandaagregada(n,1);  %minutos
      Capacidadreducida(a,2)=Capacidadreducida(a-1,2) + PAAR; %capacidad
      dervAirport(n,2)=PAAR;

      if((Demandaagregada(n,2) - Capacidadreducida(a,2))>0)
      totaldelay = totaldelay + Demandaagregada(n,2) - Capacidadreducida(a,2);
      end

    end
         
    if((n > (Hend_minutos - min(ETA_minuto) + 1))&& (acabado == false))%Reduci�n de la capacidad, mentras el AAR se est� aplicando
      a=a+1;
      Capacidadreducida(a,1)=Demandaagregada(n,1);  %minutos
      Capacidadreducida(a,2)=Capacidadreducida(a-1,2) + AAR; %capacidad
      dervAirport(n,2)=AAR;

      if((Demandaagregada(n,2) - Capacidadreducida(a,2))>0)
      totaldelay = totaldelay + Demandaagregada(n,2) - Capacidadreducida(a,2);
      end

         if(Capacidadreducida((a),2)>= Demandaagregada(n,2))
          % Construimos las estructuras del segmento
            acabado = true;

            if(Capacidadreducida((a),2)== Demandaagregada(n,2))
                HNoReg_min = n + min(ETA_minuto)-1 ;                    
            else
            % definir el punto de intersecci�n

            s1=struct('A',[Demandaagregada(n-1,1),Demandaagregada(n-1,2)],'B',[Demandaagregada(n,1),Demandaagregada(n,2)]);                
            s2=struct('A',[Capacidadreducida(a-1,1),Capacidadreducida(a-1,2)],'B',[Capacidadreducida(a,1),Capacidadreducida(a,2)]);

           % Pasamos los segmentos a la funci�n intersectSegments 
            intersection= intersectSegments(s1, s2);
            HNoReg_min = intersection(1) ;


            %totaldelay = totaldelay + ((Demandaagregada(n-1,2)- Capacidadreducida(c-1,2))*(HNoReg_min-(n-1)))/2 ;

            end

         end

    end
     
    n = n+1;

    end

HNoReg = [fix(HNoReg_min/60),ceil((HNoReg_min-fix(HNoReg_min/60)*60))];
%HNoReg=0;

pintarojo = (Hend_minutos - Hstart_minutos)+1;

figure();
% Dibujamos el diagrama
hold on
title('Agregate Demand');
xlabel('Time (hour)');
ylabel('Demand ( number of aircraft )');
plot((Demandaagregada(:,1))/60,Demandaagregada(:,2), 'b');
plot(Capacidadreducida(1:1:pintarojo,1)/60,Capacidadreducida(1:1:pintarojo,2), 'r'); % dibujar el PAAR
plot(Capacidadreducida(pintarojo:1:end,1)/60,Capacidadreducida(pintarojo:1:end,2), 'g');% dibujar el AAR
legend('Aggregate demand','Capacity reduced','Capacity nominal')
hold off

% figure();
% % Dibujamos el diagrama derivado
% hold on
% title('Derivative Demand/Capacity');
% xlabel('Time (hour)');
% ylabel(' Derivative Demand/Capacity (number of aircraft)');
% plot((dervDemandaagregada(:,1))/60,dervDemandaagregada(:,2), 'b');
% plot(dervAirport(1:1:pintarojo,1)/60,dervAirport(1:1:pintarojo,2), 'r'); % dibujar el PAAR
% legend('Derv. demand','Airport Capacity')
% hold off

end



