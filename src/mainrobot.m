function [robot,secrobot] = mainrobot(robot,secrobot,introbot)

%Variables globales
global obs
global obsx
global obsy 
global obswhere
global intlidexiste
global intsegexiste
global tiempo


%Verificar cual interrupci�n debo verificar
if robot.ident == 1
    introboexiste = intlidexiste;
else
    introboexiste = intsegexiste;
end


try   
    
    %Verificar si ha aparecido un obst�culo
    if strcmp(get(obs,'Visible'),'on')
        %Verificar distancia al obst�culo
        if strcmp(obswhere,'x')
            d=abs(robot.x-obsx);
        elseif strcmp(obswhere,'y')
            d=abs(robot.y-obsy);
        end
        
        %Si distancia es menor a 0.862, lanzar interrupci�n
        if d <= 0.862
            %Si acaba de ocurrir la interrupcion
            if introboexiste==0
                %Leer y guardar el movimiento actual
                robot = h6(robot, 'Movimiento actual', 27, 2);
                robot = h6(robot, 'Velocidad actual', 28, 2);
            end
            
            %Salir del main e ir a la interrupci�n
            error('S3')
        end  
        
    %Si regreso de una 'S3'
    elseif(introboexiste == 3)
        %Retomar y reportar movimiento antes del corte
        robot = h1(robot, robot.oldmov, robot.oldvel);
        robot = h6(robot, 'Viejo', 10, 1);
        
        %Enviar orden para que el agente amigo retome movimiento
        robot = h6(robot, 'Mover Amigo', 20, 1);   
        
        %Apagar las alarmas visual y sonora del robot
        robot = h7(robot, 0);
        
        %Resetear el cron�metro de tiempo detenido
        tiempo.min=0;
        tiempo.seg=0;
        tiempo.cent=0;
        
        %Remover el mensaje 'S3'
        introboexiste = 0;
    end
    
    
    %Verificar si se ha ca�do la comunicaci�n (S5)
    if (robot.com == 0)
        %Si acaba de ocurrir la interrupcion
        if introboexiste==0
            %Leer y guardar el movimiento actual
            robot.oldmov = [robot.dir1 robot.dir2 robot.dir3 robot.dir4];
            robot.oldvel = [robot.phi1punto robot.phi2punto robot.phi3punto robot.phi4punto];
        end
            
        %Salir del main e ir a la interrupci�n
        error('S5')
        
    %Si regreso de una 'S5'
    elseif(introboexiste == 5)
        %Retomar y reportar movimiento antes del corte
        robot = h1(robot, robot.oldmov, robot.oldvel);
        robot = h6(robot, 'Viejo', 10, 1);
        
        %Enviar orden para que el agente amigo retome movimiento
        robot = h6(robot, 'Mover Amigo', 20, 1); 
        
        %Remover el mensaje 'S5'
        introboexiste = 0;
    end
    
    
    %Verificar si hay mensaje entrante de detener (S7)
    %("detener amigo" est� identificado con repcod == 21)
    if introbot == 21
        %Si acaba de ocurrir la interrupcion
        if introboexiste==0
            %Leer y guardar el movimiento actual
            robot = h6(robot, 'Movimiento actual', 27, 2);
            robot = h6(robot, 'Velocidad actual', 28, 2);
        end
        
        %Salir del main e ir a la interrupci�n
        error('S7')
        
    %Si regreso de una 'S7'
    elseif(introboexiste == 7)
        %Mientras no haya normalidad, mantener bloqueo hasta confirmarla
        while robot.stat == 0
            robot = h6(robot, 'Confirmar Normalidad', 23, 2);                
        end
        
        %Retomar y reportar movimiento antes del corte
        robot = h1(robot, robot.oldmov, robot.oldvel);
        robot = h6(robot, 'Viejo', 10, 1);       
        
        %Remover el mensaje 'S7'
        introboexiste = 0;
    end
    
    
    %Secci�n 0 (Configuraci�n inicial)
    if(secrobot==0)
        %Verificar si comunicaciones est�n activas
        while robot.com == 0
        end

        %Asignar etapa y configuraci�n inicial del robot
        robot.etapa = 0;
        robot = h2(robot, 0);   %Altura m�nima para el gripper
        robot = h3(robot, 0);   %Giro de brazo libre
        robot = h4(robot, 0);   %Abrir el gripper
    
        %Enviar reporte de "Listo"
        robot = h6(robot, 'Listo', 1, 1);
        
        %Autorizar paso a la siguiente secci�n
        secrobot=secrobot+1;
    
    
    %Secci�n 1 (Negociar ciclo de transporte)
    elseif(secrobot==1)        
        %Preguntar nivel de bater�a
        robot = h6(robot, 'Nivel de bater�a', 24, 2);
        
        %Si la negociaci�n es fallida, llamar recarga y apagar el robot
        if robot.n == 0
            robot = h6(robot, 'Llamar recarga', 32, 1);
        %Si la negociaci�n es exitosa, autorizar paso a la siguiente
        %secci�n       
        else
            secrobot=secrobot+1;
        end
    
    
    %Secci�n 2 (Configuraci�n inicial de la acci�n cooperativa I1)
    elseif(secrobot==2)
        %Pausa para ver el �ltimo mensaje
        pause(0.5)
        
        %Asignar configuraci�n inicial de la etapa
        robot.etapa = 1;
        robot.mcont = 0;
        robot.ir_a = 0;
        
        %Reportar los valores configurados
        robot = h6(robot, 'Etapa = 1', 14, 1);
        robot = h6(robot, 'Mcont = 0', 15, 1);
        
        %Llamar funci�n de la acci�n cooperativa
        [robot,secrobot] = I1(robot,secrobot);
    
    
    %Secciones 3 a 10 (Ir directamente a I1)
    elseif((secrobot>=3) && (secrobot<=10))        
        %Llamar funci�n de la acci�n cooperativa
        [robot,secrobot] = I1(robot,secrobot);
    
    
    %Secci�n 11 (Configuraci�n inicial de la acci�n cooperativa I2)
    elseif(secrobot==11)
        %Pausa para ver el �ltimo mensaje
        pause(0.5)
        
        %Asignar configuraci�n inicial de la etapa
        robot.etapa = 2;
        robot.mcont = 0;
        robot.curva = 0;
        
        %Reportar los valores configurados
        robot = h6(robot, 'Etapa = 2', 14, 1);
        robot = h6(robot, 'Mcont = 0', 15, 1);
        
        %Verificar cual funci�n llamar
        if robot.ident == 1
            [robot,secrobot] = I2lider(robot,secrobot);
        elseif robot.ident == 2
            [robot,secrobot] = I2seguidor(robot,secrobot);
        end
        
        
    %Secciones 12 a 20 (Ir directamente a I2)
    elseif((secrobot>=12) && (secrobot<=20)) 
        %Verificar cual funci�n llamar
        if robot.ident == 1
            [robot,secrobot] = I2lider(robot,secrobot);
        elseif robot.ident == 2
            [robot,secrobot] = I2seguidor(robot,secrobot);
        end        
    
    
    %Secci�n 21 (Configuraci�n inicial de la acci�n cooperativa I3)
    elseif(secrobot==21)
        %Pausa para ver el �ltimo mensaje
        pause(0.5)
        
        %Asignar configuraci�n inicial de la etapa
        robot.etapa = 3;
        robot.dejar_en = 0;
        
        %Reportar los valores configurados
        robot = h6(robot, 'Etapa = 3', 14, 1);
        
        %Llamar funci�n de la acci�n cooperativa
        [robot,secrobot] = I3(robot,secrobot);
        
        
    %Secciones 22 a 31 (Ir directamente a I3)
    elseif((secrobot>=22) && (secrobot<=31))
        %Llamar funci�n de la acci�n cooperativa
        [robot,secrobot] = I3(robot,secrobot);
    
    
    %Secci�n 32 (Configuraci�n inicial de la acci�n cooperativa I4)
    elseif(secrobot==32)
        %Pausa para ver el �ltimo mensaje
        pause(0.5)
        
        %Asignar configuraci�n inicial de la etapa
        robot.etapa = 4;
        robot.mcont = 0;
        robot.curva = 0;
        
        %Reportar los valores configurados
        robot = h6(robot, 'Etapa = 4', 14, 1);
        robot = h6(robot, 'Mcont = 0', 15, 1);
        
        %Verificar cual funci�n llamar
        if robot.ident == 1
            [robot,secrobot] = I4lider(robot,secrobot);
        elseif robot.ident == 2
            [robot,secrobot] = I4seguidor(robot,secrobot);
        end
        
        
    %Secciones 33 a 44 (Ir directamente a I4)
    elseif((secrobot>=33) && (secrobot<=44)) 
        %Verificar cual funci�n llamar
        if robot.ident == 1
            [robot,secrobot] = I4lider(robot,secrobot);
        elseif robot.ident == 2
            [robot,secrobot] = I4seguidor(robot,secrobot);
        end  
    
    end
    

