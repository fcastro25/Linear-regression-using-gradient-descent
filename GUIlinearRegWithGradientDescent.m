function GUIlinearRegWithGradientDescent

%--------------------------------------------------------------------------
%GRAPHICAL INTERFACE
%--------------------------------------------------------------------------

%Centralize the current window at the center of the screen
[posX,posY,Width,Height]=centralizeWindow(1300,768);
figposition = [posX,posY,Width,Height];

GUIlinearRegWithGradientDescent_ = figure('Menubar','none',...
    'Name','Linear Regression with Gradient Descent',...
    'NumberTitle','off',...
    'NextPlot','add',...
    'units','pixel',...
    'position',figposition,...
    'Toolbar','figure',...
    'Visible','off',...
    'Resize','off');

%--------------------------------------------------------------------------

optionPanel = uipanel(GUIlinearRegWithGradientDescent_,...
    'Units','normalized',...
    'position',[0.02 0.02 0.2 0.96]);

interactionMode = uicontrol(optionPanel,'Style','popupmenu',...
    'units','normalized',...
    'String',{'By user interaction','Randomly'},...
    'TooltipString','Way that dispersing points are generated.',...
    'fontUnits','normalized',...
    'position',[0.03 0.925 0.944 0.036],...
    'CallBack',@changeInteractionMode_callBack);

n_of_dispersing_points = uicontrol(optionPanel,'Style','edit',...
    'TooltipString','Number of dispersing points.',...
    'Units','normalized',...
    'String','10',...
    'fontUnits','normalized',...
    'position',[0.03 0.875 0.46 0.036]);

buffer_zone = uicontrol(optionPanel,'Style','edit',...
    'TooltipString','Buffer zone.',...
    'Units','normalized',...
    'String','0.05',...
    'fontUnits','normalized',...
    'position',[0.51 0.875 0.46 0.036]);

set_dispersing_points_manually = uicontrol(optionPanel,'Style','pushbutton',...
    'Units','normalized',...
    'String','Set dispersing points manually',...
    'fontUnits','normalized',...
    'Visible','on',...
    'position',[0.03 0.825 0.944 0.036],...
    'CallBack',@setDispersingPoints_callBack);

set_dispersing_points_randomly = uicontrol(optionPanel,'Style','pushbutton',...
    'Units','normalized',...
    'String','Set dispersing points randomly',...
    'fontUnits','normalized',...
    'Visible','off',...
    'position',[0.03 0.825 0.944 0.036],...
    'CallBack',@setDispersingPoints_callBack);

uicontrol(optionPanel,'Style','pushbutton',...
    'Units','normalized',...
    'String','Generate a random straight line',...
    'fontUnits','normalized',...
    'position',[0.03 0.775 0.944 0.036],...
    'CallBack',@guessLine_callBack);

m = uicontrol(optionPanel,'Style','edit',...
    'TooltipString','Angular coeficient (m).',...
    'Units','normalized',...
    'String','',...
    'fontUnits','normalized',...
    'position',[0.03 0.725 0.46 0.036]);

b = uicontrol(optionPanel,'Style','edit',...
    'TooltipString','Linear coeficient (b).',...
    'Units','normalized',...
    'String','',...
    'fontUnits','normalized',...
    'position',[0.51 0.725 0.46 0.036]);

alpha = uicontrol(optionPanel,'Style','edit',...
    'TooltipString','Learning rate associated with the angular coeficient (m).',...
    'Units','normalized',...
    'String','0.001',...
    'fontUnits','normalized',...
    'position',[0.03 0.675 0.46 0.036]);

beta = uicontrol(optionPanel,'Style','edit',...
    'TooltipString','Learning rate associated with the linear coeficient (b).',...
    'Units','normalized',...
    'String','0.001',...
    'fontUnits','normalized',...
    'position',[0.51 0.675 0.46 0.036]);

iterations = uicontrol(optionPanel,'Style','edit',...
    'TooltipString','Número de iterações.',...
    'Units','normalized',...
    'String','100',...
    'fontUnits','normalized',...
    'position',[0.03 0.625 0.944 0.036]);

pause_in_each_iteration = uicontrol(optionPanel,'Style','edit',...
    'TooltipString','Pause in each iteration.',...
    'Units','normalized',...
    'String','0.05',...
    'fontUnits','normalized',...
    'position',[0.03 0.575 0.944 0.036]);

uicontrol(optionPanel,'Style','pushbutton',...
    'Units','normalized',...
    'String','Optimize Line',...
    'fontUnits','normalized',...
    'position',[0.03 0.525 0.944 0.036],...
    'CallBack',@optimizeLine_callBack);

