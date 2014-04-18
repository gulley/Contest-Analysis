classdef Methods < ParseTreeNode
    
    properties
        attributes
        functions
    end
    
    methods
        
        function this = Methods(attributes,functions)
            this.attributes = attributes;
            this.functions = functions;
            
            attributes.parent = this;
            functions.parent = this;
        end
        
        function  matlabCode(this,code)
            code.insert('methods ')
            if(~isempty(this.attributes))
                code.insert('(')
                this.attributes.matlabCode(code);
                code.insert(')')
            end
            
            this.functions.matlabCode(code)
            
            code.newline;
            code.insert('end ')
        end
        
        function nodes = children(this)
            nodes = {'attributes','functions'};
        end
        
    end
    
end

