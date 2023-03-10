function [fitresult, gof] = maxwelldelayfit(t, gate74_3mm)
%CREATEFIT(T,GATE74_3MM)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : t
%      Y Output: gate74_3mm
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 13-Jan-2016 14:19:30


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( t, gate74_3mm );

% Set up fittype and options.
ft = fittype( '(a./(x-d)-v).^2.*exp(-(b./(x-d)).^2)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Robust = 'Bisquare';
opts.Lower = [10 0 -10 -10];
% opts.StartPoint = [0.88186650045181 0.669175304534394 0.190433267179954
% 0.368916546063895]; Phenylalanine
% opts.StartPoint = [0.485375648722841 0.8002804688888 0.141886338627215 0.421761282626275];%Adenine at 0.4 mJ
% opts.StartPoint = [0.915735525189067 0.792207329559554 0.959492426392903 0.655740699156587];%Adenine at 1000 uJ
opts.StartPoint = [0.340385726666133 0.585267750979777 0.223811939491137 0.751267059305653];%Glycine at 0.3 mJ

opts.Upper = [10000 200 20 1000];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
plot(t,gate74_3mm,'o','markersize',6);
hold on;
h = plot( fitresult );
legend( 'gate74_3mm vs. t', 'untitled fit 1', 'Location', 'NorthEast' );
% Label axes
xlabel( 't' );
ylabel( 'gate74_3mm' );
grid on


