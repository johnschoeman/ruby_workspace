def tail_fact(n, acc=1)
  return acc if n <= 1
  tail_fact(n-1, n*acc)
end

def fact(n)
  return 1 if n <= 1
  n * fact(n-1)
end