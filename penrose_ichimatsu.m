clear
close all

% define golden ratio
phi = (1+sqrt(5))/2;

n_cake = 10;
% n_iterations = 4;

%% create triangles_0
triangles_0 = {};
triangle = [];
colors_0 = [];
r = 1;
for i = 1:n_cake
    VA = [0 0];
    VB = [cos((2*i-1)*pi/10),sin((2*i-1)*pi/10)];
    VC = [cos((2*i+1)*pi/10),sin((2*i+1)*pi/10)];
    triangle = [VB;VA;VC];
    
    if mod(i,2)==1
        triangle = [VC;VA;VB];
    end
    
    color = 1;
    
    triangles_0 = [triangles_0,triangle];
    colors_0 = [colors_0,color];
end

for n_iterations = 1:4
    %% subdivide triangles_0
    triangles = {};
    colors = [];
    for i = 1:n_cake
        
        triangles_k = {};
        colors_k = [];
        triangles_i = triangles_0(i);
        colors_i = colors_0(i);
        
        for k = 1:n_iterations
            triangles_k = {};
            colors_k = [];
            triangle_H = {};
            color_H = [];
            for j = 1:size(triangles_i,1)
                triangle_j = triangles_i{j};
                if colors_i(j) == 1
                    P = triangle_j(2,:)+(triangle_j(1,:)-triangle_j(2,:))/phi;
                    triangle_split = {[triangle_j(3,:);P;triangle_j(2,:)];...
                        [P;triangle_j(3,:);triangle_j(1,:)]}; %(CPA)(PCB)
                    color_split = [2;1];
                    
                else
                    Q = triangle_j(1,:)+(triangle_j(2,:)-triangle_j(1,:))/phi;
                    R = triangle_j(1,:)+(triangle_j(3,:)-triangle_j(1,:))/phi;
                    triangle_split = {[R;Q;triangle_j(1,:)];...
                        [Q;R;triangle_j(2,:)];...
                        [triangle_j(3,:);R;triangle_j(2,:)]}; %(RQB)(QRA)(CRA)
                    color_split = [2;1;2];
                end
                triangle_H = [triangle_H;triangle_split];
                color_H = [color_H;color_split];
            end
            triangles_k = [triangles_k;triangle_H];
            colors_k = [colors_k;color_H];
            
            triangles_i = triangles_k;
            colors_i = colors_k;
            
        end
        
        triangles = [triangles,triangles_i];
        colors = [colors,colors_i];
    end
    
    %% rectangle
    rectangles = cell(size(triangles));
    bcenters = cell(size(triangles));
    for i = 1:n_cake
        for j = 1:size(triangles,1)
            triangle_ji = triangles{j,i};
            bcenter = (triangle_ji(1,:)+triangle_ji(3,:))/2;
            r1 = (triangle_ji(1,:)+triangle_ji(2,:))/2;
            r2 = (triangle_ji(3,:)+triangle_ji(2,:))/2;
            vect_13 = 2*(bcenter-r1);
            vect_24 = 2*(bcenter-r2);
            r3 = r1 + vect_13;
            r4 = r2 + vect_24;
            rectangles{j,i} = [r1;r2;r3;r4];
            bcenters{j,i} = bcenter;
        end
    end
    
    %% figure settings
    figure
    axes('Units', 'normalized', 'Position', [0 0 1 1]);
    hold on
    axis off
    xlim([-1.1 1.1]);
    ylim([-1.1 1.1]);
    set(gcf,'Position',[200,100,600,600])
    
    %% patch triangle
    color_1 = sscanf('FFFFEE','%2x%2x%2x',[1 3])/255;
    color_2 = sscanf('F0E0D6','%2x%2x%2x',[1 3])/255;
    
    for i = 1:n_cake
        for j = 1:size(triangles,1)
            
            triangle_ji = triangles{j,i};
            bcenter_ji = bcenters{j,i};
            r_ji = sqrt(sum(bcenter_ji.^2));
            
            if r_ji>=1/3
                if colors(j,i) == 1
                    %patch(triangle_ji(:,1),triangle_ji(:,2),color_1)
                else
                    %patch(triangle_ji(:,1),triangle_ji(:,2),color_2)
                end
            end
        end
    end
    
    %% patch rectangle
    color_r1 = sscanf('002269','%2x%2x%2x',[1 3])/255;
    color_r2 = sscanf('002269','%2x%2x%2x',[1 3])/255;
    
    for i = 1:n_cake
        for j = 1:size(rectangles,1)
            
            rectangle_ji = rectangles{j,i};
            bcenter_ji = bcenters{j,i};
            r_ji = sqrt(sum(bcenter_ji.^2));
            
            if r_ji>=1/3
                if colors(j,i) == 1
                    patch(rectangle_ji(:,1),rectangle_ji(:,2),color_r1)
                else
                    patch(rectangle_ji(:,1),rectangle_ji(:,2),color_r2)
                end
            end
        end
    end
    
    %% save figure
%     filename = ['ichimatsu',num2str(n_iterations,'%.0f'),'.tif'];
%     saveas(gcf,filename)
end