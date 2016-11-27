function [ output_args ] = plotHistograms(ETA,CTA,AAR,PAAR)
%PLOTHISTOGRAMS Trazar� los datos de ETA y CTA

%Comienzo de la variable
inicio = 0; 
CTA(:,3)=CTA(:,1)+CTA(:,2)/60;
ETA(:,3)=ETA(:,1)+ETA(:,2)/60;

%Finalizaci�n de la variable
fin = 24; 

linde=[inicio fin 0 (AAR+10)];

figure(3)
hold on
title('Histogram arrivals non-regulated traffic');
xlabel('time (hours)');
ylabel('arrivals (number of aircraft)');
x=[inicio+0.5:1:fin+0.5];
x2=[inicio:1:fin];
x2(10)=x2(11);
x2(14)=x2(13);

eje1=ones(length(x),1)*AAR;
eje2=ones(length(x),1)*PAAR;
eje3=ones(length(x),1)*AAR;

eje3(11)=PAAR;
eje3(12)=PAAR;
eje3(13)=PAAR;

hist(ETA(:,3), x);
plot(x,eje1,'*g');
plot(x,eje2,'+r');
plot(x2,eje3,'-m');

axis(linde);


figure(4)
hold on
title('Histogram arrivals regulated traffic');
xlabel('time (hours)');
ylabel('arrivals (number of aircraft)');
hist(CTA(:,3), x);
plot(x,eje1,'*g');
plot(x,eje2,'+r');
plot(x2,eje3,'-m');

axis(linde);

end





