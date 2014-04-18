classdef Junk  < ParseTreeNode
    
    properties
        text
        type
    end
    
    methods
        function this = Junk(type, text)
            this.type = type;
            this.text = text;
        end
        
        function matlabCode(this,code)
            code.insert('Parse tree build failure ----------------------');
            code.newline
            code.insert(this.text');
            code.newline
            code.insert('-----------------------------------------------');
            code.newline
        end
    end
    
end

