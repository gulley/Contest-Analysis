function timeplot(d)

cla
score = [d.score];
% Normalize the lowest score to be one. This heightens the effect of the
% log scaling
score = score - min(score) + 1;
id = [d.id];
t = [d.t];

if false
    % Show influence lines
    for i = 1:length(d)
        if d(i).parent > 0
            ix = find(id==d(i).parent);
            if ~isnan(score(ix))
                line([t(i) t(ix)],[score(i) score(ix)],'Color',0.8*[1 1 1])
            end
        end
    end
end

if true
    % Show leader frontier in red
    d = rankAtDebut(d);
    leaders = find([d.initial_rank]==1);
    hold on
    
    ix = sort([1:length(leaders) 1:length(leaders)]);
    ix1 = ix;
    ix1(1) = [];
    ix2 = ix;
    ix2(end) = [];
    
    plot(t(leaders(ix1)),score(leaders(ix2)),'Color','red')
    hold off
    
end

for i = 1:length(d)
    line(t(i),score(i),'LineStyle','none','Marker','.','MarkerSize',8)
end


set(gca,'YScale','log')
box on
datetick('x',6)
xlabel('Time of Entry')
ylabel('Log Normalized Score')