% id=[{'id5'};{'id5'};{'id5'};{'id5'};{'id5'}];Eugenio
% plot(data.(id{1})(1).Norm.EXO_R_x.signals);
% f=fields(data.id5.sagital(1).Raw);

%% Leer datos excels
addpath('C:\Users\jimmy\OneDrive - Universidad Rey Juan Carlos\01_Doctorado\Estudios experimentales\Validación Barras delta_Kinovea\Datos');
cd('C:\Users\jimmy\OneDrive - Universidad Rey Juan Carlos\01_Doctorado\Estudios experimentales\Validación Barras delta_Kinovea\Datos\id5_Santi');
fileName_aux = dir('C:\Users\jimmy\OneDrive - Universidad Rey Juan Carlos\01_Doctorado\Estudios experimentales\Validación Barras delta_Kinovea\Datos\id5_Santi');
fileName_aux(1,:) = [];
fileName_aux(1,:) = [];
j=1;
var=[{'HIP_lat_x'};{'HIP_lat_y'};{'KNEE_lat_x'};{'KNEE_lat_y'};{'ANKLE_lat_x'};{'ANKLE_lat_y'};{'TOE_lat_x'};{'TOE_lat_y'}]; %{'HEEL_lat_x'};{'HEEL_lat_y'};
% calib=[60.05;85.12;62.78;46.94;63.38;10.96;49.06;5.79]; % Del excel 63.38;6.57;
ang=[{'Hip_Angle'};{'Knee_Angle'};{'Ankle_Angle'}];
veloc = [{'speed05'};{'speed1'}];
condition = [{'CL'};{'CC'};{'CML'};{'CMR'}];
n=10; %Orden
Fc=4; %Frecuencia de Corte
Fs=30; %Frecuencia de muestreo
[numFilt, denFilt]=butter(n, Fc/(0.5*Fs));
% Calibración marcadores
C = xlsread('id5_Sagital_calib.xml');
for n=1:length(var)
    data.id5.Calib.(var{n}) = mean(C(:,n+1));
