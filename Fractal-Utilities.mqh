
// Fractal Utilities

#property copyright "Developed by Hosein Rahnama"
#property link "https://www.mql5.com/en/users/hosein.rahnama"
#property version "1.3"

enum ENUM_SHAPE
{
    ARROW = 226,           // Arrow
    BOLD_ARROW = 234,      // Bold Arrow
    HALLOW_ARROW = 242,    // Hallow Arrow
    WING = 218,            // Wing
    CIRCLE = 159,          // Circle
    SQUARE = 167,          // Square
    RHOMBUS = 119,         // Rhombus
    STAR = 172             // Star
};

enum ENUM_BUFFER
{
    UP_FRACTAL_ARROW = 0,
    DOWN_FRACTAL_ARROW = 1,
    UP_FRACTAL = 2,
    DOWN_FRACTAL = 3
};

enum ENUM_INDICATOR_TIMEFRAME
{
    CURRENT,    // Current
    M1,         // M1
    M5,         // M5
    M15,        // M15
    M30,        // M30
    H1,         // H1
    H4,         // H4
    D1,         // D1
    W1,         // W1
    MN          // MN
};

ENUM_TIMEFRAMES getTimeFrame(ENUM_INDICATOR_TIMEFRAME inputTimeFrame)
{
    ENUM_TIMEFRAMES timeFrame = PERIOD_CURRENT;
    switch(inputTimeFrame)
    {
        case CURRENT:
            timeFrame = PERIOD_CURRENT;
            break;
        case M1:
            timeFrame = PERIOD_M1;
            break;
        case M5:
            timeFrame = PERIOD_M5;
            break;
        case M15:
            timeFrame = PERIOD_M15;
            break;
        case M30:
            timeFrame = PERIOD_M30;
            break;
        case H1:
            timeFrame = PERIOD_H1;
            break;
        case H4:
            timeFrame = PERIOD_H4;
            break;
        case D1:
            timeFrame = PERIOD_D1;
            break;
        case W1:
            timeFrame = PERIOD_W1;
            break;
        case MN:
            timeFrame = PERIOD_MN1;
    }
    return timeFrame;
}

string getRelativePath();

bool isUpFractal(const int bar, const double radius)
{
    for(int adjacentBar = 1; adjacentBar <= radius; adjacentBar++)
    {
        if(!(High[bar + adjacentBar] <= High[bar] && High[bar - adjacentBar] <= High[bar]))
        {
            return false;
        }
    }
    return true;
}

bool isDownFractal(const int bar, const double radius)
{
    for(int adjacentBar = 1; adjacentBar <= radius; adjacentBar++)
    {
        if(!(Low[bar + adjacentBar] >= Low[bar] && Low[bar - adjacentBar] >= Low[bar]))
        {
            return false;
        }
    }
    return true;
}

double YShiftToPriceShift(const int YShift)
{
    int oldestVisibleBar = WindowFirstVisibleBar();
    int XStart;
    int YStart;
    ChartTimePriceToXY(0, 0, Time[oldestVisibleBar], Close[oldestVisibleBar], XStart, YStart);

    int subWindow;
    datetime timeEnd;
    double priceEnd;
    ChartXYToTimePrice(0, XStart, YStart - YShift, subWindow, timeEnd, priceEnd);

    double priceShift = priceEnd - Close[oldestVisibleBar];
    return priceShift;
}

void adjustArrowOffset(const int YShift,
                       double & upFractalArrow[],
                       double & downFractalArrow[],
                       const double & upFractal[],
                       const double & downFractal[])
{
    int oldestVisibleBar = WindowFirstVisibleBar();
    int numVisibleBars = WindowBarsPerChart();
    int newestVisibleBar = oldestVisibleBar - numVisibleBars;
    if(newestVisibleBar < 0)
    {
        newestVisibleBar = 0;
    }
    for(int bar = newestVisibleBar; bar <= oldestVisibleBar; bar++)
    {
        if(upFractalArrow[bar] != EMPTY_VALUE)
        {
            upFractalArrow[bar] = upFractal[bar] + YShiftToPriceShift(YShift);
        }
        if(downFractalArrow[bar] != EMPTY_VALUE)
        {
            downFractalArrow[bar] = downFractal[bar] - YShiftToPriceShift(YShift + 1);
        }
    }
}