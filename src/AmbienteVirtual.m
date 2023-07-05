function varargout = AmbienteVirtual(varargin)
% AMBIENTEVIRTUAL MATLAB code for AmbienteVirtual.fig
%      AMBIENTEVIRTUAL, by itself, creates a new AMBIENTEVIRTUAL or raises the existing
%      singleton*.
%
%      H = AMBIENTEVIRTUAL returns the handle to a new AMBIENTEVIRTUAL or the handle to
%      the existing singleton*.
%
%      AMBIENTEVIRTUAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AMBIENTEVIRTUAL.M with the given input arguments.
%
%      AMBIENTEVIRTUAL('Property','Value',...) creates a new AMBIENTEVIRTUAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AmbienteVirtual_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AmbienteVirtual_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AmbienteVirtual

% Last Modified by GUIDE v2.5 02-Jan-2012 18:19:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AmbienteVirtual_OpeningFcn, ...
                   'gui_OutputFcn',  @AmbienteVirtual_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AmbienteVirtual is made visible.
function AmbienteVirtual_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AmbienteVirtual (see VARARGIN)

% Choose default command line output for AmbienteVirtual
handles.output = hObject;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%El siguiente código se ejecuta al comenzar el programa


%Limpiar command window
clc

%Variables globales
global lider
global seguidor

global drawlider
global liderver
global liderhor
global liderinf
global liderind

global drawseguidor
global seguidorver
global seguidorhor
global seguidorinf
global seguidorind

global canaleta

global mtx
global mty

global mpix
global mpily1
global mpily2
global mpisy1
global mpisy2

global mpfx
global mpfy


%INICIO DEL DIBUJADO

%1. Dibujar otros adornos
estrecarga = rectangle('Position',[18,2,1,1],'Curvature',0.2,'Facecolor','w');
pared1 = rectangle('Position',[0,0,19,1],'Facecolor','k','Edgecolor','none');
pared2 = rectangle('Position',[0,0,1,11.5],'Facecolor','k','Edgecolor','none');
pared3 = rectangle('Position',[0,20,1,20],'Facecolor','k','Edgecolor','none');
pared4 = rectangle('Position',[0,39,30,1],'Facecolor','k','Edgecolor','none');
pared5 = rectangle('Position',[29,0,1,40],'Facecolor','k','Edgecolor','none');
pared6 = rectangle('Position',[15,0,1,10.5],'Facecolor','k','Edgecolor','none');
pared7 = rectangle('Position',[15,10.5,4,1],'Facecolor','k','Edgecolor','none');
pared8 = rectangle('Position',[21,10.5,8,1],'Facecolor','k','Edgecolor','none');
stand1 = rectangle('Position',[2.5,4,10,2],'Facecolor','b','Edgecolor','none');
stand2 = rectangle('Position',[5,16,2,21],'Facecolor','b','Edgecolor','none');
stand3 = rectangle('Position',[11,14.5,2,22.5],'Facecolor','b','Edgecolor','none');
stand4 = rectangle('Position',[17,14.5,2,22.5],'Facecolor','b','Edgecolor','none');
stand5 = rectangle('Position',[23,14.5,2,22.5],'Facecolor','b','Edgecolor','none');


%2. Dibujar trayectoria

%2.1 Segmentos circulares
x1=[20 20 4.7162 4.6042];
y1=[12.444 12.556 12.8419 12.8419];

x2=[19.7162 19.6042 4.3181 4.3181];
y2=[12.8419 12.8419 13.1269 13.2389];

r=0.367;

%Pre-asignando para mayor velocidad
d=[0 0 0 0];
a=[0 0 0 0];
b=[0 0 0 0];
e=[0 0 0 0];

for i=1:4
    d(i) = sqrt((x2(i)-x1(i))^2+(y2(i)-y1(i))^2); % Distance between points    
    b(i) = asin(d(i)/2/r); % Half arc angle
    e(i) = sqrt(r^2-d(i)^2/4); % Distance, center to midpoint
end
for i=1:2
    a(i) = atan2(-(x2(i)-x1(i)),y2(i)-y1(i)); % Perpendicular bisector angle
end
for i=3:4
    a(i) = atan2(x2(i)-x1(i),-(y2(i)-y1(i))); % Perpendicular bisector angle (clockwise)
end

c2a = linspace(a(1)-b(1),a(1)+b(1)); % Arc angle range    
circx2a = (x1(1)+x2(1))/2-e(1)*cos(a(1))+r*cos(c2a); % Cartesian coords. of arc
circy2a = (y1(1)+y2(1))/2-e(1)*sin(a(1))+r*sin(c2a);

