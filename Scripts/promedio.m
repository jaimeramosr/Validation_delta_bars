id = [{'id1'};{'id2'};{'id3'};{'id4'};{'id5'}];
angSag=[{'Hip_Angle'};{'Knee_Angle'};{'Ankle_Angle'}];
angFront=[{'Abd_R'};{'Abd_L'};{'Pelvis_List'}];
veloc = [{'speed05'};{'speed1'}];
condition = [{'CL'};{'CC'};{'CML'};{'CMR'}];
com=[{'COM_x'};{'COM_y'}];
ankle=[{'ANKLE_R_x'};{'ANKLE_L_x'}];

for i=1:5
    for v=1:2
        for c=1:4
            for a=1:3
            data.media.signals.(veloc{v}).(condition{c}).AngSeg.(angSag{a}).signals((i-1)*10+1:(i-1)*10+10,:)= data.(id{i}).sagital.(veloc{v}).(condition{c}).AngSeg.(angSag{a}).signals(:,:);
            data.media.signals.(veloc{v}).(condition{c}).AngSeg.(angFront{a}).signals((i-1)*10+1:(i-1)*10+10,:)= data.(id{i}).frontal.(veloc{v}).(condition{c}).AngSeg.(angFront{a}).signals(:,:);
            end
        end
    end
end        
    for v=1:2
        for c=1:4
            for a=1:3
            data.media.signals.(veloc{v}).(condition{c}).AngMean.(angSag{a}).signals= mean(data.media.signals.(veloc{v}).(condition{c}).AngSeg.(angSag{a}).signals);
            data.media.signals.(veloc{v}).(condition{c}).AngDesv.(angSag{a}).signals= std(data.media.signals.(veloc{v}).(condition{c}).AngSeg.(angSag{a}).signals);
            data.media.signals.(veloc{v}).(condition{c}).AngMean.(angFront{a}).signals= mean(data.media.signals.(veloc{v}).(condition{c}).AngSeg.(angFront{a}).signals);
            data.media.signals.(veloc{v}).(condition{c}).AngDesv.(angFront{a}).signals= std(data.media.signals.(veloc{v}).(condition{c}).AngSeg.(angFront{a}).signals);
            end
        end
    end

%%
for i=1:5
    for v=1:2
        for c=1:4
            for a=1:2
            data.media.signals.(veloc{v}).(condition{c}).COMSeg.(com{a}).signals((i-1)*10+1:(i-1)*10+10,:)= data.(id{i}).frontal.(veloc{v}).(condition{c}).Segmented.(com{a}).signals(:,:); 
            data.media.signals.(veloc{v}).(condition{c}).AnkleSeg.(ankle{a}).signals((i-1)*10+1:(i-1)*10+10,:)= data.(id{i}).frontal.(veloc{v}).(condition{c}).Segmented.(ankle{a}).signals(:,:); 
            end
        end
    end
end
for v=1:2
        for c=1:4
            for a=1:2
            data.media.signals.(veloc{v}).(condition{c}).COMNorm.(com{a}).signals(:,:)=data.media.signals.(veloc{v}).(condition{c}).COMSeg.(com{a}).signals(:,:)-data.media.signals.(veloc{v}).(condition{c}).COMSeg.(com{a}).signals(:,1);
            data.media.signals.(veloc{v}).(condition{c}).COMMean.(com{a}).signals= mean(data.media.signals.(veloc{v}).(condition{c}).COMNorm.(com{a}).signals);
            data.media.signals.(veloc{v}).(condition{c}).COMDesv.(com{a}).signals= std(data.media.signals.(veloc{v}).(condition{c}).COMNorm.(com{a}).signals);
            data.media.signals.(veloc{v}).(condition{c}).AnkleNorm.(ankle{a}).signals(:,:)=data.media.signals.(veloc{v}).(condition{c}).AnkleSeg.(ankle{a}).signals(:,:)-data.media.signals.(veloc{v}).(condition{c}).AnkleSeg.(ankle{1}).signals(:,1);
            data.media.signals.(veloc{v}).(condition{c}).AnkleMean.(ankle{a}).signals= mean(data.media.signals.(veloc{v}).(condition{c}).AnkleNorm.(ankle{a}).signals);
            data.media.signals.(veloc{v}).(condition{c}).AnkleDesv.(ankle{a}).signals= std(data.media.signals.(veloc{v}).(condition{c}).AnkleNorm.(ankle{a}).signals);
            end
        end
end

