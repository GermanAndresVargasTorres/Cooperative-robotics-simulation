function [robot]=CinDir(robot)
    

%Obtener sentido de giro de las ruedas (0 para apagado, 1 para giro hacia 
%adelante u horario, -1 para giro hacia atras u antihorario)
dir1=robot.dir1;
dir2=robot.dir2;
dir3=robot.dir3;
dir4=robot.dir4;

%Obtener velocidad de giro de las ruedas (fipunto) en rad/s
%El valor máximo es Wmax = 9.02 rad/s
if(dir1==0)
    phi1punto=0;
else
    phi1punto=robot.phi1punto;    
end

if(dir2==0)
    phi2punto=0;
else
    phi2punto=robot.phi2punto;     
end

if(dir3==0)
    phi3punto=0;
else
    phi3punto=robot.phi3punto;    
end

if(dir4==0)
    phi4punto=0;
else
    phi4punto=robot.phi4punto;    
end


%Constantes del chasis del robot

%theta, ángulo en rad entre frame del robot y frame global
theta=robot.theta;

%Ángulos alfa; formados entre el frame del robot y el vector que lleva al
%centro de la rueda correspondiente
a1=atan2(0.175,0.166468);     %  0.8104 rad
a2=atan2(0.175,-0.166468);    %  2.3312 rad
a3=atan2(-0.175,-0.166468);   % -2.3312 rad
a4=atan2(-0.175,0.166468);    % -0.8104 rad

%Ángulos Beta En Radianes; formados entre el vector que lleva
%al centro de la rueda correspondiente y el vector de velocidad angular
%[dependiente del vector v(t)]
if(dir1==1) 
    b1=atan2(0.175,-0.166468);    %  2.3312 rad
else
    b1=atan2(-0.175,0.166468);    % -0.8104 rad
end

if(dir2==1) 
    b2=atan2(0.175,0.166468);     %  0.8104 rad
else
    b2=atan2(-0.175,-0.166468);   % -2.3312 rad
end

if(dir3==1) 
    b3=atan2(-0.175,0.166468);    % -0.8104 rad
else
    b3=atan2(0.175,-0.166468);    %  2.3312 rad
end

if(dir4==1) 
    b4=atan2(-0.175,-0.166468);   % -2.3312 rad
else
    b4=atan2(0.175,0.166468);     %  0.8104 rad
end

%Ángulos gamma, orientación de los rodillos respecto al eje de rotación de la
%rueda sueca
g1=pi/4;
g2=-pi/4;
g3=pi/4;
g4=-pi/4;

%l, distancia en metros desde el frame del robot hasta el centro de cada rueda
l=sqrt(0.166468^2+0.175^2);

%r, radio de las ruedas en metros
r=0.0269875;


%Operaciones

%Calculando la matriz RINV (rotación frame global respecto a frame del robot)
R1=[cos(theta); sin(theta); 0];
R2=[-1*sin(theta); cos(theta); 0];
R3=[0; 0; 1];

RINV=[R1 R2 R3];

%Calculando la matriz M (términos J1f)
M1=[sin(a1+b1+g1); sin(a2+b2+g2); sin(a3+b3+g3); sin(a4+b4+g4)];
M2=[-1*cos(a1+b1+g1); -1*cos(a2+b2+g2); -1*cos(a3+b3+g3); -1*cos(a4+b4+g4)];
M3=[-1*l*cos(b1+g1); -1*l*cos(b2+g2); -1*l*cos(b3+g3); -1*l*cos(b4+g4)];

M=[M1 M2 M3];
MINV=pinv(M);

%Calculando la matriz N (términos J2)
N=[r*phi1punto*cos(g1); r*phi2punto*cos(g2); r*phi3punto*cos(g3); r*phi4punto*cos(g4)];

%Cálculo del vector Ei punto
Ei_punto=RINV*MINV*N;

xipunto=Ei_punto(1,1);
yipunto=Ei_punto(2,1);
thetaipunto=Ei_punto(3,1);

%Guardar velocidades globales para dibujar obstáculos posteriormente
robot.xipunto = xipunto;
robot.yipunto = yipunto;
robot.thetaipunto = thetaipunto;

%Dividir por 50 (el cronómetro aumenta cada 0.02 segundos)
xipunto=xipunto/50;
yipunto=yipunto/50;
thetaipunto=thetaipunto/50;

%Calcular nuevas coordenadas
x = robot.x + xipunto;
y = robot.y + yipunto;
theta = robot.theta + thetaipunto;

%Actualizar coordenadas del robot
robot = actualizar(robot,x,y,theta);
