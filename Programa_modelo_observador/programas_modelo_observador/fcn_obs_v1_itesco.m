function v = fcn_obs_v1_itesco(t,y)

v=zeros(8,1);

global pulso L D b f

%SALIDAS DEL FLUJO DEL SISTEMA ORIGINAL
Q1=y(1);
H2=y(2);
Q2=y(3);

x1=y(4);
x2=y(5);
x3=y(6);
x4=y(7);
x5=y(8);

%ENTRADAS DE PRESION DEL SISTEMA 
u=fct_Hin_v1_itesco(pulso,t);
u1=u(1);
Hin=u1;
u2=u(2);
Hout=u2;

fuga=fct_fuga_v1_itesco(pulso,t);
dz1=fuga(1);
rho=fuga(2);


%PARAMETROS DEL MODELO
tau=1;
g=9.81;%%gravedad
A=pi*(D/2)^2;%%area de tuberia m^2
% A=pi*((1*2.54)/2)^2;
muu=tau/(2*D*A);
% f=0.0226;


u=fct_Hin_v1_itesco(pulso,t);
u1=u(1);
u2=u(2);

fuga=fct_fuga_v1_itesco(pulso,t);
dz1=fuga(1);
rho=fuga(2);

v = zeros(3,1);

ww1=dz1*(u1-u2);
ww2=L*(u1-H2);

hh2=u1-(u1-u2)

if(dz1==0)
        dH2=0;
        dQ1=0;
        dQ2=0;
else
    dQ1=-((g*A)/dz1)*(H2-u1)-f*muu*Q1*abs(Q1);
    dH2=-((b^2)/(g*A*dz1))*(Q2-Q1+rho*(H2)^0.5);
    dQ2=-((g*A)/(L-dz1))*(u2-H2)-f*muu*Q2*abs(Q2);
end

v(1)=dQ1;
v(2)=dH2;
v(3)=dQ2;


a1=g*A;
a2=(b^2)/(g*A);

SC1=[2
    1];

SC2=[3
    3
    1];

the1=1.2;
DTH1=the1*inv([1 0;0 1/the1]);
the2=1.1;
DTH2=the2*inv([1 0 0;0 1/the2 0;0 0 1/the2^2]);

% DTH=[eye(2) zeros(2,3);
%     zeros(3,2) eye(3)*(1/l1)];

GG1=the1*inv(DTH1)*SC1;
GG2=the2*inv(DTH2)*SC2;

GG=[GG1
    GG2];

muu=f*muu;

    if(dz1==0)
        dz=[0 0 0 0 0];
    else
