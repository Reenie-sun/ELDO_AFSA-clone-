%%
%���ڴ�ͳ�˹���Ⱥ�㷨����դ�񻷾��е��Ż�.
%�������Ż���Ϊ�˽����ͳ�㷨��ÿ��ִ�ж�ѡȡ���Ž����Ϊ���Ӷ���Ϊդ���ϰ���ʹ�þֲ����Ž⣬����ȫ�����Ž⣬����·���滮������
%��Ҫ����ʽΪ��ȥ����ͳ�㷨ÿһ����ѡȡ���Ž����Ϊ����������Ⱥ�ҵ�Ŀ���ʱ���ͼ�¼���ҵ�Ŀ������Ⱥ�켣���γ�·���滮�Ŀ��н�
%�ڿ��н��У�ѡȡ���ţ���·����̵Ľ⣬��Ϊ���Ź滮·��.
%��֤���㷨99.99%���������£��������·���滮�ĺ����
%%
close all;
clear all;
clc;
%%
%���������˵��ϰ�����������עstart,goalλ��
% a = rand(20)>0.35;%�ڰ׸���ռ����
tic;

a = load('object.txt');
% a = load('environment.txt');%blacb--barrier occputy 35%.
% a = rand(20)>0.3;
% a = load('environment6060.mat', 'k');
% a = a.k;
n = size(a,1);
b = a;
b(end+1,end+1) = 0;
figure;
colormap([0 0 0;1 1 1])
pcolor(b); % ����դ����ɫ
set(gca,'XTick',10:10:n,'YTick',10:10:n);  % ��������
axis image xy

% displayNum(n);%��ʾդ���е���ֵ

text(1,n+1.5,'START','Color','red','FontSize',10);%��ʾstart�ַ�
text(n+1,1.5,'GOAL','Color','red','FontSize',10);%��ʾgoal�ַ�

hold on
%pin strat goal positon
% scatter(1+0.5,n+0.5,'MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0], 'LineWidth',1);%start point
% scatter(n+0.5,1+0.5,'MarkerEdgeColor',[0 1 0],'MarkerFaceColor',[0 1 0], 'LineWidth',1);%goal point

hold on

%%
%�ϰ��ռ���󼯺�B
Barrier = (find(a==0))';

%%
%����������

%%
%main
%%
% arrayValue = [13,34,256];
% %�жϽ��Ƿ����ϰ�����
% NB = length(arrayValue);
% for i = 1:1:NB
%     if ismember(arrayValue(i),Barrier) ==1
%         arrayValue(i) = randi([1 400],1); %ɾ���������ϰ��ﴦ������.������1-400��������� 
%     end
% end
N = 50;%�˹�������
try_number = 8;
MAXGEN = 500;%����������
visual = 10;
delta = 0.618;
start = n;%�˹���Ⱥ��ʼλ��
DistMin = sqrt((1-n)^2+(n-1)^2);%��̾����־λ
goal = n*n-n+1;%Ŀ��λ��
shift = 1;%��ʳ��Ϊ��{Ⱥ�ۣ�׷β}��Ϊ��ģʽ�л���
shiftFreq = 5;%��ʳ��Ϊ��{Ⱥ�ۣ�׷β}��Ϊ���л�Ƶ��
rightInf = sqrt(2);
% arrayValue = [20 39 58 77 96 115 134 153 172 192 212 232 252 272 291 310 
%                 329 328 327 326 325 324 344 364 363 362 361 381];%��ʼ��
arrayValue = [20];%����ȷ���Ҫ��ʾ��������.
for i =1:1:N
    ppValue(i) = start;%�����˹���Ⱥλ�õı���
end
H =GrideAF_foodconsistence(n,ppValue,goal);
count = 1;%��¼ִ����ʳ��Ϊ�Ĵ���
runDist = 0;%��¼����·�����ܳ���
runDist_part = 0;%��¼ÿһ�����е�����·�����ȣ����ڱȽ�
BestH = zeros(1,MAXGEN);%��¼ÿһ�ε����е�����Hֵ 
index = [];%��¼�ҵ�·������Ⱥ
% endpath = 1;%��¼�Ż�������·���ĵڼ�����
% path_optimum = [];%��¼�Ż����·��
% Rf = 4*sqrt(2);%�Ż�������Ұ�뾶
% kcount = 0;%����Ѱ�ż���
% dupilcate = 1;%�Ż���������
%-----------------------------------------���˱���������ʼ��ȫ������------------------------------------------------------
for j = 1:1:MAXGEN
    switch shift
%------------------------------------��ʳ��Ϊ----------------------------------------------------------------------------
        case 1
            for i = 1:1:N
               [nextPosition,nextPositionH] = GridAF_prey(n,ppValue(i),i,try_number,H,Barrier,goal);
               %��Ҫ��¼��ÿ�����Ӧ��λ�ã��Լ�ʳ��Ũ��.�Ա��´θ���.
               position(j,i) = nextPosition;%position���������Ⱥ��λ��.
               H(i) = nextPositionH;
            end
            disp('prey!!!!')
%------------------------------------Ⱥ����Ϊ---------------------------------------------------------------------------    
         case 2     
            for i = 1:1:N
                [nextPosition_S,nextPositionH_S] = GridAF_swarm(n,N,position(j-1,:),i,visual,delta,try_number,H,Barrier,goal);
                [nextPosition_F,nextPositionH_F] = GridAF_follow(n,N,position(j-1,:),i,visual,delta,try_number,H,Barrier,goal);
                if nextPositionH_F < nextPositionH_S
                    nextPosition = nextPosition_F;
                    nextPositionH = nextPositionH_F;
                else
                    nextPosition = nextPosition_S;
                    nextPositionH = nextPositionH_S;
                end
                 position(j,i) = nextPosition;%position���������Ⱥ��λ��.
                 H(i) = nextPositionH;
            end 
            disp('swarm & follow!!!')
    end
%-----------------------------------------------------------------------------------------------------------------
    count = count+1;%�����˹��㶼�����һ����ʳ��Ϊ
    if rem(count,shiftFreq) == 0 %��Ϊcount��1��ʼ�ǣ�����5ʱ������4����ʳ��Ϊ
        shift = 2;
    else
        shift = 1;
    end
    
    %Ҫ����ppValue��ֵ
    ppValue =  position(j,:);
    %����position���ҵ��˹��㵽��goal��ʱ��������ѭ��
    index = find(position(j,:)==goal);
    if ~isempty(index)
        break;
    end

end

%%�������Ϊ������������������ѭ������˵��û��·������
if MAXGEN <= j
    disp('There is no way can arrive to the goal!!!');
else
%%
% %�Ż����еĿ���·��
% for i = 1:1:length(index)
%     path_optimum(i,:) = [start;position(:,index(i))]';
% %����Ϊ������
% %     path_optimum(i,:) = [20,19,39,58,78,77,96,95,114,113,133,152,172,192,211,212,232,252,272,271,270,269,288,308,327,307,327,326,325,345,344,363,362,381];
%     kcount = 0;
%     endpath = 1;
%     path_optimum(i,endpath)
%     while path_optimum(i,endpath) ~= goal%˵���Ѿ��Ż�����Ŀ��㣬��ȫ������Ż�
%         fprintf("�����Ż����%d��......\n",i)
%         if kcount ==0
%             [path_optimum(i,:),endpath] = Gridpath_optimum(n,endpath,path_optimum(i,:),Rf,Barrier);
%         else
%             if kcount >= 6
%             Rf = 3*sqrt(2);
%             end
%             [path_optimum(i,:),endpath] = Gridpath_optimum(n,endpath+1,path_optimum(i,:),Rf,Barrier);
%         end
%          kcount = kcount+1;
%     end
% end

%�����п���·�����ҳ����·��
    for i = 1:1:length(index)
        arrayValue =[start;position(:,index(i))]';
%----------------------���������·�����ܳ���-----------------------------
        for j = 1:1:length(arrayValue)-1
            d = distance(n,arrayValue(j),arrayValue(j+1));
            runDist_part = runDist_part + d;
        end
        transimit(i) = runDist_part;%��¼���п���·�����ܳ���   
        runDist_part = 0;
    end
    [runDist,runMin_index] = min(transimit);
    arrayValue = [start;position(:,index(runMin_index))]';
    fprintf('index�����·��Ϊ��%d��\n',index(runMin_index))
    
    for i =1:1:length(arrayValue)
        BestH(i) = goal-arrayValue(i);%��¼���ſ��н�ĵ���ͼ
    end
    
    DrawPath(n,arrayValue);%��������·��       
%------------------------------------------------------------------------
    fprintf('���߳���Ϊ: %f\n',runDist)%��ʾ����·���ĳ���
end
%-----------------------------------------------------------------------
%%��������ͼ
% figure
% plot(1:MAXGEN,BestH)
% xlabel('��������')
% ylabel('�Ż�ֵ')
% title('��Ⱥ�㷨��������')
%----------------------------------------------------------------------
%%
toc;
% PS:��ֵ�����0.5��Ϊ�˱�֤�������������դ�����Ĵ