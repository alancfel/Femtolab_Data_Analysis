% axes(handles.axes1);
legend(handles.axes1, 'show');
hLegend = findall(gcf,'tag','legend');
uic = get(hLegend,'UIContextMenu');
uimenu_refresh = findall(uic,'Label','Refresh');
callback = get(uimenu_refresh,'Callback');
hgfeval(callback,[],[]);