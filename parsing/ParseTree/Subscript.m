classdef Subscript < ParseTreeNode
    
    properties
        variable
        inputs
    end
    
    methods
        
        function this = Subscript(variable,inputs)
            this.variable = variable;
            this.inputs = inputs;
            
            variable.parent = this;
            inputs.parent = this;
        end
        
        function matlabCode(this,code)
            this.variable.matlabCode(code);
            code.insert('(');
            this.inputs.matlabCode(code);
            code.insert(')');
        end
        
        function nodes = children(this)
            nodes = {'variable','inputs'};
        end
        
    end
    
end

