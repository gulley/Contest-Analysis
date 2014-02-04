function stepchart(d,option)

if nargin < 2
    option = 'timestamp';
end

% leaderIx = find([d.initial_rank] == 1);
leaderIx = 1:length(d);
linesOld = unique(d(leaderIx(1)).lines);

% Graphics initialization code
cla
lineStartPoint = 0;

for i = 1:length(leaderIx)
    
    linesNew = unique(d(leaderIx(i)).lines);
    
    conservedLines = intersect(linesOld,linesNew);
    novelLines = setdiff(linesNew,linesOld);
    removedLines = setdiff(linesOld,linesNew);
    
    
    % Plot the leader as a three segment line.
    t = d(leaderIx(i)).t;
    
    if strcmp(option,'timestamp')
        % Time-based x value
        line(t*[1 1],lineStartPoint+length(removedLines)+[0 length(conservedLines)+length(novelLines)],'Color',[0 0 1])
        
    else
        % Ordinal index x value
        line(i*[1 1],lineStartPoint+length(removedLines)+[0 length(conservedLines)+length(novelLines)],'Color',[0 0 1])
    end
    
    lineStartPoint = lineStartPoint + length(removedLines);
    
    linesOld = linesNew;
    
end

if strcmp(option,'timestamp')
    datetick
end

