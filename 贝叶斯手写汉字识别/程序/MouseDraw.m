function  MouseDraw(action)
%��Handle Graphics���趨�����¼�
%���������²��Ž���д�֣��Ҽ�����ʶ��
%(MouseDraw Events)�ķ�Ӧָ��(Callbacks)
% global���ܴ�����
 global InitialX InitialY FigHandle 
 imSizex = 90;  %����ͼƬ�ĳ���
 imSizey = 120; %����ͼƬ�Ŀ��
 if nargin == 0
     action = 'start';   
 end
 switch(action)
    %%����ͼ���Ӵ�
    case 'start',
        FigHandle = figure('WindowButtonDownFcn','MouseDraw down');
        set(FigHandle,'position',[200,200,360,410] ); %�趨ͼ����С����Ӧʶ���ͼƬ��С
        %set(gca,'position',[0.1,0.1,0.5,0.8] ); %��
        axis([1 imSizex 1 imSizey]);    % �趨ͼ�᷶Χ
        grid on;
        box on;     % ��ͼ�����ͼ��
        title('��д�����봰(���д�� �Ҽ�ʶ��)');
        dlmwrite('C:\Users\Hubery\Desktop\�����γ�\�˹�����\����ҵ\GUI2\IXT.txt', -10, 'delimiter', '\t', 'precision', 6);
        dlmwrite('C:\Users\Hubery\Desktop\�����γ�\�˹�����\����ҵ\GUI2\IYT.txt', -10, 'delimiter', '\t', 'precision', 6);
        %%����ť������ʱ�ķ�Ӧָ��
    case 'down',
        if strcmp(get(FigHandle, 'SelectionType'), 'normal')    %��������
            set(FigHandle,'pointer','hand');      
            CurPiont = get(gca, 'CurrentPoint');
            InitialX = CurPiont(1,1);
            InitialY = CurPiont(1,2);
            dlmwrite('C:\Users\Hubery\Desktop\�����γ�\�˹�����\����ҵ\GUI2\IXT.txt', InitialX, '-append', 'delimiter', '\t', 'precision', 6);
            dlmwrite('C:\Users\Hubery\Desktop\�����γ�\�˹�����\����ҵ\GUI2\IYT.txt', InitialY, '-append', 'delimiter', '\t', 'precision', 6);
            set(gcf, 'WindowButtonMotionFcn', 'MouseDraw move');
            set(gcf, 'WindowButtonUpFcn', 'MouseDraw up');
        elseif strcmp(get(FigHandle, 'SelectionType'), 'alt')   % ������Ҽ�
            set(FigHandle, 'Pointer', 'arrow');
            set( FigHandle, 'WindowButtonMotionFcn', '')
            set(FigHandle, 'WindowButtonUpFcn', '')
            fprintf('MouseDraw right button down!\n');
            ImageX = importdata('C:\Users\Hubery\Desktop\�����γ�\�˹�����\����ҵ\GUI2\IXT.txt');
            ImageY = importdata('C:\Users\Hubery\Desktop\�����γ�\�˹�����\����ҵ\GUI2\IYT.txt');
            InputImage = ones(imSizex,imSizey);
            roundX = round(ImageX);
            roundY = round(ImageY);
            for k = 1:size(ImageX,1)
                if 0<roundX(k) && roundX(k)<imSizex && 0<roundY(k) && roundY(k)<imSizey
                    InputImage(roundX(k)-1:roundX(k)+2, roundY(k)-1:roundY(k)+2) = 0;
                end
            end
            InputImage = imrotate(InputImage,90);       % ͼ����ת90
            axes(FigHandle.Children),cla;%ɾ������ͼ��
            delete('C:\Users\Hubery\Desktop\�����γ�\�˹�����\����ҵ\GUI2\IXT.txt');%ÿ��ʶ����Ҫ��ɾ���������Ǹ��������'-append'д��
            delete('C:\Users\Hubery\Desktop\�����γ�\�˹�����\����ҵ\GUI2\IYT.txt');
            bayesBinaryTest(InputImage); %������д��ʶ����
            imwrite(InputImage,'C:\Users\Hubery\Desktop\�����γ�\�˹�����\����ҵ\GUI2\ͼƬ.bmp');
        end
    %%�����ƶ�ʱ�ķ�Ӧָ��
    case 'move',
        CurPiont = get(gca, 'CurrentPoint');
        X = CurPiont(1,1);
        Y = CurPiont(1,2);
        % ������ƶ��Ͽ�ʱ�����������ɢ�㡣
        % ����y=kx+bֱ�߷���ʵ�֡�
        x_gap = 0.1;    % ����x��������
        y_gap = 0.1;    % ����y��������
        if X > InitialX
            step_x = x_gap;
        else
            step_x = -x_gap;
        end
        if Y > InitialY
            step_y = y_gap;
        else
            step_y = -y_gap;
        end  
        % ����x,y�ı仯��Χ�Ͳ���
        if abs(X-InitialX) < 0.01        % ��ƽ����y�ᣬ��б�ʲ�����ʱ
            iy = InitialY:step_y:Y;
            ix = X.*ones(1,size(iy,2));
        else
            ix = InitialX:step_x:X ;    % ����x�ı仯��Χ�Ͳ���
            % ��б�ʴ��ڣ���k = (Y-InitialY)/(X-InitialX) ~= 0
            iy = (Y-InitialY)/(X-InitialX).*(ix-InitialX)+InitialY;   
        end
        ImageX = [ix, X]; 
        ImageY = cat(2, iy, Y);
        line(ImageX,ImageY, 'marker', '.', 'markerSize',18, ...
            'LineStyle', '-', 'LineWidth', 2, 'Color', 'Black');
        dlmwrite('C:\Users\Hubery\Desktop\�����γ�\�˹�����\����ҵ\GUI2\IXT.txt', ImageX, '-append', 'delimiter', '\t', 'precision', 6);
        dlmwrite('C:\Users\Hubery\Desktop\�����γ�\�˹�����\����ҵ\GUI2\IYT.txt', ImageY, '-append', 'delimiter', '\t', 'precision', 6);
        InitialX = X;       %��ס��ǰ������
        InitialY = Y;       %��ס��ǰ������
    %%����ť���ͷ�ʱ�ķ�Ӧָ��
    case 'up',
        % ��������ƶ�ʱ�ķ�Ӧָ��
        set(gcf, 'WindowButtonMotionFcn', '');
        % �������ť���ͷ�ʱ�ķ�Ӧָ��
        set(gcf, 'WindowButtonUpFcn', '');
end
