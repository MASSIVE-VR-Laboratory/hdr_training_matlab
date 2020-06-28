function plotMAPResults(data)
%% function to plot mAP bar charts

    classes = {'aeroplane', 'bicycle', 'bird', 'boat', 'bottle', ...
               'bus', 'car', 'cat', 'chair', 'cow', 'diningtable', 'dog',...
               'horse', 'motorbike', 'person', 'pottedplant', 'sheep', ...
               'sofa', 'train', 'tvmonitor'};

    hb = bar(data*100);
    set(hb(1), 'FaceColor','r');    
    set(hb(2), 'FaceColor','b');   
%     set(hb(3), 'FaceColor','b');
    
    xt = 1:numel(classes);
    set(gca, 'XTick', xt, 'XTickLabel', classes, 'FontSize', 14);
    xtickangle(45);
    xlabel('Object Categories PASCAL VOC (2007 + 2012)', 'FontSize', 20, 'FontWeight', 'Bold');
    ylabel('Detection Average Precision (AP)', 'FontSize', 20, 'FontWeight', 'Bold');    
    
end