c2b = linspace(a(2)-b(2),a(2)+b(2)); % Arc angle range    
circx2b = (x1(2)+x2(2))/2-e(2)*cos(a(2))+r*cos(c2b); % Cartesian coords. of arc
circy2b = (y1(2)+y2(2))/2-e(2)*sin(a(2))+r*sin(c2b);

c4a = linspace(a(3)-b(3),a(3)+b(3)); % Arc angle range    
circx4a = (x1(3)+x2(3))/2-e(3)*cos(a(3))+r*cos(c4a); % Cartesian coords. of arc
circy4a = (y1(3)+y2(3))/2-e(3)*sin(a(3))+r*sin(c4a);

c4b = linspace(a(4)-b(4),a(4)+b(4)); % Arc angle range    
circx4b = (x1(4)+x2(4))/2-e(4)*cos(a(4))+r*cos(c4b); % Cartesian coords. of arc
circy4b = (y1(4)+y2(4))/2-e(4)*sin(a(4))+r*sin(c4b);

trayecto2a = line('XData',circx2a,'YData',circy2a,'Color','y');
trayecto2b = line('XData',circx2b,'YData',circy2b,'Color','y');
trayecto4a = line('XData',circx4a,'YData',circy4a,'Color','y');
trayecto4b = line('XData',circx4b,'YData',circy4b,'Color','y');

%2.2 Segmentos rectos
trayecto1 = line('XData',[20 20],'YData',[0.444 12.444],'Color','y');
trayecto3 = line('XData',[19.7162 4.7162],'YData',[12.8419 12.8419],'Color','y');
trayecto5 = line('XData',[4.3181 4.3181],'YData',[13.1269 36.3389],'Color','y');

%2.3 Dibujar trayectoria de punto inicial
tpil1 = line('XData',[20 22.0945],'YData',[3.944 3.944],'Color','y');
tpil2 = line('XData',[20 22.0945],'YData',[4.444 4.444],'Color','y');
tpis1 = line('XData',[20 22.0945],'YData',[0.944 0.944],'Color','y');
tpis2 = line('XData',[20 22.0945],'YData',[0.444 0.444],'Color','y');

tpil=[0 0 0 0 0 0 0 0 0 0]; %Pre-asignación
tpis=[0 0 0 0 0 0 0 0 0 0]; %Pre-asignación
tpx = [20.8255 20.9665 21.1075 21.2485 21.3895 21.5305 21.6715 21.8125 21.9535 22.0945];

for i=1:10
    tpil=line('XData',[tpx(i) tpx(i)],'YData',[3.944 4.444],'Color','y');
    tpis=line('XData',[tpx(i) tpx(i)],'YData',[0.944 0.444],'Color','y');
end

%2.4 Dibujar trayectoria de punto final
tpf = line('XData',[4.3181 4.755 4.755 4.3181 4.3181 4.755 4.755 4.3181],'YData',[33.0269 33.0269 33.1269 33.1269 36.1269 36.1269 36.2269 36.2269],'Color','y');


%3. Dibujar marcadores

%Marcadores de trayectoria
mtx=[20 20 20 20 20 20 20 20 19.7112 19.6092 4.7112 4.6092 4.3181 4.3181 4.3181 4.3181 4.3181 4.3181];
mty=[0.449 0.551 1.051 4.051 4.449 4.551 12.449 12.551 12.8419 12.8419 12.8419 12.8419 13.1319 13.2339 33.1339 33.2339 36.2339 36.3339];
mt=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; %Pre-asignación

%3.1 Dibujar marcadores de trayectoria
for i=1:18
    mt(i)=rectangle('Position',[mtx(i)-0.0225,mty(i)-0.0225,0.045,0.045],'Curvature',0.99,'FaceColor','r');
end

%Marcadores de punto inicial
mpix = [20.8255 20.9665 21.1075 21.2485 21.3895 21.5305 21.6715 21.8125 21.9535 22.0945];

mpily1 = 4.551;
mpil1 = [0 0 0 0 0 0 0 0 0 0]; %Pre-asignación

mpily2 = 4.051;
mpil2 = [0 0 0 0 0 0 0 0 0 0]; %Pre-asignación

mpisy1 = 0.551;
mpis1 = [0 0 0 0 0 0 0 0 0 0]; %Pre-asignación

mpisy2 = 1.051;
mpis2 = [0 0 0 0 0 0 0 0 0 0]; %Pre-asignación

