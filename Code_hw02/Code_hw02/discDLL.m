function [ dll_env,dll_pow,dll_quasi,dll_coh ] = discDLL( eI, eQ, pI, pQ, laI, laQ )

pImax = abs(max(eI(:)));

E = sqrt(eI.^2 + eQ.^2);
L = sqrt(laI.^2 + laQ.^2);

dll_env = 0.5 * (E-L) ./ (E+L);
dll_pow = 0.5 * (E.^2 - L.^2) ./ (E.^2 + L.^2);
dll_quasi = 0.5 * ( (eI - laI).*pI + (eQ - laQ).*pQ ) / (pImax^2);
dll_coh = 0.5 * (eI - laI) .* pI / (pImax^2);

end