function [vm,v,Nv_273] = plotmax_well(m, T_neutrons,dimension)

% m= 29.0;            % amu air = 29
% M= 0.029;
M = m/1000;         % kg/mol air = 0.029
% T_neutrons= 273; 	% kelvin
k= 1.38066E-23; 	% Boltzmann constant in J/K
R= 8.31446;          % universal gas constant = kN(A) in J/mol K
vprob_273=sqrt(2*R*T_neutrons/M);	% m/s
v=0:10:5*vprob_273;	% create a molecular speed variable of decent range

if dimension == 3
    Nv_273=4*pi*(M/(2*pi*R*T_neutrons))^1.5*v.^2.*exp(-M*v.^2/(2*R*T_neutrons));% 3-dimension velocity distribution
else if dimension == 2
        Nv_273=2*pi*(M/(2*pi*R*T_neutrons))^1*v.^1.*exp(-M*v.^2/(2*R*T_neutrons));% 2-dimension velocity distribution
    else if dimension == 1
            Nv_273=(M/(2*pi*R*T_neutrons))^0.5.*exp(-M*v.^2/(2*R*T_neutrons)); %1-dimension velocity distribution
        else
            fprinft('Dimension input is wrong!It should be 1, 2 or 3.')
        end
    end
end
% Nv_323=4*3.14*(M/(2*3.14*R*323))^1.5*v.^2.*exp(-M*v.^2/(2*R*323));

figure;
set(gca,'fontsize',20);
set(gcf, 'Position', [160,200,700,62*7]);
plot(v,Nv_273,'.','markersize',8);
% title('Maxwell-Boltzmann Distribution of Thermal Neutron Velocities');
xlabel('Velocity [m s^{-1}]');
ylabel('N(v)dv');
% hold on;
% plot(v,Nv_323,'*');
% legend('T=273K','T=323K');
vm = vprob_273;
end