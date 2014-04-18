classdef CommaSeperatedList  < ParseTreeNode
    
    properties
        contents
    end
    
    methods
        function this = CommaSeperatedList(contents)
            this.contents = contents;
            for i = 1:length(this.contents)
                this.contents{i}.parent = this;
            end
       end
        
         function matlabCode(this,code)
            for i = 1:length(this.contents)
                if(i>1),code.insert(', ');end
                this.contents{i}.matlabCode(code);
            end
        end
        
        function nodes = children(this)
            nodes = {'contents'};
        end
        
        function calculateUseDef(this)
            this.literalsRead = cell(1,0);
            this.literalsWritten = cell(1,0);
            
            children = this.contents;
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

