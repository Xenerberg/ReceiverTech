function noise = AWGN( meu,stdev,num )

noise = meu + stdev.*randn(1,num);

end

% http://www.dspguru.com/dsp/howtos/how-to-generate-white-gaussian-noise   
% http://www.gaussianwaves.com/2010/01/central-limit-theorem-2/

% X=0;
%    for i = 1:num
%       X = randn(1,num); 
%    end	
%    X = X - num/2;               % set mean to 0 */
%    X = X * sqrt( 12 / num);      % adjust variance to 1 */
% 
%    noise = meu + (stdev * X);