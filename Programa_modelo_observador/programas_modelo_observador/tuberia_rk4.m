clc
% clear

% % L=86.49;%%%68.147
% % D=6.54e-2;%%%6.271e-2
% % b=375;
% % tau=1.72e-2;
% % g=9.81;
% % A=pi*(D/2)^2;
% % % A=pi*((1*2.54)/2)^2;
% % muu=tau/(2*D*A);
% % f=0.0226;

L=85;%%%68.147 m
D=6.35e-2;%%%6.271e-2 m
b=407.75;
% tau=1.72e-2;
tau=1;
g=9.81;%%gravedad
A=pi*(D/2)^2;%%area de tuberia m^2
% A=pi*((1*2.54)/2)^2;
muu=tau/(2*D*A);
f=0.0226;

XX=[];
ts=50e-3;
tf=8;

%%%condiciones iniciales
Q1=4.25e-3;
Q2=4.25e-3;
% rho=(2.7e-5);
rho=(8e-5);
H2=5;
%%%

%%%%fuga
pul1=1.5;
u1=[ones(pul1/ts+1,1)*6.4
    ones(30/ts,1)*6];%14.15;
u2=[ones(pul1/ts+1,1)*3.6
    ones(30/ts,1)*3.4];%7.15;
dz1=[ones(pul1/ts,1)*0
    ones(30/ts,1)*(20)];

jj=1;

for i=0:ts:tf
    
%     if(dz1(jj)==0)
% %         dQ1=-f*muu*Q1*abs(Q1);
% %         dQ2=-f*muu*Q2*abs(Q2);
%         dH2=0;
%         dQ1=0;
%         dQ2=0;
%     else
%         dQ1=-((g*A)/dz1(jj))*(H2-u1(jj))-f*muu*Q1*abs(Q1);
%         dH2=-((b^2)/(g*A*dz1(jj)))*(Q2-Q1+rho*(H2)^0.5);
%         dQ2=-((g*A)/(L-dz1(jj)))*(u2(jj)-H2)-f*muu*Q2*abs(Q2);
%     end
    
    
    
    XX=[XX;Q1 H2 Q2 dz1(jj) rho];        
    
    if(dz1(jj)==0)
        dH2=0;
        dQ1=0;
        dQ2=0;
        ddz1=0;
        drho=0;
        
        Q1=dQ1*ts+Q1;
        H2=dH2*ts+H2;    
        Q2=dQ2*ts+Q2;
%     dz1=ddz1*ts+dz1(jj);
        rho=drho*ts+rho;
    
    else
        dQ1=-((g*A)/dz1(jj))*(H2-u1(jj))-f*muu*Q1*abs(Q1);
        dH2=-((b^2)/(g*A*dz1(jj)))*(Q2-Q1+rho*(H2)^0.5);
        dQ2=-((g*A)/(L-dz1(jj)))*(u2(jj)-H2)-f*muu*Q2*abs(Q2);
        
        x11=dQ1;
        x12=dH2;
        x13=dQ2;
        
        x21=-((g*A)/dz1(jj))*((H2+ts*x12/2)-u1(jj))-f*muu*(Q1+ts*x11/2)*abs(Q1+ts*x11/2);
        x22=-((b^2)/(g*A*dz1(jj)))*((Q2+ts*x13/2)-(Q1+ts*x11/2)+rho*(H2+ts*x12/2)^0.5);
        x23=-((g*A)/(L-dz1(jj)))*(u2(jj)-(H2+ts*x12/2))-f*muu*(Q2+ts*x13/2)*abs(Q2+ts*x13/2);
        
        x31=-((g*A)/dz1(jj))*((H2+ts*x22/2)-u1(jj))-f*muu*(Q1+ts*x21/2)*abs(Q1+ts*x21/2);
        x32=-((b^2)/(g*A*dz1(jj)))*((Q2+ts*x23/2)-(Q1+ts*x21/2)+rho*(H2+ts*x22/2)^0.5);
        x33=-((g*A)/(L-dz1(jj)))*(u2(jj)-(H2+ts*x22/2))-f*muu*(Q2+ts*x23/2)*abs(Q2+ts*x23/2);
        
        x41=-((g*A)/dz1(jj))*((H2+ts*x32)-u1(jj))-f*muu*(Q1+ts*x31)*abs(Q1+ts*x31);
        x42=-((b^2)/(g*A*dz1(jj)))*((Q2+ts*x33)-(Q1+ts*x31)+rho*(H2+ts*x32)^0.5);
        x43=-((g*A)/(L-dz1(jj)))*(u2(jj)-(H2+ts*x32))-f*muu*(Q2+ts*x33)*abs(Q2+ts*x33);
        
        Q1=(ts/6)*(x11+2*x21+2*x31+x41)+Q1;
        H2=(ts/6)*(x12+2*x22+2*x32+x42)+H2;
        Q2=(ts/6)*(x13+2*x23+2*x33+x43)+Q2;
        
        ddz1=0;
        drho=0;
        
        %     dz1=ddz1*ts+dz1(jj);
        rho=drho*ts+rho;

    end

    jj=jj+1;
end

t=0:ts:tf;
%%

figure(1)
subplot(121),plot(t, [XX(:,1) XX(:,3)]),grid
subplot(122),plot(t, [XX(:,2)]),grid
% subplot(222),plot(t, XX(:,2))
% subplot(223),plot(t, XX(:,3))
% subplot(224),plot(t, XX(:,4))

figure(2)
plot(t,XX(:,5)),grid