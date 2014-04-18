classdef Code < handle
    % A utility to make a code generator's job easier.
    
    properties(Access = private)
        lines
        indentString;
    end
    
    methods
        
        function this = Code
            this.lines = {''};
            this.indentString = '';
        end
        
        function insert(this,string)
            this.lines{end} = [this.lines{end},string];
        end
        
        function newline(this)
            this.lines{end+1} = this.indentString;
        end
        
        function indent(this)
            this.indentString((end+1):end+4) = ' ';
        end
        
        function undent(this)
            this.indentString((end-3):end) = [];
        end
        
        function chars = getChars(this)
            chars = char(this.lines);
        end
        
        function lines = getLines(this)
            lines = this.lines;
        end
        
    end
    
end

