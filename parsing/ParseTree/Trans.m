classdef Trans < ParseTreeNode
    
    properties
        contents
    end
    
    methods
        
        function this = Trans(contents)
            this.contents = contents;

            contents.parent = this;
        end
        
        function matlabCode(this,code)
            this.contents.matlabCode(code);
            code.insert('''');
        end
        
        function nodes = children(this)
            nodes = {'contents'};
        end
        
    end
end

