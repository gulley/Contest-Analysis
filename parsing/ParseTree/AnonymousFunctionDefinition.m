classdef AnonymousFunctionDefinition < ParseTreeNode
    
    properties
        inputs
        expression
    end
    
    methods
        function this = AnonymousFunctionDefinition(inputs,expression)
            this.inputs = inputs;
            this.expression = expression;
            
            inputs.parent = this;
            expression.parent = this;
        end
        
        function matlabCode(this,code)
            code.insert('@');
            
            % inputs
            if ~isempty(this.inputs)
                code.insert('(')
                this.inputs.matlabCode(code);
                code.insert(')');
            end
            
            % expression
            code.insert('(')
            this.expression.matlabCode(code);
            code.insert(')');
        end
        
        function nodes = children(this)
            nodes = {'inputs','expression'};
        end
        
    end
    
end
