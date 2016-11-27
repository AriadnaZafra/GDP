function [ CTA ] = computeCTA(ETA,delay,holdingdelay)
% COMPUTE CTA crear la matriz CTA
% Calcula el Controlled Time de llegadas de la ETA del los vuelos y el delay asignado a cada vuelo

% Declararemos la matriz CTA
CTA=[];
% Cambio ETA de horas a minutos
ETA_min=minute(ETA,0);

%Declaracion de los contadores. 
n=1;
m=1;

% Crearemos la matriz en un bucle
    while(n<=length(ETA_min))           
        m=1;
        CTA_min(n)=ETA_min(n);      
         while(m<=length(delay))                    
            if(n==delay(m,1)) % Si existe cualquier ID del retardo igual a la posición de ETA_min donde estamos
                CTA_min(n)=ETA_min(n)+delay(m,2);                
            end           
            m=m+1;
         end 
         m=1;
         while(m<=length(holdingdelay)) 
            if(n==holdingdelay(m,1)) % Si existe cualquier ID del retardo igual a la posición de ETA_min donde estamos
                CTA_min(n)=ETA_min(n)+holdingdelay(m,2);                
            end 
            m=m+1;
         end                   
        n=n+1;
    end
%Cambio de minutos a horas 
CTA = hour(CTA_min);    

end

