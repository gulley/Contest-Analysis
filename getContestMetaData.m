function contestStruct = getContestMetaData

contestIdList = getAllContestIds;

query = 'SELECT ALL id,title FROM contests';
db = connectToContestDatabase;
names = queryDatabase(db, query);
close(db)

s = [];
for i = 1:length(contestIdList)
    contestId = contestIdList(i);
    s(i).id = contestId;
    name = names{contestId,2};
    s(i).name = name;
    
    switch name
        case 'Binpack'
            s(i).hasDarkness = false; 
            s(i).start       = '14-Dec-1998 12:00:00';
            s(i).end         = '18-Dec-1998 17:00:00';
            s(i).darknessEnd = '';
            s(i).twilightEnd = '';
        case 'Mars Surveyor'
            s(i).hasDarkness = false; 
        case 'Mastermind'
            s(i).hasDarkness = false; 
        case 'Molecule'
            s(i).hasDarkness = false; 
        case 'Protein Folding'
            s(i).hasDarkness = false; 
        case 'Trucking Freight'
            s(i).hasDarkness = false; 
        case 'Gerrymandering'
            s(i).hasDarkness = true; 
            s(i).start       = '21-Apr-2004 09:00:00';
            s(i).end         = '28-Apr-2004 17:00:00';
            s(i).darknessEnd = '22-Apr-2004 12:00:00';
            s(i).twilightEnd = '23-Apr-2004 12:00:00';
        case 'Moving Furniture'
            s(i).hasDarkness = true; 
            s(i).darknessEnd = '';
            s(i).twilightEnd = '';
        case 'Ants'
            s(i).hasDarkness = true; 
            s(i).darknessEnd = '';
            s(i).twilightEnd = '';
        case 'Sudoku'
            s(i).hasDarkness = true; 
            s(i).darknessEnd = '';
            s(i).twilightEnd = '';
        case 'Blockbuster'
            s(i).hasDarkness = true; 
            s(i).darknessEnd = '';
            s(i).twilightEnd = '';
        case 'Blackbox'
            s(i).hasDarkness = true; 
            s(i).darknessEnd = '';
            s(i).twilightEnd = '';
        case 'Peg Solitaire'
            s(i).hasDarkness = true; 
            s(i).darknessEnd = '';
            s(i).twilightEnd = '';
        case 'Gene Splicing'
            s(i).hasDarkness = true; 
            s(i).darknessEnd = '';
            s(i).twilightEnd = '';
        case 'Wiring'
            s(i).hasDarkness = true; 
            s(i).darknessEnd = '';
            s(i).twilightEnd = '';
        case 'Army Ants'
            s(i).hasDarkness = true; 
            s(i).darknessEnd = '';
            s(i).twilightEnd = '';
        case 'Color Bridge'
            s(i).hasDarkness = true; 
            s(i).darknessEnd = '';
            s(i).twilightEnd = '';
        case 'Sensor'
            s(i).hasDarkness = true; 
            s(i).darknessEnd = '';
            s(i).twilightEnd = '';
        case 'Sailing Home'
            s(i).hasDarkness = true; 
            s(i).darknessEnd = '';
            s(i).twilightEnd = '';
        case 'Crossword'
            s(i).hasDarkness = true; 
            s(i).darknessEnd = '';
            s(i).twilightEnd = '';
    end
    
end

contestStruct = s;