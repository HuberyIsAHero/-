function studyData()
%�Զ���ѧϰ����ѵ��������
%ͨ��ѭ����ÿһ��ѧϰ��������ѧϰ����
clear templet pattern;          %���ѧϰ����
dataSet = '��������ѧ����Ժ';  %ѧϰ���ַ���
for i = 1:9    %9������
    for j = 1:5 %ÿ��������Ҫ5������������5��������
        sampleTraining(i,j,dataSet); %ѭ��ѧϰ������
    end
end