%3.2 Dibujar marcadores de punto inicial
for i=1:10
    mpil1(i)=rectangle('Position',[mpix(i)-0.0225,mpily1-0.0225,0.045,0.045],'Curvature',0.99,'FaceColor','r');
    mpil2(i)=rectangle('Position',[mpix(i)-0.0225,mpily2-0.0225,0.045,0.045],'Curvature',0.99,'FaceColor','r');
    mpis1(i)=rectangle('Position',[mpix(i)-0.0225,mpisy1-0.0225,0.045,0.045],'Curvature',0.99,'FaceColor','r');
    mpis2(i)=rectangle('Position',[mpix(i)-0.0225,mpisy2-0.0225,0.045,0.045],'Curvature',0.99,'FaceColor','r');
end

%Marcadores de punto final
mpfx = [4.755 4.755 4.755 4.755];
mpfy = [33.1339 33.2339 36.2339 36.3339];

%3.3 Dibujar marcadores de punto final
for i=1:4
    mpf(i)=rectangle('Position',[mpfx(i)-0.0225,mpfy(i)-0.0225,0.045,0.045],'Curvature',0.99,'FaceColor','r');
end

%4. Dibujar estiba (punto inicial)
estiba = rectangle('Position',[21,1.425,1.54,2.15],'Facecolor',[0.5882 0.2941 0]);

%5. Dibujar estante (punto final)
estante = rectangle('Position',[5,32.9329,0.29,3.5],'Facecolor',[0.5882 0.2941 0]);


%Crear robots
lider = transportador(1,20,4.5,0);
seguidor = transportador(2,20,0.5,0);

%Hallar vertices para dibujar los robots
lvx = lider.verx;
lvy = lider.very;

svx = seguidor.verx;
svy = seguidor.very;

%6. Dibujar robots
drawlider = patch(lvx, lvy, 'w');
liderver = line('XData',[lvx(2) lvx(12)],'YData',[lvy(2) lvy(12)]);
liderhor = line('XData',[lvx(7) lvx(15)],'YData',[lvy(7) lvy(15)]);
liderinf = line('XData',[lvx(4) lvx(16)],'YData',[lvy(4) lvy(16)]);
liderind = line('XData',[lvx(10) lvx(14)],'YData',[lvy(10) lvy(14)],'Color','r');

drawseguidor = patch(svx, svy, 'w');
seguidorver = line('XData',[svx(2) svx(12)],'YData',[svy(2) svy(12)]);
seguidorhor = line('XData',[svx(7) svx(15)],'YData',[svy(7) svy(15)]);
seguidorinf = line('XData',[svx(4) svx(16)],'YData',[svy(4) svy(16)]);
seguidorind = line('XData',[svx(10) svx(14)],'YData',[svy(10) svy(14)],'Color','r');
%La linea roja del sensor inductivo denota el frente de cada robot

%7. Dibujar canaleta transportada (inicialmente no visible)
canaleta = line('XData',[lider.gripx seguidor.gripx],'YData',[lider.gripy seguidor.gripy],'Visible','off','Color','w','LineWidth',5);

%8. Dibujar los mini-mapas
axes(handles.axes2);
im1 = imread('Mini-mapa.jpg');
image(im1);
set(handles.axes2,'XTick',[]);
set(handles.axes2,'YTick',[]);

axes(handles.axes3);
im2 = imread('Mini-mapa2.jpg');
image(im2);
set(handles.axes3,'XTick',[]);
set(handles.axes3,'YTick',[]);

%FIN DEL DIBUJADO


%Estado inicial del sistema
set(handles.text7,'String','Sin Iniciar');
set(handles.text14,'String','Sin Iniciar');  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AmbienteVirtual wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AmbienteVirtual_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbutton1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Reestablecer dibujado al objeto Axes1 antes de comenzar
axes(handles.axes1);


%Variables globales
global pauso
global detengo

global lider
global seguidor

global drawlider
global liderver
global liderhor
global liderinf
global liderind

global drawseguidor
global seguidorver
global seguidorhor
global seguidorinf
global seguidorind

global canaleta
global canainicambia
global canafincambia

global reportelider
global reportesegui
global intlider
global intseguidor
global intlidexiste
global intsegexiste
global tiempo
global cooralert

global normalid
global normaseg
global permiso
global bateria
global negocio
global ir_a
global dejar_en


%Banderas de Pausar y Detener
pauso = 1;
detengo = 1;

%Estado inicial de los reportes
reportelider = 'Sin iniciar';
reportesegui = 'Sin iniciar';

%Estado inicial de las interrupciones de los agentes
intlider = 0;
intseguidor = 0;

