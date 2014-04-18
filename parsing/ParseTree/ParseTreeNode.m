classdef ParseTreeNode < handle & matlab.mixin.Heterogeneous
    % Every node in a parse tree is a subclass of this.
    % This infrastructure is very lightly designed; only enough to keep it
    % from tipping over.
    
    properties
        parent
    end
    
    methods
        
        % Code Generation
        function code = generateMatlabCode(this)
            code = Code;
            this.matlabCode(code);
        end
        
        function ch = char(this)
            code = this.generateMatlabCode;
            ch = code.getChars;
        end
        
        % Searching
        function results = find(this,className)
            
            if ismatch(this,className)
                results = {this};
            else
                results = {};
            end
            
            children = this.children;
            for i = 1:length(children)
                child = this.(children{i});
                if isa(child,'ParseTreeNode')
                    results = [results,child.find(className)];
                elseif iscell(child)
                    for j = 1:length(child)
                        results = [results,child{j}.find(className)];
                    end
                end
            end
        end
        
        function match = ismatch(node,matcher)
            if ischar(matcher)
                match = isa(node,matcher);
            elseif isa(matcher,'function_handle')
                match = matcher(node);
            else
                error('A Matcher must either be a string or a function handle');
            end
        end
        
        %TODO: Should this be an abstract method?
        function nodes = children(this)
            nodes = [];
        end
        
        %  Display in a way that lets the user understand the parse
        % This guy should use a code object to make things easier.
        function show(this)
            persistent indent
            if isempty(indent)
                indent = '';
            end
            
            children = this.children;
            indent = [indent, '    '];
            
            fprintf('%s\n',class(this));
            for i = 1:length(children)
                contents = this.(children{i});
                
                if isa(contents,'ParseTreeNode')
                    fprintf('%s%s: ',indent,children{i});
                    contents.show
                elseif iscell(contents)
                    for j = i:length(contents)
                        fprintf('%s%s{%2d}: ',indent,children{i},j);
                        contents{j}.show
                    end
                else
                    fprintf('%s%s: ',indent,children{i});
                    disp(contents)
                end
                
            end
            indent(1:4) = [];
        end
        
        function replaceWith(this,oldChild,newChild)
            if(nargin == 2)
                % if you call replace with one child,
                % we assume you meant replace "this" with the new child
                this.parent.replaceWith(this,oldChild);
            else
                children = this.children;
                for i = 1:length(children)
                    if oldChild == this.(children{i})
                        this.(children{i}) = newChild;
                        newChild.parent = this;
                        return
                    end
                end
                if isa(this,'StatementBlock')
                    statements = this.statements;
                    for i = 1:length(statements)
                        if oldChild == statements{i}
                            this.statements{i} = newChild;
                             newChild.parent = this;
                            return
                        end
                    end
                end
            end
        end
        
        function calculateUseDef(this)
            % By default, a node reads and writes the nodes read and writen
            % by its children. If that's not right, classes must override
            % this method.
            this.literalsRead = cell(1,0);
            this.literalsWritten = cell(1,0);
            
            children = this.children;
            for i = 1:length(children)
                child = this.(children{i});
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
    
    methods(Abstract)
        % Generate MATLAB code for this node
        matlabCode(this,code)
    end
    
end

