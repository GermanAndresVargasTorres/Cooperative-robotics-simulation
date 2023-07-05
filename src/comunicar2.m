function val = comunicar2(ident, reporte, repcod)

%Variables globales
global lider
global seguidor 

global reportelider
global reportesegui

global normalid
global normaseg
global permiso
global bateria
global negocio
global ir_a
global dejar_en

%Asignar el reporte a la variable correspondiente en el coordinador
if (ident==1)
    reportelider=reporte;
elseif (ident==2)
    reportesegui=reporte;
end


%Clasificar el mensaje entrante
switch repcod
    
    case 22     %Confirmar permiso
        val = permiso;
        
    case 23     %Confirmar normalidad
        if ident==1
            val = normalid;
        elseif ident==2
            val = normaseg;
        end
        
    case 24     %Nivel de batería
        val = negocio;
        
    case 25     %Número de canaleta
        val = ir_a;
        
    case 26     %Altura de descarga
        val = dejar_en;
        
    case 27     %Movimiento actual
        if ident==1
            val = [lider.dir1 lider.dir2 lider.dir3 lider.dir4];
        elseif ident==2
            val = [seguidor.dir1 seguidor.dir2 seguidor.dir3 seguidor.dir4];
        end
        
    case 28     %Velocidad actual
        if ident==1
            val = [lider.phi1punto lider.phi2punto lider.phi3punto lider.phi4punto];
        elseif ident==2
            val = [seguidor.phi1punto seguidor.phi2punto seguidor.phi3punto seguidor.phi4punto];
        end
        
    case 29     %Velocidad amigo
        if ident==1
            val = [seguidor.phi1punto seguidor.phi2punto seguidor.phi3punto seguidor.phi4punto];
        elseif ident==2
            val = [lider.phi1punto lider.phi2punto lider.phi3punto lider.phi4punto];
        end 
        
end