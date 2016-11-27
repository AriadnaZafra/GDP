function [ Matrix_minute ] = minute( Matrix, delay )
%MINUTOS 
% Cambiar el valor de la hora (en una matriz) a los minutos (en un vector)

m=1;
    if(delay==1)
        
         while(m<=size(Matrix,1))
              Matrix_minute(m)=(Matrix{m,1})*60+(Matrix{m,2});  
              m=m+1; 
         end
    else       
          while(m<=size(Matrix,1))
              Matrix_minute(m)=(Matrix(m,1))*60+(Matrix(m,2));  
              m=m+1; 
          end
    end 
end

