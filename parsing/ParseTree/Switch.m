classdef Switch < ParseTreeNode
    
    properties
        var
        cases
    end
    
    methods
        
        function this = Switch(var,cases)
            this.var = var;
            this.cases = cases;
            
            var.parent = this;
            cases.parent = this;
        end
        
        function matlabCode(this,code)
            code.insert('switch ');
            this.var.matlabCode(code);
            
            this.cases.matlabCode(code);
            
            code.newline
            code.insert('end');
        end
        
        function nodes = children(this)
            nodes = {'var','cases'};
        end
        
    end
    
end

