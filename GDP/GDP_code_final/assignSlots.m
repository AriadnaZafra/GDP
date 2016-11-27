function [slots, delay, holdingdelay]=assignSlots(slots,ETA,Controlled,Excluded)
%ASSIGNSLOTS 
% Primero tenemos que asignar los slots a los planos excluidos del GDP y luego a los controlados.
% Calcular el retardo asignado a cada avión.

delay = []; %delay matriz generada: ID - minimo delay
slots_minute=minute(slots, 0); %GDP; 

%Slots tiempo windows computing *** código específico para estos datos
% Tenemos que proporcionar el parámetro ventana desde
ventanaPAAR = slots_minute(2)-slots_minute(1);

% Asignamos los slots a los aviones.
n= 1; % n será el metro para los aviones
slot= 1; % «slots» es el contador de slots

% Mientras que no terminamos la lista de aeronaves excluidas y el número
% de slots probaremos si el ETA del avión es menor que la próximo slot (en este caso puede entrar en el slot)
    while((n<=length(Excluded)) && (slot<=length(slots)))      
            
%                if((slots_minute(slot) - Excluded{n,2}(1,1))>= 0);
                   % El vuelo puede llegar en el minuto inicial del slot o en el próximo minuto. Depende del período de tiempo
                 if((slots_minute(slot) - Excluded(n,2))>= 0) 

                        slots(slot,3)=Excluded(n,1); % Mantener en la tercera columna de slots la ID de la aeronave GDP();
                        holdingdelay(n,1)= Excluded(n,1); % Mantener en una nueva matriz de demora, la ID del vuelo - GDP;
                        holdingdelay(n,2)=(slots_minute(slot) - Excluded(n,2)); % Mantener en la segunda columna de la demora los minutos de retraso que llevarán el vuelo en comparación con su ETA - GPD;
                       
                        if(holdingdelay(n,2)<0)
                            holdingdelay(n,2)=0;
                        end
                        n=n+1;
                end
        slot = slot +1;            
    end
% Realizar el mismo procedimiento pero ahora con el vuelo controlado
n=1;
slot=1;
     while((n<=length(Controlled))&&((slot<=length(slots))))
        
        if(slots(slot,3)== 0 ) 
                    
                if((slots_minute(slot) - Controlled(n,2)) >= 0)

                        slots(slot,3)=Controlled(n,1); % Mantener en los tercera columna de slots los ID de la aeronave 
                        delay(n,1)= Controlled(n,1); % Mantener en una nueva matriz de demora, la ID del vuelo
                        delay(n,2)= (slots_minute(slot) - Controlled(n,2)); % tener en los segunda columna de la demora los minutos de retraso que llevarán el vuelo en comparación con su ETA
%                          if(delay(n,2)<0)
%                             delay(n,2)=0;
%                         end
                        
                        n=n+1;
                end
        end
        slot=slot+1;
     end
end

    
     
     

