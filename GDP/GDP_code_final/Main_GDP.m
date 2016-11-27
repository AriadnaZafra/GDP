clear all;
close all;

%Carga los datos de la GDP_data.mat que contiene: AAR, distances, ETA, ETD, Hed, Hstart, Internacionales, PAAR.

load('GDP_data.mat')

% Hdef=08h00  Hstart=10h00  Hend=12h00 PAAR=30  AAR=60

Hdef=[8 00]; %Parametro que dices tu.
Hend=[12 00]; % hora de fin
PAAR=30;
AAR=60;

Hstart = [10 00]; % hora de inicio

%Parametros del aeropuerto
%AAR - aeronaves por hora que el aeropuerto acepta en condiciones nominales
%PAAR - aeronaves por hora que el aeropuerto acepta en condiciones del GDP

%Radio del GDP
radius = 1000;

%funcion AgregateDemand  
% [HNoReg delaytotal] = agregateDemand(ETA, Hstart, Hend, PAAR, AAR);
% modificado
[HNoReg totaldelay] = agregateDemand(ETA, Hstart, Hend, PAAR, AAR);
%funcion computeSlotsGDP 
slots = computeSlotsGDP(Hstart, Hend, HNoReg, PAAR, AAR);

%funcion computeAircraftSatus 
[NotAffected, ExcludedRadius, ExcludedInternational, ExcludedFlying, Excluded, Controlled, Aviones] = computeAircraftStatus(ETA,ETD,Distances,International,Hdef,Hstart,HNoReg,radius);

%funcion assignSlots 
[slots, delay, holdingdelay]= assignSlots(slots, ETA, Controlled, Excluded); 


grounddelay =[];
airdelay =[];
d=1;
s=1;
%Ver all data en Aviones
for i=133:length(Aviones)    
    for j=1:length(slots)
        if(slots(j,3)==Aviones(i,1))
            Aviones(i,5)=round(slots(j,1));
            Aviones(i,6)=round(slots(j,2));
            etamin = Aviones(i,2)*60+Aviones(i,3);
            realetamin = Aviones(i,5)*60+Aviones(i,6);
            Aviones(i,7) = realetamin-etamin;
            
            if(Aviones(i,4)>0)
                airdelay(d) = Aviones(i,7);
                d=d+1;
            else
                grounddelay(s) = Aviones(i,7);
                s=s+1;
            end
        end
    end
end

totalavionesgrounddelay = sum(grounddelay);
totalavionesairdelay = sum(airdelay);
totalavionesdelay = totalavionesgrounddelay+totalavionesairdelay;

meanavionesairdelay= mean(airdelay);
meanavionesgrounddelay= mean(grounddelay);
minavionesgrounddelay= min(grounddelay);
minavionesairdelay= min(airdelay);
maxavionesgrounddelay= max(grounddelay);
maxavionesairdelay= max(airdelay)

%funcion computeCTA 
CTA= computeCTA(ETA,delay,holdingdelay);

%Plots 
plotHistograms(ETA,CTA,AAR,PAAR);

