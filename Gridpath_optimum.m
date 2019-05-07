function [ path_optimum,endpath ] = Gridpath_optimum( n,ii,path,Rf,Barrier )
%���������
% n----����ά��
% ii----��ǰ·�����˹�����
% path----��ǰ���н�ľ���
% Rf----�Ż�������Ұ
% Barrier----�ϰ�����
% ���������
% path_optimum----��ǰ�˹����Ż����·������
% endpath----��ǰ��⵽��һ������
Dt = 0;%ԭʼ·�����Ż������Ұ��λ�ڵľ���֮��
Dop = 0;%�Ż����·��֮��
wait_path = [];
wait_test = path(ii);%�ȴ����Ծ���
% endpath = ii;
count = 0;%�������δȫ���޸ĵĸ���
search_area = allow_fun(n,Barrier,wait_test,Rf);%�Ż������Ѱ����
[cin,ia,ib] = intersect(search_area,path);%�ҳ���������Ĺ���Ԫ�أ�iaΪ����Ԫ���ڵ�һ�������е�λ�ã�ib����
%�ҵ�iiʱ��֮��ĵ���ib�д洢��λ��,�Ż�����
ib = sort(ib);%��Ϊintersect֮��˳�򱻴�����

index = ib((find(ib > ii))');
if isempty(index)
    path_optimum = path;
    endpath = ii;
    return;
end
%�ڵ��Թ����з��֣���path�����ؽ�ʱ��index�᲻��������ˣ���Ҫ���䲹������
if index(end) - index(1)+1 ~= length(index)
    index = index(1):1:index(end);
end
%����ii�������Ѱ��Ұ�еĵ��ŷʽ����
for i =1:1:length(index)
    D(i) = distance(n,path(index(i)-1),path(index(i)));
    Dt = Dt+D(i);
end
%��Ѱ����·��������Ұ�����λ�õ�·��
for i = 1:1:length(index)
    allow_area = allow_fun(n,Barrier,wait_test,sqrt(2));
    for j = 1:1:length(allow_area)
        DH(j) = distance(n,allow_area(j),path(index(end)));
    end
    [DHmin,index_DH] = min(DH);
    %��������С���Ǹ�λ�÷ŵ���ѡ������ȥ
    wait_path(i) = allow_area(index_DH);
    wait_test = wait_path(i);
    if DHmin == 0   %˵���Ѿ��ҵ�·�����������wait_path��
        break;
    end
end
% wait_path
%�����ѡ·���ĳ���
wait_path_total = [path(ii) wait_path];
for i = 1:1:length(wait_path_total)-1
    dop(i) = distance(n,wait_path_total(i),wait_path_total(i+1));
    Dop = Dop+dop(i);
end

if Dop < Dt%������Ҫ�Ż�
    disp("need optimum!!!")
    %������Ҫ�ĵ㻻����Ҫ�ĵ�,ֻҪ�������һ���㣬ȫ������
    for i = 1:1:length(index)
        if path(index(i)) ~= path(index(end))
            path(index(i)) = wait_path(i);   
            if path(index(i)) == path(index(end))
                count = i;
                break;%˵���Ż������
            end
        end
    end
    
    if count ~= 0%˵��û���Ż���ɣ�����Ȼ����
        while length(index) - count > 0%˵������û���޸ĵ���ֵ�ĸ���
            disp("����û���޸ĵĸ��ӣ�����")
            %�жϺ����Ƿ�����Ҫ�޸ĵ���û���޸ĵ�����
           count = count+1;
            if index(count) ~= index(end)
                disp("��")
                path(index(count)) = path(index(end));
            end 
        end  
    end
end

% if isempty(index)
%     index(end) = length(path);
% end
path_optimum = path;
endpath = index(end);
%--------------------------------------------------����·����·��ά�����ı�,����Ҫ�����Ѿ��Ż�����ֵ---------------------------------
end

% [20,39,58,57,77,96,115,114,113,112,132,131,152,171,170,189,188,207,227,226,245,264,263,262,282,302,322,341,361,381]
% [20,19,38,57,57,77,96,95,114,133,132,131,150,169,168,188,208,227,246,245,226,245,244,263,282,302,322,341,361,381]