%Contadores de sección de programa a ejecutar 
seclider = 0;
secseguidor = 0;

%Contador de tiempo cuando aparece un obstáculo
tiempo = reloj();


%Dibujar canaletas en puntos inicial y final
canainix = [21.1355 21.2765 21.4175 21.5585 21.6995 21.8405 21.9815 22.1225 22.2635 22.4045];
canaini = [0 0 0 0 0 0 0 0 0 0]; %Pre-asignando
visibles = str2double(get(handles.edit1,'String'));

for i=1:10
    canaini(i)=line('XData',[canainix(i) canainix(i)],'YData',[1 4],'LineWidth',5,'Color','w','Visible','off'); 
end
for i=11-visibles:10
    set(canaini(i),'Visible','on');
end

canafin=line('XData',[5.065 5.065],'YData',[33.1829 36.1829],'LineWidth',5,'Color','w','Visible','off');
if(str2double(get(handles.edit2,'String')) > 0)
    set(canafin,'Visible','on');
end


%Creando variables iniciales del coordinador
crono = reloj();
bateria = 25;
negocio = 1;
normalid = 1;
normaseg = 1;
permiso = 0;
com1 = 1;
com2 = 1;

%Leer número de canaletas en estiba y estante
ir_a_total=str2double(get(handles.edit1,'String'));
dejar_en_total=str2double(get(handles.edit2,'String'));

%Valores iniciales de ir_a y dejar_en para los agentes
ir_a=11-ir_a_total;
dejar_en=dejar_en_total;

%Variable para indicar al coordinador las interrupciones que han ocurrido
intexiste = 0;
intlidexiste = 0;
intsegexiste = 0;

%Variable para indicar si se borran/agregan canaletas del dibujo
borrocanal = 0;
dibujocanal = 0;

%Variables para saber si cambia la cantidad de canaletas en estiba/estante
canainicambia = [0 0];
canafincambia = [0 0];

%Variables para saber si estiba/estante se llenaron
estiballena = 0;
estantelleno = 0;


%Indicar que la operación va a comenzar
set(handles.text7,'String','Listo');
set(handles.text14,'String','Listo');  

%Pausa para ver el reporte
pause(1)