dispersing_graph = axes(GUIlinearRegWithGradientDescent_,...
    'Units','normalized',...
    'Box','on',...
    'position',[0.27 0.53 0.46 0.45]);

loss_function_graph = axes(GUIlinearRegWithGradientDescent_,...
    'Units','normalized',...
    'Box','on',...
    'position',[0.27 0.1 0.2 0.35]);

loss_function_profile = axes(GUIlinearRegWithGradientDescent_,...
    'Units','normalized',...
    'Box','on',...
    'position',[0.53 0.1 0.2 0.35]);

logTable = uitable(GUIlinearRegWithGradientDescent_,...
    'ColumnName', {'m','b','Loss','dLoss/dm','dLoss/db'},...
    'ColumnWidth',{60 60 60 80 80},...
    'Units','normalized',...
    'position',[0.75 0.022 0.2324 0.958]);

set(GUIlinearRegWithGradientDescent_,'Visible','on')
%--------------------------------------------------------------------------
%CALLBACKS
%--------------------------------------------------------------------------

%SET DISPERSING POINTS
function setDispersingPoints_callBack(varargin)
%Retrieve the handle structure
handles = guidata(GUIlinearRegWithGradientDescent_);

delete_a_graph_component_from_its_tag(loss_function_graph,'optimized_parameters')
delete_a_graph_component_from_its_tag(dispersing_graph,'initial_line')
delete_a_graph_component_from_its_tag(dispersing_graph,'points')
delete_a_graph_component_from_its_tag(dispersing_graph,'intermediate_lines')

N = str2double(get(n_of_dispersing_points,'String'));

x_d = zeros([1,N]);
y_d = zeros([1,N]);

axes(dispersing_graph)
if(get(interactionMode,'Value')==1)
    for i=1:N
        xlim([-1,1]); ylim([-1,1])
        h = impoint();
        pos = getPosition(h);
        x_d(1,i) = pos(1);
        y_d(1,i) = pos(2);
        xlim([-1,1]); ylim([-1,1])
    end
else
    m_ = 0 + 60*rand(1);
    del_y = 2*tand(m_);
    b_min_i = 0 - (del_y/2);
    b_min_f = 0 + (del_y/2);
    area_x = [-1 1 1 -1];
    buffer_width = str2double(get(buffer_zone,'String'));
    area_y = [b_min_i-buffer_width,...
              b_min_f-buffer_width,...
              b_min_f+buffer_width,...
              b_min_i+buffer_width];
    
    x_temp = zeros([1,N]);
    y_temp = zeros([1,N]);
    hold off
    i_ = 0;
    while(i_<N)
        x_rand = -1 + 2*rand(1);
        y_rand = -1 + 2*rand(1);
        in = inpolygon(x_rand,y_rand,area_x,area_y);
        if(in)
            i_ = i_ + 1;
            x_temp(i_) = x_rand;
            y_temp(i_) = y_rand;
        end
    end
    x_d = x_temp;
    y_d = y_temp;
end

hold off
plot(x_d,y_d,'bo','Tag','points')
hold on
grid on
xlim([-1,1]); ylim([-1,1])

generateLossGraph(N,x_d,y_d)

handles.x_d = x_d;
handles.y_d = y_d;
%Update de handle structure
guidata(GUIlinearRegWithGradientDescent_,handles);
end

%SHOW AND HIDE GUI COMPONENTS RELATED TO SELECTED RTP APPROACH
function changeInteractionMode_callBack(varargin)
%Retrieve the handle structure
handles = guidata(GUIlinearRegWithGradientDescent_);

if(get(interactionMode,'Value')==1)
    set(set_dispersing_points_manually,'Visible','on')
    set(set_dispersing_points_randomly,'Visible','off')
    set(n_of_dispersing_points,'String','10')
else
    set(set_dispersing_points_manually,'Visible','off')
    set(set_dispersing_points_randomly,'Visible','on')
    set(n_of_dispersing_points,'String','100')
end

%Update de handle structure
guidata(GUIlinearRegWithGradientDescent_,handles);
end

%GUESS A INITIAL LINE
function guessLine_callBack(varargin)
%Retrieve the handle structure
handles = guidata(GUIlinearRegWithGradientDescent_);

delete_a_graph_component_from_its_tag(loss_function_graph,'optimized_parameters')
delete_a_graph_component_from_its_tag(dispersing_graph,'intermediate_lines')

rand_m_i = -1 + 2*rand(1);
rand_b_i = -1 + 2*rand(1);

