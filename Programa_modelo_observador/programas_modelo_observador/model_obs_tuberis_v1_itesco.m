clc
clear

global pulso loc_fuga L D b f HOUT HIN HOUT_ini HIN_ini par_fuga

ts=1e-3;
tf=4;
pulso=1;

%%%psi to mH2O
HOUT_ini=6.25; %%%mH20
HIN_ini=7.88;

HOUT=3.59; %%3.6
HIN=4.042; %%4

L=5.8*2;%%%86
loc_fuga=L-2.40;
D=1*0.0254;%%%6.54e-2
b=407.75*(0.55);  %%%Velocidad de la onda de presion 0.885 6.702*0.703070; 
f=0.0226; %%%coeficiente de friccion

%%%condiciones iniciales
Q1=0.474e-3;  %%%m3/s
Q2=0.435e-3;
H2=6.5;
par_fuga=8e-5;

x1=0.474e-3;
x2=6.5;
x3=0.474e-3;
x4=5;
x5=1e-5;

x=[Q1 H2 Q2 x1 x2 x3 x4 x5];


% tt=[0 tf];
tt=[0:ts:tf];

% the1=0.21;
% DTH1=the1*inv([1 0;0 1/the1])*[2 1]';
% the2=0.031;
% DTH2=the2*inv([1 0 0;0 1/the1 0;0 0 1/the1^2])*[3 3 1]';

 opts = odeset('RelTol',1e-2,'AbsTol',2e-4,'MaxStep',6e-2);

% % % [t XX] = ode45('fct_tuberia_v1_itesco',tt,x);

[t XX] = ode23s('fcn_obs_v1_itesco',tt,x);

% figure(1)
% subplot(121),plot(t, [XX(:,1) XX(:,3)]),grid
% subplot(122),plot(t, [XX(:,2)]),grid
% subplot(222),plot(t, XX(:,2))
% subplot(223),plot(t, XX(:,3))
% subplot(224),plot(t, XX(:,4))

% % figure(2)
% % plot(t,XX(:,5)),grid
% % 

%%
figure(3)
plot(t,[XX(:,1) XX(:,4)]),grid
figure(4)
plot(t,[XX(:,2) XX(:,5)]),grid
figure(5)
plot(t,[XX(:,3) XX(:,6)]),grid
figure(6)
plot(t,[XX(:,7)]),grid

%%


name_file='EstimacionFlujo_mod1';
datas=[{[t,XX(:,1)]},{[t,XX(:,4)]}]; 
legends=[{'$Q_{1}(t)$ (Sistema)'},{'$\hat{Q}_{1}(t)$ (Observador)'}];
labels.x='Tiempo (seg)';
labels.y='Flujo (m^3/s)';
color=[{'b'},{'r'}];
linestyle=[{'-'},{'--'}];
fct_draw_special(name_file,datas,labels,legends,color,linestyle)

name_file='EstimacionFlujo_mod2';
datas=[{[t,XX(:,3)]},{[t,XX(:,6)]}]; 
legends=[{'$Q_{2}(t)$ (Sistema)'},{'$\hat{Q}_{2}(t)$ (Observador)'}];
labels.x='Tiempo (seg)';
labels.y='Flujo (m^3/s)';
color=[{'b'},{'r'}];
linestyle=[{'-'},{'--'}];
fct_draw_special(name_file,datas,labels,legends,color,linestyle)

%%

name_file='EstimacionFuga_mod';
datas=[{[t,XX(:,7)]}]; 
legends=[{'$Fuga$'}];
labels.x='Tiempo (seg)';
labels.y='Distancia (m)';
color=[{'b'}];
linestyle=[{'--'}];
fct_draw_special(name_file,datas,labels,legends,color,linestyle)


%%


HH=[];
for i=1:length(t)
    
if(t(i)<pulso)
    hin=HIN_ini;%%%6.4
    hout=HOUT_ini;%%%
elseif(t(i)>=pulso)&&(t(i)<=pulso+6)
    hin=HIN;%%%2.5
    hout=HOUT; %%%%1.5
else
    hin=HIN_ini;%%%2.5
    hout=HOUT_ini; %%%%1.5
end
HH=[HH; hin hout];
end


figure(20)
plot(t,HH)


name_file='Presion_sis_obs_h1';
datas=[{[t,HH(:,1)]}]; 
legends=[{'$H_{in}(t)$ (entrada)'}];
labels.x='Tiempo (seg)';
labels.y='Presión (m)';
color=[{'b'}];
linestyle=[{'-'}];
fct_draw_special(name_file,datas,labels,legends,color,linestyle)

name_file='Presion_sis_obs_h2';
datas=[{[t,HH(:,2)]}]; 
legends=[{'$H_{out}(t)$ (salida)'}];
labels.x='Tiempo (seg)';
labels.y='Presión (m)';
color=[{'b'}];
linestyle=[{'-'}];
fct_draw_special(name_file,datas,labels,legends,color,linestyle)