%Ciclo infinito
i=1;
while i == 1  
    try               
        %Verificar la bandera de Pausa
        if pauso == 0 
            error('pausa');
        end
        
        %Verificando la bandera de Detener
        if detengo == 0 
            break
        end    
        
        %Verificando comunicaciones con ambos agentes
        com1=lider.com;
        com2=seguidor.com;
        
        if (com1==0 || com2==0)
            %Cambiar la variable de estado
            normalid = 0;
            normaseg = 0;
            
            %Mostrar error en consola de mensajes
            set(handles.text18,'string','Se ha caído la comunicación con uno de los agentes.');
            
            %Indicar al coordinador que va a ocurrir 'IC'
            intexiste = 1;
            
            %Notificar el error
            error('IC')
        else            
            %Cambiar la variable de estado
            normalid = 1;
            normaseg = 1;
            
            %Mostrar error en consola de mensajes
            set(handles.text18,'string','Normal');
            
            %Si regreso de una 'IC', Remover orden de detener ambos agentes
            if (intexiste == 1 && strcmp((interrupcion.message),'IC'))
                intlider = 0;
                intseguidor = 0;
                
                %Remover el mensaje de 'IC'
                intexiste = 0;
            end
            
        end
                
        
        %Calcular valor actual de la batería
        bateria = bateria - crono.cambio;
        
        %Negociando si se realiza un ciclo de transporte
        if ((bateria >= 9) && (seclider==1) && (secseguidor==1))
            %NO se realiza si la estiba está vacía
            if estiballena == 1
                negocio = 0;
                
                %Mostrar mensajes en reportes y consola de mensajes                          
                set(handles.text7,'String','Apagado');
                set(handles.text14,'String','Apagado');
                set(handles.text18,'string','Ya no quedan canaletas para transportar.');
                
                %Pausa para observar el cambio de estado
                pause(4)
            
                %Detener la simulación
                detengo=0;
                set(handles.text18,'string','Simulación finalizada.');
            
            %NO se realiza si el estante está lleno
            elseif estantelleno == 1
                negocio = 0;
                
                %Mostrar mensajes en reportes y consola de mensajes                          
                set(handles.text7,'String','Apagado');
                set(handles.text14,'String','Apagado');
                set(handles.text18,'string','El estante ya está completamente lleno.');
                
                %Pausa para observar el cambio de estado
                pause(4)
            
                %Detener la simulación
                detengo=0;
                set(handles.text18,'string','Simulación finalizada.');
            
            %Si no ocurrieron las anteriores, SI se realiza
            else
                negocio = 1;
            end
            
            
        elseif ((bateria < 9) && (seclider==1) && (secseguidor==1))
            %NO se realiza si ya no queda batería suficiente
            negocio = 0;
            
            %Mostrar mensajes en reportes y consola de mensajes                          
            set(handles.text7,'String','Apagado');
            set(handles.text14,'String','Apagado');
            set(handles.text18,'string','Conectar los robots a la estación de recarga.');
            
            %Pausa para observar el cambio de estado
            pause(4)
            
            %Detener la simulación
            detengo=0;
            set(handles.text18,'string','Simulación finalizada.');
        end
        
        
        %Verificar si se otorga permiso de actuación coordinada
        if ((lider.etapa == seguidor.etapa) && (lider.repcod == seguidor.repcod))
            permiso = 1;
        else
            permiso = 0;
        end    
        
        
        
        %Si es necesario, modificar la cantidad de canaletas en estiba
        if ((canainicambia(1)==1) && (canainicambia(2)==1))
            borrocanal = ir_a;
            
            %Correr el conteo en estiba si aun es menor a 10
            if ir_a < 10
                ir_a = ir_a + 1;
                set(handles.edit1,'String',num2str(11-ir_a));
            else
                set(handles.edit1,'String','0');
                estiballena = 1;
            end
        else
            borrocanal = 0;
        end
        
        %Si es necesario, modificar la cantidad de canaletas en estante
        if ((canafincambia(1)==1) && (canafincambia(2)==1))
            dibujocanal = 1;
            
            %Correr el conteo en estante si aun es menor a 10
            if dejar_en < 9
                dejar_en = dejar_en + 1;
                set(handles.edit2,'String',num2str(dejar_en));
            else
                set(handles.edit2,'String','10');
                estantelleno = 1;
            end
        end
        
        %Hallando longitud de la canaleta
        distx = (lider.gripx - seguidor.gripx)^2;
        disty = (lider.gripy - seguidor.gripy)^2;
        d = sqrt(distx + disty);
        
        %Verificar si los robots están en un intervalo de curva
        if ((lider.curva == 1) || (seguidor.curva == 1))
            normalid = 0;
            normaseg = 0;
        else
            normalid = 1;     
            normaseg = 1;
            
            %Si distancia de canaleta es crítica, reducir nuevamente
            if (d < 2.8)
                if (seguidor.etapa == 2)
                    normaseg = 0;
                elseif (lider.etapa == 4)
                    normalid = 0;
                end
            elseif (d > 3.05)
                if (lider.etapa == 2)
                    normalid = 0;
                elseif ((seguidor.etapa == 4) && (lider.mcont <= 12))
                    normaseg = 0;
                end
            end
        end
        
        
        %Ejecutar bloques de código de ambos agentes
        
        %La condición de sección se ha puesto para evitar
        %bloquear la ejecución al lanzar repetidamente confirmación
        if(seclider <= 43)
            [lider,seclider] = mainrobot(lider,seclider,intlider);
        end
        if(secseguidor <= 43)
            [seguidor,secseguidor] = mainrobot(seguidor,secseguidor,intseguidor);
        end
        if((seclider == 44) && (secseguidor == 44))
            seclider = 0;
            secseguidor = 0;
        end
        
        %Incrementando el cronometro e imprimiendo en pantalla
        crono = aumentar(crono);
        str = sprintf('%d:%d:%d',crono.min,crono.seg,crono.cent);
        set(handles.text16,'string',str);
        
        %Actualizar los reportes de ambos agentes
        if(detengo ~= 0)
            set(handles.text7,'String',reportelider);
            set(handles.text14,'String',reportesegui);            
            set(handles.text18,'string','Normal');
        end
        
        
        %Si ha ocurrido un bloqueo
        if cooralert == 30
            %Indicar en la consola de mensajes
            set(handles.text18,'string','Un obstáculo está bloqueando el convoy.');
            
            %Mostrar el tiempo bloqueado en el reporte del agente
            %correspondiente, o sino borrar el mensaje
            if intlidexiste == 3
                str = sprintf('Tiempo detenido = %d:%d:%d',tiempo.min,tiempo.seg,tiempo.cent);
                set(handles.text19,'String',str);
                
                %Si el tiempo es menor a 30, hacer parpadear el robot
                %correspondiente (alarmas encendidas)
                if tiempo.seg < 30
                    if get(drawlider,'FaceColor') == [1 1 1]
                        set(drawlider,'FaceColor','r')
                    else
                        set(drawlider,'FaceColor','w')
                    end
                %Tras 30 segundos de bloqueo, las alarmas se apagan
                else
                    set(drawlider,'FaceColor','w')
                end
                    
            elseif intlidexiste == 0                
                set(drawlider,'FaceColor','w')
                set(handles.text18,'String','Normal');
                set(handles.text19,'String',' ');
                
            elseif intsegexiste == 3
                str = sprintf('Tiempo detenido = %d:%d:%d',tiempo.min,tiempo.seg,tiempo.cent);
                set(handles.text20,'String',str);
                
                %Si el tiempo es menor a 30, hacer parpadear el robot
                %correspondiente (alarmas encendidas)
                if tiempo.seg < 30
                    if get(drawseguidor,'FaceColor') == [1 1 1]
                        set(drawseguidor,'FaceColor','r')
                    else
                        set(drawseguidor,'FaceColor','w')
                    end
                %Tras 30 segundos de bloqueo, las alarmas se apagan
                else
                    set(drawseguidor,'FaceColor','w')
                end
                
            elseif intsegexiste == 0                
                set(drawseguidor,'FaceColor','w')
                set(handles.text18,'String','Normal');
                set(handles.text20,'String',' ');
            end
            
        end
        
        %Si el bloqueo no desapareció tras 30 segundos 
        if cooralert == 31
            %Si ya se solucionó, remover advertencia
            if(intlidexiste == 0 && intsegexiste == 0)
                %Mostrar mensajes en reportes y consola de mensajes
                set(handles.text7,'String',reportelider);
                set(handles.text14,'String',reportesegui);                
                set(handles.text18,'String','Normal');
                set(handles.text19,'String',' ');
                set(handles.text20,'String',' ');
            else
                %Mostrar mensajes en reportes y consola de mensajes             
                set(handles.text7,'String','Suspendido');
                set(handles.text14,'String','Suspendido');
                set(handles.text18,'string','El obstáculo no desapareció. Favor acudir al sitio del bloqueo.');
            end            
            
        end
        
        
        %Mostrar en pantalla coordenadas de los robots
        set(handles.text3,'String',num2str(lider.x));
        set(handles.text4,'String',num2str(lider.y));
        if (abs(lider.theta) < 0.00001)
            set(handles.text5,'String','0');
        else
            set(handles.text5,'String',num2str(lider.theta*(180/pi)));
        end
        
        set(handles.text10,'String',num2str(seguidor.x));
        set(handles.text11,'String',num2str(seguidor.y));
        if (abs(seguidor.theta) < 0.00001)
            set(handles.text12,'String','0');
        else
            set(handles.text12,'String',num2str(seguidor.theta*(180/pi)));
        end
        
        %Si se ha agarrado la canaleta, dibujarla entre los robots
        if((lider.grip == 1) && (seguidor.grip == 1))
            set(canaleta,'Visible','on');
            set(canaleta,'XData',[lider.gripx seguidor.gripx],'YData',[lider.gripy seguidor.gripy]);
        else
            set(canaleta,'Visible','off');
        end
        
                
        %Si es necesario, borrar una canaleta del estante
        if(borrocanal ~= 0)
            set(canaini(borrocanal),'Visible','off');
        end
        
        %Si es necesario, dibujar una canaleta en la estiba
        if(dibujocanal == 1)
            set(canafin,'Visible','on');
        end
        
        
        %Viendo longitud de la canaleta        
        %set(handles.text18,'String',num2str(d));
        
        
        %Redibujar robots
        set(drawlider,'XData',lider.verx);
        set(drawlider,'YData',lider.very);
        rotate(drawlider, [0 0 1], lider.theta*(180/pi), [lider.x lider.y 0]);
        vx=get(drawlider,'XData');
        vy=get(drawlider,'YData');
        
        set(liderver,'XData',[vx(2) vx(12)],'YData',[vy(2) vy(12)]);
        set(liderhor,'XData',[vx(7) vx(15)],'YData',[vy(7) vy(15)]);
        set(liderinf,'XData',[vx(4) vx(16)],'YData',[vy(4) vy(16)]);
        set(liderind,'XData',[vx(10) vx(14)],'YData',[vy(10) vy(14)]);
        
        set(drawseguidor,'XData',seguidor.verx);
        set(drawseguidor,'YData',seguidor.very);
        rotate(drawseguidor, [0 0 1], seguidor.theta*(180/pi), [seguidor.x seguidor.y 0]);
        vx=get(drawseguidor,'XData');
        vy=get(drawseguidor,'YData');
        
        set(seguidorver,'XData',[vx(2) vx(12)],'YData',[vy(2) vy(12)]);
        set(seguidorhor,'XData',[vx(7) vx(15)],'YData',[vy(7) vy(15)]);
        set(seguidorinf,'XData',[vx(4) vx(16)],'YData',[vy(4) vy(16)]);
        set(seguidorind,'XData',[vx(10) vx(14)],'YData',[vy(10) vy(14)]);
        
        %Redibujar cámara
        camx = (lider.x + seguidor.x)/2;
        camy = (lider.y + seguidor.y)/2;
        set(handles.axes1,'XLim',[camx-2.5 camx+2.5]);
        set(handles.axes1,'YLim',[camy-2.5 camy+2.5]);
        
        %Pausa de 0.001 segundos
        pause(0.001)           
        
        
    catch interrupcion
        %Pausa de 0.001 segundos
        pause(0.001)
        
        %Verificando la bandera de Detener
        if detengo == 0 
            break
        end      
        
        %Clasificar el error generado y actuar correspondientemente
        cualfue = interrupcion.message;
        switch cualfue                
                
            case 'IC'         
                %Verificando cual agente recibe la orden de "detener"
                %("detener amigo" está identificado con repcod == 21)
                com1=lider.com;
                com2=seguidor.com;
                
                if com1 == 0
                    intseguidor = 21;
                elseif com2 == 0
                    intlider = 21;
                end
                
                %Ejecutar bloques de código de ambos agentes
        
                %La condición de sección se ha puesto para evitar
                %bloquear la ejecución al lanzar repetidamente confirmación
                if(seclider <= 43)
                    [lider,seclider] = mainrobot(lider,seclider,intlider);
                end
                if(secseguidor <= 43)
                    [seguidor,secseguidor] = mainrobot(seguidor,secseguidor,intseguidor);
                end
                if((seclider == 44) && (secseguidor == 44))
                    seclider = 0;
                    secseguidor = 0;
                end
                
                %Mostrar en pantalla estado actual de los robots
                set(handles.text7,'String',reportelider);
                set(handles.text14,'String',reportesegui);
                
                
                %Hallar segundos faltantes para 60
                salto = 60 - crono.seg;
                
                %Aumentar los 5 segundos
                if(crono.seg > 54)
                    crono.min = crono.min + 1;
                    crono.seg = 5 - salto;
                else
                    crono.seg = crono.seg + 5;
                end
                
                %Mostrar nuevo tiempo
                str = sprintf('%d:%d:%d',crono.min,crono.seg,crono.cent);
                set(handles.text16,'string',str);
                          
                %Desmarcar los botones de interrupción correspondientes
                set(handles.pushbutton3,'BackgroundColor',[0.941 0.941 0.941],'ForegroundColor','k');
                set(handles.pushbutton4,'BackgroundColor',[0.941 0.941 0.941],'ForegroundColor','k');
        end
                
        
    end
        
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global pauso

