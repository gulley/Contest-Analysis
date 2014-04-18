classdef Return < ParseTreeNode
    
    methods
        
      function matlabCode(this,code)
            code.insert('return')
        end
        
    end
    
end