end
for (archivo=1:length(fileName_aux))
    if(contains(fileName_aux(archivo).name, "Sagital.xml"))
        % [path,data.id5.sagital.(veloc{v}).(condition{c}).nameFile,ext] = fileparts(fileName_aux(archivo).name);
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
        data.id5.sagital.(veloc{v}).(condition{c}).time = T(:,1)';
        data.id5.sagital.(veloc{v}).(condition{c}).contacts = T(:,2)';
        for n=1:length(var)
            % Recogida de los raw data y filtrado
            data.id5.sagital.(veloc{v}).(condition{c}).Raw.(var{n}) = T(:,n+2)'; data.id5.sagital.(veloc{v}).(condition{c}).Filt.(var{n})=filtfilt(numFilt, denFilt,data.id5.sagital.(veloc{v}).(condition{c}).Raw.(var{n}));
           % data.id5.Calib.(var{n}) = calib(n);
            n=n+1;
        end
        % Segmentación de ciclos de la marcha
        for i=1:10
            t=data.id5.sagital.(veloc{v}).(condition{c}).contacts(i);t1=data.id5.sagital.(veloc{v}).(condition{c}).contacts(i+1);
           index=find(abs(data.id5.sagital.(veloc{v}).(condition{c}).time(:)-t)<0.001); index1=find(abs(data.id5.sagital.(veloc{v}).(condition{c}).time(:)-t1)<0.001);
            x=linspace(1,length(data.id5.sagital.(veloc{v}).(condition{c}).time(index:index1)),100);
            for n=1:length(var)
                data.id5.sagital.(veloc{v}).(condition{c}).Segmented.(var{n}).signals(i,:)=interp1(1:1:length(data.id5.sagital.(veloc{v}).(condition{c}).Filt.(var{n})(index:index1)),data.id5.sagital.(veloc{v}).(condition{c}).Filt.(var{n})(index:index1),x);
                data.id5.sagital.(veloc{v}).(condition{c}).Segmented.(var{n}).values.min(i,1)=min(data.id5.sagital.(veloc{v}).(condition{c}).Segmented.(var{n}).signals(i,:));
                data.id5.sagital.(veloc{v}).(condition{c}).Segmented.(var{n}).values.max(i,1)=max(data.id5.sagital.(veloc{v}).(condition{c}).Segmented.(var{n}).signals(i,:));
                data.id5.sagital.(veloc{v}).(condition{c}).Segmented.(var{n}).values.rango(i,1)=max(data.id5.sagital.(veloc{v}).(condition{c}).Segmented.(var{n}).signals(i,:))-min(data.id5.sagital.(veloc{v}).(condition{c}).Segmented.(var{n}).signals(i,:));
                n=n+1;
            end
        end
        for n=1:length(var)
            %Promediado y cálculo de la desviación estándar, min, máx y rango
            data.id5.sagital.(veloc{v}).(condition{c}).Mean.(var{n}).signals=mean(data.id5.sagital.(veloc{v}).(condition{c}).Segmented.(var{n}).signals);
            data.id5.sagital.(veloc{v}).(condition{c}).Desv.(var{n})=std(data.id5.sagital.(veloc{v}).(condition{c}).Segmented.(var{n}).signals);
            data.id5.sagital.(veloc{v}).(condition{c}).Mean.(var{n}).values.min=min(data.id5.sagital.(veloc{v}).(condition{c}).Mean.(var{n}).signals);
            data.id5.sagital.(veloc{v}).(condition{c}).Mean.(var{n}).values.max=max(data.id5.sagital.(veloc{v}).(condition{c}).Mean.(var{n}).signals);
            data.id5.sagital.(veloc{v}).(condition{c}).Mean.(var{n}).values.rango=max(data.id5.sagital.(veloc{v}).(condition{c}).Mean.(var{n}).signals)-min(data.id5.sagital.(veloc{v}).(condition{c}).Mean.(var{n}).signals);
            % Normalización de las señales promedio con respecto al valor de inicio del ciclo
            data.id5.sagital.(veloc{v}).(condition{c}).Norm.(var{n}).signals=data.id5.sagital.(veloc{v}).(condition{c}).Mean.(var{n}).signals-data.id5.sagital.(veloc{v}).(condition{c}).Mean.(var{n}).signals(1);
            data.id5.sagital.(veloc{v}).(condition{c}).Norm.(var{n}).values.min=min(data.id5.sagital.(veloc{v}).(condition{c}).Norm.(var{n}).signals);
            data.id5.sagital.(veloc{v}).(condition{c}).Norm.(var{n}).values.max=max(data.id5.sagital.(veloc{v}).(condition{c}).Norm.(var{n}).signals);
            data.id5.sagital.(veloc{v}).(condition{c}).Norm.(var{n}).values.rango=max(data.id5.sagital.(veloc{v}).(condition{c}).Norm.(var{n}).signals)-min(data.id5.sagital.(veloc{v}).(condition{c}).Norm.(var{n}).signals);
            n=n+1;
        end
        % Calibración de las rotaciones angulares
        trunkCalib = [data.id5.Calib.HIP_lat_x-20;data.id5.Calib.HIP_lat_y]'-[data.id5.Calib.HIP_lat_x;data.id5.Calib.HIP_lat_y]';
        femurCalib = [data.id5.Calib.HIP_lat_x;data.id5.Calib.HIP_lat_y]'-[data.id5.Calib.KNEE_lat_x;data.id5.Calib.KNEE_lat_y]';
        tibiaCalib = [data.id5.Calib.KNEE_lat_x;data.id5.Calib.KNEE_lat_y]'-[data.id5.Calib.ANKLE_lat_x;data.id5.Calib.ANKLE_lat_y]';
        footCalib = [data.id5.Calib.ANKLE_lat_x;data.id5.Calib.ANKLE_lat_y]'-[data.id5.Calib.TOE_lat_x;data.id5.Calib.TOE_lat_y]';
        hip_calib_ang = (atan2(abs(det([trunkCalib;-femurCalib])),dot(trunkCalib,-femurCalib)))*180/pi;
        knee_calib_ang = (atan2(abs(det([femurCalib;-tibiaCalib])),dot(femurCalib,-tibiaCalib)))*180/pi;
        ankle_calib_ang= (atan2(abs(det([tibiaCalib;-footCalib])),dot(tibiaCalib,-footCalib)))*180/pi;
        % Cálculo de rotaciones articulares en el plano sagital
        for seg=1:length(data.id5.sagital.(veloc{v}).(condition{c}).Segmented.HIP_lat_x.signals(:,1))
            trunk = [data.id5.sagital.(veloc{v}).(condition{c}).Segmented.HIP_lat_x.signals(seg,:)-20;data.id5.sagital.(veloc{v}).(condition{c}).Segmented.HIP_lat_y.signals(seg,:)]'-[data.id5.sagital.(veloc{v}).(condition{c}).Segmented.HIP_lat_x.signals(seg,:);data.id5.sagital.(veloc{v}).(condition{c}).Segmented.HIP_lat_y.signals(seg,:)]';
            femur = [data.id5.sagital.(veloc{v}).(condition{c}).Segmented.HIP_lat_x.signals(seg,:);data.id5.sagital.(veloc{v}).(condition{c}).Segmented.HIP_lat_y.signals(seg,:)]'-[data.id5.sagital.(veloc{v}).(condition{c}).Segmented.KNEE_lat_x.signals(seg,:);data.id5.sagital.(veloc{v}).(condition{c}).Segmented.KNEE_lat_y.signals(seg,:)]';
            tibia =[data.id5.sagital.(veloc{v}).(condition{c}).Segmented.KNEE_lat_x.signals(seg,:);data.id5.sagital.(veloc{v}).(condition{c}).Segmented.KNEE_lat_y.signals(seg,:)]'-[data.id5.sagital.(veloc{v}).(condition{c}).Segmented.ANKLE_lat_x.signals(seg,:);data.id5.sagital.(veloc{v}).(condition{c}).Segmented.ANKLE_lat_y.signals(seg,:)]';
            foot =[data.id5.sagital.(veloc{v}).(condition{c}).Segmented.ANKLE_lat_x.signals(seg,:);data.id5.sagital.(veloc{v}).(condition{c}).Segmented.ANKLE_lat_y.signals(seg,:)]'-[data.id5.sagital.(veloc{v}).(condition{c}).Segmented.TOE_lat_x.signals(seg,:);data.id5.sagital.(veloc{v}).(condition{c}).Segmented.TOE_lat_y.signals(seg,:)]';
            for i=1:length(femur)
                hip_ang(i) = -hip_calib_ang+(atan2(abs(det([trunk(i,:);-femur(i,:)])),dot(trunk(i,:),-femur(i,:))))*180/pi;
                knee_ang(i) = -knee_calib_ang+(atan2(abs(det([femur(i,:);-tibia(i,:)])),dot(femur(i,:),-tibia(i,:))))*180/pi;
                ankle_ang(i) = -ankle_calib_ang+(atan2(abs(det([tibia(i,:);-foot(i,:)])),dot(tibia(i,:),-foot(i,:))))*180/pi;
            end
            data.id5.sagital.(veloc{v}).(condition{c}).AngSeg.(ang{1}).signals(seg,:)=-(hip_ang);
            data.id5.sagital.(veloc{v}).(condition{c}).AngSeg.(ang{2}).signals(seg,:)=-knee_ang;
            data.id5.sagital.(veloc{v}).(condition{c}).AngSeg.(ang{3}).signals(seg,:)=ankle_ang;
            for a=1:3
                data.id5.sagital.(veloc{v}).(condition{c}).AngSeg.(ang{a}).values.min(seg,1)=min(data.id5.sagital.(veloc{v}).(condition{c}).AngSeg.(ang{a}).signals(seg,:));
                data.id5.sagital.(veloc{v}).(condition{c}).AngSeg.(ang{a}).values.max(seg,1)=max(data.id5.sagital.(veloc{v}).(condition{c}).AngSeg.(ang{a}).signals(seg,:));
                data.id5.sagital.(veloc{v}).(condition{c}).AngSeg.(ang{a}).values.rango(seg,1)=max(data.id5.sagital.(veloc{v}).(condition{c}).AngSeg.(ang{a}).signals(seg,:))-min(data.id5.sagital.(veloc{v}).(condition{c}).AngSeg.(ang{a}).signals(seg,:));
            end
        end
        for a=1:length(ang)
            data.id5.sagital.(veloc{v}).(condition{c}).AngMean.(ang{a}).signals=mean(data.id5.sagital.(veloc{v}).(condition{c}).AngSeg.(ang{a}).signals);
            data.id5.sagital.(veloc{v}).(condition{c}).AngDesv.(ang{a}).signals=std(data.id5.sagital.(veloc{v}).(condition{c}).AngSeg.(ang{a}).signals);
            data.id5.sagital.(veloc{v}).(condition{c}).AngMean.(ang{a}).values.min=min(data.id5.sagital.(veloc{v}).(condition{c}).AngMean.(ang{a}).signals);
            data.id5.sagital.(veloc{v}).(condition{c}).AngMean.(ang{a}).values.max=max(data.id5.sagital.(veloc{v}).(condition{c}).AngMean.(ang{a}).signals);
            data.id5.sagital.(veloc{v}).(condition{c}).AngMean.(ang{a}).values.rango=max(data.id5.sagital.(veloc{v}).(condition{c}).AngMean.(ang{a}).signals)-min(data.id5.sagital.(veloc{v}).(condition{c}).AngMean.(ang{a}).signals);
        end
        j=j+1;
    end