%Marcar/desmarcar el boton de pausa
if(get(hObject,'Value')==0)
    set(hObject,'BackgroundColor',[0.941 0.941 0.941],'ForegroundColor','k');
    set(hObject,'String','PAUSA');
elseif(get(hObject,'Value')==1)
    set(hObject,'BackgroundColor','b','ForegroundColor','w');
    set(hObject,'String','REANUDAR');
end

%Variar la bandera de pausa
if pauso == 1
    pauso=0;
    set(handles.text18,'string','Simulación pausada. Haga clic en "REANUDAR".');
else
    pauso=1;
    set(handles.text18,'string','Normal');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global detengo

%Desmarcar el boton de pausa
if(get(handles.togglebutton1,'Value')==1)
    set(handles.togglebutton1,'Value',0,'BackgroundColor',[0.941 0.941 0.941],'ForegroundColor','k');
    set(handles.togglebutton1,'String','PAUSA');
end

%Variar la bandera de detener
if detengo == 1
    detengo=0;
    set(handles.text18,'string','Simulación finalizada.');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global lider
global obsx
global obsy
global obs
global obswhere

%Variable de prueba de etapa
test = 0;

try
    %Verificar si la etapa es correcta
    if(lider.etapa == 2 || lider.etapa == 4)
        test = 1;
    end
    
    %Si la etapa es correcta, lanzar interrupción para dibujar obstáculo
    if(test == 1)
        error('etapa_bien');
    %Si no, indicar que no se puede dibujar un obstáculo durante la etapa
    %actual
    elseif(test == 0)
        set(handles.text18,'String','Un obstáculo no puede aparecer durante la etapa actual.')
        pause(0.5)
    end
    
