%% ECE593 HW7 cross-fold data
function [tdata,vdata] = folddata(data,fold)
    
    label = randi(fold,size(data,1),1);% random sign fold

    tdata = cell(fold,1);
    vdata = cell(fold,1);
    
   for i = 1:fold
        tdata{i} = data(label ~= fold,: );
        vdata{i} = data(label == fold,: );
   end
end