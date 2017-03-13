---
title       : Overfitting
subtitle    : for fun but not profit.
author      : Steven E. Pav
job         : (former quant)
framework   : io2012 # {revealjs, io2012, html5slides, shower, dzslides, ...} probably not dzslides
highlighter : highlight # {highlight.js, prettify, highlight}  highlight.js was the best, I think
hitheme     : tomorrow      # 
widgets     : [mathjax, bootstrap]            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
revealjs    : 
  transition  : "none"
  center      : "false"
  transitionSpeed : "fast"
  theme : "sky"    
---

<!-- zoom transition also good, but a little distracting -->
<!-- c.f.  
http://zevross.com/blog/2014/11/19/creating-elegant-html-presentations-that-feature-r-code/
http://stackoverflow.com/a/21468200/164611
https://github.com/hakimel/reveal.js/
https://j.eremy.net/align-lists-flush-left/
-->

<!-- 
run it via 
slidify::slidify('index.Rmd')

or 
r -l slidify -e 'slidify("index.Rmd")'
-->
 
\(
\DeclareMathOperator*{\argmin}{\arg\!\min}
\)
<style type="text/css">
p { text-align: left; }
</style>

## Everyone Overfits

Consider the work cycle of an equities quant:

	1. Posit some mechanism causing market inefficiency (or read about it in a paper, 
	on the net, or in the NY Times Sunday Business section).
	2. Collect the data and write some code to test for the inefficiency.
	3. Find inconclusive backtest, and bugs in code.
	4. Modify idea while fixing code.
	5. Generalize the problem, start fiddling with knobs.
	6. Maybe find an effect, but try some other stuff.
	...
	192. Brute force check all knob settings.
	193. Definitely have a tradeable strategy this time, present to investment team.
	194. Suffer from amnesia regarding development.
	195. Back to 1.

How can this possibly work?

--- .class #poo_two

## Two Kinds of Overfitting


There are two effects of overfitting:

1. Estimates of the out-of-sample performance of a strategy are
	 too optimistic.
2. You select and deploy a strategy that is suboptimal compared
	 to others in your search space.


You _can_ suffer both!

### Overfit is _not_ cured by ML tricks:

You can talk about cross validation, hold-out sets and in-sample all you want. 
_There is no out-of-sample._ There is _in-sample_ and 
_trading-real-money-on-the-strategy_.

Overfit is approached as a technical problem, but fighting
it requires discipline and soft engineering skills:
If you don't keep track of everything you have tried, you can't 
apply most techniques.

--- .class #terminology

## Some Terminology

As an approximation, suppose that the returns of strategy are constant over time.

Typically use $\mu$ for the expected value, and $\sigma^2$ for the variance
of the returns.

Informally, the Sharpe ratio is defined as
$$
\zeta = \frac{\mu - r_0}{\sigma},
$$
where $r_0$ is the 'risk-free' or 'disastrous rate' of return.

To a first order approximation, funds and investors want to maximize Sharpe.

Often use same terminology to refer to population quantity and sample estimate,
but they are different.

--- .class #poapprox

## Optimal Sharpe over many correlated strategies

* Suppose you backtested many strategies, selected for 
in-sample (backtested) Sharpe.
* Probably automated and human search search: GP, SA, non-linear
optimization, hill-climbing, knob-fiddling, _etc._ 
* Correlated returns and you threw away most of the time
series, and don't remember how many there were.

In principle, there are $m$ time series of returns, each of length $n$, in 
a $n \times m$ matrix $X$.
Think of a dimensionality reduction, with $X$ nearly contained in a $k$
dimensional subspace, with $k \ll m$:
$$
X \approx L W,
$$
where $L$ is $n \times k$, and $W$ is $k \times m$.

You can think of returns in $X$ as portfolios over latent returns in $L$ with
portfolio weights $W$. 

_What is the maximal Sharpe of a linear combination of $k$ assets?_

--- .class #poapproxtwo

## Optimal portfolio Sharpe


