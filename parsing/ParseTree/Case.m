classdef Case < ParseTreeNode
    
    properties
        match
        body
    end
    
    methods
        
        function this = Case(match,body)
            this.match = match;
            this.body = body;
            match.parent = this;
            body.parent = this;
        end
        
        function matlabCode(this,code)
            
            if(isempty(this.match))
                code.insert('otherwise');
            else
                code.insert('case ');
                this.match.matlabCode(code);
            end
            this.body.matlabCode(code)
        end
        
        function nodes = children(this)
            nodes = {'match','body'};
        end
        
    end
    
end

