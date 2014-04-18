classdef ClassDef < ParseTreeNode
    
    properties
        className
        superclasses
        contents
    end
    
    methods
        
        function this = ClassDef(classInfo,contents)
            if isa(classInfo,'Literal')
                this.className = classInfo;
                this.superclasses = [];
                classInfo.parent = this;
            else % its a compare...
                this.className = classInfo.left;
                this.superclasses = classInfo.right;
                this.className.parent = this;
                this.superclasses.parent = this;
            end
            this.contents = contents;
            contents.parent = this;
            
        end
        
        function matlabCode(this,code)
            code.insert('classdef ');
            this.className.matlabCode(code);
            code.insert(' < ')
            this.superclasses.matlabCode(code);
            code.newline;
            
            this.contents.matlabCode(code)
            
            code.newline;
            code.insert('end');
        end
        
        function nodes = children(this)
            nodes = {'className','superclasses','contents'};
        end
        
    end
end

