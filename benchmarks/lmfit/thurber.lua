
local t = gsl.vector {
      -3.067E0,
      -2.981E0,
      -2.921E0,
      -2.912E0,
      -2.840E0,
      -2.797E0,
      -2.702E0,
      -2.699E0,
      -2.633E0,
      -2.481E0,
      -2.363E0,
      -2.322E0,
      -1.501E0,
      -1.460E0,
      -1.274E0,
      -1.212E0,
      -1.100E0,
      -1.046E0,
      -0.915E0,
      -0.714E0,
      -0.566E0,
      -0.545E0,
      -0.400E0,
      -0.309E0,
      -0.109E0,
      -0.103E0,
       0.010E0,
       0.119E0,
       0.377E0,
       0.790E0,
       0.963E0,
       1.006E0,
       1.115E0,
       1.572E0,
       1.841E0,
       2.047E0,
       2.200E0 }

local F = gsl.vector {
      80.574,
      84.248,
      87.264,
      87.195,
      89.076,
      89.608,
      89.868,
      90.101,
      92.405,
      95.854,
     100.696,
     101.060,
     401.672,
     390.724,
     567.534,
     635.316,
     733.054,
     759.087,
     894.206,
     990.785,
    1090.109,
    1080.914,
    1122.643,
    1178.351,
    1260.531,
    1273.514,
    1288.339,
    1327.543,
    1353.863,
    1414.509,
    1425.208,
    1421.384,
    1442.962,
    1464.350,
    1468.705,
    1447.894,
    1457.628 }

local x0 = gsl.vector { 1000, 1000, 400, 40, 0.7, 0.3, 0.03 }

local x = gsl.vector {
			  1.2881396800E+03,
			  1.4910792535E+03,
			  5.8323836877E+02,
			  7.5416644291E+01,
			  9.6629502864E-01,
			  3.9797285797E-01,
			  4.9727297349E-02 }

local function iter()
   local i, n = 0, #F
   return function()
	     i = i + 1
	     if i <= n then
		return t[i], F[i]
	     end
	  end
end

return {title = 'Thurber dataset',
	iter= iter,
	N= 37, P= 7,
        t= t, F= F, x0= x0, xref= x,
        t0= -3.1, t1= 2.2 }
