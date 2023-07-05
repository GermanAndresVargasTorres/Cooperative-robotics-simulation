function [robot,secrobot] = I1(robot,secrobot)

%Variables globales
global ir_a
global canainicambia

global mpix
global mpily2
global mpisy2

global mtx


%Sección 2 (Sincronizar actuación)
if(secrobot==2)
    %Confirmar permiso de actuación
    robot = h6(robot, 'Confirmar permiso', 22, 2);
    
    %Si el permiso es otorgado, pasar a siguiente sección
    if robot.p == 1
        secrobot = secrobot + 1;
    end
    

%Sección 3 (Hallar la canaleta que se debe recoger)
elseif(secrobot==3)    
    %Enviar reporte de pregunta
    robot = h6(robot, 'Número de canaleta', 25, 2);
    
    %Inicio de movimiento hacia la derecha y reporte
    robot = h6(robot, 'Derecha', 6, 1);
    wmax=(4391/51)*(pi/30);
    robot = h1(robot, [-1 1 -1 1], [wmax wmax wmax wmax]);
    
    %Mover el robot
    [robot] = CinDir(robot);
    
    %Autorizar paso a la siguiente sección
    secrobot=secrobot+1;  
    
    
%Sección 4 (Moverse a la derecha hasta alcanzar la canaleta indicada)
elseif(secrobot==4)
    %Si se alcanzó la indicada, pasar a siguiente sección
    if(robot.mcont == ir_a)
        secrobot = secrobot + 1;
        return
    end
    
    %Aproximar las coordenadas del sensor inductivo
    cond1=roundsd(robot.indx,5); 
        
    %Si se detecta un marcador, activaremos la bandera
    for i=1:ir_a                  
        if ((isalmost(cond1,mpix(i),0.0025)) && (i ~= robot.mcont))
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
    

%Sección 5 (Tensionar brazo e iniciar acercamiento a la canaleta)    
elseif(secrobot==5)
    %Detener robot y reportar
    robot = h6(robot, 'Detener', 2, 1);
    wmax=(4391/51)*(pi/30);
    robot = h1(robot, [0 0 0 0], [wmax wmax wmax wmax]);
    
    %Tensionar brazo
    robot = h3(robot, 1);
    
    %Iniciar acercamiento y reportar
    if robot.ident == 1;
        robot = h6(robot, 'Atrás', 4, 1);
        wmax=(4391/51)*(pi/30);
        robot = h1(robot, [-1 -1 -1 -1], [wmax wmax wmax wmax]);
    else
        robot = h6(robot, 'Adelante', 3, 1);
        wmax=(4391/51)*(pi/30);
        robot = h1(robot, [1 1 1 1], [wmax wmax wmax wmax]);
    end
    
    %Mover el robot
    [robot] = CinDir(robot);
    
    %Pasar a la siguiente sección
    secrobot = secrobot + 1;
    
    
%Sección 6(Detener, agarrar canaleta y sincronizar)
elseif(secrobot==6)
    %Verificar por cual marcador preguntar
    if robot.ident == 1
        mpiy = mpily2;
        wmax=(4391/51)*(pi/30);
        robot = h1(robot, [-1 -1 -1 -1], [wmax wmax wmax wmax]);
    else
        mpiy = mpisy2;
        wmax=(4391/51)*(pi/30);
        robot = h1(robot, [1 1 1 1], [wmax wmax wmax wmax]);
    end
    
    %Aproximar las coordenadas del sensor inductivo
    cond1=roundsd(robot.indy,4);
    
    %Si se llegó al marcador
    if (isalmost(cond1,mpiy,0.0015))
        %Detener el robot y reportar
        robot = h6(robot, 'Detener', 2, 1);
        wmax=(4391/51)*(pi/30);
        robot = h1(robot, [0 0 0 0], [wmax wmax wmax wmax]);
        
        %Cerrar el gripper y reportar
        robot = h4(robot,1);
        robot = h6(robot, 'Cerrado', 13, 1);
        
        %Pasar a la siguiente sección
        secrobot = secrobot + 1;
    
    %De lo contrario, continuar acercamiento
    else
        [robot] = CinDir(robot);
    end
    
    
%Sección 7 (Sincronización)
elseif(secrobot==7)
    %Confirmar permiso de actuación
    robot = h6(robot, 'Confirmar permiso', 22, 2);
    
    %Si el permiso es otorgado, pasar a siguiente sección
    if robot.p == 1
        secrobot = secrobot + 1;
    end
    
    
%Sección 8 (Elevar el brazo a la altura máxima y sincronizar de nuevo)
elseif(secrobot==8)
    %Elevar el brazo (10 es la altura máxima)
    robot = h2(robot, 10);
    
    %Pausa correspondiente a la elevación (aprox. 1 segundo, mitad y mitad para cada robot)
    pause(0.5)
    
    %Emitir el reporte
    robot = h6(robot, 'Altura máx', 11, 1);
    
    %Confirmar permiso de actuación
    robot = h6(robot, 'Confirmar permiso', 22, 2);
    
    %Si el permiso es otorgado, pasar a siguiente sección
    if robot.p == 1
        secrobot = secrobot + 1;
        
        %Indicar que cambia conteo de canaletas en estiba
        canainicambia(robot.ident) = 1;
        
        %Preparar el movimiento hacia la izquierda y reportarlo
        robot = h6(robot, 'Izquierda', 5, 1);
        wmax=(4391/51)*(pi/30);
        robot = h1(robot, [1 -1 1 -1], [wmax wmax wmax wmax]);
    end
    
    
%Sección 9 (Moverse de regreso al punto de transporte)
elseif(secrobot==9)
    %Ya se cambió conteo de canaletas en estiba
    canainicambia(robot.ident) = 0;
    
    %Si se alcanzó la indicada, pasar a siguiente sección
    if(robot.mcont == 0)
        secrobot = secrobot + 1;
        return
    end
    
    %Aproximar las coordenadas del sensor inductivo
    cond1=roundsd(robot.indx,5); 
        
    %Si se detecta un marcador, activaremos la bandera
    for i=1:ir_a                  
        if ((isalmost(cond1,mpix(i),0.0025)) && (i ~= robot.mcont))
            robot.ind = 1;
            break
        else
            robot.ind = 0;
        end
    end
    
    %Verificar el último marcador, el cual pertenece a la trayectoria
    if (isalmost(cond1,mtx(1),0.0025))
        robot.ind = 1;
    end
    
    %Dada la bandera, reducir el conteo de marcadores y reportar
    if robot.ind == 1
        robot = decrem(robot);
        str = sprintf('Mcont = %d',robot.mcont);
        robot = h6(robot, str, 15, 1);
    else    
        %De lo contrario, seguir moviendo el robot hacia la derecha
        [robot] = CinDir(robot);
    end
    
    
%Sección 10 (Final de acción cooperativa I1)
elseif(secrobot==10)
    %Detener el robot y reportar
    robot = h6(robot, 'Detener', 2, 1);
    wmax=(4391/51)*(pi/30);
    robot = h1(robot, [0 0 0 0], [wmax wmax wmax wmax]);
    
    %Liberar el brazo
    robot=h3(robot,0);
    
    %Ir a la acción cooperativa I2
    secrobot = secrobot + 1;
    
end