classdef AssignmentStatement < ParseTreeNode
    
    properties
        assignedTo
        assignedFrom
    end
    
    methods
        function this = AssignmentStatement(left,right)
            this.assignedTo = left;
            this.assignedFrom = right;
            
            left.parent = this;
            right.parent = this;
        end
        
        function matlabCode(this,code)
            this.assignedTo.matlabCode(code);
            if(~isempty(this.assignedFrom))
                code.insert(' = ');
                this.assignedFrom.matlabCode(code);
            end
        end
        
        function nodes = children(this)
            nodes = {'assignedTo','assignedFrom'};
        end
        
        function calculateUseDef(this)
            this.assignedTo.calculateUseDef();
            this.assignedFrom.calculateUseDef();
                                  
            this.literalsRead    = this.assignedFrom.literalsRead;
            this.literalsWritten = this.assignedTo.literalsWritten; 
        end
        
    end
    
end

