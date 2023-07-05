function comunicar1(ident, reporte, repcod)

%Variables globales
global reportelider
global reportesegui
global cooralert

%Asignar el reporte a la variable correspondiente en el coordinador
if (ident==1)
    reportelider=reporte;
elseif (ident==2)
    reportesegui=reporte;
end


%Clasificar el mensaje entrante
if repcod <= 17
    %NO OLVIDAR QUE TENGO QUE AJUSTAR EL GOTO
    %tipo = 1;       %Mensajes de reporte    
    
elseif repcod >= 18 && repcod <= 21
    %tipo = 2;       %Mensajes hacia el otro agente
    
    %Llamar al "conmutador" del coordinador
    comlider(ident,repcod);
    
elseif repcod >= 30
    %tipo = 4;       %Mensajes de alerta
    
    %Activar la alerta correspondiente en el coordinador
    cooralert = repcod;
end

    
