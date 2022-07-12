function v = fct_Hin_v1_itesco(pulso,t)

global HOUT HIN HOUT_ini HIN_ini
v=zeros(2,1);

if(t<pulso)
    hin=HIN_ini;%%%6.4
    hout=HOUT_ini;%%%
elseif(t>=pulso)&&(t<=pulso+6)
    hin=HIN;%%%2.5
    hout=HOUT; %%%%1.5
else
    hin=HIN_ini;%%%2.5
    hout=HOUT_ini; %%%%1.5
end

v(1)=hin;
v(2)=hout;
