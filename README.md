# Fractal
This is a technical indicator used for identifying extremums of different degrees.

# Contribution
You can contribute to the source code on GitHub by opening new issues or making pull requests. You are also welcomed to comment below [**this post**][1] on `mql5.com` for reporting bugs, or suggesting any further improvement that you may find useful.

# Installation

Run MetaTrader and navigate to your MetaTrader data folder through the menu bar by selecting `File -> Open Data Folder`. Copy `Fractal Utilities.mqh` into `MQL4\Include` folder, and copy `Fractal STF.mq4` and `Fractal MTF.mq4` into `MQL4\Indicators` folder. Compile `Fractal STF.mq4` and `Fractal MTF.mq4`, respectively. Note that the path to the `Fractal STF.ex4`, the compiled code for `Fractal STF.mq4`, should be given in the inputs of Fractal MTF indicator. If you put both `Fractal STF.mq4` and `Fractal MTF.mq4` into the default `MQL4\Indicators` directory, then set this input as Fractal STF. However, if you put them into a subdirectory like `MQL4\Indicators\Developed` then set the path to `\Developed\Fractal STF` as shown in **Figure 2**.

# Description
There is a built-in fractal indicator in MT4/MT5, whose origins goes back to the famous Bill Williams. The main purpose of this indicator is to identify a local extremum by comparing a candle's high/low with that of its neighboring candles to justify it as an up-fractal/down-fractal, a term coined by Williams instead of local maximum/minimum. Some other equivalent terms are swing high/low and top/bottom, which are used among traders interchangeably.

This indicator has the following advantages over its built-in MT4/MT5  counterpart:

1. Williams believed that like our middle finger, which is a fractal compared with its two neighboring ones, the radius of the comparison should be chosen as two, which is the default value for the built-in fractal indicator in MT4/MT5. In this indicator, the user can choose this neighborhood radius to his/her will. This has the benefit of distinguishing extrema of different degrees at the same time on the chart as shown in **Figure 1**.

2. User can also choose the shape of symbols pointing to these extrema, enabling him/her to associate with extrema of each degree a unique symbol for better visualization.

3. User can specify the vertical distance of the arrows from the high/low of the candles to avoid overlapping of symbols corresponding to extrema of different degrees. The idea for dynamic adjustment of the vertical distance was mainly inspired by the answers of tdbarnard in [**here**][2]. The main point to consider is that we want the pixel distance of an arrow (arrow offset) to be a constant value away from a candle's high/low. However, this does not mean that the equivalent price distance should be constant too. Indeed, as the chart's scale is changed, the price distance corresponding to a fixed pixel distance will also change, which requires a dynamic distance adjustment. You can see the detailed implementation of this idea in the code.

4. User can view higher time frame fractals in a lower time frame, making this a multi time frame (MTF) indicator. For example, user can set the indicator time frame as D1 and choose a radius of 2 for the fractals. Next, if user switches to M15 time frame, Fractal MTF marks those M15 bars whose high/low coincides with that of their corresponding fractals in D1 time frame. Note that the indicator time frame should be greater than or equal to the chart time frame, which is attached to it. If the user chooses an indicator time frame smaller than the chart time frame, then the indicator uses the chart time frame by default.

<br></br>
![][3] \
**Figure 1**. Fractals with neighborhood radius of 2 and 5.

<br></br>
![][4] \
**Figure 2.** Inputs of the Fractal MTF indicator.

<br></br>

[1]: https://www.mql5.com/en/code/35575
[2]: https://www.forexfactory.com/thread/456946-perfect-placing-of-arrows-on-the-chart
[3]: https://c.mql5.com/18/99/1__6.png
[4]: https://c.mql5.com/18/102/Capture__2.PNG