%funcion computeDelay
[maxdelay,plane]=max(delay(:,2)');
Meandelay = mean(delay(:,2)');
Delaytotal= sum(delay(:,2));

%funcion computeHolgindDelay 
[maxholding,plane]=max(holdingdelay(:,2)');
Meanholding = mean(holdingdelay(:,2)');
holdingtotal= sum(holdingdelay(:,2));


%% Efectos de cambio de radio, en el GDP.
% 
for i=1:400
    radius=500+5*i;
    gradius(i)=radius;
    
    slots = computeSlotsGDP(Hstart,Hend,HNoReg,PAAR,AAR);
    [NotAffected, ExcludedRadius, ExcludedInternational, ExcludedFlying, Excluded, Controlled, Aviones]=computeAircraftStatus(ETA,ETD,Distances,International,Hdef,Hstart,HNoReg,radius);
    defNumAffected(i) = length(Controlled);
    [slots, delay, holdingDelay]=assignSlots(slots,ETA,Controlled,Excluded);
    if (size(delay,2) ==1)
        delay(1,1) = 0;
        delay(1,2) = 0;
        delay(2,1) = 0;
        delay(2,2) = 0;        
    end
    
    grounddelay =[];
    airdelay =[];
    d=1;
    s=1;
    %Ver all data en Aviones
    for k=133:length(Aviones)    
        for j=1:length(slots)
            if(slots(j,3)==Aviones(k,1))
                Aviones(k,5)=round(slots(j,1));
                Aviones(k,6)=round(slots(j,2));
                etamin = Aviones(k,2)*60+Aviones(k,3);
                realetamin = Aviones(k,5)*60+Aviones(k,6);
                Aviones(k,7) = realetamin-etamin;

                if(Aviones(k,4)>0)
                    airdelay(d) = Aviones(k,7);
                    d=d+1;
                else
                    grounddelay(s) = Aviones(k,7);
                    s=s+1;
                end
            end
        end
    end

    deftotalavionesgrounddelay(i) = sum(grounddelay);
    deftotalavionesairdelay(i) = sum(airdelay);
    deftotalavionesdelay(i) = deftotalavionesgrounddelay(i)+deftotalavionesairdelay(i);

    defmeanavionesairdelay(i)= mean(airdelay);
    defmaxairdelay(i)=max(airdelay);
    defmeanavionesgrounddelay(i)= mean(grounddelay);
    defmaxground(i)=max(grounddelay);
    
    
    CTA = computeCTA(ETA,delay,holdingdelay);
    
    defGroundDelay(i)=sum(delay(:,2));
    defGroundMaxDelay(i)=max((delay(:,2)));
    defGroundAverageDelay(i)=mean(delay(:,2));
    defGroundVarDelay(i)=var(delay(:,2)',1);
    
    gHoldingDelay(i)=sum(holdingDelay(:,2));
    defHoldingMaxDelay(i)=max((holdingDelay(:,2)));
    defHoldingAverageDelay(i)=mean(holdingDelay(:,2));
    defHoldingVarDelay(i)=var(holdingDelay(:,2)',1);
    
    totalDelay=vertcat(delay(:,2),holdingDelay(:,2));
    defTotalDelay(i)=sum(totalDelay);
    defTotalMaxDelay(i)=max(totalDelay);
    defTotalAverageDelay(i)=mean(totalDelay);
    defTotalVarDelay(i)=var(totalDelay,1);
    
    defAffectedAct(i)=length(Controlled);

end

figure(5)

hold on
title('Total delay versus radius of exemption');
xlabel('Radius of exemption (units)');
ylabel('Delay (min)');
plot(gradius,deftotalavionesgrounddelay,'g','LineWidth',1.5);
plot(gradius,deftotalavionesairdelay,'r','LineWidth',1.5);
plot(gradius,deftotalavionesdelay,'--','Color','k','LineWidth',1.4);
legend('Total Ground Delay','Total Holding Delay','Total Delay')
hold off

figure(6)

hold on
title('Mean delay versus radius of exemption');
xlabel('Radius of exemption (units)');
ylabel('Delay (min)/ Number Flights ');

plot(gradius,defNumAffected,'c','LineWidth',1.5);
plot(gradius,defmeanavionesgrounddelay,'g','LineWidth',1.5);
plot(gradius,defmeanavionesairdelay,'r','LineWidth',1.5);
plot(gradius,defTotalAverageDelay,'--','Color','k','LineWidth',1.4);
plot(gradius,defmaxairdelay,'.','Color','b','LineWidth',1.4);
plot(gradius,defmaxground,'.','Color','m','LineWidth',1.4);
legend('Number of Flights Affected','Avegare Ground Delay','Average Holding Delay','Total Average Delay','Max Air Delay','Max Ground Delay')
hold off


