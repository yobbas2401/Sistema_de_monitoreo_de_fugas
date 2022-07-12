function v = fct_tuberia_v1_itesco(t,y)

global pulso L D b f

tau=1;
g=9.81;%%gravedad
A=pi*(D/2)^2;%%area de tuberia m^2
% A=pi*((1*2.54)/2)^2;
muu=tau/(2*D*A);
% f=0.0226;


Q1=y(1);
H2=y(2);
Q2=y(3);

u=fct_Hin_v1_itesco(pulso,t);
u1=u(1);
u2=u(2);

fuga=fct_fuga_v1_itesco(pulso,t);
dz1=fuga(1);
rho=fuga(2);

v = zeros(3,1);

% % % ww1=dz1*(u1-u2);
% % % ww2=L*(u1-H2);
% % % 
% % % hh2=u1-(u1-u2)

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
