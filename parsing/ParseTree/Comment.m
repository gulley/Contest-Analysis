classdef Comment < ParseTreeNode
    
    properties
        string
    end
    
    methods
        function this = Comment(string)
            this.string = string;
        end
        
        function matlabCode(this,code)
            code.insert(this.string);
        end
        
        function show(this)
            fprintf('%s\n',this.string);
        end
        
    end
    
end

