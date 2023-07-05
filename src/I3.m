function [robot,secrobot] = I3(robot,secrobot)

%Variables globales
global canafincambia

global mpfx
global mpfy

global mtx


%Sección 21 (Sincronizar actuación)
if(secrobot==21)
    %Confirmar permiso de actuación
    robot = h6(robot, 'Confirmar permiso', 22, 2);
    
    %Si el permiso es otorgado, pasar a siguiente sección
    if robot.p == 1
        secrobot = secrobot + 1;
    end
    

%Sección 22 (Tensionar brazo e iniciar movimiento hacia la derecha)
elseif(secrobot==22)    
    %Tensionar el brazo
    robot = h3(robot,1);
    
    %Inicio de movimiento hacia la derecha y reporte
    robot = h6(robot, 'Derecha', 6, 1);
    wmax=(4391/51)*(pi/30);
    robot = h1(robot, [-1 1 -1 1], [wmax wmax wmax wmax]);
    
    %Mover el robot
    [robot] = CinDir(robot);
    
    %Autorizar paso a la siguiente sección
    secrobot=secrobot+1;  
    
    
%Sección 23 (Moverse a la derecha hasta alcanzar el estante)
elseif(secrobot==23)
    
    %Aproximar las coordenadas del sensor inductivo
    cond1=roundsd(robot.indx,5); 
        
    %Si se detecta un marcador, activaremos la bandera
    if (isalmost(cond1,mpfx(1),0.0025))
        robot.ind = 1;
    else
        robot.ind = 0;
    end
    
    %Dada la bandera, pasar a la siguiente sección
    if robot.ind == 1
        secrobot = secrobot + 1;
        return
    else    
        %De lo contrario, seguir moviendo el robot hacia la derecha
        [robot] = CinDir(robot);
    end
    

%Sección 24 (Detener y sincronizar)    
elseif(secrobot==24)
    %Detener robot y reportar
    robot = h6(robot, 'Detener', 2, 1);
    wmax=(4391/51)*(pi/30);
    robot = h1(robot, [0 0 0 0], [wmax wmax wmax wmax]);
    
    %Confirmar permiso de actuación
    robot = h6(robot, 'Confirmar permiso', 22, 2);
    
    %Si el permiso es otorgado, pasar a siguiente sección
    if robot.p == 1
        secrobot = secrobot + 1;
    end
    
    
%Sección 25(Posicionar gripper y sincronizar)
elseif(secrobot==25)
    %Verificar altura a la cual descargar
    robot = h6(robot, 'Altura de descarga', 26, 2);
    
    %Subir el gripper a la altura indicada y reportar
    robot = h2(robot,robot.dejar_en);
    str = sprintf('Altura OK = %d',robot.dejar_en);
    robot = h6(robot, str, 12, 1);
    
    %Confirmar permiso de actuación
    robot = h6(robot, 'Confirmar permiso', 22, 2);
    
    %Si el permiso es otorgado, pasar a siguiente sección
    if robot.p == 1
        %Indicar que cambia conteo de canaletas en estante
        canafincambia(robot.ident) = 1;
    
        secrobot = secrobot + 1;
    end
    
    
%Sección 26 (Abrir grippers e iniciar distanciamiento de la canaleta)
elseif(secrobot==26)
    %Ya se cambió conteo de canaletas en estante
    canafincambia(robot.ident) = 0;
    
    %Abrir el gripper
    robot = h4(robot,0);
    
    %Pausa de 1 segundo (0.5 cada agente) para saber que se descargó
    pause(0.05)
    
    %Iniciar distanciamiento y reportar
    if robot.ident == 1;
        robot = h6(robot, 'Adelante', 3, 1);
        wmax=(4391/51)*(pi/30);
        robot = h1(robot, [1 1 1 1], [wmax wmax wmax wmax]);        
    else
        robot = h6(robot, 'Atrás', 4, 1);
        wmax=(4391/51)*(pi/30);
        robot = h1(robot, [-1 -1 -1 -1], [wmax wmax wmax wmax]);
    end
    
    %Mover el robot
    [robot] = CinDir(robot);
    
    %Pasar a la siguiente sección
    secrobot = secrobot + 1;
    
    
