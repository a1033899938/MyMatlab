%位置='image'/'graph'/'fit'/'fitI'(ntensity)/'fitW'(centerwavelen)/'fitL'(inwidth)/'diff1'
%类型='x'(label)/'y'(label)/'t'(ittle),'l'(egend)
%索引/向量
%修改日期:20240320
function [item] = smartItem(plotType,itemType)
%% 从工作区传递变量
sw = evalin('base', 'sw');                                                                                                                                                                                                                                  
idx.name = evalin('base', 'idx.name');
filename = evalin('base', 'filename');
filename_splited_mat = evalin('base', 'filename_splited_mat');
filename_legend_combined = evalin('base', 'filename_legend_combined');
iFiles = evalin('base', 'iFiles');
imageTotalTitle = evalin('base', 'imageTotalTitle');
%% 
PLorRf = 'PL Intensity(counts)';
if sw.reflectanceContrast
    PLorRf = 'Reflectance Contrast(\DeltaR/R)';
elseif sw.normalizeByMax
    PLorRf = 'Normalized Intensity(a.u.)';
elseif sw.normalizeByTime
    PLorRf = 'Time Normalized Intensity(a.u.)';
elseif sw.firstOrderDifferential
    PLorRf = 'First order differential(a.u.)';
else
end

switch plotType
    case 'image'
        %初始值
        Xlabel = 'Wavelength(nm)';
        Ylabel = 'Strip';
        Zlabel = PLorRf;%colorbar
        if sw.ylabelToAngle
            Ylabel = 'Angle(degree)';
        end
        if sw.xlabelToEnergy
            Xlabel = 'Energy(eV)';
        end
        if sw.showImageVertically
            Labelswitch = Xlabel;
            Xlabel = Ylabel;
            Ylabel = Labelswitch;
        end
        if ~sw.showImageInSubplot
            if sw.showEntileLegend
                Title = filename;
            elseif sw.combineFilename
                Title = filename_legend_combined{1,iFiles};
            else
                Title = imageTotalTitle;
            end
        else
            Title = imageTotalTitle;%每个subplot的标题 
        end
    case 'graph'
        %初始值
        Xlabel = 'Wavelength(nm)';
        Ylabel = PLorRf;
        Title = filename_splited_mat(idx.name);
        if sw.xlabelToEnergy
            Xlabel = 'Energy(eV)';
        end
        if sw.showGraphInOnePlot
            Legend = [filename_splited_mat(idx.name,:)];%所有graph的标签
            if sw.showEntileLegend
                Legend = filename;
            elseif sw.combineFilename
                Legend = filename_legend_combined;
            end
        end
        if sw.showGraphInCascadePlot
            Ylabel = 'a.u.';
            Legend = [filename_splited_mat(idx.name,:)];%所有graph的标签
            if sw.showEntileLegend
                Legend = filename;
            elseif sw.combineFilename
                Legend = filename_legend_combined;
            end
        end
        if sw.showGraphInOneImage
            Zlabel = PLorRf;
            if sw.sortByElectric == 1
                Ylabel = 'Votage(V)';
                Title = 'Doping Dependent PL Spectra';
            elseif sw.sortByElectric == 2
                Ylabel = 'Votage(V)';
                Title = 'Electrical Field Dependent PL Spectra';
            elseif sw.sortByPower
                Ylabel = 'Excitation Power(uW)';
            else
                Ylabel = 'graph number';
            end
        end
    case fit
        Legend = [filename_splited_mat(idx.name,:),'fitting curve'];%所有graph的标签
        if sw.combineFilename
            Legend = filename_legend_combined;
        end
    case fitI
        if sw.sortByElectric == 1
            Title = ['Doping dependent ' PLorRf];
            Xlabel = 'Votage(V)';
            Ylabel = PLorRf;
        elseif sw.sortByElectric == 2
            Title = ['Electrical filed dependent ' PLorRf];
            Xlabel = 'Votage(V)';
            Ylabel = PLorRf;
        else
        end
    case fitW
        if sw.sortByElectric == 1
            Title = 'Doping Dependent Center Wavelength(nm)';
            Xlabel = 'Votage(V)';
            Ylabel = 'Center Wavelength(nm)';
        elseif sw.sortByElectric == 2
            Title = 'Electrical Filed Dependent Center Wavelength(nm)';
            Xlabel = 'Votage(V)';
            Ylabel = 'Center Wavelength(nm)';
        else
        end
    case fitL
        if sw.sortByElectric == 1
            Title = 'Doping Dependent Linewidth(nm)';
            Xlabel = 'Votage(V)';
            Ylabel = 'Linewidth(nm)';
        elseif sw.sortByElectric == 2
            Title = 'Electrical Filed Dependent Linewidth(nm)';
            Xlabel = 'Votage(V)';
            Ylabel = 'Linewidth(nm)';
        else
        end
    otherwise      
end
    switch itemType
        case 'x'
            item = Xlabel;
        case 'y'
            item = Ylabel;
        case 't'
            item = Title;
        case 'l'
            item = Legend;
        otherwise
    end
return
end