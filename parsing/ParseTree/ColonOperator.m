classdef ColonOperator < ParseTreeNode
    
    properties
        left
        right
    end
    
    methods
        
        function this = ColonOperator(left,right)
            this.left = left;
            this.right = right;
            
            left.parent = this;
            right.parent = this;
        end
        
        function matlabCode(this,code)
            if ~isempty(this.left)
                this.left.matlabCode(code);
            end
            code.insert(':');
            if ~isempty(this.right)
                this.right.matlabCode(code);
            end
        end
        
        function nodes = children(this)
            nodes = {'left','right'};
        end
        
    end
    
end

