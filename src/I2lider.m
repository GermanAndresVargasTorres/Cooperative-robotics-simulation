function [robot,secrobot] = I2lider(robot,secrobot)

%Variables globales
global mtx
global mty


%Sección 11 (Sincronizar actuación)
if(secrobot==11)
    %Confirmar permiso de actuación
    robot = h6(robot, 'Confirmar permiso', 22, 2);
    
    %Si el permiso es otorgado, pasar a siguiente sección
    if robot.p == 1
        secrobot = secrobot + 1;
    end
    
    
%Sección 12 (Inicio movimiento hacia adelante)
elseif(secrobot==12)        
    %Inicio de movimiento hacia adelante y reporte
    robot = h6(robot, 'Adelante', 3, 1);
    wmax=(4391/51)*(pi/30);
    robot = h1(robot, [1 1 1 1], [wmax wmax wmax wmax]);
    
    %Mover el robot
    [robot] = CinDir(robot);
    
    %Autorizar paso a la siguiente sección
    secrobot=secrobot+1;  
    
    
%Sección 13 (Avanzar hasta la curva)
elseif(secrobot==13)
    %Si se alcanzó la indicada, pasar a siguiente sección
    if(robot.mcont == 4)
        secrobot = secrobot + 1;
        return
    end
    
    %Aproximar las coordenadas del sensor inductivo
    cond1=roundsd(robot.indy,5); 
        
    %Si se detecta un marcador, activaremos la bandera
    for i=4:8                  
        if ((isalmost(cond1,mty(i),0.0025)) && ((i-4) ~= robot.mcont))
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
    
    
%Sección 14 (Inicio curva hacia la izquierda)
elseif(secrobot==14)
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
    
    
%Sección 15 (Curva hacia la izquierda)
elseif(secrobot == 15)
    %Si se alcanzó la indicada, pasar a siguiente sección
    if(robot.mcont == 6)
        secrobot = secrobot + 1;
        return
    end
    
    %Aproximar las coordenadas del sensor inductivo
    cond1=roundsd(robot.indx,5);
    cond2=roundsd(robot.indy,5);
        
    %Si se detecta un marcador, activaremos la bandera
    for i=8:10    
        if ((isalmost(cond1,mtx(i),0.0025)) && (isalmost(cond2,mty(i),0.0025)) && ((i-4) ~= robot.mcont))
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
    
    
%Sección 16 (Avanzar hacia la segunda curva)
elseif(secrobot==16)
    %Corrección de orientación (compensando avances discretos de la
    %simulación)
    robot.theta = pi/2;
    
    %Pausa para ver cuando se ha detectado un marcador
    if robot.ind == 1
        pause(0.5)
    end
    
    %Terminó la curva para el robot
    robot.curva=0;
    
    %Si se alcanzó la indicada, pasar a siguiente sección
    if(robot.mcont == 8)
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
    for i=10:12                  
        if ((isalmost(cond1,mtx(i),0.0025)) && ((i-4) ~= robot.mcont))
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
    
    
%Sección 17 (Inicio curva hacia la derecha)
elseif(secrobot==17)
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
    
    
%Sección 18 (Curva hacia la derecha)
elseif(secrobot == 18)
    %Si se alcanzó la indicada, pasar a siguiente sección
    if(robot.mcont == 10)
        secrobot = secrobot + 1;
        return
    end
    
    %Aproximar las coordenadas del sensor inductivo
    cond1=roundsd(robot.indx,5);
    cond2=roundsd(robot.indy,5);
        
    %Si se detecta un marcador, activaremos la bandera
    for i=12:14   
        if ((isalmost(cond1,mtx(i),0.0025)) && (isalmost(cond2,mty(i),0.0025)) && ((i-4) ~= robot.mcont))
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
    
    
%Sección 19 (Avance final)
elseif(secrobot==19)
    %Corrección de orientación (compensando avances discretos de la
    %simulación)
    robot.theta = 0;
    
    %Pausa para ver cuando se ha detectado un marcador
    if robot.ind == 1
        pause(0.5)
    end
    
    %Terminó la curva para el robot
    robot.curva=0;
    
    %Si se alcanzó la indicada, pasar a siguiente sección
    if(robot.mcont == 13)
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
    for i=14:18                  
        if ((isalmost(cond1,mty(i),0.0025)) && ((i-4) ~= robot.mcont))
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
    
    
%Sección 20 (Final de acción cooperativa I2)
elseif(secrobot==20)
    %Detener el robot y reportar
    robot = h6(robot, 'Detener', 2, 1);
    wmax=(4391/51)*(pi/30);
    robot = h1(robot, [0 0 0 0], [wmax wmax wmax wmax]);
    
    %Ir a la acción cooperativa I3
    secrobot = secrobot + 1;
    
    
end