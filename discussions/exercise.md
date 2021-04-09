Sejam $f_\tau\colon B\to\mathbb{R}$ funções indexadas por um parâmetro $\tau\in T$. Suponha que para cada $\tau\in T$, existe um único $\beta(\tau)\in B$ tal que
$$
f_\tau\big(\beta(\tau)\big)<f_\tau\big({b}\big),
$$
para todo ${b}\in B$. (note que isso define implicitamente uma função $\beta\colon T\to B$)

---

\begin{enumerate}
\item mostre que, dados $M$ elementos distintos $\tau_1,\dots,\tau_M\in T$ (onde $M\in\mathbb{N}$), vale que
\begin{equation}
\sum_{m=1}^Mf_{\tau_m}\big(\beta(\tau_m)\big) < \sum_{m=1}^Mf_{\tau_m}\big({b}_m\big),
\end{equation}
para qualquer $({b}_1,\dots,{b}_M)\in B^M$.
\item suponha adicionalmente que:
\begin{enumerate}
\item $T\subseteq\mathbb{R}$ é um intervalo fechado.
\item $B= \mathbb{R}^D$, onde $D\in\mathbb{N}$.
\item a função $(\tau,b)\mapsto f_\tau(b)$ é contínua.
\end{enumerate}
Mostre que
\begin{equation}
\int_T f_\tau\big(\beta(\tau)\big)\,\mathrm{d}\tau < \int_T f_\tau\big({b}(\tau)\big)\,\mathrm{d}\tau,
\end{equation}
para qualquer função contínua ${b}\colon T\to B$.
\end{enumerate}

