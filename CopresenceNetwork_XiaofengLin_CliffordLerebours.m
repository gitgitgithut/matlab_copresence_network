clc;clear all;
filename = 'newlists.csv';
Data = csvread(filename);
individuals = 300;
threshold = 1;
adjM1 = naive(Data,individuals,threshold);
adjM2 = optimal(Data,individuals,threshold);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function adjMat = coocurrenceOP(Data,individuals,treshold)
adjMat=zeros(individuals);    
pCounter=1;
colCounter=1;
rowData=length(Data(:,1));
colData= length(Data(1,:));
firstID=0;
tempVector=zeros(1,individuals);
tempCounter=1;
dcolCounter=1;

for pCounter=1:rowData
    tempVector=zeros(1,individuals); %%reset tempvector for next plane
    firstID=Data(pCounter,1); 
    tempVector(1,firstID)=1;
    colCounter=colCounter+1;
    while (colCounter <= colData && Data(pCounter,colCounter)~= 0 )
        tempVector(1,Data(pCounter,colCounter))=1;
        colCounter=colCounter+1;
    end 
   colCounter=1;
    %add my temp vector to the coresponding adjency matrix
    while ( dcolCounter<=colData && Data(pCounter,dcolCounter)~= 0)
        for tempCounter=1:1:individuals
            adjMat(Data(pCounter,dcolCounter),tempCounter)
            =tempVector(1,tempCounter) +
            adjMat(Data(pCounter,dcolCounter),tempCounter);
        end 
        dcolCounter=dcolCounter+1;
     end 
     dcolCounter=1;
     end 
%% with the copresence matrix completed create a treshold list of all people
who fly above a treshold with the third component being the treshold 
treshMat=[];
tempPairTresh=zeros(1,3);
%search through the adj matrix but note it is uper triangular and we do not
%need to work about (i,i) since it is the same person. 
for row=1:individuals
    for column=row:individuals
        if adjMat(row,column)>= treshold
            tempPairTresh(1,1)=row;
            tempPairTresh(1,2)=column;
            tempPairTresh(1,3)=adjMat(row,column);
            treshMat=[treshMat;tempPairTresh];
        end 
    end 
end 
%%plot the treshmat
scatter3(treshMat(:,1),treshMat(:,2),treshMat(:,3),'filled')
xlabel('Person 1')
ylabel('Person 2')
zlabel('treshold')   
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function adjM = naive(Data,individuals,threshold)
    given = 0;
    condition = 0;
    adjM = zeros(individuals);
    l = length(Data);
    for row = 1 : 100
        i = 1;
        while (i < l && Data(row,i) ~= 0)
            j = i + 1;
            given = Data(row,i);
            while (j <= l && Data(row,j) ~= 0)
                condition = Data(row,j);
                adjM(given,condition) = adjM(given,condition) + 1;
                j = j + 1;
            end
            i = i + 1;
        end
    end
    suspect = [];
    for i = 1 : individuals
       for j = 1 : individuals
          if  adjM(i,j) >= threshold
              suspect = [suspect;{i,j}];
          end
       end
    end
    suspect = cell2mat(suspect);
    scatter3(suspect(:,1),suspect(:,2),threshold*ones(length(suspect(:,1)),1));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%