catch interrupcionrobot    
    
    %Clasificar el error generado y actuar correspondientemente
    cualfue = interrupcionrobot.message;
    switch cualfue       
        
        case 'S3'
            %Si acaba de ocurrir la interrupcion
            if introboexiste == 0
                %Reportar el bloqueo al coordinador
                robot = h6(robot, 'Bloqueo', 30, 1);
            
                %Detener el agente
                robot = h1(robot, [0 0 0 0], robot.oldvel);
            
                %Enviar orden para que el agente amigo se detenga
                robot = h6(robot, 'Detener amigo', 21, 1); 
            end
            
            %Si el tiempo es mayor a 30, solicitar atenci�n al bloqueo
            if tiempo.seg >= 30
                robot = h6(robot, 'Acudir a bloqueo', 31, 1);
                
                %Apagar las alarmas visual y sonora del robot
                robot = h7(robot, 0);
                
            %Si el tiempo es menor a 30, prender las alarmas visual y 
            %sonora y aumentar el contador de tiempo
            elseif tiempo.seg < 30
                robot = h7(robot, 1);
                
                tiempo = aumentar(tiempo);
            end
            
            %Indicar a coordinador que ocurri� 'S3'
            introboexiste = 3;
                
        case 'S5'    
            
            %Reiniciar el m�dulo inal�mbrico (se pausa 4 segundos para
            %observar el cambio)
            robot = h8(robot);
            pause(4)
            
            %Reportar "online"
            robot = h6(robot, 'Online', 33, 1);
            
            %Indicar a coordinador que ocurri� 'S5'
            introboexiste = 5;                           
                                    
        case 'S7'    
            
            %Detener y reportar 
            robot = h1(robot, [0 0 0 0], robot.oldvel);
            robot = h6(robot, 'Detener', 2, 1);
               
            %Indicar a coordinador que ocurri� 'S3'
            introboexiste = 7;
            
    end 
                
end


%Verificar en cual interrupci�n debo guardar
if robot.ident == 1
    intlidexiste = introboexiste;
else
    intsegexiste = introboexiste;
end

        