classdef setLayer < handle
    %define：定义一个名为setLayer类
    %多层介质结构的堆叠方向为z方向
    %nargin：输入的参数的数量(n arg in)
    %varargin：输入的自由参数(var arg in)
    %% 定义属性
    properties
        material='';%层名称
        index = 1.0;%折射率，默认为真空折射率
        thickness = 100%层厚度（nm）
        z_min = 0;%层的z方向最小值（nm）
        z_max = 100;%层的z方向最大值
        resolution = 20;%层中的兴趣点数量（以z位置标记）（后续可计算这些点的场强）
        probePoints%此层的兴趣点向量（包括首尾点）
    end
    
    methods
        function obj=setLayer(varargin)
            % Set values
            iArgs = 1;
            while iArgs <= nargin
                if ischar(varargin{iArgs})%如果当前参数名是字符则进行switch
                    switch lower(varargin{iArgs})
                        case 'material'
                            %由于类的输入为成对出现，每对的第一个为参数名,第二个才是对应的值
                            obj.material = varargin{iArgs+1};
                            iArgs=iArgs+2;
                        case 'index'
                            obj.index=varargin{iArgs+1};
                            iArgs=iArgs+2;
                        case 'thickness'
                            obj.thickness=varargin{iArgs+1};
                            iArgs=iArgs+2;
                        case {'z_min','x_min','z min','x min'}
                            % tolerate x_min and other possible mistakes
                            obj.z_min=varargin{iArgs+1};
                            iArgs=iArgs+2;
                        case 'resolution'
                            obj.resolution=varargin{iArgs+1};
                            iArgs=iArgs+2;
                        otherwise
                            disp('Error: incorrect input.');
                            %'You can set "material, index, thickness, z_min, resolution...');
                        return;
                    end
                end
            end
            %计算层的z方向最大值
            obj.z_max = obj.z_min+obj.thickness;
            %创建兴趣点向量
            obj.probePoints = zeros(1,obj.resolution);
            obj.probePoints = obj.z_min: (obj.z_max-obj.z_min)/(obj.resolution-1) :obj.z_max;
        end   
    end
    
end