%Sección 27 (Distanciamiento, detener y liberar el brazo)
elseif(secrobot==27)    
    %Verificar por cual marcador preguntar
    if robot.ident == 1
        my = mpfy(4);
        wmax=(4391/51)*(pi/30);
        robot = h1(robot, [1 1 1 1], [wmax wmax wmax wmax]);
    else
        my = mpfy(1);
        wmax=(4391/51)*(pi/30);
        robot = h1(robot, [-1 -1 -1 -1], [wmax wmax wmax wmax]);
    end
    
    %Aproximar las coordenadas del sensor inductivo
    cond1=roundsd(robot.indy,5);
    
    %Si se llegó al marcador
    if (isalmost(cond1,my,0.0025))
        %Detener el robot y reportar
        robot = h6(robot, 'Detener', 2, 1);
        wmax=(4391/51)*(pi/30);
        robot = h1(robot, [0 0 0 0], [wmax wmax wmax wmax]);
        
        %Liberar el brazo
        robot = h3(robot,0);
        
        %Preparar el movimiento hacia la izquierda y reportarlo
        robot = h6(robot, 'Izquierda', 5, 1);
        wmax=(4391/51)*(pi/30);
        robot = h1(robot, [1 -1 1 -1], [wmax wmax wmax wmax]);
        
        %Pasar a la siguiente sección
        secrobot = secrobot + 1;
    
    %De lo contrario, continuar distanciamiento
    else
        [robot] = CinDir(robot);
    end
    
    
%Sección 28 (Moverse de regreso a la trayectoria)
elseif(secrobot==28)    
    %Aproximar las coordenadas del sensor inductivo
    cond1=roundsd(robot.indx,5); 
    
    %Verificar el último marcador, el cual pertenece a la trayectoria
    if (isalmost(cond1,mtx(18),0.0025))
        robot.ind = 1;
    else
        robot.ind = 0;
    end
    
    %Dada la bandera, pasar a la siguiente sección
    if robot.ind == 1
        secrobot = secrobot + 1;
    else    
        %De lo contrario, seguir moviendo el robot hacia la izquierda
        [robot] = CinDir(robot);
    end
    
    
%Sección 29 (Detener e iniciar giro horario 180°)
elseif(secrobot==29)
    %Detener el robot y reportar
    robot = h6(robot, 'Detener', 2, 1);
    wmax=(4391/51)*(pi/30);
    robot = h1(robot, [0 0 0 0], [wmax wmax wmax wmax]);
    
    %Iniciar giro horario 180° y reportar
    robot = h6(robot, 'Giro Horario 180°', 16, 1);
    wmax=(4391/51)*(pi/30);
    robot = h1(robot, [-1 1 1 -1], [wmax wmax wmax wmax]);
    
    %Mover el robot
    [robot] = CinDir(robot);
    
    %Pasar a la siguiente sección
    secrobot = secrobot + 1;
    
    
%Sección 30 (Giro horario 180°)
elseif(secrobot==30)
    %Aproximar las coordenadas del sensor infrarrojo
    cond1=roundsd(robot.infx,5);
    cond2=roundsd(robot.infy,5);
    
    %Verificar coordenada de la linea por la que se pregunta
    if robot.ident==1
        lineay = 36.3389;
    else
        lineay = 33.1389;
    end
    
    %Verificar si se detecta nuevamente la linea de trayectoria
    if ((isalmost(cond1,4.3181,0.0025)) && (isalmost(cond2,lineay,0.0025)))
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
    
    
%Sección 31 (Fin de acción cooperativa I3)
elseif(secrobot==31)
    %Corrección de orientación
    robot.theta = -pi;
    
    %Detener el robot y reportar
    robot = h6(robot, 'Detener', 2, 1);
    wmax=(4391/51)*(pi/30);
    robot = h1(robot, [0 0 0 0], [wmax wmax wmax wmax]);
    
    %Ir a la acción cooperativa I4
    secrobot = secrobot + 1;
    
    
end