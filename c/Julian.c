#include "Extend.api"

static const long MODIFIED_JULIAN_OFFSET = 2415019;
static const long LASTJULDATE = 17520902L;   /* last day to use Julian calendar */
static const long LASTJULJDN  = 2361221L;    /* jdn of same */

CLIPPER julianDayToYmd()
    {

    const long daysPer400Years = 146097L;
    const long fudgedDaysPer4000Years = 1460970L + 31;

    long year
    long month
    long day

    long julianDay  = _parnl( 1 );

    long x = julianDay + 68569L + MODIFIED_JULIAN_OFFSET;
    long z = 4 * x / daysPer400Years;
    x      = x - (daysPer400Years * z + 3) / 4;
    year   = 4000 * (x + 1) / fudgedDaysPer4000Years;
    x      = x - 1461 * year / 4 + 31;
    month  = 80 * x / 2447;
    day    = x - 2447 * month / 80;
    x      = month / 11;
    month  = month + 2 - 12 * x;
    year   = 100 * (z - 49) + year + x;

  FEZ_ASSERT(year  >= 1900, "Illegal value calculated for year, year < 1900");
  FEZ_ASSERT((month > 0) && (month < 13), "Illegal value calculated for month");
  FEZ_ASSERT((day > 0) && (day < 32), "Illegal value calculated for day");
}