%% Plots
veloc = [{'speed05'};{'speed1'}];
angSag=[{'Hip_Angle'};{'Knee_Angle'};{'Ankle_Angle'}];
angFront=[{'Abd_R'};{'Abd_L'};{'Pelvis_List'}];
v=1;
figure ('Name', veloc{v})
subplot(3,3,1)
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{1}).AngMean.(angSag{1}).signals,data.media.signals.(veloc{v}).(condition{1}).AngDesv.(angSag{1}).signals,'lineprops','-g','patchSaturation',0.33);
s.mainLine.LineWidth = 2;
hold on
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{2}).AngMean.(angSag{1}).signals,data.media.signals.(veloc{v}).(condition{2}).AngDesv.(angSag{1}).signals,'lineprops','--b','patchSaturation',0.33);
s.mainLine.LineWidth = 1.5;
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{3}).AngMean.(angSag{1}).signals,data.media.signals.(veloc{v}).(condition{3}).AngDesv.(angSag{1}).signals,'lineprops','-.r','patchSaturation',0.25);
s.mainLine.LineWidth = 1;
legend('unrestricted walking','wearing corset','wearing corset+frame')
title('Sagittal plane kinematics');
ylabel("Hip flexion");
xlabel("Gait cycle (%)");
subplot(3,3,4)
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{1}).AngMean.(angSag{2}).signals,data.media.signals.(veloc{v}).(condition{1}).AngDesv.(angSag{2}).signals,'lineprops','-g','patchSaturation',0.33);
s.mainLine.LineWidth = 2;
hold on
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{2}).AngMean.(angSag{2}).signals,data.media.signals.(veloc{v}).(condition{2}).AngDesv.(angSag{2}).signals,'lineprops','--b','patchSaturation',0.33);
s.mainLine.LineWidth = 1.5;
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{3}).AngMean.(angSag{2}).signals,data.media.signals.(veloc{v}).(condition{3}).AngDesv.(angSag{2}).signals,'lineprops','-.r','patchSaturation',0.25);
s.mainLine.LineWidth = 1;
ylabel("Knee flexion");
xlabel("Gait cycle (%)");
subplot(3,3,7)
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{1}).AngMean.(angSag{3}).signals,data.media.signals.(veloc{v}).(condition{1}).AngDesv.(angSag{3}).signals,'lineprops','-g','patchSaturation',0.33);
s.mainLine.LineWidth = 2;
hold on
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{2}).AngMean.(angSag{3}).signals,data.media.signals.(veloc{v}).(condition{2}).AngDesv.(angSag{3}).signals,'lineprops','--b','patchSaturation',0.33);
s.mainLine.LineWidth = 1.5;
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{3}).AngMean.(angSag{3}).signals,data.media.signals.(veloc{v}).(condition{3}).AngDesv.(angSag{3}).signals,'lineprops','-.r','patchSaturation',0.25);
s.mainLine.LineWidth = 1;
ylabel("Ankle flexion");
xlabel("Gait cycle (%)");

subplot(3,3,2)
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{1}).AngMean.(angFront{1}).signals,data.media.signals.(veloc{v}).(condition{1}).AngDesv.(angFront{1}).signals,'lineprops','-g','patchSaturation',0.33);
s.mainLine.LineWidth = 2;
hold on
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{2}).AngMean.(angFront{1}).signals,data.media.signals.(veloc{v}).(condition{2}).AngDesv.(angFront{1}).signals,'lineprops','--b','patchSaturation',0.33);
s.mainLine.LineWidth = 1.5;
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{3}).AngMean.(angFront{1}).signals,data.media.signals.(veloc{v}).(condition{3}).AngDesv.(angFront{1}).signals,'lineprops','-.r','patchSaturation',0.25);
s.mainLine.LineWidth = 1;
title('Frontal plane kinematics');
ylabel("Right hip abduction");
xlabel("Gait cycle (%)");
subplot(3,3,5)
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{1}).AngMean.(angFront{2}).signals,data.media.signals.(veloc{v}).(condition{1}).AngDesv.(angFront{2}).signals,'lineprops','-g','patchSaturation',0.33);
s.mainLine.LineWidth = 2;
hold on
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{2}).AngMean.(angFront{2}).signals,data.media.signals.(veloc{v}).(condition{2}).AngDesv.(angFront{2}).signals,'lineprops','--b','patchSaturation',0.33);
s.mainLine.LineWidth = 1.5;
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{3}).AngMean.(angFront{2}).signals,data.media.signals.(veloc{v}).(condition{3}).AngDesv.(angFront{2}).signals,'lineprops','-.r','patchSaturation',0.25);
s.mainLine.LineWidth = 1;
ylabel("Left hip abduction");
xlabel("Gait cycle (%)");
subplot(3,3,8)
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{1}).AngMean.(angFront{3}).signals,data.media.signals.(veloc{v}).(condition{1}).AngDesv.(angFront{3}).signals,'lineprops','-g','patchSaturation',0.33);
s.mainLine.LineWidth = 2;
hold on
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{2}).AngMean.(angFront{3}).signals,data.media.signals.(veloc{v}).(condition{2}).AngDesv.(angFront{3}).signals,'lineprops','--b','patchSaturation',0.33);
s.mainLine.LineWidth = 1.5;
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{3}).AngMean.(angFront{3}).signals,data.media.signals.(veloc{v}).(condition{3}).AngDesv.(angFront{3}).signals,'lineprops','-.r','patchSaturation',0.25);
s.mainLine.LineWidth = 1;
ylabel("Pelvic list");
xlabel("Gait cycle (%)");

