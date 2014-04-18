classdef IfBlock < ParseTreeNode
    % One condition/body block of an if statement
    
    properties
        condition
        body
    end
    
    methods
        
        function this = IfBlock(condition,body)
            this.condition = condition;
            this.body = body;
            
            condition.parent = this;
            body.parent = this;
        end
        
        function matlabCode(this,code)
            if ~isempty(this.condition)
                code.insert('if ');
                this.condition.matlabCode(code);
            end
            this.body.matlabCode(code)
        end
        
        function nodes = children(this)
            nodes = {'condition','body'};
        end
        
    end
    
end

