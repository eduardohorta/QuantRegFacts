$$
\newcommand{\bs}{\boldsymbol}
\newcommand{\wh}{\widehat}
\newcommand{\R}{\mathbb{R}}
$$

Consider a random variable $Y$ and a $D$-dimensional random vector $X$ such that 
$$
Q(\tau | x) = x'\beta(\tau)
$$
for $\tau\in(0,1)$ and $x\in\mathrm{support}(X)$, where $\beta$ is a smooth function and where
$$
Q(\tau|x):=\inf\{y\in\R : F(y|x)\ge\tau\},
$$
$F(\cdot|x)$ being the conditional cdf of $Y$ given $X=x$.



Given a random sample $(X_n,Y_n)_{n=1}^N$ from $(X,Y)$, consider now a grid
$$
0<\tau_1\le\tau_2\le\cdots\le\tau_M<1
$$
(possibly depending on $N$) and let $\varphi_1,\varphi_2,\dots,\varphi_L$ be an orthonormal set in $\R^M$ (also possibly depending on $N$), with $L\le M$. Let
$$
\bs{\beta} = \begin{pmatrix}
\beta_1(\tau_1) & \beta_1(\tau_2) & \cdots & \beta_1(\tau_M)\\
\beta_2(\tau_1) & \beta_2(\tau_2) & \cdots & \beta_2(\tau_M)\\
\vdots & \vdots & \ddots & \vdots\\
\beta_D(\tau_1) & \beta_D(\tau_2) & \cdots & \beta_D(\tau_M)\\
\end{pmatrix}
$$
It is known that, given any $D\times M$ matrix $B$ with columns $b_m\in\R^D$, for $m=1,\dots,M$, one has
$$
R(\bs{\beta})\le R(B),
$$
where
$$
R(B) = \sum_{m=1}^M\sum_{n=1}^N \rho_{\tau_m}(Y_n - X_n'b_m)
$$
with $2\rho_\tau(z) := (2\tau-1)z + |z|$ for $z\in\R$ and $\tau\in(0,1)$.

Now, if $\tau\mapsto\beta(\tau)$ is smooth and if $\varphi_1,\dots,\varphi_L$ is chosen adequately, then we have
$$
\bs{\beta}\approx \bs{\alpha\varphi}
$$
for some $D\times L$ matrix $\bs\alpha$,  where $\bs{\varphi}$ is the $L\times M$ matrix with rows $\varphi_\ell$. This suggests estimating $\bs{\beta}$ by finding a $D\times L$ matrix $\wh{\bs\alpha}$ to solve the optimization problem
$$
\min_{\bs{a}} \sum_{m=1}^M\sum_{n=1}^N\rho_{\tau_m}(Y_n - X_n'\bs{a}\phi_m)
$$
where $\phi_m$ is the $m$th column of $\bs{\varphi}$. Letting $\bs{\eta}$ denote an $N\times M$ matrix with positive entries, the above minimum can alternatively be written as
$$
\min_{\bs {a}} \min_{\bs{\eta}} R(\bs{a},\bs{\eta})
$$
where
$$
2R(\bs{a},\bs{\eta}) := \sum_{m=1}^M\sum_{n=1}^N (2\tau_m-1)(Y_n-X_n'\bs{a}\phi_m) + \frac12\left[\frac{(Y_n - X_n'\bs{a}\phi_m)^2}{\eta_{nm}} + \eta_{nm}\right]
$$
The first order conditions are given by the $D\times L$ system of linear equations
$$
\sum_{m}\sum_n \frac{Y_n-X_n'\bs{a}\phi_m}{\eta_{nm}}X_n\phi_m'=\sum_m\sum_n(1-2\tau_m)X_n\phi_m'\tag{1}
$$
and the $N\times M$ equalities
$$
\eta_{nm} = |Y_n - X_n'\bs{a}\phi_m|\tag{2}
$$
This can be extended to include lasso-type penalties, for example by letting $\bs{\zeta}$ denote a $D\times M$ matrix and writing
$$
R_\lambda(\bs{a},\bs{\eta},\bs{\zeta}) = R(\bs{a},\bs{\eta}) + \lambda\sum_{\ell=1}^L\sum_{d=1}^D\frac12\left[\frac{a_{d\ell}^2}{\zeta_{d\ell}}+\zeta_{d\ell}\right]
$$
where $\lambda>0$. The first order conditions for minimizing $R_\lambda$ are given by 

1. a slightly modified version of $(1)$,
2. equation $(2)$ as is, and
3.  the $D\times L$ equalities

$$
\zeta_{d\ell} = |a_{d\ell}|.
$$

I asked my student to minimize $R_\lambda$ using the CVXR package (not very efficient, and in particular it does not use the FOCs). The preliminary results are very interesting. We are using as basis vectors the $\varphi_1,\dots,\varphi_L$ resulting from application of a Gram-Schmidt algorithm to the set $\{\tilde{\varphi}_1,\dots,\tilde{\varphi}_L\}\subseteq\R^M$ given by
$$
\tilde{\varphi}_\ell' = \begin{pmatrix}
\tau_1^{\ell-1} & \cdots & \tau_M^{\ell-1}
\end{pmatrix},\qquad \qquad\ell=1,\dots,L
$$
One idea that she still has to implement is to only penalize the first two rows of $\bs{a}$. The heuristic is that most of the $L^1$ norm of $\tau\mapsto\beta_d(\tau)$ comes from the the first two terms in its polynomial representation (constant term and linear term). This may facilitate variable selection. Other possibility is to force $a_{d,\ell+1}\le a_{d,\ell}$ but I don't know how to do this.



Since the CVXR approach is very inefficient, I am thinking about an algorithm similar to the Lejeune-Sarda one (which is relatively fast). For clarity, let us forget about the lasso penalty for a while. The algorithm goes as follows:

0. Initialize $\bs{\eta}^0$ arbitrarily.
1. Given the value $\bs{\eta}^r$ of the $r$-th iteration, find a solution $\bs{a}^{r+1}$ for equation $(1)$ with $\eta_{nm}^r$ in place of $\eta_{nm}$.
2. Set $\eta_{nm}^{r+1} = \max\{\pi,|Y_n - X_n'\bs{a}^{r+1}\varphi_m|\}]$, where $\pi>0$ is a precision parameter.
3. Iterate steps 1-2 until some convergence criterion has been met.

The problem is that I got stuck with equation $(1)$: ideally it should be possible to arrive at an expression of the form
$$
\bs{a} = {\bs{U}}^{-1}\bs{V}\bs{Y}
$$
for some $D\times D$ matrix $U$, some $D\times N$ matrix $\bs{V}$ and where
$$
\bs{Y} = \begin{pmatrix}
Y_1 & Y_1 & \cdots & Y_1\\
Y_2 & Y_2 & \cdots & Y_2\\
\vdots & \vdots & \ddots & \vdots\\
Y_N & Y_N & \cdots & Y_N
\end{pmatrix}\qquad(N\times L)
$$
Unfortunately, it seems that my Linear Algebra skills are somewhat rusty, so I couldn't “isolate $\bs{a}$ in the LHS”. Any help here would be highly welcome.

---

In paralell, I ran a small Monte Carlo simulation of the Lejeune-Sarda algorithm from your proposal (notice that it is very similar to the above with $L=M$ and $\varphi_1,\dots,\varphi_L$ the canonical basis for $\R^M$).  I'll wrap up a summary and send them to you later this week.



---

Again, let us forget about the lasso penalty for a while. The algorithm goes as follows:

0. Initialize $\bs{\eta}^0$ and $\bs{a}^0$ arbitrarily.

1. Given the values $\bs{\eta}^r$ and $\bs{a}^r$ of the $r$-th iteration, compute the solutions
   $$
   \bs{b}_m^{r+1} = (\mathbf{X}_{m,r}'\mathbf{X})^{-1}\big(\mathbf{X}_{m,r}'\mathbf{Y} + (2\tau_m-1)\bar{X}\big)
   $$
   for $m=1,\dots,M$ (relatively slow – for a grid of $\tau$'s with $M$ points this means $M$ matrix inversions), where
   $$
   \mathbf{X} = \begin{pmatrix}
   X_1'\\
   \vdots\\
   X_N'
   \end{pmatrix}
   $$
   and where the component $n,d$ of $\mathbf{X}_{m,r}$ is
   $$
   [\mathbf{X}_{m,r}]_{n,d} = \frac{\mathbf{X}_{n,d}}{\bs{\eta}^r_{n,m}}
   $$

2. Let $\mathbf{B}^{r+1} = \begin{pmatrix} \bs{b}_1^{r+1} & \cdots & \bs{b}_M^{r+1}\end{pmatrix}$ and compute $\bs{a}^{r+1} = \mathbf{B}^{r+1}\bs{\varphi}'$

3. Set $\eta_{nm}^{r+1} = \max\{\pi,|Y_n - X_n'\bs{a}^{r+1}\varphi_m|\}]$, where $\pi>0$ is a precision parameter.

4. Iterate steps 1-3 until some convergence criterion has been met.

