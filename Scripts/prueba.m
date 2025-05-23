% id=[{'id5'};{'id5'};{'id5'};{'id5'};{'id5'}];
% plot(data.(id{1})(1).Norm.HIP_R_x.signals);
% f=fields(data.id5.frontal(1).Raw);

%% Leer datos excels
addpath('C:\Users\jimmy\OneDrive - Universidad Rey Juan Carlos\01_Doctorado\Estudios experimentales\Validación Barras delta_Kinovea\Datos');
cd('C:\Users\jimmy\OneDrive - Universidad Rey Juan Carlos\01_Doctorado\Estudios experimentales\Validación Barras delta_Kinovea\Datos\id5_Santi');
fileName_aux = dir('C:\Users\jimmy\OneDrive - Universidad Rey Juan Carlos\01_Doctorado\Estudios experimentales\Validación Barras delta_Kinovea\Datos\id5_Santi');
fileName_aux(1,:) = [];
fileName_aux(1,:) = [];
j=1;
var=[{'ANKLE_R_x'};{'ANKLE_R_y'};{'ANKLE_L_x'};{'ANKLE_L_y'};{'KNEE_R_x'};{'KNEE_R_y'};{'KNEE_L_x'};{'KNEE_L_y'};{'HIP_R_x'};{'HIP_R_y'};{'HIP_L_x'};{'HIP_L_y'};{'COM_x'};{'COM_y'}]; % {'TOE_R_x'};{'TOE_R_y'};{'TOE_L_x'};{'TOE_L_y'};
%calib=[40.08;2.78;64.62;3.52;40.47;40.41;64.06;40.40;38.99;91.59;63.47;91.08;51.23;91.34];  % Del excel 39.99;-10.70;65.37;-10.23;
ang=[{'Abd_R'};{'Abd_L'};{'Pelvis_List'}];
veloc = [{'speed05'};{'speed1'}];
condition = [{'CL'};{'CC'};{'CML'};{'CMR'}];
n=6; %Orden
Fc=4; %Frecuencia de Corte
Fs=30; %Frecuencia de muestreo
[numFilt, denFilt]=butter(n, Fc/(0.5*Fs));
% Calibración marcadores
C = xlsread('id5_Frontal_calib.xml');
for n=1:length(var)-2
    data.id5.Calib.(var{n}) = mean(C(:,n+1));
