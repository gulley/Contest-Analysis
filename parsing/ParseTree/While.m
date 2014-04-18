classdef While < ParseTreeNode
    
    properties
        condition
        loopBody
    end
    
    methods
        
        function this = While(condition,loopBody)
            this.condition = condition;
            this.loopBody = loopBody;
            
            condition.parent = this;
            loopBody.parent = this;
        end
        
        function matlabCode(this,code)
            code.insert('while ');
            this.condition.matlabCode(code);
            this.loopBody.matlabCode(code)
            code.newline
            code.insert('end');
        end
        
        function nodes = children(this)
            nodes = {'condition','loopBody'};
        end
        
    end
    
end

