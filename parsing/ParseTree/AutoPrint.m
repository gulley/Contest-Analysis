classdef AutoPrint< ParseTreeNode
    % A statement that leaves the semicolon off the end will be wrapped in
    % one of these.
    
    properties
        statement
    end
    
    methods
        
        function this = AutoPrint(statement)
            this.statement = statement;
            statement.parent = this;
        end
        
        function matlabCode(this,code)
            this.statement.matlabCode(code);
        end
        
        function nodes = children(this)
            nodes = {'statement'};
        end
        
    end
end


