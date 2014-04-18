classdef Catenation < ParseTreeNode
    
    properties
        type
        contents
    end
    
    methods
        function this = Catenation(type,contents)
            this.type = type;
            this.contents = contents;
            
            contents.parent = this;
        end
        
        function matlabCode(this,code)
            switch this.type
                case 'LB'
                    code.insert('[');
                    this.contents.matlabCode(code);
                    code.insert(']');
                case 'LC'
                    code.insert('{');
                    this.contents.matlabCode(code);
                    code.insert('}');
                case 'LP'
                    code.insert('(');
                    this.contents.matlabCode(code);
                    code.insert(')');
            end
        end
        
        function nodes = children(this)
            nodes = {'contents'};
        end
        
    end
    
end

