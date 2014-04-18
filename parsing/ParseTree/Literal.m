classdef Literal < ParseTreeNode
    
    properties
        type
        string
    end
    
    methods
        function this = Literal(type,string)
            this.type = type;
            this.string = string;
        end
        
        function matlabCode(this,code)
            code.insert(this.string);
        end
        
        function show(this)
            fprintf('%s (%s)\n',this.string,this.type);
        end
        
        function calculateUseDef(this)
            if strcmp(this.type,'ID')
                this.literalsRead    = {this.string};
                this.literalsWritten = {this.string};
            else
                this.literalsRead    = {};
                this.literalsWritten = {};
             end
        end
        
    end
    
end

