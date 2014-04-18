function [ k ] = testFunction( a,b,c )
    % used by usageExample
    k = a + b;
    foo = b/c;
    if(a - c) > foo
        k = foo * 2;
    end   
end

