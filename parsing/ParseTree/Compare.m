classdef Compare < ParseTreeNode
    
    properties
        type
        left
        right
    end
    
    methods
        
        function this = Compare(type,left,right)
            this.type = type;
            this.left = left;
            this.right = right;
            
            left.parent = this;
            right.parent = this;
        end
        
        function matlabCode(this,code)
            this.left.matlabCode(code);
            code.insert(sprintf(' %s ',symbol(this.type)));
            this.right.matlabCode(code);
        end
        
        function nodes = children(this)
            nodes = {'type','left','right'};
        end
        
    end
    
end

function s = symbol(operator)
    switch(operator)
        case 'LT', s = '<';
        case 'GT', s = '>';
        case 'EQ', s = '==';
        case 'NE', s = '~=';
        case 'GE', s = '>=';
        case 'LE', s = '<=';
        otherwise,   s = operator;
    end
end