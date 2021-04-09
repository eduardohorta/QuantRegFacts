Seja $(X_n)_{n\ge0}$ uma cadeia de Markov no espaço de estados $S=\{0,1\}$ com distribuição inicial $\lambda_X$ e matriz de transição
$$
P = \begin{pmatrix}
p_{00} & p_{01}\\
p_{10} & p_{11}
\end{pmatrix}
$$

Seja também $(Y_n)_{n\ge0}$ um processo estocástico (não sabemos ainda se é Markoviano) no espaço de estados $S$ com distribuição inicial $\lambda_Y$ e tal que, para $\tau\in(0,1)$ e $n\ge0$, valha
$$
Q_{Y_{n+1}}(\tau\,|\,\mathfrak{F}_n) = \beta_0(\tau) + \beta_1(\tau)Y_n + \beta_2(\tau)X_n + \beta_3(\tau)X_nY_n
$$
onde $\mathfrak{F}_n = \sigma\big(X_t,Y_t:\,t\le n\big)$ e onde, para $\tau\in(0,1)$, os coeficientes $\beta_j$ são definidos por
\begin{align*}
\beta_0(\tau) &= \mathbb{I}_{[1/4\le \tau<1]}\\
\beta_1(\tau) &= \mathbb{I}_{[1/4\le\tau<1/2]}\\
\beta_2(\tau) &= \mathbb{I}_{[1/4\le\tau<1/2]}\\
\beta_2(\tau) &= \mathbb{I}_{[1/4\le\tau<1/2]} - \mathbb{I}_{[1/2\le\tau<3/4]}.
\end{align*}

\begin{enumerate}
\item Mostre que, condicional em $\mathfrak{F}_n$, a variável aleatória $Y_{n+1}$ tem distribuição $\mathrm{Bernoulli}(V_n)$, onde 
\begin{equation*}
V_n = \begin{cases}
1/4 & \text{se $X_n=0$ e $Y_n=0$}\\
1/2 & \text{se ($X_n=1$ e $Y_n=0$) ou ($X_n=0$ e $Y_n=1$)}\\
3/4 & \text{se $X_n=1$ e $Y_n=1$}
\end{cases}
\end{equation*}
\item Mostre que $(X_n,Y_n)_{n\ge0}$ é uma cadeia de Markov no espaço de estados $S\times S$ e encontre a respectiva matriz de transição.
\end{enumerate}