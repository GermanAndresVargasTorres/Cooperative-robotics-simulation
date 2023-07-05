function [robot,secrobot] = I4seguidor(robot,secrobot)

%Variables globales
global mtx
global mty


%Sección 32 (Sincronizar actuación)
if(secrobot==32)
    %Confirmar permiso de actuación
    robot = h6(robot, 'Confirmar permiso', 22, 2);
    
    %Si el permiso es otorgado, pasar a siguiente sección
    if robot.p == 1
        secrobot = secrobot + 1;
    end
    
    
%Sección 33 (Inicio movimiento hacia adelante)
elseif(secrobot==33)        
    %Inicio de movimiento hacia adelante y reporte
    robot = h6(robot, 'Adelante', 3, 1);
    wmax=(4391/51)*(pi/30);
    robot = h1(robot, [1 1 1 1], [wmax wmax wmax wmax]);
    
    %Mover el robot
    [robot] = CinDir(robot);
    
    %Autorizar paso a la siguiente sección
    secrobot=secrobot+1;  
    
    
%Sección 34 (Avanzar hasta la curva)
elseif(secrobot==34)
    %Si se alcanzó la indicada, pasar a siguiente sección
    if(robot.mcont == 2)
        secrobot = secrobot + 1;
        return
    end
    
    %Aproximar las coordenadas del sensor inductivo
    cond1=roundsd(robot.indy,5); 
        
    %Si se detecta un marcador, activaremos la bandera
    for i=13:18                  
        if ((isalmost(cond1,mty(i),0.0025)) && ((15-i) ~= robot.mcont))
            robot.ind = 1;
            break
        else
            robot.ind = 0;
        end
    end
    
    %Dada la bandera, aumentar el conteo de marcadores y reportar
    if robot.ind == 1
        robot = increm(robot);
        str = sprintf('Mcont = %d',robot.mcont);
        robot = h6(robot, str, 15, 1);
    else    
        %De lo contrario, seguir moviendo el robot hacia la derecha
        [robot] = CinDir(robot);
    end
    
    
%Sección 35 (Inicio curva hacia la izquierda)
elseif(secrobot==35)
    %Activar bandera de curva
    robot.curva = 1;
    
    %Inicio de curva hacia la izquierda y reporte
    robot = h6(robot, 'Curva Hacia Izquierda', 7, 1);
    wmax=(4391/51)*(pi/30);
    robot = h1(robot, [1 0 0 1], [wmax wmax wmax wmax]);
    
    %Mover el robot
    [robot] = CinDir(robot);
    
    %Autorizar paso a la siguiente sección
    secrobot=secrobot+1;  
    
    
%Sección 36 (Curva hacia la izquierda)
elseif(secrobot == 36)
    %Si se alcanzó la indicada, pasar a siguiente sección
    if(robot.mcont == 4)
        secrobot = secrobot + 1;
        return
    end
    
    %Aproximar las coordenadas del sensor inductivo
    cond1=roundsd(robot.indx,5);
    cond2=roundsd(robot.indy,5);
        
    %Si se detecta un marcador, activaremos la bandera
    for i=11:13    
        if ((isalmost(cond1,mtx(i),0.0025)) && (isalmost(cond2,mty(i),0.0025)) && ((15-i) ~= robot.mcont))
            robot.ind = 1;
            break
        else
            robot.ind = 0;
        end
    end
    
    %Dada la bandera, aumentar el conteo de marcadores y reportar
    if robot.ind == 1
        robot = increm(robot);
        str = sprintf('Mcont = %d',robot.mcont);
        robot = h6(robot, str, 15, 1);
    else    
        %De lo contrario, seguir moviendo el robot hacia la derecha
        [robot] = CinDir(robot);
    end
    
    
%Sección 37 (Avanzar hacia la segunda curva)
elseif(secrobot==37)
    %Corrección de orientación (compensando avances discretos de la
    %simulación)
    robot.theta = (-1/2)*pi;
    
    %Pausa para ver cuando se ha detectado un marcador
    if robot.ind == 1
        pause(0.5)
    end
    
    %Terminó la curva para el robot
    robot.curva=0;
    
    %Si se alcanzó la indicada, pasar a siguiente sección
    if(robot.mcont == 6)
        secrobot = secrobot + 1;
        return
    end
    
    %Confirmar si el convoy ha entrado a la etapa de curva
    robot = h6(robot, 'Confirmar normalidad', 23, 2);
    
    %Ajustar la velocidad acorde a la respuesta anterior
    if robot.stat == 1
         wmax=(4391/51)*(pi/30);
         robot = h1(robot, [1 1 1 1], [wmax wmax wmax wmax]);
    else
        wmed=((4391/51)*(pi/30))/2;
        robot = h1(robot, [1 1 1 1], [wmed wmed wmed wmed]);
    end
        
    %Aproximar las coordenadas del sensor inductivo
    cond1=roundsd(robot.indx,5); 
        
    %Si se detecta un marcador, activaremos la bandera
    for i=9:11                  
        if ((isalmost(cond1,mtx(i),0.0025)) && ((15-i) ~= robot.mcont))
            robot.ind = 1;
            break
        else
            robot.ind = 0;
        end
    end
    
    %Dada la bandera, aumentar el conteo de marcadores y reportar
    if robot.ind == 1
        robot = increm(robot);
        str = sprintf('Mcont = %d',robot.mcont);
        robot = h6(robot, str, 15, 1);
    else    
        %De lo contrario, seguir moviendo el robot hacia la derecha
        [robot] = CinDir(robot);
    end
    
    
