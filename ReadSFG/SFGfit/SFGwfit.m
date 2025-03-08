function y = SFGwfit(x,A01,f,w01,G01)
%EXP_CONV(x,t,S) calc the 1-D convolution of a Gaussian and a exp func (analytically).
%   t -- decay time, or time constant in exp(-x/t)
%   S -- sigma of the Gaussian
y = (A01).*exp(1i*f)./(x-(w01)+1i*(G01));
end