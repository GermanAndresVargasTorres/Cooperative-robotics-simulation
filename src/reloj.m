classdef reloj
    %Este es el archivo principal para la clase "reloj"
    
    properties
        %Conteo
        min=0;
        seg=0;
        cent=0;
        
        %Bandera que se activa cada cambio de minuto
        cambio=0;
    end
    
    methods
        
        %Esta es la función del constructor
        function obj = reloj()
            obj.min=0;
            obj.seg=0;
            obj.cent=0;
            obj.cambio=0;
        end
            
        %Función para incrementar el tiempo
        function obj = aumentar(obj)
            %Desactivar la bandera
            obj.cambio = 0;
            
            %Incrementar dos centésimas de segundo
            obj.cent=obj.cent + 2;
            
            %Si es necesario, incrementar segundos
            if(obj.cent == 100)
                obj.seg = obj.seg + 1;
                obj.cent = 0;    
            end
            
            %Si es necesario, incrementar minutos
            if(obj.seg == 60)
                obj.min = obj.min + 1;
                obj.seg = 0;
                
                %Activar la bandera
                obj.cambio = 1;
            end
        end
        
    end
    
end