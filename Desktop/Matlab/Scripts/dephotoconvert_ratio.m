function [return_value] = dephotoconvert_ratio(MRLC_filename, pMRLC_filename, fib_filename, Z)

dephotoconvert(['SUM_' MRLC_filename], ['SUM_' fib_filename], ['bg_' 'SUM_' MRLC_filename], ['bg_' 'SUM_' fib_filename], MRLC_filename, fib_filename);
dephotoconvert(['SUM_' pMRLC_filename], ['SUM_' fib_filename], ['bg_' 'SUM_' pMRLC_filename], ['bg_' 'SUM_' fib_filename], pMRLC_filename, fib_filename);
get_ratio(['pcc_' MRLC_filename], ['pcc_' pMRLC_filename], Z);

