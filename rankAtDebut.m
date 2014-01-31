function dOut = rankAtDebut(dIn)
%rankAtDebut  Calculate the initial rank for all entries
%   dOut = rankAtDebut(dIn) adds the field "rankAtDebut" to the contest
%   data structure.

bestScore = inf;
scoreList = inf;
d = dIn;
for i = 1:length(d)
    d(i).initial_rank = i;
    if d(i).passed && ~isinf(d(i).score)
        d(i).initial_rank = find(d(i).score < scoreList,1);
        scoreList = sort([scoreList d(i).score]);
    end
end
dOut = d;