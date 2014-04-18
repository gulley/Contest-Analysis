classdef Try < ParseTreeNode
    
    properties
        tryBlock
        errorName
        catchBlock
    end
    
    methods
        
        function this = Try(tryBlock,errorName,catchBlock)
            this.tryBlock = tryBlock;
            this.errorName = errorName;
            this.catchBlock = catchBlock;
            
            tryBlock.parent = this;
            errorName.parent = this;
            catchBlock.parent = this;
        end
        
        function matlabCode(this,code)
            code.insert('try ');
            
            this.tryBlock.matlabCode(code)
            
            code.newline
            code.insert('catch ');
            this.errorName.matlabCode(code)
            
            this.catchBlock.matlabCode(code)
            
            code.newline
            code.insert('end');
        end
        
        function nodes = children(this)
            nodes = {'tryBlock','errorName','catchBlock'};
        end
        
    end
    
end

