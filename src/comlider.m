function comlider(ident, repcod)

%Variables globales
global intlider
global intseguidor

%Transmitir el mensaje correspondiente al agente contrario
if ident==1
    intseguidor = repcod;
elseif ident==2
    intlider = repcod;
end 