end
data.id5.Calib.COMx = (data.id5.Calib.HIP_R_x + data.id5.Calib.HIP_L_x)/2;
data.id5.Calib.COMy = (data.id5.Calib.HIP_R_y + data.id5.Calib.HIP_L_y)/2;
for (archivo=1:length(fileName_aux))
    if(contains(fileName_aux(archivo).name, "Frontal.xml"))
        % [path,data.id5.frontal.(veloc{v}).(condition{c}).nameFile,ext] = fileparts(fileName_aux(archivo).name);
        if (contains(fileName_aux(archivo).name, "05_"))
            v=1;
        elseif(contains(fileName_aux(archivo).name, "1_"))
            v=2;
        end
        if (contains(fileName_aux(archivo).name, "CL"))
            c=1;
        elseif(contains(fileName_aux(archivo).name, "CC"))
            c=2;
        elseif(contains(fileName_aux(archivo).name, "CML"))
            c=3;
        elseif(contains(fileName_aux(archivo).name, "CMR"))
            c=4;
        end
        T = xlsread(fileName_aux(archivo).name);
        data.id5.frontal.(veloc{v}).(condition{c}).time = T(:,1)';
        data.id5.frontal.(veloc{v}).(condition{c}).contacts = T(:,2)';
        for n=1:length(var)-2
            % Recogida de los raw data y filtrado
            data.id5.frontal.(veloc{v}).(condition{c}).Raw.(var{n}) = T(:,n+2)'; data.id5.frontal.(veloc{v}).(condition{c}).Filt.(var{n})=filtfilt(numFilt, denFilt,data.id5.frontal.(veloc{v}).(condition{c}).Raw.(var{n}));
            % data.id5.Calib.(var{n}) = calib(n);
            n=n+1;
        end
        data.id5.frontal.(veloc{v}).(condition{c}).Raw.(var{length(var)-1}) = (data.id5.frontal.(veloc{v}).(condition{c}).Raw.HIP_R_x + data.id5.frontal.(veloc{v}).(condition{c}).Raw.HIP_L_x)/2 ; data.id5.frontal.(veloc{v}).(condition{c}).Filt.(var{length(var)-1})=filtfilt(numFilt, denFilt,data.id5.frontal.(veloc{v}).(condition{c}).Raw.(var{length(var)-1}));
        data.id5.frontal.(veloc{v}).(condition{c}).Raw.(var{length(var)}) = (data.id5.frontal.(veloc{v}).(condition{c}).Raw.HIP_R_y + data.id5.frontal.(veloc{v}).(condition{c}).Raw.HIP_L_y)/2 ; data.id5.frontal.(veloc{v}).(condition{c}).Filt.(var{length(var)})=filtfilt(numFilt, denFilt,data.id5.frontal.(veloc{v}).(condition{c}).Raw.(var{length(var)}));
        % Segmentación de ciclos de la marcha
        for i=1:10
            t=data.id5.frontal.(veloc{v}).(condition{c}).contacts(i);t1=data.id5.frontal.(veloc{v}).(condition{c}).contacts(i+1);
            index=find(data.id5.frontal.(veloc{v}).(condition{c}).time(:)==t); index1=find(data.id5.frontal.(veloc{v}).(condition{c}).time(:)==t1);
            x=linspace(1,length(data.id5.frontal.(veloc{v}).(condition{c}).time(index:index1)),100);
            for n=1:length(var)
                data.id5.frontal.(veloc{v}).(condition{c}).Segmented.(var{n}).signals(i,:)=interp1(1:1:length(data.id5.frontal.(veloc{v}).(condition{c}).Filt.(var{n})(index:index1)),data.id5.frontal.(veloc{v}).(condition{c}).Filt.(var{n})(index:index1),x);
                data.id5.frontal.(veloc{v}).(condition{c}).Segmented.(var{n}).values.min(i,1)=min(data.id5.frontal.(veloc{v}).(condition{c}).Segmented.(var{n}).signals(i,:));
                data.id5.frontal.(veloc{v}).(condition{c}).Segmented.(var{n}).values.max(i,1)=max(data.id5.frontal.(veloc{v}).(condition{c}).Segmented.(var{n}).signals(i,:));
                data.id5.frontal.(veloc{v}).(condition{c}).Segmented.(var{n}).values.rango(i,1)=max(data.id5.frontal.(veloc{v}).(condition{c}).Segmented.(var{n}).signals(i,:))-min(data.id5.frontal.(veloc{v}).(condition{c}).Segmented.(var{n}).signals(i,:));
                n=n+1;
            end
            %Cálculo de la posición promedio de los tobillos durante el doble apoyo
            data.id5.frontal.(veloc{v}).(condition{c}).Segmented.ANKLE_R_x.values.mean10(i,1)=mean(data.id5.frontal.(veloc{v}).(condition{c}).Segmented.ANKLE_R_x.signals(i,1:10));
            data.id5.frontal.(veloc{v}).(condition{c}).Segmented.ANKLE_R_x.values.mean50(i,1)=mean(data.id5.frontal.(veloc{v}).(condition{c}).Segmented.ANKLE_R_x.signals(i,50:60));
            data.id5.frontal.(veloc{v}).(condition{c}).Segmented.ANKLE_L_x.values.mean10(i,1)=mean(data.id5.frontal.(veloc{v}).(condition{c}).Segmented.ANKLE_L_x.signals(i,1:10));
            data.id5.frontal.(veloc{v}).(condition{c}).Segmented.ANKLE_L_x.values.mean10(i,1)=mean(data.id5.frontal.(veloc{v}).(condition{c}).Segmented.ANKLE_L_x.signals(i,50:60));
        end
        for n=1:length(var)
            %Promediado y cálculo de la desviación estándar, min, máx y rango
            data.id5.frontal.(veloc{v}).(condition{c}).Mean.(var{n}).signals=mean(data.id5.frontal.(veloc{v}).(condition{c}).Segmented.(var{n}).signals);
            data.id5.frontal.(veloc{v}).(condition{c}).Desv.(var{n})=std(data.id5.frontal.(veloc{v}).(condition{c}).Segmented.(var{n}).signals);
            data.id5.frontal.(veloc{v}).(condition{c}).Mean.(var{n}).values.min=min(data.id5.frontal.(veloc{v}).(condition{c}).Mean.(var{n}).signals);
            data.id5.frontal.(veloc{v}).(condition{c}).Mean.(var{n}).values.max=max(data.id5.frontal.(veloc{v}).(condition{c}).Mean.(var{n}).signals);
            data.id5.frontal.(veloc{v}).(condition{c}).Mean.(var{n}).values.rango=max(data.id5.frontal.(veloc{v}).(condition{c}).Mean.(var{n}).signals)-min(data.id5.frontal.(veloc{v}).(condition{c}).Mean.(var{n}).signals);
            % Normalización de las señales promedio con respecto al valor de inicio del ciclo
            data.id5.frontal.(veloc{v}).(condition{c}).Norm.(var{n}).signals=data.id5.frontal.(veloc{v}).(condition{c}).Mean.(var{n}).signals-data.id5.frontal.(veloc{v}).(condition{c}).Mean.(var{n}).signals(1);
            data.id5.frontal.(veloc{v}).(condition{c}).Norm.(var{n}).values.min=min(data.id5.frontal.(veloc{v}).(condition{c}).Norm.(var{n}).signals);
            data.id5.frontal.(veloc{v}).(condition{c}).Norm.(var{n}).values.max=max(data.id5.frontal.(veloc{v}).(condition{c}).Norm.(var{n}).signals);
            data.id5.frontal.(veloc{v}).(condition{c}).Norm.(var{n}).values.rango=max(data.id5.frontal.(veloc{v}).(condition{c}).Norm.(var{n}).signals)-min(data.id5.frontal.(veloc{v}).(condition{c}).Norm.(var{n}).signals);
            n=n+1;
        end
        %Cálculo de la posición promedio de los tobillos durante el doble apoyo
        data.id5.frontal.(veloc{v}).(condition{c}).Mean.ANKLE_R_x.values.mean10=mean(data.id5.frontal.(veloc{v}).(condition{c}).Mean.ANKLE_R_x.signals(1:10));
        data.id5.frontal.(veloc{v}).(condition{c}).Mean.ANKLE_R_x.values.mean50=mean(data.id5.frontal.(veloc{v}).(condition{c}).Mean.ANKLE_R_x.signals(50:60));
        data.id5.frontal.(veloc{v}).(condition{c}).Mean.ANKLE_L_x.values.mean10=mean(data.id5.frontal.(veloc{v}).(condition{c}).Mean.ANKLE_L_x.signals(1:10));
        data.id5.frontal.(veloc{v}).(condition{c}).Mean.ANKLE_L_x.values.mean10=mean(data.id5.frontal.(veloc{v}).(condition{c}).Mean.ANKLE_L_x.signals(50:60));
        %Calibración rotaciones
        pelvisCalib = [data.id5.Calib.HIP_R_x;data.id5.Calib.HIP_R_y]'-[data.id5.Calib.HIP_L_x;data.id5.Calib.HIP_L_y]';
        femur_RCalib =[data.id5.Calib.KNEE_R_x;data.id5.Calib.KNEE_R_y]'-[data.id5.Calib.HIP_R_x;data.id5.Calib.HIP_R_y]';
        femur_LCalib =[data.id5.Calib.KNEE_L_x;data.id5.Calib.KNEE_L_y]'-[data.id5.Calib.HIP_L_x;data.id5.Calib.HIP_L_y]';
        horizontal =[0;1]';
        abd_L_calib_ang = (atan2(abs(det([pelvisCalib;femur_LCalib])),dot(pelvisCalib,femur_LCalib)))*180/pi;
        abd_R_calib_ang = (atan2(abs(det([-pelvisCalib;femur_RCalib])),dot(-pelvisCalib,femur_RCalib)))*180/pi;
        pelvis_List_calib_ang = (atan2(abs(det([horizontal;pelvisCalib])),dot(horizontal,pelvisCalib)))*180/pi;
        %Cálculo rotaciones abd y pelvis
        for seg=1:length(data.id5.frontal.(veloc{v}).(condition{c}).Segmented.ANKLE_R_x.signals(:,1))
            pelvis = [data.id5.frontal.(veloc{v}).(condition{c}).Segmented.HIP_R_x.signals(seg,:);data.id5.frontal.(veloc{v}).(condition{c}).Segmented.HIP_R_y.signals(seg,:)]'-[data.id5.frontal.(veloc{v}).(condition{c}).Segmented.HIP_L_x.signals(seg,:);data.id5.frontal.(veloc{v}).(condition{c}).Segmented.HIP_L_y.signals(seg,:)]';
            femur_R =[data.id5.frontal.(veloc{v}).(condition{c}).Segmented.KNEE_R_x.signals(seg,:);data.id5.frontal.(veloc{v}).(condition{c}).Segmented.KNEE_R_y.signals(seg,:)]'-[data.id5.frontal.(veloc{v}).(condition{c}).Segmented.HIP_R_x.signals(seg,:);data.id5.frontal.(veloc{v}).(condition{c}).Segmented.HIP_R_y.signals(seg,:)]';
            femur_L =[data.id5.frontal.(veloc{v}).(condition{c}).Segmented.KNEE_L_x.signals(seg,:);data.id5.frontal.(veloc{v}).(condition{c}).Segmented.KNEE_L_y.signals(seg,:)]'-[data.id5.frontal.(veloc{v}).(condition{c}).Segmented.HIP_L_x.signals(seg,:);data.id5.frontal.(veloc{v}).(condition{c}).Segmented.HIP_L_y.signals(seg,:)]';
            for i=1:length(pelvis)
                abd_L_ang(i) = -abd_L_calib_ang+(atan2(abs(det([pelvis(i,:);femur_L(i,:)])),dot(pelvis(i,:),femur_L(i,:))))*180/pi;
                abd_R_ang(i) = -abd_R_calib_ang+(atan2(abs(det([-pelvis(i,:);femur_R(i,:)])),dot(-pelvis(i,:),femur_R(i,:))))*180/pi;
                pelvis_List_ang(i) = -pelvis_List_calib_ang+(atan2(abs(det([horizontal;pelvis(i,:)])),dot(horizontal,pelvis(i,:))))*180/pi;
            end
            data.id5.frontal.(veloc{v}).(condition{c}).AngSeg.(ang{1}).signals(seg,:)=abd_R_ang;
            data.id5.frontal.(veloc{v}).(condition{c}).AngSeg.(ang{2}).signals(seg,:)=abd_L_ang;
            data.id5.frontal.(veloc{v}).(condition{c}).AngSeg.(ang{3}).signals(seg,:)=pelvis_List_ang;
            for a=1:3
                data.id5.frontal.(veloc{v}).(condition{c}).AngSeg.(ang{a}).values.min(seg,1)=min(data.id5.frontal.(veloc{v}).(condition{c}).AngSeg.(ang{a}).signals(seg,:));
                data.id5.frontal.(veloc{v}).(condition{c}).AngSeg.(ang{a}).values.max(seg,1)=max(data.id5.frontal.(veloc{v}).(condition{c}).AngSeg.(ang{a}).signals(seg,:));
                data.id5.frontal.(veloc{v}).(condition{c}).AngSeg.(ang{a}).values.rango(seg,1)=max(data.id5.frontal.(veloc{v}).(condition{c}).AngSeg.(ang{a}).signals(seg,:))-min(data.id5.frontal.(veloc{v}).(condition{c}).AngSeg.(ang{a}).signals(seg,:));
            end
        end
        for a=1:length(ang)
            data.id5.frontal.(veloc{v}).(condition{c}).AngMean.(ang{a}).signals=mean(data.id5.frontal.(veloc{v}).(condition{c}).AngSeg.(ang{a}).signals);
            data.id5.frontal.(veloc{v}).(condition{c}).AngDesv.(ang{a}).signals=std(data.id5.frontal.(veloc{v}).(condition{c}).AngSeg.(ang{a}).signals);
            data.id5.frontal.(veloc{v}).(condition{c}).AngMean.(ang{a}).values.min=min(data.id5.frontal.(veloc{v}).(condition{c}).AngMean.(ang{a}).signals);
            data.id5.frontal.(veloc{v}).(condition{c}).AngMean.(ang{a}).values.max=max(data.id5.frontal.(veloc{v}).(condition{c}).AngMean.(ang{a}).signals);
            data.id5.frontal.(veloc{v}).(condition{c}).AngMean.(ang{a}).values.rango=max(data.id5.frontal.(veloc{v}).(condition{c}).AngMean.(ang{a}).signals)-min(data.id5.frontal.(veloc{v}).(condition{c}).AngMean.(ang{a}).signals);
        end
        j=j+1;
    end
