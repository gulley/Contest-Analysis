classdef DotLP < ParseTreeNode
    
    properties
        name
        inputs
    end
    
    methods
        
        function this = DotLP(name,inputs)
            this.name = name;
            this.inputs = inputs;
            
            name.parent = this;
            inputs.parent = this;
        end
        
        function matlabCode(this,code)
            this.name.matlabCode(code);
            if ~isempty(this.inputs.contents)
                code.insert('.(')
                this.inputs.matlabCode(code);
                code.insert(')');
            end
        end
        
        function nodes = children(this)
            nodes = {'name','inputs'};
        end
        
    end
    
end

