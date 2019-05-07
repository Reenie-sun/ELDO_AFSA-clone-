close all;
clear all;
clc;
%%
%���������˵��ϰ�����������עstart,goalλ��
% a = rand(20)>0.35;%�ڰ׸���ռ����
tic;

a = load('object.txt');%blacb--barrier occputy 35%.
% a = ones(20);
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
MAXGEN = 100;%����������
visual = 6;
delta = 0.618;
start = 20;%�˹���Ⱥ��ʼλ��
DistMin = sqrt((1-n)^2+(n-1)^2);%��̾����־λ
goal = 381;%Ŀ��λ��
shift = 1;%��ʳ��Ϊ��{Ⱥ�ۣ�׷β}��Ϊ��ģʽ�л���
shiftFreq = 5;%��ʳ��Ϊ��{Ⱥ�ۣ�׷β}��Ϊ���л�Ƶ��
countMin = 2;%��¼���Ž����.
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
BestH = zeros(1,MAXGEN);%��¼ÿһ�ε����е�����Hֵ 
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
%================================================================================================================
    [Hmin,index] = min(H);%�ҵ�Hmin��Ӧ��ɱ��λ��.����index��  
    %Ҫ����ppValue��ֵ
    ppValue =  position(j,:);
    %������Сֵ��arrayValue��ȥ
    if Hmin < DistMin
        DistMin = Hmin;
        arrayValue(countMin) = position(j,index);%��ÿһ�������ŵĽ��¼����  
    else
        DistMin = DistMin;
        arrayValue(countMin) = arrayValue(countMin-1);
    end
    BestH(j) = DistMin;%��¼ÿһ�ε����е�����Hֵ 
    countMin = countMin+1;
    if arrayValue(countMin-1) == goal
       break;
    end
% %Ϊȥ���ֲ����Ž��ȫ�ֵ�Ӱ�죬�ж�arrayValue��ÿ��ֵ�Ƿ�����һ��ֵ�ÿ�������
%     if distance(n,arrayValue(countMin-1),arrayValue(countMin-2)) > rightInf
%          [nextPosition,nextPositionH] = GridAF_prey(n,arrayValue(countMin-2),index,try_number,H,Barrier,goal);
%          arrayValue(countMin-1) = nextPosition;
%     end
end

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
% plot(1:MAXGEN,BestH)
% xlabel('��������')
% ylabel('�Ż�ֵ')
% title('��Ⱥ�㷨��������')
%----------------------------------------------------------------------
%%
toc;
% PS:��ֵ�����0.5��Ϊ�˱�֤�������������դ�����Ĵ