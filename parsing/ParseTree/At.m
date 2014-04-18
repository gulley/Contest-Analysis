classdef At < ParseTreeNode
    
    properties
        name
    end
    
    methods
        
        function this = At(name)
            this.name = name;
            name.parent = this;
        end
        
        function matlabCode(this,code)
            code.insert('@');
            this.name.matlabCode(code);
        end
        
        function nodes = children(this)
            nodes = {'name'};
        end
        
    end
    
end