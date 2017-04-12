library(rethinking)
library(brms)
library(rstan)
model_string = "
data  {
   int<lower=0> N;
   int<lower=0> density[N]; 
   int<lower=0> y[N];
   int<lower=0> tank[N];
}

parameters  {
    real a[N];
    real<lower=0, upper=1> theta;
}

model {
    target += binomial_lpmf(y|density, theta);
    target += log_inv_logit(a[tank]); # note this is not
    target += normal_lpdf(a[tank]| 0, 5);
    #theta ~ inv_logit(a[tank]);
    #a[tank] ~ normal(0, 5);
}

"
reedfrogs$tanks = 1:nrow(reedfrogs)
data_list = list(
                 N=nrow(reedfrogs), 
                 density = reedfrogs$density, 
                 y=reedfrogs$surv,
                 tank=reedfrogs$tank)
stan_samples = stan(model_code = model_string, data = data_list)