catch etapa_bien
    %Determinar obstáculo según hacia donde se dirige el robot
    %NOTA: Para simplificar, se omitirán los tramos curvos
    
    if(lider.xipunto > 0.24)
        obsx = lider.x + 2;
        obsy = lider.y;
        obswhere = 'x';
    elseif(lider.xipunto < -0.24)
        obsx = lider.x - 2;
        obsy = lider.y;
        obswhere = 'x';
    elseif(lider.yipunto > 0.24)
        obsx = lider.x;
        obsy = lider.y + 2;
        obswhere = 'y';
    elseif(lider.yipunto < -0.24)
        obsx = lider.x;
        obsy = lider.y - 2;
        obswhere = 'y';
    end
    
    %Marcar/desmarcar el boton y dibujar/desdibujar el obstáculo
    if(get(hObject,'Value')==0)
        set(hObject,'BackgroundColor',[0.941 0.941 0.941],'ForegroundColor','k');
        set(obs,'Visible','off');
    elseif(get(hObject,'Value')==1)
        set(hObject,'BackgroundColor','b','ForegroundColor','w');
        obs = rectangle('Position',[obsx-0.25,obsy-0.25,0.5,0.5],'Curvature',0.5,'FaceColor','g');
    end
    

end
        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbutton3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global lider

