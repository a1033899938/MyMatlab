%######## Geometry Parameters ###############
nm2um_factor = 1e-3;


period_um = 524*nm2um_factor;
duty_cycle =(period_um-70*nm2um_factor)/period_um;%(600-50)/600;
tg_um = 50*nm2um_factor;		% thickness of grating
tm_um=0.7*nm2um_factor;
ts_um = 1.130259304148331e+02*nm2um_factor - tg_um;        % thickness of slab WG
ttBN_um=15*nm2um_factor;
tbBN_um=15*nm2um_factor;
tbgra_um=0*nm2um_factor;
% duty_cycle = Structure.dc;
% period_um = Structure.period*nm2um_factor;
% tg_um = Structure.tg*nm2um_factor;		% thickness of grating
% ts_um = 0.280 - tg_um;        % thickness of slab WG
tb_um = 2;  % Thickness of the base plate
% dc = 0.4;		% Duty cycle of grating
% phase_normal =  0.557512209375118 + pi;%0.647012284899018 +pi;%
% t_buffer = (phase_normal - pi)/(4*pi)*0.8;
% t_airgap = t_buffer + 0.2;	% thickness of airgap

% Set entry and exit media
% Refractive indices of all following media are changing with setup_dispersion.m
air = 1.0;
GaAs = 3.68;
SiN = 2.0;
SiO2 = 1.455;  % At around 700nm
Si = 3.78; % At around 700nm
n1 = air;
n3 = Si;
hBN=1.75;
%%%%%%%% set HPCC layer by layer, top to bottom %%%%%%%%%%%%%%%%%
% data=[];
% if (ttBN_um~=0)
%    data=[data; ttBN_um,   0,  hBN,   period_um,     NaN,    NaN;];
% end
% if (tbgra_um~=0)
%    data=[data; tbgra_um,   0,  Gra,   period_um,     NaN,    NaN;];
% end
% if (tbBN_um~=0)
%    data=[data; tbBN_um,   0,  hBN,   period_um,     NaN,    NaN;];
% end
% % HCG layer
% data=[data; tg_um,   0,  SiN,   period_um*duty_cycle,  air,    period_um;];
% % One slab
% if (ts_um~=0)
% data=[data; ts_um,   0,  SiN,   period_um,     NaN,    NaN;];
% end
% % One base layer
% data=[data; tb_um,   0,  SiO2,   period_um,     NaN,    NaN;];





data=[];
% Graphene bars
% if (tbgra_um~=0)
%    data=[data; tbgra_um,  0,  air, 0.1, Gra, 0.14, air, 0.39,Gra, 0.43, air, period_um;];
% end
% Bottom graphene 
% if (tbgra_um~=0)
%    data=[data; tbgra_um,   0,  Gra,   period_um,     NaN,    NaN, NaN,    NaN,  NaN,    NaN,  NaN,    NaN;];
% end
% Bottom hBN
% if (tbBN_um~=0)
%    data=[data; tbBN_um,   0,  hBN,   period_um,     NaN,    NaN, NaN,    NaN,  NaN,    NaN,  NaN,    NaN;];
% end
% Monolayer semiconductor 
if (tm_um~=0)
   data=[data; tm_um,   0,  MoS2,   period_um,     NaN,    NaN;];
end
% HCG layer
data=[data; tg_um,   0,  SiN,   period_um*duty_cycle,  air,    period_um;];
% One slab
if (ts_um~=0)
data=[data; ts_um,   0,  SiN,   period_um,     NaN,    NaN;];
end
% One base layer
data=[data; tb_um,   0,  SiO2,   period_um,     NaN,    NaN;];