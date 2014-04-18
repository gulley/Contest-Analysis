classdef BlockComment < ParseTreeNode
    
    properties
        string
    end
    
    methods
        function this = BlockComment(string)
            this.string = string;
        end
        
        function matlabCode(this,code)
            code.insert(this.string);
        end
        
    end
    
end