end

%% Plots
a=1;b=3;c=5;d=7;e=2;f=4;g=6;h=8; % 3,1,5,7
figure ('Name', '0.5m')
subplot(2,3,1)
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{2}).AngMean.(ang{1}).signals,data.id5.frontal.speed05.(condition{2}).AngDesv.(ang{1}).signals,'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{1}).AngMean.(ang{1}).signals,data.id5.frontal.speed05.(condition{1}).AngDesv.(ang{1}).signals,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{3}).AngMean.(ang{1}).signals,data.id5.frontal.speed05.(condition{3}).AngDesv.(ang{1}).signals,'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{4}).AngMean.(ang{1}).signals,data.id5.frontal.speed05.(condition{4}).AngDesv.(ang{1}).signals,'lineprops','-r','patchSaturation',0.33);
legend('CL','CC','CML')
title('Abd_R')
subplot(2,3,2)
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{2}).AngMean.(ang{2}).signals,data.id5.frontal.speed05.(condition{2}).AngDesv.(ang{2}).signals,'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{1}).AngMean.(ang{2}).signals,data.id5.frontal.speed05.(condition{1}).AngDesv.(ang{2}).signals,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{3}).AngMean.(ang{2}).signals,data.id5.frontal.speed05.(condition{3}).AngDesv.(ang{2}).signals,'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{4}).AngMean.(ang{2}).signals,data.id5.frontal.speed05.(condition{4}).AngDesv.(ang{2}).signals,'lineprops','-r','patchSaturation',0.33);
title('Abd_L')
subplot(2,3,3)
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{2}).AngMean.(ang{3}).signals,data.id5.frontal.speed05.(condition{2}).AngDesv.(ang{3}).signals,'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{1}).AngMean.(ang{3}).signals,data.id5.frontal.speed05.(condition{1}).AngDesv.(ang{3}).signals,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{3}).AngMean.(ang{3}).signals,data.id5.frontal.speed05.(condition{3}).AngDesv.(ang{3}).signals,'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{4}).AngMean.(ang{3}).signals,data.id5.frontal.speed05.(condition{4}).AngDesv.(ang{3}).signals,'lineprops','-r','patchSaturation',0.33);
title('Pelvis List')
subplot(2,3,4)
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{2}).Norm.(var{13}).signals,data.id5.frontal.speed05.(condition{2}).Desv.(var{13}),'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{1}).Norm.(var{13}).signals,data.id5.frontal.speed05.(condition{1}).Desv.(var{13}),'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{3}).Norm.(var{13}).signals,data.id5.frontal.speed05.(condition{3}).Desv.(var{13}),'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{4}).Norm.(var{13}).signals,data.id5.frontal.speed05.(condition{4}).Desv.(var{13}),'lineprops','-r','patchSaturation',0.33);
title('COMx displacement')
subplot(2,3,5)
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{2}).Norm.(var{14}).signals,data.id5.frontal.speed05.(condition{2}).Desv.(var{14}),'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{1}).Norm.(var{14}).signals,data.id5.frontal.speed05.(condition{1}).Desv.(var{14}),'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{3}).Norm.(var{14}).signals,data.id5.frontal.speed05.(condition{3}).Desv.(var{14}),'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{4}).Norm.(var{14}).signals,data.id5.frontal.speed05.(condition{4}).Desv.(var{14}),'lineprops','-r','patchSaturation',0.33);
title('COMy displacement')
subplot(2,3,6)
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{2}).Mean.ANKLE_R_x.signals,data.id5.frontal.speed05.(condition{2}).Desv.ANKLE_R_x,'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{2}).Mean.ANKLE_L_x.signals,data.id5.frontal.speed05.(condition{2}).Desv.ANKLE_L_x,'lineprops','-g','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{1}).Mean.ANKLE_R_x.signals,data.id5.frontal.speed05.(condition{1}).Desv.ANKLE_R_x,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{1}).Mean.ANKLE_L_x.signals,data.id5.frontal.speed05.(condition{1}).Desv.ANKLE_L_x,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{3}).Mean.ANKLE_R_x.signals,data.id5.frontal.speed05.(condition{3}).Desv.ANKLE_R_x,'lineprops','-y','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{3}).Mean.ANKLE_L_x.signals,data.id5.frontal.speed05.(condition{3}).Desv.ANKLE_L_x,'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{4}).Mean.ANKLE_R_x.signals,data.id5.frontal.speed05.(condition{4}).Desv.ANKLE_R_x,'lineprops','-r','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.frontal.speed05.(condition{4}).Mean.ANKLE_L_x.signals,data.id5.frontal.speed05.(condition{4}).Desv.ANKLE_L_x,'lineprops','-r','patchSaturation',0.33);
title('Ankle x displacement R&L')

