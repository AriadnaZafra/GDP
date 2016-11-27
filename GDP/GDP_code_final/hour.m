function [ Matrix ] = hour( Matrix_min )
%HOUR Va a cambiar el valor de horas a minutos
% Los datos recibidos está en un vector de minutos. Devuelve una matriz de 2 columnas: horas x minutos

% Iniciación del contador
h=1;
    if(size(Matrix_min,2) ==1)
        Matrix=[fix(Matrix_min/60), (Matrix_min-fix(Matrix_min/60)*60) ];    
    else           
        while(h<=size(Matrix_min,2))
            Matrix(h,1)=fix(Matrix_min(h)/60) ; %columnas en horas
            Matrix(h,2)= (Matrix_min(h)-fix(Matrix_min(h)/60)*60); %columna en minutos
            h=h+1;
        end
    end
end

