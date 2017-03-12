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
	193. Definitely have a tradeable strategy, present to investment team.
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

### Overfit is _not_ cured by silly ML tricks:

You can talk about hold-out sets and in-sample all you want. 
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

To a first order approximation, funds want to maximize Sharpe.

--- .class #twoproblems

## Technical Approaches

Two forms of the problem I was interested in:

1. For automated strategy search: having observed the in-sample Sharpe of $n \gg 10^4$ strategies,
possibly selected by hill-climbing in-sample Sharpe, could we de-bias the Sharpe of the optimal one? 
Or could we select some top $k$ of them and 'average' the strategies?
2. For human strategy search: having observed the _returns_ of $n \ge 10^3$ strategies, along with
the settings of some 'knobs' for each of them, could we estimate the effects of
each knob? Could we pick the best knob setting and de-bias the estimated future
Sharpe?

I suspected classical approaches (WRC and extensions, Hansen's SPA, _etc._)
would not work: different input, wrong assumptions, wouldn't scale.

--- .class #poapprox

### Optimal Sharpe over many correlated strategies

Suppose you observed the time series of returns of $n \gg 10^4$ strategies, each
of length $T$, in $T \times n$ matrix $X$.

Think of a dimensionality reduction, where $X$ is nearly contained in some $k$
dimensional subspace, with $k \ll T$:
$$
X \approx L W,
$$
where $L$ is $T \times k$, and $W$ is $k \times n$.

You can think of returns in $X$ as portfolios over latent returns in $L$ with
portfolio weights $W$. 

What is the maximal Sharpe over $k$ assets?

--- .class #poapproxtwo

### Optimal portfolio Sharpe

Optimal Sharpe over $k$ assets is achieved by the Markowitz portfolio.
Distribution is related to Hotelling's $T^2$.

As an aside, interesting connections between quant metrics 
(the 'right' ones) and classical statistics:

 quant world  |  classical statistics  
--------------|-------------------------
Sharpe ratio                   | $t$ statistic 
squared Sharpe of Markowitz Portfolio | Hotelling $T^2$ 
expected squared Sharpe, conditional on features | Hotelling-Lawley Trace

--- .class #poapproxthree

### Optimal portfolio Sharpe

Optimal Sharpe over $k$ assets is achieved by the Markowitz portfolio.
Distribution is related to Hotelling's $T^2$.

We know the distribution of the (in-sample) Sharpe of the Markowitz portfolio
as a function of $k$, $T$, and the (population) Sharpe of the 
(population) Markowitz portfolio. 

We also have good estimators of, and confidence intervals around that population 
optimal Sharpe given the in-sample statistics. (Given in
[SharpeR](http://github.com/shabbychef/SharpeR) for example.)

Note that the $X$ did not need to be observed, only the optimal Sharpe over
$X$. (Downside: have to estimate $k$)


