classdef transportador
    %Este es el archivo principal para el rol de transportador
    
    properties
        %Identificador del robot
        %(1=lider, 2=seguidor)
        ident=1;          
        
        %Etapa del algoritmo en la cual se encuentra el agente
        etapa=0;
        
        %Contador de marcadores de actuación
        mcont=0;
        
        %Indicador de reducción de velocidad en curva
        curva=0;
        
        
        %Coordenadas del robot
        x=0;
        y=0;
        theta=0;
        
        %Velocidades globales (variables adicionales para dibujar los
        %obstáculos)
        xipunto=0;
        yipunto=0;
        thetaipunto=0;
        
        
        %Vertices para dibujar el robot
        verx=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        very=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        
        %Coordenadas cartesianas de los sensores
        infx=0;
        infy=0;
        
        indx=0;
        indy=0;
        
        ultx=0;
        ulty=0;
        
        %Ángulos para coordenadas polares de los sensores
        ainf=-pi/2;
        aind=pi/2;
        ault=pi/2;       
        
        %Coordenadas cartesianas del gripper
        gripx=0;
        gripy=0;
        
        %Ángulo para coordenadas polares del gripper
        agrip=0;
        
        
        %Sentido de giro de las cuatro ruedas (H1)
        %(0 = rueda apagada, 1 = giro horario/hacia adelante, -1 = giro antihorario/hacia atras)
        dir1=1;
        dir2=1;
        dir3=1;
        dir4=1;
        
        %Velocidad de giro de las cuatro ruedas (H1)
        %El valor máximo es Wmax = 9.02 rad/s
        %wmax=(4391/51)*(pi/30);
        phi1punto=(4391/51)*(pi/30);
        phi2punto=(4391/51)*(pi/30);
        phi3punto=(4391/51)*(pi/30);
        phi4punto=(4391/51)*(pi/30);
        
        %Altura del brazo (H2)
        %(0=mínima, 10=máxima)
        altura=0;
        
        %Sujeción del brazo (H3)
        %(0=libre, 1=tensionado)
        brazo=0;
        
        %Estado del gripper (H4)
        %(0=abierto, 1=cerrado)
        grip=0;
        
        %Estado de los sensores (H5)
        %(0=no detecta, 1=detecta)
        inf=1;
        ind=1;
        ult=0;
        
        %Mensaje y código para reporte (H6)
        reporte='Listo';
        repcod=1;
        
        %Alarma de luz y alarma sonora (H7)
        %(0=apagadas, 1=encendidas)
        alarmas=0;
        
        %Estado de la comunicación inalámbrica (H8)
        %(0=desconectado, 1=normal)
        com=1;
        
        
        %Variables para almacenar respuestas de comunicación
        p = 0;              %22) Confirmar permiso
        stat = 0;           %23) Confirmar normalidad
        n = 1;              %24) Nivel de batería
        ir_a = 0;           %25) Número de canaleta
        dejar_en = 0;       %26) Altura de descarga
        oldmov = [0 0 0 0];         %27) Movimiento actual
        oldvel = [0 0 0 0];         %28) Velocidad actual
        friendvel = [0 0 0 0];      %29) Velocidad amigo
        
    end
    
    methods
        
        %Esta es la función del constructor
        function obj = transportador(i, cx, cy, ang)
            %Asignar valores
            obj.ident = i;
            
            obj.x = cx;
            obj.y = cy;  
            obj.theta = rem(ang, 2*pi);
            
            obj.verx = [cx-0.1665 cx cx+0.1665 cx+0.1665 cx+0.1665 cx+0.31 cx+0.31 cx+0.31 cx+0.1665 cx+0.1665 cx+0.1665 cx cx-0.1665 cx-0.1665 cx-0.1665 cx-0.1665];
            obj.very = [cy-0.175 cy-0.175 cy-0.175 cy-0.056 cy-0.0325 cy-0.0325 cy cy+0.0325 cy+0.0325 cy+0.051 cy+0.175 cy+0.175 cy+0.175 cy+0.051 cy cy-0.056];
            
            obj.infx=cx+0.056*cos(obj.ainf+ang);
            obj.infy=cy+0.056*sin(obj.ainf+ang);
            
            obj.indx=cx+0.051*cos(obj.aind+ang);
            obj.indy=cy+0.051*sin(obj.aind+ang);
            
            obj.ultx=cx+0.217*cos(obj.ault+ang);
            obj.ulty=cy+0.217*sin(obj.ault+ang);
            
            obj.gripx=cx+0.31*cos(obj.agrip+ang);
            obj.gripy=cy+0.31*sin(obj.agrip+ang);
        end
        
        %Función para actualizar las coordenadas del robot
        function obj = actualizar(obj, cx, cy, ang)
            %Asignar valores
            obj.x = cx;
            obj.y = cy;  
            obj.theta = rem(ang, 2*pi);
            
            obj.verx = [cx-0.1665 cx cx+0.1665 cx+0.1665 cx+0.1665 cx+0.31 cx+0.31 cx+0.31 cx+0.1665 cx+0.1665 cx+0.1665 cx cx-0.1665 cx-0.1665 cx-0.1665 cx-0.1665];
            obj.very = [cy-0.175 cy-0.175 cy-0.175 cy-0.056 cy-0.0325 cy-0.0325 cy cy+0.0325 cy+0.0325 cy+0.051 cy+0.175 cy+0.175 cy+0.175 cy+0.051 cy cy-0.056];
            
            obj.infx=cx+0.056*cos(obj.ainf+ang);
            obj.infy=cy+0.056*sin(obj.ainf+ang);
            
            obj.indx=cx+0.051*cos(obj.aind+ang);
            obj.indy=cy+0.051*sin(obj.aind+ang);
            
            obj.ultx=cx+0.217*cos(obj.ault+ang);
            obj.ulty=cy+0.217*sin(obj.ault+ang);
            
            obj.gripx=cx+0.31*cos(obj.agrip+ang);
            obj.gripy=cy+0.31*sin(obj.agrip+ang);           
        end
        
        %Función para incrementar el contador de marcadores
        function obj = increm(obj)
            obj.mcont = obj.mcont + 1;
        end
        
        function obj = decrem(obj)
            obj.mcont = obj.mcont - 1;
        end
        
        
        %Funciones para modificar los valores de las habilidades
        
        function obj = h1(obj, d, v)
            %Asignar valores de sentido de giro
            obj.dir1=d(1);
            obj.dir2=d(2);
            obj.dir3=d(3);
            obj.dir4=d(4);
            
            %Asignar valores de velocidad de giro
            obj.phi1punto=v(1);
            obj.phi2punto=v(2);
            obj.phi3punto=v(3);
            obj.phi4punto=v(4);
        end
        
        function obj = h2(obj, alt)
            %Asignar valor de altura del brazo
            obj.altura = alt;
        end
        
        function obj = h3(obj, free)
            %Asignar valor de sujeción del brazo
            obj.brazo = free;
        end
        
        function obj = h4(obj, grip)
            %Asignar valor de estado del gripper
            obj.grip = grip;
        end
        
        function obj = h5(obj, inf, ind, ult)
            %Asignar valores del estado de los sensores
            obj.inf=inf;
            obj.ind=ind;
            obj.ult=ult;
        end
        
        function obj = h6(obj, reporte, repcod, reptipo)
            %Asignar nuevo valor y código al reporte
            obj.reporte = reporte;
            obj.repcod = repcod;
            
            %Comunicar el reporte al coordinador
            %(tipo R1 = 1 no requiere respuesta)
            if reptipo==1
                comunicar1(obj.ident, obj.reporte, obj.repcod);                
                
            %(tipo R2 = 2 si requiere respuesta)
            elseif reptipo==2
                val=comunicar2(obj.ident, obj.reporte, obj.repcod);
                    
                %Asignar valores recibidos
                switch obj.repcod
                    case 22     %Confirmar permiso
                            obj.p = val;
                    case 23     %Confirmar normalidad
                            obj.stat = val;
                    case 24     %Nivel de batería
                            obj.n = val;
                    case 25     %Número de canaleta
                            obj.ir_a = val;
                    case 26     %Altura de descarga
                            obj.dejar_en = val;
                    case 27     %Movimiento actual
                            obj.oldmov = val;
                    case 28     %Velocidad actual
                            obj.oldvel = val;
                    case 29     %Velocidad amigo
                            obj.friendvel = val;    
                end
            end    
                    
        end
        
        function obj = h7(obj, alarmas)
            %Conmutar las alarmas
            obj.alarmas = alarmas;
        end
        
        function obj = h8(obj)
            %Reiniciar el módulo inalámbrico
            obj.com = 1;
        end
        
        
    end
    
    
end
                