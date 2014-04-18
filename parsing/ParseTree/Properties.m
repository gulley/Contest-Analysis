classdef Properties < ParseTreeNode
    
    properties
        attributes
        contents
    end
    
    methods
        
        function this = Properties(attributes,contents)
            this.attributes = attributes;
            this.contents = contents;
            
            attributes.parent = this;
            contents.parent = this;
        end
        
        function  matlabCode(this,code)
            code.insert('properties ')
            if(~isempty(this.attributes))
                code.insert('(')
                this.attributes.matlabCode(code);
                code.insert(')')
            end
            
            this.contents.matlabCode(code)
            
            code.newline;
            code.insert('end')
        end
        
        function nodes = children(this)
            nodes = {'attributes','contents'};
        end
        
    end
    
end