end

%% Plots
a=1;b=3;c=5;d=7;e=2;f=4;g=6;h=8; % 3,1,5,7
figure ('Name', 'Exo 0.5')
subplot(2,2,1)
shadedErrorBar(1:1:100,data.id5.sagital.speed05.(condition{2}).AngMean.(ang{1}).signals,data.id5.sagital.speed05.(condition{2}).AngDesv.(ang{1}).signals,'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.sagital.speed05.(condition{1}).AngMean.(ang{1}).signals,data.id5.sagital.speed05.(condition{1}).AngDesv.(ang{1}).signals,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.sagital.speed05.(condition{3}).AngMean.(ang{1}).signals,data.id5.sagital.speed05.(condition{3}).AngDesv.(ang{1}).signals,'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.sagital.speed05.(condition{4}).AngMean.(ang{1}).signals,data.id5.sagital.speed05.(condition{4}).AngDesv.(ang{1}).signals,'lineprops','-r','patchSaturation',0.33);
legend('w/o corset','w/ corset','w/ corset+frame')
title('Hip flexion')
subplot(2,2,2)
shadedErrorBar(1:1:100,data.id5.sagital.speed05.(condition{2}).AngMean.(ang{2}).signals,data.id5.sagital.speed05.(condition{2}).AngDesv.(ang{2}).signals,'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.sagital.speed05.(condition{1}).AngMean.(ang{2}).signals,data.id5.sagital.speed05.(condition{1}).AngDesv.(ang{2}).signals,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.sagital.speed05.(condition{3}).AngMean.(ang{2}).signals,data.id5.sagital.speed05.(condition{3}).AngDesv.(ang{2}).signals,'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.sagital.speed05.(condition{4}).AngMean.(ang{2}).signals,data.id5.sagital.speed05.(condition{4}).AngDesv.(ang{2}).signals,'lineprops','-r','patchSaturation',0.33);
title('Knee flexion')
subplot(2,2,3)
shadedErrorBar(1:1:100,data.id5.sagital.speed05.(condition{2}).AngMean.(ang{3}).signals,data.id5.sagital.speed05.(condition{2}).AngDesv.(ang{3}).signals,'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.sagital.speed05.(condition{1}).AngMean.(ang{3}).signals,data.id5.sagital.speed05.(condition{1}).AngDesv.(ang{3}).signals,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.sagital.speed05.(condition{3}).AngMean.(ang{3}).signals,data.id5.sagital.speed05.(condition{3}).AngDesv.(ang{3}).signals,'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.sagital.speed05.(condition{4}).AngMean.(ang{3}).signals,data.id5.sagital.speed05.(condition{4}).AngDesv.(ang{3}).signals,'lineprops','-r','patchSaturation',0.33);
title('Ankle flexion')
subplot(2,2,4)
shadedErrorBar(1:1:100,data.id5.sagital.speed05.(condition{2}).Norm.TOE_lat_x.signals,data.id5.sagital.speed05.(condition{2}).Desv.TOE_lat_x,'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.sagital.speed05.(condition{1}).Norm.TOE_lat_x.signals,data.id5.sagital.speed05.(condition{1}).Desv.TOE_lat_x,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.sagital.speed05.(condition{3}).Norm.TOE_lat_x.signals,data.id5.sagital.speed05.(condition{3}).Desv.TOE_lat_x,'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.sagital.speed05.(condition{4}).Norm.TOE_lat_x.signals,data.id5.sagital.speed05.(condition{4}).Desv.TOE_lat_x,'lineprops','-r','patchSaturation',0.33);
title('Antero-posterior displacement of the toe')


