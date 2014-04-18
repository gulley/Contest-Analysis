classdef Persistent < ParseTreeNode
    
    properties
        contents
    end
    
    methods
        function this = Persistent(contents)
            this.contents = contents;
            contents.parent = this;
        end
        
        function matlabCode(this,code)
            code.insert('persistent ');
            this.contents.matlabCode(code);
        end
        
        function nodes = children(this)
            nodes = {'contents'};
        end
        
    end
    
end