%Marcar el boton y desactivar la comunicación del lider
if(get(hObject,'Value')==1)
    set(hObject,'BackgroundColor','b','ForegroundColor','w');
    lider.com = 0;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global seguidor
global obsx
global obsy
global obs
global obswhere

%Variable de prueba de etapa
test = 0;

try
    %Verificar si la etapa es correcta
    if(seguidor.etapa == 4)
        test = 1;
    end
    
    %Si la etapa es correcta, lanzar interrupción para dibujar obstáculo
    if(test == 1)
        error('etapa_bien');
    %Si no, indicar que no se puede dibujar un obstáculo durante la etapa
    %actual
    elseif(test == 0)
        set(handles.text18,'String','Un obstáculo no puede aparecer durante la etapa actual.')
        pause(1)
    end
    
catch etapa_bien    
    %Determinar obstáculo según hacia donde se dirige el robot
    %NOTA: Para simplificar, se omitirán los tramos curvos
    
    if(seguidor.xipunto > 0.24)
        obsx = seguidor.x + 2;
        obsy = seguidor.y;
        obswhere = 'x';
    elseif(seguidor.xipunto < -0.24)
        obsx = seguidor.x - 2;
        obsy = seguidor.y;
        obswhere = 'x';
    elseif(seguidor.yipunto > 0.24)
        obsx = seguidor.x;
        obsy = seguidor.y + 2;
        obswhere = 'y';
    elseif(seguidor.yipunto < -0.24)
        obsx = seguidor.x;
        obsy = seguidor.y - 2;
        obswhere = 'y';
    end
    
    %Marcar/desmarcar el boton y dibujar/desdibujar el obstáculo
    if(get(hObject,'Value')==0)
        set(hObject,'BackgroundColor',[0.941 0.941 0.941],'ForegroundColor','k');
        set(obs,'Visible','off');
    elseif(get(hObject,'Value')==1)
        set(hObject,'BackgroundColor','b','ForegroundColor','w');
        obs = rectangle('Position',[obsx-0.25,obsy-0.25,0.5,0.5],'Curvature',0.5,'FaceColor','g');
    end

end
        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbutton4

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global seguidor

%Marcar el boton y desactivar la comunicación del seguidor
if(get(hObject,'Value')==1)
    set(hObject,'BackgroundColor','b','ForegroundColor','w');
    seguidor.com = 0;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


try
    if(str2double(get(hObject,'String')) == 0)
        error('num_mal');
    elseif(str2double(get(hObject,'String')) > 10)
        error('num_mal');
    else
        set(handles.text18,'String','Normal')
    end
    
catch nummuybajo
    set(handles.text18,'String','Coloque un numero de canaletas en estiba mayor a 0 y menor o igual a 10')    

end
        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


try
    if(str2double(get(hObject,'String')) >= 10)
        error('num_mal');
    else
        set(handles.text18,'String','Normal')
    end
    
catch nummuyalto
    set(handles.text18,'String','El estante esta lleno. No se pueden transportar mas canaletas.')    

end
        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Este código se ejecuta al cerrar el programa.
%Siempre presionar DETENER antes de cerrar el programa.

delete(hObject);

clear all
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