%% Plots
a=1;b=3;c=5;d=7;e=2;f=4;g=6;h=8; % 3,1,5,7
figure ('Name', 'Exo 1')
subplot(2,2,1)
shadedErrorBar(1:1:100,data.id5.sagital.speed1.(condition{2}).AngMean.(ang{1}).signals,data.id5.sagital.speed1.(condition{2}).AngDesv.(ang{1}).signals,'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.sagital.speed1.(condition{1}).AngMean.(ang{1}).signals,data.id5.sagital.speed1.(condition{1}).AngDesv.(ang{1}).signals,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.sagital.speed1.(condition{3}).AngMean.(ang{1}).signals,data.id5.sagital.speed1.(condition{3}).AngDesv.(ang{1}).signals,'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.sagital.speed1.(condition{4}).AngMean.(ang{1}).signals,data.id5.sagital.speed1.(condition{4}).AngDesv.(ang{1}).signals,'lineprops','-r','patchSaturation',0.33);
legend('w/o corset','w/ corset','w/ corset+frame')
title('Hip flexion')
subplot(2,2,2)
shadedErrorBar(1:1:100,data.id5.sagital.speed1.(condition{2}).AngMean.(ang{2}).signals,data.id5.sagital.speed1.(condition{2}).AngDesv.(ang{2}).signals,'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.sagital.speed1.(condition{1}).AngMean.(ang{2}).signals,data.id5.sagital.speed1.(condition{1}).AngDesv.(ang{2}).signals,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.sagital.speed1.(condition{3}).AngMean.(ang{2}).signals,data.id5.sagital.speed1.(condition{3}).AngDesv.(ang{2}).signals,'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.sagital.speed1.(condition{4}).AngMean.(ang{2}).signals,data.id5.sagital.speed1.(condition{4}).AngDesv.(ang{2}).signals,'lineprops','-r','patchSaturation',0.33);
title('Knee flexion')
subplot(2,2,3)
shadedErrorBar(1:1:100,data.id5.sagital.speed1.(condition{2}).AngMean.(ang{3}).signals,data.id5.sagital.speed1.(condition{2}).AngDesv.(ang{3}).signals,'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.sagital.speed1.(condition{1}).AngMean.(ang{3}).signals,data.id5.sagital.speed1.(condition{1}).AngDesv.(ang{3}).signals,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.sagital.speed1.(condition{3}).AngMean.(ang{3}).signals,data.id5.sagital.speed1.(condition{3}).AngDesv.(ang{3}).signals,'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.sagital.speed1.(condition{4}).AngMean.(ang{3}).signals,data.id5.sagital.speed1.(condition{4}).AngDesv.(ang{3}).signals,'lineprops','-r','patchSaturation',0.33);
title('Ankle flexion')
subplot(2,2,4)
shadedErrorBar(1:1:100,data.id5.sagital.speed1.(condition{2}).Norm.TOE_lat_x.signals,data.id5.sagital.speed1.(condition{2}).Desv.TOE_lat_x,'lineprops','-g','patchSaturation',0.33);
hold on
shadedErrorBar(1:1:100,data.id5.sagital.speed1.(condition{1}).Norm.TOE_lat_x.signals,data.id5.sagital.speed1.(condition{1}).Desv.TOE_lat_x,'lineprops','-b','patchSaturation',0.33);
shadedErrorBar(1:1:100,data.id5.sagital.speed1.(condition{3}).Norm.TOE_lat_x.signals,data.id5.sagital.speed1.(condition{3}).Desv.TOE_lat_x,'lineprops','-y','patchSaturation',0.33);
% shadedErrorBar(1:1:100,data.id5.sagital.speed1.(condition{4}).Norm.TOE_lat_x.signals,data.id5.sagital.speed1.(condition{4}).Desv.TOE_lat_x,'lineprops','-r','patchSaturation',0.33);
title('Antero-posterior displacement of the toe')

%%
max(data.id2.sagital.speed05.(condition{2}).AngMean.(ang{1}).signals)
min(data.id2.sagital.speed05.(condition{2}).AngMean.(ang{1}).signals)
max(data.id2.sagital.speed05.(condition{1}).AngMean.(ang{1}).signals)
min(data.id2.sagital.speed05.(condition{1}).AngMean.(ang{1}).signals)
max(data.id2.sagital.speed05.(condition{3}).AngMean.(ang{1}).signals)
min(data.id2.sagital.speed05.(condition{3}).AngMean.(ang{1}).signals)