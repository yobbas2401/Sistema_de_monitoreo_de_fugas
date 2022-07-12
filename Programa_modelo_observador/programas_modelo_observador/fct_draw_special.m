%%
function []=fct_draw_special(name_file,datas,labels,legends,color,linestyle)
% fct_draw_special peut etre utilisee dans le cas ou les différentes
% courbes n'ont pas la même abscisse
% voici la forme que doivent avoir les données:
% datas=[{[x1,y1]},{[x2,y2]}]; le vecteur datas contient
% l'ordonnée dans la première colonne et les abscisses dans les autres
% colonnes
% legends=[{'U_{nl}'},{'U_{mcc}'}];
% labels.x='Time (S)';
% labels.y='u : duty cycle';
% color=[{'b'},{'r'}];
% linestyle=[{'-'},{'--'}];




clc
close all



nb_courbes=size(datas);
nb_courbes=nb_courbes(2);




lin_width_param=2;

iFontSize=20;
strFontUnit='points';     %[{points} | normalized | inches | centimeters | pixels]
strFontName='Times';      %[Times | Courier | ] TODO complete the list
strFontWeight='normal';   %[light | {normal} | demi | bold]
strFontAngle='normal';    %[{normal} | italic | oblique]ps: only for axes
strInterpreter='tex';   %[{tex} | latex]
fLineWidth=1.0;           %width of the line of the axes







%%
%figure dimension
h=figure;

set(gcf, 'Units','centimeters');
afFigurePosition=[1 1 25 10];
set(gcf,'Position',afFigurePosition);
set(gcf,'PaperPositionMode','auto');


%axis properties

% general properties

lin_width_param;
% str_X_tick=0:5:25;
% str_Y_tick=0:20:100;
    datas1=datas(1);
    datas1=datas1{:};
    str_XLim=[min(datas1(:,1)),max(datas1(:,1))];
for i=2:nb_courbes
    datas1=datas(i);
    datas1=datas1{:};
str_XLim=[min(str_XLim(1),min(datas1(:,1))),max(str_XLim(2),max(datas1(:,1)))];
end



%str_YLim=[min(datas(:,2:end)),max(datas(:,2:end))]
set(gca, 'XLim', str_XLim);
%set(gca,'Xtick',str_X_tick, 'Ytick',str_Y_tick,'YLim',str_YLim)

set(gca,'Xgrid', 'on', 'Ygrid','on', 'GridLineStyle',':', 'Linewidth',fLineWidth)
set(gca,'FontName',strFontName,'FontSize',iFontSize);





 xlabel(labels.x, 'FontName',strFontName,'FontWeight',strFontWeight,'FontSize',iFontSize, 'Interpreter',strInterpreter);
 ylabel(labels.y, 'FontName',strFontName,'FontWeight',strFontWeight,'FontSize',iFontSize, 'Interpreter',strInterpreter);

set(gca,'Units','normalized','Position',[0.15 0.2 0.75 0.7])


hold on
for i=1:nb_courbes
    color1=color(i);
    linestyle1=linestyle(i);
    datas1=datas(i);
    datas1=datas1{:};
plot(datas1(:,1),datas1(:,2),'linewidth',lin_width_param,'color',color1{:},'linestyle',linestyle1{:})
end




grid
box on
% %legend properties


astrArrayOfLabels=legends;
% 
% strLegendLocation='Best';
strLegendLocation='SouthEast';
strLegendLocation='NorthEast';

strLegendOrientation='vertical';
strinterpreter='latex';

legend(astrArrayOfLabels, 'Location',strLegendLocation,'FontSize',13,'Interpreter',strinterpreter)%,'Orientation',strLegendOrientation);
grid


%instructions to print the file in pdf
bprintonfile_pdf=1;
bprintonfileeps=0;
strfilepath=name_file;



iresolution=300;

bcropthefigure=1;

if (bprintonfile_pdf || bprintonfileeps)
    
    if (bcropthefigure)
        print('-depsc2',sprintf('-r%d',iresolution),strcat(strfilepath,'.eps'));
    else
        print('-depsc2','-loose',sprintf('-r%d', iresolution),strcat(strfilepath,'.eps'));
    end;
    
    if (bprintonfile_pdf)
        system(sprintf('epstopdf  --outfile=%s.pdf %s.eps', strfilepath,strfilepath));
    end;
    
    if (~bprintonfileeps)
        delete(sprintf('%s.eps',strfilepath));
    end;
end


