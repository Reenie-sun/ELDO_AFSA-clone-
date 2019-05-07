close all;
clear all;
clc;
%%
%���������˵��ϰ�����������עstart,goalλ��
% a = rand(20)>0.35;%�ڰ׸���ռ����
tic;

a = load('environment.txt');%blacb--barrier occputy 35%.
n = size(a,1);
b = a;
b(end+1,end+1) = 0;
figure(1);
colormap([0 0 0;1 1 1])
pcolor(b); % ����դ����ɫ
set(gca,'XTick',[10 20],'YTick',[10 20]);  % ��������
axis image xy

displayNum(n);%��ʾդ���е���ֵ

text(1,21.5,'START','Color','red','FontSize',10);%��ʾstart�ַ�
text(21,1.5,'GOAL','Color','red','FontSize',10);%��ʾgoal�ַ�

hold on
%pin strat goal positon
scatter(1+0.5,20+0.5,'MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0], 'LineWidth',1);%start point
scatter(20+0.5,1+0.5,'MarkerEdgeColor',[0 1 0],'MarkerFaceColor',[0 1 0], 'LineWidth',1);%goal point

hold on

%%
%�ϰ��ռ���󼯺�B
Barrier = (find(a==0))';


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
N = 20;%�˹�������
try_number = 8;
MAXGEN = 100;%����������
visual = 6;
delta = 0.618;
start = 20;%�˹���Ⱥ��ʼλ��
goal_false = 189;%դ��ͼ���ĸ���������һ�㣬�ڿ�������
goal_true = 381;%�˹���Ŀ��λ��,�ڶ�����Ⱥ
start_2 = goal_true;
DistMin = sqrt((1-n)^2+(n-1)^2);%��̾����־λ
DistMin2 = sqrt((1-n)^2+(n-1)^2);
shift = 1;%��ʳ��Ϊ��{Ⱥ�ۣ�׷β}��Ϊ��ģʽ�л���
shiftFreq = 5;%��ʳ��Ϊ��{Ⱥ�ۣ�׷β}��Ϊ���л�Ƶ��
countMin = 2;%��¼���Ž����.
countMin2 = 2;
rightInf = sqrt(2);
% arrayValue = [20 39 58 77 96 115 134 153 172 192 212 232 252 272 291 310 
%                 329 328 327 326 325 324 344 364 363 362 361 381];%��ʼ��
arrayValue1 = [20];%����ȷ���Ҫ��ʾ��������.
arrayValue2 = [381];
for i =1:1:N
    ppValue(i) = start;%�����˹���Ⱥλ�õı���
end

for i =1:1:N
    ppValue2(i) = start_2;%�����˹���Ⱥλ�õı���
end
H = GrideAF_foodconsistence(n,ppValue,goal_false);

H2 = GrideAF_foodconsistence(n,ppValue2,goal_false);
count = 1;%��¼ִ����ʳ��Ϊ�Ĵ���
runDist = 0;%��¼����·�����ܳ���
BestH1 = zeros(1,MAXGEN);%��¼ÿһ�ε����е�����Hֵ 
BestH2 = zeros(1,MAXGEN);
%-----------------------------------------���˱���������ʼ��ȫ������------------------------------------------------------
for j = 1:1:MAXGEN
    switch shift
%------------------------------------��ʳ��Ϊ----------------------------------------------------------------------------
        case 1
            for i = 1:1:N
               [nextPosition_1,nextPositionH_1] = GridAF_prey(n,ppValue(i),i,try_number,H,Barrier,goal_false);
               
                [nextPosition_2,nextPositionH_2] = GridAF_prey(n,ppValue2(i),i,try_number,H,Barrier,goal_false);
               %��Ҫ��¼��ÿ�����Ӧ��λ�ã��Լ�ʳ��Ũ��.�Ա��´θ���.
               position(i) = nextPosition_1;%position���������Ⱥ��λ��.
               H(i) = nextPositionH_1;
               
               position2(i) = nextPosition_2;%position���������Ⱥ��λ��.
               H2(i) = nextPositionH_2;
            end
            disp('prey!!!!')
%------------------------------------Ⱥ����Ϊ---------------------------------------------------------------------------    
         case 2     
            for i = 1:1:N
                [nextPosition_S_1,nextPositionH_S_1] = GridAF_swarm(n,N,position,i,visual,delta,try_number,H,Barrier,goal_false);
                [nextPosition_F_1,nextPositionH_F_1] = GridAF_follow(n,N,position,i,visual,delta,try_number,H,Barrier,goal_false);
                
                [nextPosition_S_2,nextPositionH_S_2] = GridAF_swarm(n,N,position2,i,visual,delta,try_number,H2,Barrier,goal_false);
                [nextPosition_F_2,nextPositionH_F_2] = GridAF_follow(n,N,position2,i,visual,delta,try_number,H2,Barrier,goal_false);
                
                if nextPositionH_F_1 < nextPositionH_S_1
                    nextPosition_1 = nextPosition_F_1;
                    nextPositionH_1 = nextPositionH_F_1;
                else
                    nextPosition_1 = nextPosition_S_1;
                    nextPositionH_1 = nextPositionH_S_1;
                end
                
                if nextPositionH_F_2 < nextPositionH_S_2
                    nextPosition_2 = nextPosition_F_2;
                    nextPositionH_2 = nextPositionH_F_2;
                else
                    nextPosition_2 = nextPosition_S_2;
                    nextPositionH_2 = nextPositionH_S_2;
                end
                
                 position(i) = nextPosition_1;%position���������Ⱥ��λ��.
                 H(i) = nextPositionH_1;
                 
                 position2(i) = nextPosition_2;%position���������Ⱥ��λ��.
                 H2(i) = nextPositionH_2;
                 
            end 
            disp('swarm & follow!!!')
    end
%-----------------------------------------------------------------------------------------------------------------
    count = count+1;%�����˹��㶼�����һ����Ϊ
    if rem(count,shiftFreq) == 0 %��Ϊcount��1��ʼ�ǣ�����5ʱ������4����ʳ��Ϊ
        shift = 2;
    else
        shift = 1;
    end
%================================================================================================================
    [Hmin,index] = min(H);%�ҵ�Hmin��Ӧ��ɱ��λ��.����index��  
    %Ҫ����ppValue��ֵ
    ppValue =  position;
    %������Сֵ��arrayValue��ȥ
    
    [H2min,index2] = min(H2);%�ҵ�Hmin��Ӧ��ɱ��λ��.����index��  
    %Ҫ����ppValue��ֵ
    ppValue2 =  position2;
    %������Сֵ��arrayValue��ȥ
    
    if Hmin < DistMin
        DistMin = Hmin;
        arrayValue1(countMin) = position(index);%��ÿһ�������ŵĽ��¼����  
    else
        DistMin = DistMin;
        arrayValue1(countMin) = arrayValue1(countMin-1);
    end
    
    if H2min < DistMin2
        DistMin2 = H2min;
        arrayValue2(countMin2) = position2(index2);%��ÿһ�������ŵĽ��¼����  
    else
        DistMin2 = DistMin2;
        arrayValue2(countMin2) = arrayValue2(countMin2-1);
    end
    
    BestH1(j) = DistMin;%��¼ÿһ�ε����е�����Hֵ 
    countMin = countMin+1;
    
    BestH2(j) = DistMin2;%��¼ÿһ�ε����е�����Hֵ 
    countMin2 = countMin2+1;
    
    if arrayValue1(countMin-1) == goal_false && arrayValue2(countMin2-1) == goal_false
       break;
    end
    
% %Ϊȥ���ֲ����Ž��ȫ�ֵ�Ӱ�죬�ж�arrayValue��ÿ��ֵ�Ƿ�����һ��ֵ�ÿ�������
%     if distance(n,arrayValue(countMin-1),arrayValue(countMin-2)) > rightInf
%          [nextPosition,nextPositionH] = GridAF_prey(n,arrayValue(countMin-2),index,try_number,H,Barrier,goal);
%          arrayValue(countMin-1) = nextPosition;
%     end
end
%%
%��arrayValue1��arrayValue2���ϳ�arrayValue
arrayValue = [arrayValue1 arrayValue2(end:-1:1)];

%%�������Ϊ������������������ѭ������˵��û��·������
if MAXGEN <= j
    disp('There is no way can arrive to the goal!!!');
else
    DrawPath(n,arrayValue);%��������·��   
    
%----------------------���������·�����ܳ���-----------------------------
    for i = 1:1:length(arrayValue)-1
        d = distance(n,arrayValue(i),arrayValue(i+1));
        runDist = runDist + d;
    end
%------------------------------------------------------------------------
    fprintf('���߳���Ϊ: %f\n',runDist)%��ʾ����·���ĳ���
end
%-----------------------------------------------------------------------
%%��������ͼ
% figure
% plot(1:MAXGEN,BestH1)
% xlabel('��������')
% ylabel('�Ż�ֵ')
% title('��Ⱥ�㷨��������1')
% 
% figure
% plot(1:MAXGEN,BestH2)
% xlabel('��������')
% ylabel('�Ż�ֵ')
% title('��Ⱥ�㷨��������2')
%----------------------------------------------------------------------
%%
toc;
% PS:��ֵ�����0.5��Ϊ�˱�֤�������������դ�����Ĵ