%Sección 38 (Inicio curva hacia la derecha)
elseif(secrobot==38)
    %Activar bandera de curva
    robot.curva = 1;
    
    %Inicio de curva hacia la izquierda y reporte
    robot = h6(robot, 'Curva Hacia Derecha', 8, 1);
    wmax=(4391/51)*(pi/30);
    robot = h1(robot, [0 1 1 0], [wmax wmax wmax wmax]);
    
    %Mover el robot
    [robot] = CinDir(robot);
    
    %Autorizar paso a la siguiente sección
    secrobot=secrobot+1;  
    
    
%Sección 39 (Curva hacia la derecha)
elseif(secrobot == 39)
    %Si se alcanzó la indicada, pasar a siguiente sección
    if(robot.mcont == 8)
        secrobot = secrobot + 1;
        return
    end
    
    %Aproximar las coordenadas del sensor inductivo
    cond1=roundsd(robot.indx,5);
    cond2=roundsd(robot.indy,5);
        
    %Si se detecta un marcador, activaremos la bandera
    for i=7:9   
        if ((isalmost(cond1,mtx(i),0.0025)) && (isalmost(cond2,mty(i),0.0025)) && ((15-i) ~= robot.mcont))
            robot.ind = 1;
            break
        else
            robot.ind = 0;
        end
    end
    
    %Dada la bandera, aumentar el conteo de marcadores y reportar
    if robot.ind == 1
        robot = increm(robot);
        str = sprintf('Mcont = %d',robot.mcont);
        robot = h6(robot, str, 15, 1);
    else    
        %De lo contrario, seguir moviendo el robot hacia la derecha
        [robot] = CinDir(robot);
    end
    
    
%Sección 40 (Avance final)
elseif(secrobot==40)
    %Corrección de orientación (compensando avances discretos de la
    %simulación)
    robot.theta = -pi;
    
    %Pausa para ver cuando se ha detectado un marcador
    if robot.ind == 1
        pause(0.5)
    end
    
    %Terminó la curva para el robot
    robot.curva=0;
    
    %Si se alcanzó la indicada, pasar a siguiente sección
    if(robot.mcont == 14)
        secrobot = secrobot + 1;
        return
    end
    
    %Confirmar si el convoy ha entrado a la etapa de curva
    robot = h6(robot, 'Confirmar normalidad', 23, 2);
    
    %Ajustar la velocidad acorde a la respuesta anterior
    if robot.stat == 1
         wmax=(4391/51)*(pi/30);
         robot = h1(robot, [1 1 1 1], [wmax wmax wmax wmax]);
    else
        wmed=0;
        robot = h1(robot, [1 1 1 1], [wmed wmed wmed wmed]);
    end
        
    %Aproximar las coordenadas del sensor inductivo
    cond1=roundsd(robot.indy,5); 
        
    %Si se detecta un marcador, activaremos la bandera
    for i=1:7                  
        if ((isalmost(cond1,mty(i),0.0025)) && ((15-i) ~= robot.mcont))
            robot.ind = 1;
            break
        else
            robot.ind = 0;
        end
    end
    
    %Dada la bandera, aumentar el conteo de marcadores y reportar
    if robot.ind == 1
        robot = increm(robot);
        str = sprintf('Mcont = %d',robot.mcont);
        robot = h6(robot, str, 15, 1);
    else    
        %De lo contrario, seguir moviendo el robot hacia la derecha
        [robot] = CinDir(robot);
    end
    
    
%Sección 41 (Detener e iniciar giro antihorario 180°)
elseif(secrobot==41)
    %Detener el robot y reportar
    robot = h6(robot, 'Detener', 2, 1);
    wmax=(4391/51)*(pi/30);
    robot = h1(robot, [0 0 0 0], [wmax wmax wmax wmax]);
    
    %Iniciar giro antihorario 180° y reportar
    robot = h6(robot, 'Giro Antihorario 180°', 17, 1);
    wmax=(4391/51)*(pi/30);
    robot = h1(robot, [1 -1 -1 1], [wmax wmax wmax wmax]);
    
    %Mover el robot
    [robot] = CinDir(robot);
    
    %Pasar a la siguiente sección
    secrobot = secrobot + 1;
    
    
%Sección 42 (Giro antihorario 180°)
elseif(secrobot==42)
    %Aproximar las coordenadas del sensor infrarrojo
    cond1=roundsd(robot.infx,5);
    cond2=roundsd(robot.infy,5);
    
    %Verificar si se detecta nuevamente la linea de trayectoria
    if ((isalmost(cond1,20,0.0025)) && (isalmost(cond2,0.444,0.0025)))
        robot.inf = 1;
    else
        robot.inf = 0;
    end
    
    %Dada la bandera, pasar a la siguiente sección
    if robot.inf == 1
        secrobot = secrobot + 1;
    else    
        %De lo contrario, seguir moviendo el robot hacia la izquierda
        [robot] = CinDir(robot);
    end
    
    
%Sección 43 (Final de acción cooperativa I4)
elseif(secrobot==43)
    %Corrección de orientación
    robot.theta = 0;
    
    %Detener el robot y reportar
    robot = h6(robot, 'Detener', 2, 1);
    wmax=(4391/51)*(pi/30);
    robot = h1(robot, [0 0 0 0], [wmax wmax wmax wmax]);
    
    %Confirmar permiso de finalización
    robot = h6(robot, 'Confirmar permiso', 22, 2);
    
    %Si el permiso es otorgado, esperar a que el coordinador nos reasigne
    if robot.p == 1
        secrobot = secrobot + 1;
    end
    
    
end