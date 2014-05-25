simulate =
function(n = 10, N = 100, T = mean, 
	 distribution = "rnorm")
{

  if(exists(distribution, mode = 'function')) {
     distribution = get(distribution, mode = "function")
  } else {
     distribution = eval(parse( text = distribution))
  }

  if(is.character(T)) {
     if(exists(T, mode = "function"))
        T = get(T, mode = "function")
     else
        T = eval(parse( text = T))
  }
  
  sapply(1:N,
          function(i)	 {
             T(distribution(n)) 
          })
}
		