classdef Dot < ParseTreeNode
    
    properties
        left
        right
    end
    
    methods
        
        function this = Dot(left,right)
            this.left = left;
            this.right = right;
            
            left.parent = this;
            right.parent = this;
        end
        
        function matlabCode(this,code)
            this.left.matlabCode(code);
            this.right.matlabCode(code);
        end
        
        function nodes = children(this)
            nodes = {'left','right'};
        end
        
    end
    
end

