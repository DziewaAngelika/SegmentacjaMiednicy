%%
clc;clear all; close all;
path_image_ekspert = 'D:\Magisterka\Dane\Silver07\converted_dcm\013.h5_label.dcm';
path_image_predicted = 'D:\Magisterka\Dane\Silver07\po_konwersji\013_predictions.h5_label.dcm';

image_ekspert_dcm = squeeze(dicomread(path_image_ekspert));
image_predicted_dcm = squeeze(dicomread(path_image_predicted));

%% 
layer_number = size(image_ekspert_dcm,3);
quality_matrix=zeros(layer_number,6);

sum_TP=0;sum_FP=0;sum_TN=0;sum_FN=0;
for z=1:layer_number
image_ekspert = image_ekspert_dcm(:,:,z);
image_predicted = image_predicted_dcm(:,:,z);

image_ekspert=im2double(image_ekspert);
image_predicted=im2double(image_predicted);

image_predicted(image_predicted>0.99)=1;
image_predicted(image_predicted<0.99)=0;

TP=0;FP=0;TN=0;FN=0;
for i=1:size(image_predicted,1)
    for j=1:size(image_predicted,2)
        if(image_predicted(i,j)==1 && image_ekspert(i,j)==1)
            TP=TP+1;
            sum_TP=sum_TP+1;
        elseif (image_predicted(i,j)==1 && image_ekspert(i,j)==0)
            FP=FP+1;
            sum_FP=sum_FP+1;
        elseif (image_predicted(i,j)==0 && image_ekspert(i,j)==1) 
            FN=FN+1;
            sum_FN=sum_FN+1;
        else
            TN=TN+1;
            sum_TN=sum_TN+1;
        end
    end
end

%dok³adnoœæ
ACC = (TP + TN)/(TP + FP + TN + FN);
%czu³oœæ
TPR = TP/(TP + FN);
%specyficznoœæ
TNR = TN /(FP + TN );
%Precyzja
PPV = TP/(TP + FP);
%Dice rêcznie
Dice = (2*TP)/((2*TP) + FP + FN);
%Jaccard rêcznie
IoU = TP/(TP + FP + FN);

quality_matrix(z,:)=[ACC,TPR,TNR,PPV,Dice,IoU];

end
quality_matrix(isnan(quality_matrix))=0;
means_quality_measures = mean(quality_matrix);

%Suma wszystkich

%dok³adnoœæ
sum_ACC = (sum_TP + sum_TN)/(sum_TP + sum_FP + sum_TN + sum_FN);
%czu³oœæ
sum_TPR = sum_TP/(sum_TP + sum_FN);
%specyficznoœæ
sum_TNR = sum_TN /(sum_FP + sum_TN );
%Precyzja
sum_PPV = sum_TP/(sum_TP + sum_FP);
%Dice rêcznie
sum_Dice = (2*sum_TP)/((2*sum_TP) + sum_FP + sum_FN);
%Jaccard rêcznie
sum_IoU = sum_TP/(sum_TP + sum_FP + sum_FN);

sum_quality_mean_measures = [sum_ACC, sum_TPR, sum_TNR, sum_PPV, sum_Dice, sum_IoU];

%Wyœwietlanie wyników
means = [means_quality_measures;sum_quality_mean_measures];
quality_names={'Dok³adnoœæ','Czu³oœæ','Specyficznoœæ','Precyzja','Dice','Jaccard'};
table = array2table(means,'VariableNames', quality_names);
disp(table);





