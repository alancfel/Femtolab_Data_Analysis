function [xfigure, yfigure, zfigure] = extracty(handle,errorbarplot)
%function [xfigure, yfigure] = extracty(handle);handle is the handle of the
%figure you want extract data. The function will return the x data
%(xfigure) and y data (yfigure). Set errorbarplot = 1 to extract the
%errorbar data.
axs = get(handle,'Children');
% you may have to start poking around at the different axs(n) to get the right one
pos = get(axs(1),'Children');
% same with the pos(n), especially if you labelled your plots or have more than one line
xfigure = get(pos(1),'Xdata');
yfigure = get(pos(1),'Ydata');
if errorbarplot == 1
    zfigure = get(pos(1),'Udata');
else
    zfigure = [];
end