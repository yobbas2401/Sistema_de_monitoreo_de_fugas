function v = fct_fuga_v1_itesco(pulso,t)

global loc_fuga par_fuga
v=zeros(2,1);

if(t<=pulso)
    dz=0;
    rho=0;
else
    dz=loc_fuga;
    rho=par_fuga;
end

v(1)=dz;
v(2)=rho;