%% Plots
a=1;b=3;c=5;d=7;e=2;f=4;g=6;h=8; % 3,1,5,7
figure ('Name', '1m')
subplot(2,3,1)
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{2}).AngMean.(ang{1}).signals,data.id5.frontal.speed1.(condition{2}).AngDesv.(ang{1}).signals,'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{1}).AngMean.(ang{1}).signals,data.id5.frontal.speed1.(condition{1}).AngDesv.(ang{1}).signals,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{3}).AngMean.(ang{1}).signals,data.id5.frontal.speed1.(condition{3}).AngDesv.(ang{1}).signals,'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{4}).AngMean.(ang{1}).signals,data.id5.frontal.speed1.(condition{4}).AngDesv.(ang{1}).signals,'lineprops','-r','patchSaturation',0.33);
legend('CL','CC','CML')
title('Abd_R')
subplot(2,3,2)
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{2}).AngMean.(ang{2}).signals,data.id5.frontal.speed1.(condition{2}).AngDesv.(ang{2}).signals,'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{1}).AngMean.(ang{2}).signals,data.id5.frontal.speed1.(condition{1}).AngDesv.(ang{2}).signals,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{3}).AngMean.(ang{2}).signals,data.id5.frontal.speed1.(condition{3}).AngDesv.(ang{2}).signals,'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{4}).AngMean.(ang{2}).signals,data.id5.frontal.speed1.(condition{4}).AngDesv.(ang{2}).signals,'lineprops','-r','patchSaturation',0.33);
title('Abd_L')
subplot(2,3,3)
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{2}).AngMean.(ang{3}).signals,data.id5.frontal.speed1.(condition{2}).AngDesv.(ang{3}).signals,'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{1}).AngMean.(ang{3}).signals,data.id5.frontal.speed1.(condition{1}).AngDesv.(ang{3}).signals,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{3}).AngMean.(ang{3}).signals,data.id5.frontal.speed1.(condition{3}).AngDesv.(ang{3}).signals,'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{4}).AngMean.(ang{3}).signals,data.id5.frontal.speed1.(condition{4}).AngDesv.(ang{3}).signals,'lineprops','-r','patchSaturation',0.33);
title('Pelvis List')
subplot(2,3,4)
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{2}).Norm.(var{13}).signals,data.id5.frontal.speed1.(condition{2}).Desv.(var{13}),'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{1}).Norm.(var{13}).signals,data.id5.frontal.speed1.(condition{1}).Desv.(var{13}),'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{3}).Norm.(var{13}).signals,data.id5.frontal.speed1.(condition{3}).Desv.(var{13}),'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{4}).Norm.(var{13}).signals,data.id5.frontal.speed1.(condition{4}).Desv.(var{13}),'lineprops','-r','patchSaturation',0.33);
title('COMx displacement')
subplot(2,3,5)
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{2}).Norm.(var{14}).signals,data.id5.frontal.speed1.(condition{2}).Desv.(var{14}),'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{1}).Norm.(var{14}).signals,data.id5.frontal.speed1.(condition{1}).Desv.(var{14}),'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{3}).Norm.(var{14}).signals,data.id5.frontal.speed1.(condition{3}).Desv.(var{14}),'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{4}).Norm.(var{14}).signals,data.id5.frontal.speed1.(condition{4}).Desv.(var{14}),'lineprops','-r','patchSaturation',0.33);
title('COMy displacement')
subplot(2,3,6)
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{2}).Mean.ANKLE_R_x.signals,data.id5.frontal.speed1.(condition{2}).Desv.ANKLE_R_x,'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{2}).Mean.ANKLE_L_x.signals,data.id5.frontal.speed1.(condition{2}).Desv.ANKLE_L_x,'lineprops','-g','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{1}).Mean.ANKLE_R_x.signals,data.id5.frontal.speed1.(condition{1}).Desv.ANKLE_R_x,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{1}).Mean.ANKLE_L_x.signals,data.id5.frontal.speed1.(condition{1}).Desv.ANKLE_L_x,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{3}).Mean.ANKLE_R_x.signals,data.id5.frontal.speed1.(condition{3}).Desv.ANKLE_R_x,'lineprops','-y','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{3}).Mean.ANKLE_L_x.signals,data.id5.frontal.speed1.(condition{3}).Desv.ANKLE_L_x,'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{4}).Mean.ANKLE_R_x.signals,data.id5.frontal.speed1.(condition{4}).Desv.ANKLE_R_x,'lineprops','-r','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.frontal.speed1.(condition{4}).Mean.ANKLE_L_x.signals,data.id5.frontal.speed1.(condition{4}).Desv.ANKLE_L_x,'lineprops','-r','patchSaturation',0.33);
title('Ankle x displacement R&L')

%% Interesting variables
