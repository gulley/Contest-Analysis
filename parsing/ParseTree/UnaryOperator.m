classdef UnaryOperator < ParseTreeNode
    
    properties
        operator
        left
    end
    
    methods
        
        function this = UnaryOperator(operator,left)
            this.operator = operator;
            this.left = left;
            
            left.parent = this;
        end
        
        function matlabCode(this,code)
            code.insert(sprintf('%s',symbol(this.operator)));
            this.left.matlabCode(code);
        end
        
        function nodes = children(this)
            nodes = {'operator','left'};
        end
        
    end
end

function s = symbol(operator)
    switch(operator)
        case 'UMINUS', s = '-';
        case 'NOT', s = '~';
        otherwise,   s = operator;
    end
end
