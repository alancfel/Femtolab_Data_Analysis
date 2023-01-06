function a = spatialprofilegif(dis,t1_1726,data,filename)
%laserin is to calculate the peak intensity of the fs laser. pein is the
%peak intensity of laser with unit of W/cm2;
%fwhm is full width half maximum of the pulse duration with unit of fs; powe is the power of the laser with unit of mW; 
%focusdi is the foucus diameter of the spot size with unit of um; 

% pein = powe*1e12/(fwhm*pi*(0.5*focusdi*1e-4).^2);
a = size(data);
% for i = 1:(length(t_fit)-1)/10
%     for j = 1:a(1)
%         datasum = sum(data(:,(i*10-9):(10*i)),2);
%         namex(:,j,i) = dtn*datasum(j)/max(dtn);
% %     [namex((i-loopa)/loopst+1,:), namey((i-loopa)/loopst+1,:)] = delayscanderive(i,t_fit,dtn,dire,vt1_165,vt2_165);
%     end
% end
Fig2 = figure;%('PaperSize',[8.267716 15.692913]);
% set(Fig2, 'Position', [80,100,1000,620]);
set(Fig2, 'Position', [80,100,4000,600]);
set(Fig2, 'color', 'w');
for n = 1:1:a(3)
        delete(findall(findall(Fig2,'Type','axe')));%,'Type','text'))
%         set(handles.previous,'string',sprintf('%d',n));
%         previous_Callback(handles.previous, eventdata, handles)
        new_axes = imagesc(dis,t1_1726,data(:,:,n)); %copyobj(handles.axes1, Fig2);
%         new_axes = surf(dis,t1_1726,data(:,:,n)); shading interp;%copyobj(handles.axes1, Fig2);
        bar = colorbar;
        set(bar,'fontsize',14)
        ylabel(bar,'Normalized parent ion yields (arb.units)');
%         new_axes = pcolor(dis,t1_1726,data(:,:,n)); shading interp;
%         set(new_axes, 'Units', 'Normalized', 'Position', 'default');
%         grid(new_axes, 'off')
        set(gca,'fontsize',20);
        ylabel('Lens vertical position (mm)', 'FontSize', 20);
        xlabel('Distance between foil band and interaction point (mm)', 'FontSize', 20);
%         hay = get(new_axes,'Ylabel');
%         hax = get(new_axes,'Xlabel');
%         NewFontSize = 20;
%         set(hay,'Fontsize',NewFontSize);
%         set(hax,'Fontsize',NewFontSize);
        set(Fig2, 'PaperpositionMode', 'auto');
%         hgca = findobj(Fig2,'Type','line','visible','on');
%         set(hgca,'Color','b');
%         ylim(new_axes,'auto');
%         if xaxis == 1 && length(las) == length(xlabel2)
            %             title(new_axes,strcat(sprintf('Desorption laser energy at %2.2f',las(n)),{' '},'mJ'));
            title(gca,strcat(sprintf('%d',n),' \mus',' delay after desorption laser'),'fontsize',20);
%         else
            %             title(new_axes,strcat(xname,{' '},sprintf('at %d',xlabel2(n))));
%             title(new_axes,sprintf(xname,xlabel2(n)));
%         end
        drawnow
        frame = getframe(1);
        im = frame2im(frame);
        [A,map] = rgb2ind(im,256);
        if n == 1;
            imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.1);
        else
            imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.1);
        end
end