set(m,'String',num2str(rand_m_i))
set(b,'String',num2str(rand_b_i))

x = [-1,1];
y = [rand_m_i*x(1)+rand_b_i,rand_m_i*x(2)+rand_b_i];

delete_a_graph_component_from_its_tag(dispersing_graph,'initial_line')
hold on
plot(dispersing_graph,x,y,'r','linewidth',2,'Tag','initial_line')
hold off

delete_a_graph_component_from_its_tag(loss_function_graph,'initial_parameters')
hold on
plot(loss_function_graph,rand_m_i,rand_b_i,'ko','Tag','initial_parameters')
hold off

%Update de handle structure
guidata(GUIlinearRegWithGradientDescent_,handles);
end

%PERFORM LINE REGRESSION VIA GRADIENT DESCENT
function optimizeLine_callBack(varargin)
%Retrieve the handle structure
handles = guidata(GUIlinearRegWithGradientDescent_);

x = handles.x_d;
y = handles.y_d;

n_iteration = str2double(get(iterations,'String'));

m_initial = str2double(get(m,'String'));
b_initial = str2double(get(b,'String'));

alpha_ = str2double(get(alpha,'String'));
beta_ = str2double(get(beta,'String'));

t = str2double(get(pause_in_each_iteration,'String'));

data = [];

delete_a_graph_component_from_its_tag(loss_function_graph,'optimized_parameters')
delete_a_graph_component_from_its_tag(dispersing_graph,'intermediate_lines')

hold on
for i=1:n_iteration
    del_loss_del_m = 2*sum((m_initial.*x + b_initial - y).*x);
    del_loss_del_b = 2*sum(m_initial.*x + b_initial - y);
    m_initial = m_initial - alpha_*del_loss_del_m;
    b_initial = b_initial - beta_*del_loss_del_b;
    
    if(i~=n_iteration)
        plot(loss_function_graph,m_initial,b_initial,'k.','Tag','optimized_parameters')
    else
        plot(loss_function_graph,m_initial,b_initial,'ko','Tag','optimized_parameters')
    end
    
    x_ = [-1,1];
    y_ = [m_initial*x_(1)+b_initial,m_initial*x_(2)+b_initial];
    
    if(i~=n_iteration)
        plot(dispersing_graph,x_,y_,'r--','Tag','intermediate_lines')
    else
        plot(dispersing_graph,x_,y_,'k','linewidth',2,'Tag','intermediate_lines')
    end
    
    it(i) = i;
    err(i) = sum((m_initial.*x + b_initial - y).^2);
    delete_a_graph_component_from_its_tag(loss_function_profile,'err')
    plot(loss_function_profile,it,err,'k','Tag','err')
    
    %fill log table
    data = [data; m_initial, m_initial, err(i), del_loss_del_m, del_loss_del_b];
    set(logTable,'Data',data)
    
    pause(t)
end

axes(loss_function_profile)
xlabel('iteration')
ylabel('Loss Function')
grid on

axes(dispersing_graph)
grid on

%Update de handle structure
guidata(GUIlinearRegWithGradientDescent_,handles);
end

%--------------------------------------------------------------------------
%LOCAL FUNCTIONS
%--------------------------------------------------------------------------

function generateLossGraph(N,x_d,y_d)
    
    range = 2;
    M_ = 500;
    b_ = linspace(-range,range,M_);
    m_ = linspace(-range,range,M_);
    
    [B,M] = meshgrid(b_,m_);
    
    reg = zeros([1,N]);
    loss_function = zeros(M_);
    
    for j=1:M_
        for i=1:M_
            for k=1:N
                reg(1,k) = m_(j)*x_d(k) + b_(i);
            end
            
            loss_function(i,j) = sum((reg-y_d).^2);
        end
    end
    
    axes(loss_function_graph)
    pcolor(B,M,loss_function)
    xlabel('angular coeficient (m)')
    ylabel('linear coeficient (b)')
    title('2D Loss Function')
    shading interp
    axis image
    colormap jet
end

function delete_a_graph_component_from_its_tag(obj_handle,tag_name)
    obj = findobj(obj_handle,'Tag',tag_name);
    if(~isempty(obj))
        delete(obj)
    end
end

function [posX,posY,Width,Height]=centralizeWindow(Width_,Height_)

%Size of the screen
screensize = get(0,'Screensize');
Width = screensize(3);
Height = screensize(4);

posX = (Width/2)-(Width_/2);
posY = (Height/2)-(Height_/2);
Width=Width_;
Height=Height_;

end

end