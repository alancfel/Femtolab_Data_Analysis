function y = SFGWLfit(x,A01,w01,G01,A02,w02,G02)
%EXP_CONV(x,t,S) calc the 1-D convolution of a Gaussian and a exp func (analytically).
%   t -- decay time, or time constant in exp(-x/t)
%   S -- sigma of the Gaussian
y = (A01)./(x-(w01)+1i*(G01))+(A02)./(x-(w02)+1i*(G02));
end