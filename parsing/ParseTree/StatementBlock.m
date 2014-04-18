classdef StatementBlock < ParseTreeNode
    % A list of statements
    
    properties
        statements
    end
    
    methods
        
        function this = StatementBlock(statements)
            this.statements = statements;
            
            for i = 1:length(this.statements)
                this.statements{i}.parent = this;
            end
        end
        
        function matlabCode(this,code)
            code.indent;
            for i = 1:length(this.statements)
                code.newline;
                this.statements{i}.matlabCode(code)
                if         ~isa(this.statements{i},'AutoPrint') ...
                        && ~isa(this.statements{i},'Case')...
                        && ~isa(this.statements{i},'ClassDef')...
                        && ~isa(this.statements{i},'Comment')...
                        && ~isa(this.statements{i},'ForLoop')...
                        && ~isa(this.statements{i},'FunctionDefinition')...
                        && ~isa(this.statements{i},'IfStatement')...
                        && ~isa(this.statements{i},'Methods')...
                        && ~isa(this.statements{i},'Properties')...
                        && ~isa(this.statements{i},'Switch')...
                        && ~isa(this.statements{i},'While')
                    code.insert(';');
                end
            end
            code.undent
        end
        
        function nodes = children(this)
            nodes = {'statements'};
        end
        
        function replace(this,old,new)
            index = this.findMatch(old);
            this.statements{index} = new;
        end
        
        function remove(this,old)
            index = this.findMatch(old);
            this.statements(index) = [];
        end
        
        function insertAfter(this,old,new)
            index = this.findMatch(old);
            this.insertAt(index,new);
        end
        
        function insertBefore(this,old,new)
            index = this.findMatch(old);
            this.insertAt(index+1,new);
        end
        
        function index = findMatch(this,old)
            for i = 1:length(this.statements)
                if old == this.statements{i}
                    index = i;
                    return;
                end
            end
            error('I don''t contain that node');
        end
        
        function insertAt(this,index,new)
            if(index == 1)
                front = {};
            else
                front = this.statements(1:(index-1));
            end
            
            if index > length(this.statements)
                back = {};
            else
                back = this.statements(index:end);
            end
            
            this.statements = {front{:},new,back{:}};
            new.parent = this;
        end

        function calculateUseDef(this)
            this.literalsRead = cell(1,0);
            this.literalsWritten = cell(1,0);
            
            children = this.statements;
            for i = 1:length(children)
                child = children{i};
                if isa(child,'ParseTreeNode')
                    child.calculateUseDef();
                    this.literalsRead = [this.literalsRead,child.literalsRead];
                    this.literalsWritten = [this.literalsWritten,child.literalsWritten];
                end
            end
            
            this.literalsRead = unique(this.literalsRead);
            this.literalsWritten = unique(this.literalsWritten);
        end
    end
    
end

