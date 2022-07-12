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

x=[Q1 H2 Q2];


% tt=[0 tf];
tt=[0:ts:tf];

[t XX] = ode23s('fct_tuberia_v1_itesco',tt,x);


%%
figure(3)
plot(t,[XX(:,1)]),grid
figure(4)
plot(t,[XX(:,2)]),grid
figure(5)
plot(t,[XX(:,3)]),grid

%%
name_file='Flujos_sistema_alto';
datas=[{[t,XX(:,1)]},{[t,XX(:,3)]}]; 
legends=[{'$Q_{entrada}(t)$'},{'${Q}_{salida}(t)$'}];
labels.x='Tiempo (seg)';
labels.y='Flujo (m^3/s)';
color=[{'b'},{'r'}];
linestyle=[{'-'},{'--'}];
fct_draw_special(name_file,datas,labels,legends,color,linestyle)

name_file='Presion_sistema_alto';
datas=[{[t,XX(:,2)]}]; 
legends=[{'$H_{2}(t)$ (Intermedia)'}];
labels.x='Tiempo (seg)';
labels.y='Presión (m)';
color=[{'b'}];
linestyle=[{'-'}];
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

%%
name_file='Presion_sistema_h1';
datas=[{[t,HH(:,1)]}]; 
legends=[{'$H_{in}(t)$ (entrada)'}];
labels.x='Tiempo (seg)';
labels.y='Presión (m)';
color=[{'b'}];
linestyle=[{'-'}];
fct_draw_special(name_file,datas,labels,legends,color,linestyle)

name_file='Presion_sistema_h2';
datas=[{[t,HH(:,2)]}]; 
legends=[{'$H_{out}(t)$ (salida)'}];
labels.x='Tiempo (seg)';
labels.y='Presión (m)';
color=[{'b'}];
linestyle=[{'-'}];
fct_draw_special(name_file,datas,labels,legends,color,linestyle)