%OBSERVADOR
%MODELO MATEMATICO EQUIVALENTE PARA EL OBSERVADOR 
% PHI=[1,0, 0, 0,0; 
%             -(2*(muu*Hout*x1*x4^2 - muu*x1*x2*x4^2))/(L*a1*Hin - L*a1*x2 - a1*Hin*x4 + a1*Hout*x4),  -(x4^2*(Hout - x2))/(L*a1*Hin - L*a1*x2 - a1*Hin*x4 + a1*Hout*x4), (2*muu*x3*(L - x4)^2*(Hin - x2))/(L*a1*Hin - L*a1*x2 - a1*Hin*x4 + a1*Hout*x4), ((L - x4)^2*(Hin - x2))/(L*a1*Hin - L*a1*x2 - a1*Hin*x4 + a1*Hout*x4), 0;
%             0, 0,  1, 0,  0;
%             -(2*muu*x1*x4^2*(L - x4))/(L*a1*Hin - L*a1*x2 - a1*Hin*x4 + a1*Hout*x4),   -(x4^2*(L - x4))/(L*a1*Hin - L*a1*x2 - a1*Hin*x4 + a1*Hout*x4),  -(2*muu*x3*x4*(L - x4)^2)/(L*a1*Hin - L*a1*x2 - a1*Hin*x4 + a1*Hout*x4),  -(x4*(L - x4)^2)/(L*a1*Hin - L*a1*x2 - a1*Hin*x4 + a1*Hout*x4), 0;
%             (L*a1*Hin*x2^(1/2) - 4*muu*x1^2*x2^(1/2)*x4^2 - L*a1*x2^(3/2) - a1*Hin*x2^(1/2)*x4 + a1*Hout*x2^(1/2)*x4 + muu*Hout*x1*x4^2*x5 + 3*muu*x1*x2*x4^2*x5 + 2*L*muu*x1^2*x2^(1/2)*x4 + 4*muu*x1*x2^(1/2)*x3*x4^2 - 2*L*muu*x1*x2^(1/2)*x3*x4 - 2*L*muu*x1*x2*x4*x5)/(x2*(L*a1*Hin - L*a1*x2 - a1*Hin*x4 + a1*Hout*x4)), (x4*(4*x2^(1/2)*x3*x4 - 4*x1*x2^(1/2)*x4 - 2*L*x2*x5 + Hout*x4*x5 + 3*x2*x4*x5 + 2*L*x1*x2^(1/2) - 2*L*x2^(1/2)*x3))/(2*x2*(L*a1*Hin - L*a1*x2 - a1*Hin*x4 + a1*Hout*x4)), -(2*muu^2*Hout*x2^(1/2)*x3^2*x4^3 - 2*muu^2*Hin*x2^(1/2)*x3^2*x4^3 - L*a1*a2*x2^(3/2) - 2*a1*muu*Hin*x2^(3/2)*x4^2 + 2*a1*muu*Hout*x2^(3/2)*x4^2 + 2*L^2*a2*muu*x2^(1/2)*x3^2 - 2*a1*muu*Hout^2*x2^(1/2)*x4^2 + 4*a2*muu*x2^(1/2)*x3^2*x4^2 + L*a1*a2*Hin*x2^(1/2) - 2*L*a1*muu*x2^(5/2)*x4 - a1*a2*Hin*x2^(1/2)*x4 + a1*a2*Hout*x2^(1/2)*x4 - 2*L*muu^2*x2^(3/2)*x3^2*x4^2 + 2*L^2*muu^2*x2^(3/2)*x3^2*x4 + 2*L*a1*muu*Hin*x2^(3/2)*x4 + L^2*a2*muu*Hin*x3*x5 + 2*L*a1*muu*Hout*x2^(3/2)*x4 + L^2*a2*muu*x2*x3*x5 + a2*muu*Hin*x3*x4^2*x5 + 3*a2*muu*x2*x3*x4^2*x5 + 4*L*muu^2*Hin*x2^(1/2)*x3^2*x4^2 - 2*L^2*muu^2*Hin*x2^(1/2)*x3^2*x4 - 2*L*muu^2*Hout*x2^(1/2)*x3^2*x4^2 - 2*L^2*a2*muu*x1*x2^(1/2)*x3 - 6*L*a2*muu*x2^(1/2)*x3^2*x4 + 2*a1*muu*Hin*Hout*x2^(1/2)*x4^2 - 4*a2*muu*x1*x2^(1/2)*x3*x4^2 - 2*L*a2*muu*Hin*x3*x4*x5 - 4*L*a2*muu*x2*x3*x4*x5 - 2*L*a1*muu*Hin*Hout*x2^(1/2)*x4 + 6*L*a2*muu*x1*x2^(1/2)*x3*x4)/(a2*x2*(L*a1*Hin - L*a1*x2 - a1*Hin*x4 + a1*Hout*x4)), ((L - x4)*(a2*Hin*x4*x5 + 3*a2*x2*x4*x5 + 2*L*a2*x1*x2^(1/2) - 2*L*a2*x2^(1/2)*x3 - 4*a2*x1*x2^(1/2)*x4 + 4*a2*x2^(1/2)*x3*x4 - L*a2*Hin*x5 - L*a2*x2*x5 + 4*muu*Hin*x2^(1/2)*x3*x4^2 - 4*muu*Hout*x2^(1/2)*x3*x4^2 + 4*L*muu*x2^(3/2)*x3*x4 - 4*L*muu*Hin*x2^(1/2)*x3*x4))/(2*a2*x2*(L*a1*Hin - L*a1*x2 - a1*Hin*x4 + a1*Hout*x4)), -(x4*(L - x4))/(a1*a2*x2^(1/2))];
%         

PHI=[1, 0, 0, 0,0;
     -2*muu*x1, -a1/x4, 0, -(a1*(u1 - x2))/x4^2,0;
      0,  0, 1, 0, 0;
      0, a1/(L - x4), -2*muu*x3, -(a1*(u2 - x2))/(L - x4)^2, 0;
      (a1*a2)/(x4*(L - x4)), - (2*a1*muu*x3)/(L - x4) - (a1*a2*x5)/(2*x2^(1/2)*x4*(L - x4)), 4*muu^2*x3^2 + 2*muu*(muu*x3^2 + (a1*(u2 - x2))/(L - x4)) - (a1*a2)/(x4*(L - x4)), (2*a1*muu*x3*(u2 - x2))/(L - x4)^2 - (a1*a2*(x3 - x1 + x2^(1/2)*x5))/(x4*(L - x4)^2) + (a1*a2*(x3 - x1 + x2^(1/2)*x5))/(x4^2*(L - x4)), -(a1*a2*x2^(1/2))/(x4*(L - x4))];
 
  
        %MODELO MATEMATICO ORIGINAL
        F=[-muu*x1^2+(a1/x4)*(Hin-x2);
            (a2/x4)*(x1-x3-x5*(x2)^0.5);
            -(a1/(L-x4))*(Hout-x2)-muu*x3^2;
            0;
            0];
        %OBSERVADOR FUNCION ¨=  MODELO MATEMATICO ORIGINAL MAS LA CORRECION DEL OBSERVADOR
        dz=F-inv(PHI)*[GG1*(x1-Q1);GG2*(x3-Q2)];
        
        
    end
    
v(1)=dQ1;
v(2)=dH2;
v(3)=dQ2;

v(4)=dz(1);
v(5)=dz(2);
v(6)=dz(3);
v(7)=dz(4);
v(8)=dz(5);