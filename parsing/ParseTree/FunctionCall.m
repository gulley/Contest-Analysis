classdef FunctionCall < ParseTreeNode
    
    properties
        name
        inputs
    end
    
    methods
        
        function this = FunctionCall(name,inputs)
            this.name = name;
            this.inputs = inputs;
            
            name.parent = this;
            inputs.parent = this;
        end
        
        function matlabCode(this,code)
            this.name.matlabCode(code);
            if ~isempty(this.inputs.contents)
                code.insert('(')
                this.inputs.matlabCode(code);
                code.insert(')');
            end
        end
        
        function nodes = children(this)
            nodes = {'name','inputs'};
        end
        
        function calculateUseDef(this)
            this.inputs.calculateUseDef();            
            this.literalsRead    = [{this.name.string},this.inputs.literalsRead];
            this.literalsWritten = {};
        end
        
    end
    
end

