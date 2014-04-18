classdef ForLoop < ParseTreeNode
    
    properties
        loopVariable
        loopRange
        loopBody
    end
    
    methods
        
        function this = ForLoop(loopVariable,loopRange,loopBody)
            this.loopVariable = loopVariable;
            this.loopRange = loopRange;
            this.loopBody = loopBody;
            
            loopVariable.parent = this;
            loopRange.parent = this;
            loopBody.parent = this;
        end
        
       function matlabCode(this,code)
            code.insert('for ');
            this.loopVariable.matlabCode(code);
            code.insert(' = ');
            this.loopRange.matlabCode(code);
            this.loopBody.matlabCode(code)
            code.newline
            code.insert('end');
        end
        
        function nodes = children(this)
            nodes = {'loopVariable','loopRange','loopBody'};
        end
        
    end
    
end

