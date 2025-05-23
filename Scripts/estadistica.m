veloc = [{'speed05'};{'speed1'}];
condition = [{'CL'};{'CC'};{'CML'}];
var=[{'Hip_Angle'};{'Knee_Angle'};{'Ankle_Angle'};{'Abd_R'};{'Abd_L'};{'Pelvis_List'}];
com=[{'COM_x'};{'COM_y'}];
ankle=[{'ANKLE_R_x'};{'ANKLE_L_x'}];

for v=1:2
    for a=1:6
        for i=1:3
            for n=1:50
                data.media.value.max.(veloc{v}).(var{a})(n,i)=max(data.media.signals.(veloc{v}).(condition{i}).AngSeg.(var{a}).signals(n,:));
                data.media.value.min.(veloc{v}).(var{a})(n,i)=min(data.media.signals.(veloc{v}).(condition{i}).AngSeg.(var{a}).signals(n,:));
                data.media.value.range.(veloc{v}).(var{a})(n,i)=max(data.media.signals.(veloc{v}).(condition{i}).AngSeg.(var{a}).signals(n,:))-min(data.media.signals.(veloc{v}).(condition{i}).AngSeg.(var{a}).signals(n,:));
            end
        end
    end
end
for v=1:2
    for a=1:2
        for i=1:3
            for n=1:50
                data.media.value.max.(veloc{v}).(com{a})(n,i)=max(data.media.signals.(veloc{v}).(condition{i}).COMNorm.(com{a}).signals(n,:));
                data.media.value.min.(veloc{v}).(com{a})(n,i)=min(data.media.signals.(veloc{v}).(condition{i}).COMNorm.(com{a}).signals(n,:));
                data.media.value.range.(veloc{v}).(com{a})(n,i)=max(data.media.signals.(veloc{v}).(condition{i}).COMNorm.(com{a}).signals(n,:))-min(data.media.signals.(veloc{v}).(condition{i}).COMNorm.(com{a}).signals(n,:));
            end
        end
    end
end
for v=1:2
    for i=1:3
        for n=1:50
            data.media.value.MeanStepWidth.(veloc{v})(n,i)=mean(data.media.signals.(veloc{v}).(condition{i}).AnkleSeg.(ankle{2}).signals(n,1:5)-data.media.signals.(veloc{v}).(condition{i}).AnkleSeg.(ankle{1}).signals(n,1:5));
        end
    end
end
%%
var2=[{'Hip_Angle'};{'Knee_Angle'};{'Ankle_Angle'};{'Abd_R'};{'Abd_L'};{'Pelvis_List'};{'COM_x'};{'COM_y'}];
for i=1:8
    for j=1:3
    A05(i,j)=mean(data.media.value.range.speed05.(var2{i})(:,j));
    end
end
%%
for i=1:8
p=anova1(data.media.value.min.speed1.(var2{i}))
end
%%
for i=1:8
[h,p] = ttest(data.media.value.max.speed1.(var2{i})(:,2),data.media.value.max.speed1.(var2{i})(:,3))
end