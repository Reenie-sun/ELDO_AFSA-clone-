function [ nextPosition,nextPositionH ] = GridAF_prey(n,ppValue,ii,try_number,lastH, Barrier,goal )
%���������
% n----����ά��
% present_position_value----ppValue�˹��㵱ǰ��դ���е�ֵ(����)
% ii----��ǰ�˹������
% try_number----����Դ���
% lastH----�ϴ��˹���ʳ��Ũ��
% Barrier----�ϰ�����
% goal----�˹���Ŀ��λ��
%���������
% nextPosition----��һʱ�̵��˹���դ�����ֵ
%nextPositionH----��һʱ�̸����˹���λ�ô���ʳ��Ũ��
nextPosition = [];
allow_area = [];%��¼������
j = 1;%��¼�����������ĸ���
present_H = lastH(ii);%��ǰλ��ʱ�̵�ʵ��Ũ��ֵ.
rightInf = sqrt(2);
%%
%�˹���Ŀ�����
A = 1:1:n^2;
allow = setdiff(A,Barrier);    
for i = 1:1:length(allow)
    if 0 < distance(n,ppValue,allow(i)) && distance(n,ppValue,allow(i)) <= rightInf  
        allow_area(j) = allow(i);
        j = j+1;
    end
end
%%

for i = 1:1:try_number
    Xj = allow_area(uint16(rand*(length(allow_area)-1)+1));%�ڿ����������ѡ��һ��.
    Hj = GrideAF_foodconsistence(n,Xj,goal);
    if present_H > Hj%˵����һ����ֵ����goal����������
       nextPosition = Xj;%��ΪXj�ڿ������У����Բ����ж��Ƿ�Խ��.
       break;  %�ҵ�һ��Сֵ�ͽ���ѭ�������Եó��Ľ��Ϊ�����н⣬���������Ž�.
    end
    
end

if isempty(nextPosition)
     Xj = allow_area(uint16(rand*(length(allow_area)-1)+1));%�ڿ����������ѡ��һ��.
     nextPosition = Xj;%��ΪXj�ڿ������У����Բ����ж��Ƿ�Խ��.
end

%%
nextPositionH = GrideAF_foodconsistence(n,nextPosition,goal);
end

