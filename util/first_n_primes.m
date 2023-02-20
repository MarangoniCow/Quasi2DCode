function primes = first_n_primes(n)
% This function returns the first n prime digits.
primes = [];
i = 2;
while numel(primes) < n
    if isprime(i) && all(isprime(str2double(num2str(i)')))
        primes = [primes, i];
    end
    i = i + 1;
end
end
