classdef Hilite < ParseTreeNode
    % A ParseTreeNode that allows control over the width of generated code.
    % used by the expression display example.
    
    properties
        body
        padding
    end
    
    methods
        
        function this = Hilite(body,padding)
            this.body = body;
            this.padding = padding;
        end
        
        function matlabCode(this,code)
            prefix = '';
            suffix = '';
            if this.padding > 0
                L = floor(this.padding/2);
                R = ceil(this.padding/2);
                for i = 1:L
                    prefix = [prefix,' '];
                end
                for i = 1:R
                    suffix = [' ',suffix];
                end
            end
            code.insert(prefix);
            this.body.matlabCode(code)
            code.insert(suffix);
        end
        
        function nodes = children(this)
            nodes = {'body'};
        end
    end
    
end

