classdef FunctionDefinition < ParseTreeNode
    
    properties
        name
        inputs
        outputs
        body
    end
    
    methods
        
        function this = FunctionDefinition(name,outputs,inputs,body)
            this.name    = name;
            this.inputs  = inputs;
            this.outputs = outputs;
            this.body    = body;
            
            name.parent = this;
            inputs.parent = this;
            outputs.parent = this;
            body.parent = this;
        end
        
        function matlabCode(this,code)
            code.insert('function ');
            
            % outputs
            if length(this.outputs.contents) == 1
                this.outputs.matlabCode(code)
                code.insert(' = ');
            elseif length(this.outputs.contents) > 1
                code.insert('[')
                this.outputs.matlabCode(code);
                code.insert('] = ');
            end
            
            this.name.matlabCode(code);
            
            % inputs
            if ~isempty(this.inputs)
                code.insert('(')
                this.inputs.matlabCode(code);
                code.insert(')');
            end
            
            % body
            if(~isempty(this.body))
                this.body.matlabCode(code);
                code.newline;
                code.insert('end')
                code.newline;
            end
        end
        
        function nodes = children(this)
            nodes = {'name','inputs','outputs','body'};
        end
        
        function calculateUseDef(this) 
            this.inputs.calculateUseDef();
            this.outputs.calculateUseDef();
            this.body.calculateUseDef();
            
            this.literalsRead    = {};
            this.literalsWritten = {this.name.string};
        end
        
    end
    
end
