---
title       : Backtesting
subtitle    : war stories and cautionary tales.
author      : Steven E. Pav
job         : (former quant)
framework   : revealjs      # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax, bootstrap]            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
revealjs    : 
  transition  : "zoom"
  center      : "false"
  transitionSpeed : "fast"
  theme : "sky"    
---

<!-- c.f.  
http://zevross.com/blog/2014/11/19/creating-elegant-html-presentations-that-feature-r-code/
http://stackoverflow.com/a/21468200/164611
https://github.com/hakimel/reveal.js/
https://j.eremy.net/align-lists-flush-left/
-->
 
<style type="text/css">
p { text-align: left; }
</style>

### My background

* Former applied mathematician. (IUB graduate!)
* Quant Programmer & Quant Strategist 2007-2015 at 
two small hedge funds.
* Almost pure quant funds, ML-based, in U.S. ("single name") equities and
volatility futures.
* Tried many ML technologies to construct strategies: SVM, random forests, 
GP.
* Also traditional statistical approaches: plain old regression.
* Whatever the approach, we used _backtests_. (GP used them heavily.)

--- .class #backtests

#### What makes a profitable strategy?

  _Need prediction of future price movements._

But also:

* Turn the predictions into trades.
* No, _really_, turn the predictions into trades.
* Eliminate or reduce exposure to certain risks.
* Control trade costs. (commissions, short financing, market impact.)

Hard to estimate the effects of the different moving parts separately.

So simulate your trading historically: A _backtest._

Backtesting basically implies quantitative strategies: you cannot backtest
discretionary trading.

--- .class #whatdo

### Backtests

A backtest probably should:

* simulate the effects of your actions (orders submitted).
* simulate the actions of the world (fills, commissions, corporate actions,
_etc_.).
* translate in an obvious way to a real trading strategy.
* provide an absolute guarantee of _time safety_.

Creating a good backtesting environment requires:

* Software engineering: balance _time safety_, _computational efficiency_
and _developer sanity_.
* Domain knowledge and data: _How should you simulate fill?_
_How do corporate actions work?_
* Great statistical powers: _How do you interpret the results?_ _How do you
avoid overfitting?_
* Good intuition and sleuthing abilities: _What new thing is broken?_

--- .class #kindsof

### Different kinds of backtests

<center>![](./figure/backtests.png)</center>


--- .class #garbatrage

<style type="text/css">
p { text-align: left; }
</style>

### Garbatrage

Use Bayes' Rule:

* Devising a consistently profitable trading strategy is known to be hard. <br>
(The EMH posits that it is essentially _impossible_.)
* Bugs are easy to make. A good programmer will make several a day.

If your backtest looks profitable, what is the likelihood the
strategy is really profitable?

If you are exploring a new asset class, using a new fill simulator, 
using new code, testing a new strategy, or reading a paper from a third party, 
and the backtest looks great, _it's probably a bug_.

--- .class #anexample

<style type="text/css">
p { text-align: center; } 
</style>

### An example

Should three day old tweets give you this?

<img src="assets/fig/bmzsim-1.png" title="plot of chunk bmzsim" alt="plot of chunk bmzsim" width="900px" height="500px" />

<style type="text/css">
p { text-align: left; }
</style>

--- .class #timetravel

### Time Travel

The most common error in backtests is _time travel_.

* Data vendors often backfill data for companies or remove them.
* Corporate actions often signal information from the future.

<img src="assets/fig/aapl-1.png" title="plot of chunk aapl" alt="plot of chunk aapl" width="900px" height="500px" />

--- .class #ohno

## Break!


Turn it over to Zak for the next part.

--- .class #ohno

### Again!?

<center>![](./figure/Curve_fitting.jpg)</center>


--- .class #fooz

### misc

Equations:

$$
x = \sum_{0 \le i \le 100} i^2
$$


