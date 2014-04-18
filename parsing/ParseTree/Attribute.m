classdef Attribute < ParseTreeNode
    
    properties
        name
        value
    end
    
    methods
        
        function this = Attribute(name,value)
            this.name = name;
            this.value = value;
            name.parent = this;
            value.parent = this;
        end
       
        function matlabCode(this,code)
            this.name.matlabCode(code);
            if(~isempty(this.value))
                code.insert(' ');
                this.value.matlabCode(code);
            end
        end
        
        function nodes = children(this)
            nodes = {'name','value'};
        end
        
    end
    
end