subplot(3,3,3)
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{1}).COMMean.COM_x.signals,data.media.signals.(veloc{v}).(condition{1}).COMDesv.COM_x.signals,'lineprops','-g','patchSaturation',0.33);
s.mainLine.LineWidth = 2;
hold on
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{2}).COMMean.COM_x.signals,data.media.signals.(veloc{v}).(condition{2}).COMDesv.COM_x.signals,'lineprops','--b','patchSaturation',0.33);
s.mainLine.LineWidth = 1.5;
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{3}).COMMean.COM_x.signals,data.media.signals.(veloc{v}).(condition{3}).COMDesv.COM_x.signals,'lineprops','-.r','patchSaturation',0.25);
s.mainLine.LineWidth = 1;
title('Frontal plane cartesian');
ylabel("CoM horizontal position (cm)");
xlabel("Gait cycle (%)");
subplot(3,3,6)
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{1}).COMMean.COM_y.signals,data.media.signals.(veloc{v}).(condition{1}).COMDesv.COM_y.signals,'lineprops','-g','patchSaturation',0.33);
s.mainLine.LineWidth = 2;
hold on
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{2}).COMMean.COM_y.signals,data.media.signals.(veloc{v}).(condition{2}).COMDesv.COM_y.signals,'lineprops','--b','patchSaturation',0.33);
s.mainLine.LineWidth = 1.5;
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{3}).COMMean.COM_y.signals,data.media.signals.(veloc{v}).(condition{3}).COMDesv.COM_y.signals,'lineprops','-.r','patchSaturation',0.25);
s.mainLine.LineWidth = 1;
ylabel("CoM vertical position (cm)");
xlabel("Gait cycle (%)");
subplot(3,3,9)
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{1}).AnkleMean.ANKLE_R_x.signals,data.media.signals.(veloc{v}).(condition{1}).AnkleDesv.ANKLE_R_x.signals,'lineprops','-g','patchSaturation',0.33);
s.mainLine.LineWidth = 2;
hold on
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{2}).AnkleMean.ANKLE_R_x.signals,data.media.signals.(veloc{v}).(condition{2}).AnkleDesv.ANKLE_R_x.signals,'lineprops','--b','patchSaturation',0.33);
s.mainLine.LineWidth = 1.5;
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{3}).AnkleMean.ANKLE_R_x.signals,data.media.signals.(veloc{v}).(condition{3}).AnkleDesv.ANKLE_R_x.signals,'lineprops','-.r','patchSaturation',0.25);
s.mainLine.LineWidth = 1;
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{1}).AnkleMean.ANKLE_L_x.signals,data.media.signals.(veloc{v}).(condition{1}).AnkleDesv.ANKLE_L_x.signals,'lineprops','-g','patchSaturation',0.33);
s.mainLine.LineWidth = 2;
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{2}).AnkleMean.ANKLE_L_x.signals,data.media.signals.(veloc{v}).(condition{2}).AnkleDesv.ANKLE_L_x.signals,'lineprops','--b','patchSaturation',0.33);
s.mainLine.LineWidth = 1.5;
s=shadedErrorBar(1:1:100,data.media.signals.(veloc{v}).(condition{3}).AnkleMean.ANKLE_L_x.signals,data.media.signals.(veloc{v}).(condition{3}).AnkleDesv.ANKLE_L_x.signals,'lineprops','-.r','patchSaturation',0.25);
s.mainLine.LineWidth = 1;
ylabel("Step width (cm)");
xlabel("Gait cycle (%)");
