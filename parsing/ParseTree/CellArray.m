classdef CellArray < ParseTreeNode
    
    properties
        var
        contents
    end
    
    methods
        function this = CellArray(var,contents)
            this.var = var;
            this.contents = contents;
            var.parent = this;
            contents.parent = this;
        end
        
        function matlabCode(this,code)
            this.var.matlabCode(code);
            code.insert('{');
            this.contents.matlabCode(code);
            code.insert('}');
        end
        
       function nodes = children(this)
            nodes = {'var','contents'};
        end

    end
    
end

