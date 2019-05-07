%%
%��IAF�㷨�Ļ����ϣ������߽�һ���Ż�

%%
% close all;
clear all;
clc;
%%
%���������˵��ϰ�����������עstart,goalλ��
% a = rand(20)>0.35;%�ڰ׸���ռ����
tic;

a = load('environment.txt');%blacb--barrier occputy 35%.
% a = rand(20)>0.3;
n = size(a,1);
b = a;
b(end+1,end+1) = 0;
figure;
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
visual = 10;
delta = 0.618;
start = 20;%�˹���Ⱥ��ʼλ��
DistMin = sqrt((1-n)^2+(n-1)^2);%��̾����־λ
goal = 381;%Ŀ��λ��
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
Q = 3;%Ϊ���Ż�ָ��
KQ = 3;%���Ż���������
optimum_dis = 0;%�����Ż��У��ۼƵ����������п��н�֮��ľ���
iop = 1;%�Ż��е�ѭ������
%-----------------------------------------���˱���������ʼ��ȫ������------------------------------------------
for j = 1:1:MAXGEN
    switch shift
%------------------------------------��ʳ��Ϊ-----------------------------------------------------------------
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
%�����п���·�����ҳ����·��
for i = 1:1:length(index)
    arrayValue = [start;position(:,index(i))]';
%----------------------���������·�����ܳ���-----------------------------
    for j = 1:1:length(arrayValue)-1
        d = distance(n,arrayValue(j),arrayValue(j+1));
        runDist_part = runDist_part + d;
    end
    transimit(i) = runDist_part;%��¼���п���·�����ܳ���    
end
[runDist,runMin_index] = min(transimit);
arrayValue = [start;position(:,index(runMin_index))]';

for i =1:1:length(arrayValue)
    BestH(i) = goal-arrayValue(i);%��¼���ſ��н�ĵ���ͼ
end
%%
% %�Ż����п��е�·��
test = arrayValue;

% while(1)
%    
%     while iop < length(arrayValue) 
%         allow_area_now = allow_fun(n,Barrier,arrayValue(iop),KQ*rightInf );%�ó���ǰλ���˹���Ŀ�����
%         [cin,ia,ib] = intersect(allow_area_now,arrayValue);%�ҳ���������Ĺ���Ԫ�أ�iaΪ����Ԫ���ڵ�һ�������е�λ�ã�ib����

%         if length(cin) >= Q%˵����Ҫ�Ż�
%             for k = 1:1:length(cin)-2%������Ϊ��ȥ����һ����ͱ���
%                 optimum_dis = optimum_dis + distance(n,arrayValue(iop+k-1),arrayValue(iop+k));
%                 disp("�ж��Ƿ��Ż���")
%             end
%             %��������Ҫ��ĵ���0����������ı�����ά��
%             if distance(n,arrayValue(iop),arrayValue(iop+k)) < optimum_dis
%                 for k1 = iop+1:1:iop+k-1
%                     arrayValue(k1) = [];
%                     iop = 1;%��ΪarrayValue����ά���仯��Ҫ����ѭ��,iopҪ��1
%                     disp("������Ž⣡")
%                     break;
%                 end
%             end
%         end
%         iop = iop+1;
%     end
%     if iop >= length(arrayValue)%�ж������ѭ���Ƿ�����������������ǣ���ô˵���Ż�ȫ������.
%         break;
%     end
% end
%%
    DrawPath(n,arrayValue);%��������·��       
%------------------------------------------------------------------------
    fprintf('���߳���Ϊ: %f\n',runDist)%��ʾ����·���ĳ���
end
%-----------------------------------------------------------------------
%%��������ͼ
figure
plot(1:MAXGEN,BestH)
xlabel('��������')
ylabel('�Ż�ֵ')
title('��Ⱥ�㷨��������')
%----------------------------------------------------------------------
%%
toc;
% PS:��ֵ�����0.5��Ϊ�˱�֤�������������դ�����Ĵ