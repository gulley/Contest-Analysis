classdef Global < ParseTreeNode
    
    properties
        contents
    end
    
    methods
        function this = Global(contents)
            this.contents = contents;
            contents.parent = this;
        end
        
        function matlabCode(this,code)
            code.insert('global ');
            this.contents.matlabCode(code);
        end
        
        function nodes = children(this)
            nodes = {'contents'};
        end
        
    end
    
end