Given $k$ vector of returns with mean $\mu$ and covariance $\Sigma$,
Sharpe optimization is
$$
\argmin_{w : w^{\top}\Sigma w \le R^2} \frac{\mu^{\top} w - r_0}{\sqrt{w^{\top}\Sigma  w}} = 
c\Sigma^{-1}\mu.
$$
The Sharpe of this Markowitz Portfolio is
$$
\frac{\mu^{\top} \left(\Sigma^{-1}\mu\right)}{\sqrt{\left(\Sigma^{-1}\mu\right)^{\top}
\Sigma \left(\Sigma^{-1}\mu\right)}} 
= \sqrt{\mu^{\top}\Sigma^{-1}\mu}.
$$
When built with sample estimates, this is Hotelling's $T^2$ up to scaling:
$$
T^2 = n {\hat{\mu}^{\top}\hat{\Sigma}^{-1}\hat{\mu}}.
$$

--- .class #aside

## An aside 

Connections between quant metrics 
(the 'right' ones) and classical statistics:

 quant world  |  classical statistics   | classical use
--------------|-------------------------|--------------------------
Sharpe ratio  | $t$ statistic | detect non-$0$ mean or regression coef.
squared Sharpe of Markowitz Portfolio | Hotelling $T^2$ | detect non-$0$ _vector_ mean
expected squared Sharpe, conditional on features | Hotelling-Lawley Trace | detect non-$0$ multivariate multiple regression coef.

--- .class #poapproxthree

## Optimal portfolio Sharpe

The distribution of sample $T^2$, for Gaussian returns, is a known
function of $n, k,$ and the population $\mu^{\top}\Sigma^{-1}\mu$:
$$
\frac{n}{n-1}\frac{1/k}{1/(n-k)} {\hat{\mu}^{\top}\hat{\Sigma}^{-1}\hat{\mu}} 
\sim
F\left(k, n-k, \frac{1/k}{1/(n-k)} {\mu^{\top}\Sigma^{-1}\mu} \right)
$$
This is  _non-central F distribution_, and 
$\frac{1/k}{1/(n-k)} {\mu^{\top}\Sigma^{-1}\mu}$ is the _non-centrality
parameter_.<br>
(These are built in to R via ```df```, ```pf```, and ```qf```.)

Can build confidence intervals on the n.c.p.:
find smallest non-negative ```z``` 
such that <br>
```pf((optsr^2)*(n-k)/k, df1=k, df2=n-k, ncp=z*(n-k)/k, lower.tail=F) >= 0.05```<br>
(See ```?SharpeR::confint.sropt```)

Known unbiased estimators for 
${\mu^{\top}\Sigma^{-1}\mu}$
but they might be negative!

Better positive estimators under quadratic loss due to [Kubokawa Robert
Saleh](http://www.jstor.org/stable/3315657).

--- .class #anexample

## Back to Overfitting 

Note that the $X$ did not need to be observed, only optimal Sharpe over
$X$.<br>
(Downside: have to estimate $k$)<br>
<img src="assets/fig/unnamed-chunk-1-1.png" title="Q-Q plot of 2048 achieved optimal \txtSR values from brute force search over both windows of a Moving Average Crossover under the null of driftless log returns with zero autocorrelation versus the approximation by a 2-parameter optimal \txtSR distribution is shown." alt="Q-Q plot of 2048 achieved optimal \txtSR values from brute force search over both windows of a Moving Average Crossover under the null of driftless log returns with zero autocorrelation versus the approximation by a 2-parameter optimal \txtSR distribution is shown." width="500px" height="400px" />
<figcaption>
Q-Q plot of 2048 achieved optimal Sharpe values from brute force search over both windows of MAC vs. $k=2$ approximation.
</figcaption>

--- .class #finish

## Finally

* You can maybe use this to fight overfitting.
* Careful process also very important. ([Backtests are often
	broken](http://www.gilgamath.com/startupmltalk/#1).)
* Some of this is in ```SharpeR``` package.

