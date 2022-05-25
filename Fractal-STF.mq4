
// Single Time Frame (STF) Fractal Indicator

// Include required header files.
#include <Fractal-Utilities.mqh>

#property copyright "Developed by Hosein Rahnama"
#property link "https://www.mql5.com/en/users/hosein.rahnama"
#property version "1.3"
#property description "This indicator identifies fractals within a neighborhood."
#property description "The neighborhood has a radius which represents the number of candles to each side of the fractal candle."
#property description "The high or low of the fractal candle is a local extremum within this neighborhood."

#property strict

#property indicator_chart_window

// Set the number of indicator buffers which are drawn.
#property indicator_buffers 4
#property indicator_plots 4

// Set initial setting for drawing up-factal arrows.
#property indicator_type1 DRAW_ARROW
#property indicator_color1 clrRed
#property indicator_style1 STYLE_SOLID
#property indicator_width1 1

// Set initial setting for drawing down-factal arrows.
#property indicator_type2 DRAW_ARROW
#property indicator_color2 clrBlue
#property indicator_style2 STYLE_SOLID
#property indicator_width2 1

// Set initial setting for drawing up-factals.
#property indicator_type3 DRAW_NONE
#property indicator_color3 clrNONE

// Set initial setting for drawing down-factals.
#property indicator_type4 DRAW_NONE
#property indicator_color4 clrNONE

// Indicator buffers are set.
double upFractalArrow[];
double downFractalArrow[];
double upFractal[];
double downFractal[];

// Define global variables and data types.
bool onCalculateFirstCall = true;

// Default values for input parameters are set.
input int inputRadius = 2;             // Radius
input int inputYShift = 10;            // Arrow Offset in Pixels
input ENUM_SHAPE inputShape = WING;    // Arrow Shape

// Copy inputs for possible modification during the program.
int radius = inputRadius;
int YShift = inputYShift;
ENUM_SHAPE shape = inputShape;

int OnInit()
{
// Check validity of the radius and the vertical shift.
    if(radius < 1)
    {
        radius = 2;
        Print("Radius cannot be smaller than 1. The default value 2 is used instead.");
    }
    if(YShift < 0)
    {
        YShift = 10;
        Print("Arrow offset cannot be a negative value. The default value 10 is used instead.");
    }

// Set buffer parameters for up-fractal arrows.
    SetIndexBuffer(UP_FRACTAL_ARROW, upFractalArrow);
    SetIndexLabel(UP_FRACTAL_ARROW, NULL);
    SetIndexArrow(UP_FRACTAL_ARROW, shape);
    SetIndexEmptyValue(UP_FRACTAL_ARROW, EMPTY_VALUE);
    SetIndexDrawBegin(UP_FRACTAL_ARROW, radius);

// Set buffer parameters for down-fractal arrows.
    if(shape == ARROW || shape == BOLD_ARROW || shape == HALLOW_ARROW || shape == WING)
    {
        shape = ENUM_SHAPE(shape - 1);
    }
    SetIndexBuffer(DOWN_FRACTAL_ARROW, downFractalArrow);
    SetIndexLabel(DOWN_FRACTAL_ARROW, NULL);
    SetIndexArrow(DOWN_FRACTAL_ARROW, shape);
    SetIndexEmptyValue(DOWN_FRACTAL_ARROW, EMPTY_VALUE);
    SetIndexDrawBegin(DOWN_FRACTAL_ARROW, radius);

// Set buffer parameters for up-fractals.
    SetIndexBuffer(UP_FRACTAL, upFractal);
    SetIndexLabel(UP_FRACTAL, "Fractal-Up(" + string(radius) + ")");
    SetIndexEmptyValue(UP_FRACTAL, EMPTY_VALUE);
    SetIndexDrawBegin(UP_FRACTAL, radius);

// Set buffer parameters for up-fractals.
    SetIndexBuffer(DOWN_FRACTAL, downFractal);
    SetIndexLabel(DOWN_FRACTAL, "Fractal-Down(" + string(radius) + ")");
    SetIndexEmptyValue(DOWN_FRACTAL, EMPTY_VALUE);
    SetIndexDrawBegin(DOWN_FRACTAL, radius);

// Set a short name for the indicator.
    IndicatorSetString(INDICATOR_SHORTNAME, "Fractal(" + string(radius) + ")" );

// Set accuracy of indicator calculations.
    IndicatorSetInteger(INDICATOR_DIGITS, Digits);

    return INIT_SUCCEEDED;
}

int OnCalculate(const int ratesTotal,
                const int prevCalculated,
                const datetime & time[],
                const double & open[],
                const double & high[],
                const double & low[],
                const double & close[],
                const long & tickVolume[],
                const long & volume[],
                const int & spread[])
{
// Check for the minimum number of bars required for calculation.
    if(ratesTotal < (2 * radius + 1))
    {
        return 0;
    }

// When the indicator is dropped on the chart, variable newBars equals the number of candles in the chart.
// If newBars is 0 the current candle is changing. If newBars is 1, a new candle has just been started.
// In these two cases, calculation is only done for the recent bars. However, if newBars is greater than 1 then a change
// in data history has occured, so it is wise to do the calculations over all of the candles again.
    int newBars = ratesTotal - prevCalculated;

// Find the range of bar indices for calculation assuming a timeseries indexing direction.
    int oldestBar = (newBars <= 1) ? radius : (ratesTotal - 1) - radius;
    int newestBar = radius;

// Carry out indicator calculations.
    for(int bar = newestBar; bar <= oldestBar; bar++)
    {
        upFractal[bar] = EMPTY_VALUE;
        upFractalArrow[bar] = EMPTY_VALUE;
        if(isUpFractal(bar, radius))
        {
            upFractalArrow[bar] = High[bar] + YShiftToPriceShift(YShift);
            upFractal[bar] = High[bar];
        }
        downFractal[bar] = EMPTY_VALUE;
        downFractalArrow[bar] = EMPTY_VALUE;
        if(isDownFractal(bar, radius))
        {
            downFractalArrow[bar] = Low[bar] - YShiftToPriceShift(YShift + 1);
            downFractal[bar] = Low[bar];
        }
    }
    onCalculateFirstCall = false;

// Return the number of available bars in this function call. This will be accessible with prevCalculated in the next call.
    return(ratesTotal);
}

// Take care of chart events for keeping the vertical shift in pixels constant.
void OnChartEvent(const int id, const long & lparam, const double & dparam, const string & sparam)
{
    if(id == CHARTEVENT_CHART_CHANGE && onCalculateFirstCall == false)
    {
        adjustArrowOffset(YShift, upFractalArrow, downFractalArrow, upFractal, downFractal);
    }
}