function [ noise ] = AWGN( mean, std, num )
    noise = mean + std*randn([num,1]);
end

