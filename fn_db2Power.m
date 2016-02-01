function [power] = fn_db2Power(p_db)
    power = 10.^(p_db/10);
end