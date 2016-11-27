%Funcion que devuelve la intersección entre dos segmentos.

function point = intersectSegments(s1,s2)
    % FUNCION EXTRAIDA POR INTERNET Y MEJORADA / RETOCADA PARA REALIZAR LOS
    % VECTORES DIRECTORES. 
    % Miramos que la pendiente de ambas rectas no es la misma creamos la variable denominador. 
    denom = ((s2.B(2) - s2.A(2))*(s1.B(1) - s1.A(1))) - ((s2.B(1) - s2.A(1))*(s1.B(2) - s1.A(2)));
    if (denom == 0)
        %en caso de ser paralelas devolvemos -1
            point = -1;
    else
       
    %Creamos los vectores directores de los segmentos y calculamos cuantas veces hay que usarlo 
    %hasta la interseccion, solucion por numero de veces que hay que repetir el vector director
       
        director1 = (((s2.B(1) - s2.A(1))*(s1.A(2) - s2.A(2))) - ((s2.B(2) - s2.A(2))*(s1.A(1) - s2.A(1))))/denom;
        director2 = (((s1.B(1) - s1.A(1))*(s1.A(2) - s2.A(2))) - ((s1.B(2) - s1.A(2))*(s1.A(1) - s2.A(1))))/denom;
       
        if (abs(1-director1) < 10^-6)
            director1 = 1;
        end
        if (abs(1-director2) < 10^-6)
            director2 = 1;
        end
     %Miramos que nuestro punto de interseccion esta dentro de los parametros correctos.
        if ((director1 >= 0) && (director1 <= 1) && (director2 >= 0) && (director2 <= 1))
            %Calculamos los puntos 
            x = s1.A(1) + director1*(s1.B(1) - s1.A(1));
            y = s1.A(2) + director1*(s1.B(2) - s1.A(2));

            point = [x,y];
        else
            point = -1;
        end
    end
end