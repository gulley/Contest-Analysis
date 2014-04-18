classdef IfStatement < ParseTreeNode
    
    properties
        blocks
    end
    
    methods
        function this = IfStatement(blocks)
            this.blocks = blocks;
            blocks.parent = blocks;
        end
        
        function matlabCode(this,code)
            for i = 1:length(this.blocks.statements)
                if(i>1)
                    code.newline;
                    code.insert('else');
                end
                this.blocks.statements{i}.matlabCode(code)
            end
            code.newline;
            code.insert('end');
        end
        
        function nodes = children(this)
            nodes = {'blocks'};
        end
        
    end
    
end

