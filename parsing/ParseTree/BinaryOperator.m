classdef BinaryOperator < ParseTreeNode
    
    properties
        operator
        left
        right
    end
    
    methods
        
        function this = BinaryOperator(operator,left,right)
            this.operator = operator;
            this.left = left;
            this.right = right;
            
            left.parent = this;
            right.parent = this;
        end
        
        function matlabCode(this,code)
            
            if(isa(this.left,'BinaryOperator') && higherPrecedence (this.operator,this.left.operator))
                code.insert('(');
                this.left.matlabCode(code);
                code.insert(')');
            else
                this.left.matlabCode(code);
            end
            
            code.insert(sprintf(' %s ',symbol(this.operator)));
            
            if(isa(this.right,'BinaryOperator') && higherPrecedence (this.operator,this.right.operator))
                code.insert('(');
                this.right.matlabCode(code);
                code.insert(')');
            else
                this.right.matlabCode(code);
            end
        end
        
        function nodes = children(this)
            nodes = {'operator','left','right'};
        end
        
    end
    
end

function s = symbol(operator)
    switch(operator)
        case 'PLUS', s = '+';
        case 'MUL', s = '*';
        case 'DOTMUL', s = '.*';
        case 'DIV', s = '/';
        case 'MINUS', s = '-';
        case 'EXP', s = '^';
        case 'DOTEXP', s = '.^';
        case 'OROR', s = '||';
        case 'ANDAND', s = '&&';
        otherwise,   s = operator;
    end
end

function p = precedence(op)
    switch(op)
        case {'OROR','ANDAND'}
            p = 0;
        case {'PLUS','MINUS'}
            p = 1;
        case {'MUL','DOTMUL','DIV'}
            p = 2;
        case {'EXP','DOTEXP'}
            p = 3;
        otherwise
            p = 4;
            fprintf('BinaryOperator says WTF on %s\n',op)
    end
end

function h = higherPrecedence(op1,op2)
    p1 = precedence(op1);
    p2 = precedence(op2);
    h = p1 > p2;
end