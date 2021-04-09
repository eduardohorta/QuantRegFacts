$$
\newcommand{\Prob}{\mathbb{P}}
\newcommand{\E}{\mathbb{E}}
\newcommand{\dd}{\mathrm{d}}
$$

## A tentative global estimator

To illustrate, let us first consider the univariate scenario. For a random variable $Y$ with cdf $F$, let $\beta = F^{-1}$ denote its quantile function. Represent $\beta$ through
$$
\beta(\tau) = \sum_k \alpha_k\varphi_k(\tau),\quad\tau\in[0,1]
$$
for a sequence $(\alpha_k)$ satisfying $\sum_k \alpha_k^2<\infty$ (that is, $\alpha\in \ell^2$) and where $(\varphi_k)$ is an orthonormal basis in $L^2[0,1]$. We know that 
$$
\int_0^1\E\rho_\tau(Y-\beta(\tau))\,\dd \tau \le \int_0^1\E\rho_\tau(Y - q(\tau))\,\dd\tau\tag{1}
$$
for any candidate quantile function $q(\cdot)$. This suggests that we can estimate $\beta$ by minimizing a sample analogue of the RHS in $(1)$.

For each fixed $\tau$, we estimate $\beta(\tau)$ by minimizing, wrt to $b\in\R$, the loss function
$$
\hat R_h(b,\tau):=\frac1n\sum_{i=1}^n \rho_{\tau,h}(Y_i-b)
$$
where $\rho_{\tau,h} = K_h'*\rho_\tau$ for some nice kernel $K_h'$.

Given a candidate quantile function $b(\cdot)$, which we represent through
$$
b(\tau) = \sum_k a_k\varphi_k(\tau),\quad\tau\in[0,1],
$$
for some sequence $a\in\ell^2$, let
$$
\hat L_h(a) = \int_0^1R_h\Big(\sum\nolimits_ka_k\varphi_k(\tau),\tau\Big)\,\dd\tau.
$$
Because of equation $(1)$, it makes sense to estimate $\alpha$ by minimizing $\hat{L}_h$ wrt $a\in\ell^2$. Now, we have
$$
\frac{\partial}{\partial a_r} \hat L_h(a) = -\frac1n\sum_{i=1}^n \int_0^1 \varphi_r(\tau)\ \rho_{\tau,h}'\big(Y_i-\sum\nolimits_k a_k\varphi_k(\tau)\big) \, \dd\tau
$$
and, assuming symmetry of $K_h'$,
$$
\rho_{\tau,h}'(u) = \tau-1 + K_h(u) = \tau - K_h(-u), \quad u\in\R,
$$
which leaves us with
$$
\frac{\partial}{\partial a_r} \hat L_h(a) = \frac1n\sum_{i=1}^n \int_0^1 \left(K_h\big(\sum\nolimits_k a_k\varphi_k(\tau) - Y_i\big) - \tau \right)\varphi_r(\tau) \, \dd\tau.
$$
In order to minimize $\hat{L}_h(\cdot)$ with respect to $a\in\ell^2$, we have thus to match the coefficients $(a_k)$ such that the equality
$$
\int_0^1 \varphi_r(\tau)\ \bar{K}_h(a)\,\dd\tau = \int_0^1\tau\ \varphi_r(\tau)\,\dd\tau
$$
holds for each $r$, where $\bar{K}_h(a) = n^{-1}\sum_{i=1}^n K_h(b(\tau)-Y_i)$. Since the above equation may not have a solution, one possibility is to choose $a\in\ell^2$ to minimize
$$
\int_0^1 \left|\bar{K}_h(a) - \tau \right|^2\,\dd\tau
$$
My idea is that, in a multivariate context (where we would have $d$ sequences $(a^1_k),\dots,(a^d_k)$, one for each component of $b(\cdot)$), it is possible to implement a global (across quantile levels) variable selection by penalizing the $\ell^1$ norms of the coefficient sequences $(a^j_k)$. Of course, the Fourier series are going to be truncated at some large $\bar{k}$, but penalization may play a role here too. Also, the integrals have to be computed numerically (I played for a while to see if I could find some elegant analytical representation, but that would be too good to be true).