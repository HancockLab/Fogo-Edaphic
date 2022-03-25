import matplotlib
matplotlib.use('Agg')
import sys
import dadi
import numpy
import pylab
import demographic_models

from numpy import array

res0=sys.argv[3]

if sys.argv[2] == "exp":
    print(sys.argv[2])
    
    params = array([0.5, 1, 1, 2])
    upper_bound = [1.0, 20, 20, 10]
    lower_bound = [0, 1e-3, 1e-3, 0]
    
    func = demographic_models.pop_splitExp
    res=res0 + "/splitExp_cvi_"

elif sys.argv[2] == "pop_split":
    print('pop_split')
    params = array([1, 1, 2])
    upper_bound = [10, 10, 10]
    lower_bound = [1e-3, 1e-3, 0]
    
    func = demographic_models.pop_split
    res=res0 + "/pop-split_cvi_"

elif sys.argv[2] == "im":
    params = array([0.5, 1, 1, 2, 1, 1])
    upper_bound = [1, 10, 10, 10, 20, 20]
    lower_bound = [0, 1e-3, 1e-3, 0, 0, 0]
    
    func = demographic_models.IM
    res=res0 + "/im_cvi_"

elif sys.argv[2] == "bottleneck":
    params = array([1, 1, 1, 2.5, 2])
    upper_bound = [10, 10, 10, 10, 10]
    lower_bound = [1e-3, 1e-3, 1e-3, 0, 0]

    func = demographic_models.bottleneck
    res=res0 + "/bottleneck_cvi_"

elif sys.argv[2] == "bottleneck_twoSides":
    params = array([1, 1, 1, 1, 2.5, 2])
    upper_bound = [10, 10, 10, 10, 10, 10]
    lower_bound = [1e-3, 1e-3, 1e-3, 1e-3, 0, 0]

    func = demographic_models.bottleneck_twoSides
    res=res0 + "/bottleneck-2sides_cvi_"



# Redirect stdOut
# f=open(res + "dadiResults_rep" + str(sys.argv[1]) + ".txt", 'w+')
# sys.stdout = open(res + "log_rep" + str(sys.argv[1]) + ".txt", 'w+')





data = dadi.Spectrum.from_file(sys.argv[4])
ns = data.sample_sizes
# print(ns)
pts_l = [40, 50, 60]

#data1 = data.marginalize([0])

# Fold it or not?
#
# data1 = data.fold()
# data=data1

print(data)
data.mask[0,0]
# data.mask[ns[0],ns[1]]




func_ex = dadi.Numerics.make_extrap_log_func(func)


p0 = dadi.Misc.perturb_params(params, fold=1, upper_bound=upper_bound, lower_bound=lower_bound)                 # fold=1 is folded think
popt = dadi.Inference.optimize_log(p0, data, func_ex, pts_l,
                                   lower_bound=lower_bound,
                                   upper_bound=upper_bound,
                                   verbose=len(params),
                                   maxiter=30)
#popt = dadi.Inference.optimize_log_fmin(p0, data, func_ex, pts_l,
#                                   lower_bound=lower_bound,
#                                   upper_bound=upper_bound,
#                                   verbose=len(params),
#                                   maxiter=50)

print 'Optimized parameters', repr(popt)
s_model = func_ex(popt, ns, pts_l)

# print('model:')
# print(s_model)

##
#	For every other model
##
ll_opt = dadi.Inference.ll_multinom(s_model, data)

##
#	Just for fixed theta
##
#ll_opt = dadi.Inference.ll(s_model, data)


###
#       Printing out results
###
# ${i}"\t"${ll}"\t"${theta}"\t"${params}
f=open(res + "rep" + str(sys.argv[1]) + ".txt", 'w+')

s_theta = dadi.Inference.optimal_sfs_scaling(s_model, data)
f.write(str(sys.argv[1]) + "\t" + str(ll_opt) + "\t" + str(s_theta) + "\t")

for w in popt:
 s = str(w)
 f.write(s + "\t")
f.write('\n')
f.close()



print 'Optimized log-likelihood:', ll_opt

# s_theta = dadi.Inference.optimal_sfs_scaling(s_model, data)
# print 'Theta: ', s_theta

# f=open(res + "ll_rep" + str(sys.argv[1]) + ".txt", 'w+')
# print >> f, ll_opt

# f2 = open(res + "theta_rep" + str(sys.argv[1]) + ".txt", 'w+')
# print >> f2, s_theta

# f3 = open(res + "param_rep" + str(sys.argv[1]) + ".txt", 'w+')

# for w in popt:
#  s = str(w)
#  f3.write(s+"\t")
# f3.write('\n')
# f3.close()



###
#	Just to plot
###

pylab.figure(figsize=(9, 9), dpi=300)
dadi.Plotting.plot_1d_comp_multinom(s_model.marginalize([0]), data.marginalize([0]))
# dadi.Plotting.plot_2d_comp_multinom(s_model, data, vmin=1, resid_range=3, pop_ids =('Santo Antao', 'Fogo'))
# pylab.show()
pylab.savefig(res + 'marginal0_rep' + str(sys.argv[1]) + '.png',dpi=300)

pylab.figure(figsize=(9, 9), dpi=300)
dadi.Plotting.plot_1d_comp_multinom(s_model.marginalize([1]), data.marginalize([1]))
pylab.savefig(res + 'marginal1_rep' + str(sys.argv[1]) + '.png',dpi=300)

pylab.figure(figsize=(9, 9), dpi=300)
dadi.Plotting.plot_2d_comp_multinom(s_model, data, vmin=1, resid_range=3, pop_ids =('Population 1', 'Population 2'))
pylab.savefig(res + '2d_rep' + str(sys.argv[1]) + '.png',dpi=300)






#  pylab.figure(figsize=(9, 9), dpi=300)
# dadi.Plotting.plot_1d_comp_multinom(s_model, data)
# dadi.Plotting.plot_2d_comp_multinom(s_model, data)
# dadi.Plotting.plot_3d_comp_multinom(s_model, data, vmin=1, resid_range=3, pop_ids =('Ca','Mo', 'Ib'))
# pylab.savefig(res + str(sys.argv[1]) + '.png',dpi=300)
