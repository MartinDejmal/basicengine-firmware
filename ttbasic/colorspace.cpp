#include "ttconfig.h"
#include "vs23s010.h"

#include <stdio.h>
#include <stdint.h>

//#define DEBUG

#ifdef DEBUG
#define dbg_col(x...) do {Serial.printf(x);Serial.flush();} while(0)
#else
#define dbg_col(x...)
#endif

struct palette {
  uint8_t r, g, b;
};
#include "P-EE-A22-B22-Y44-N10.h"
#include "N-0C-B62-A63-Y33-N10.h"

static void rgb_to_hsv(uint8_t r, uint8_t g, uint8_t b, int *h, int *s, int *v)
{
  *v = max(max(r, g), b);
  if (*v == 0) {
    *s = 0;
    *h = 0;
    return;
  }
  int m = min(min(r, g), b);
  *s = 255 * (*v - m) / *v;
  if (*v == m) {
    *h = 0;
  } else {
    int d = *v - m;
    if (*v == r)
      *h = 60 * (g - b) / d;
    else if (*v == g)
      *h = 120 + 60 * (b-r) / d;
    else
      *h = 240 + 60 * (r-g) / d;
  }
  if (*h < 0)
    *h += 360;
}

/* must be same order as vs23_ops[] */
static const struct palette *pals[] = {
  p_ee_a22_b22_y44_n10,
  n_0c_b62_a63_y33_n10,
};

#define COLOR_CACHE_SIZE 64
struct color_cache_state {
  const struct palette *yuvpal;
  int h_weight, s_weight, v_weight;
  bool fixup;
};
struct color_cache_state color_cache_state;

struct color_cache {
  uint8_t r, g, b;
  uint8_t col;
};
struct color_cache color_cache[COLOR_CACHE_SIZE];

static void clear_color_cache(void)
{
  memset(color_cache, 0, sizeof(color_cache));
}

void VS23S010::setColorConversion(int yuvpal, int h_weight, int s_weight, int v_weight, bool fixup)
{
  color_cache_state.yuvpal = pals[yuvpal];
  color_cache_state.h_weight = h_weight;
  color_cache_state.s_weight = s_weight;
  color_cache_state.v_weight = v_weight;
  color_cache_state.fixup = fixup;
  clear_color_cache();
}

uint8_t VS23S010::colorFromRgb(uint8_t r, uint8_t g, uint8_t b)
{
  int h, s, v;
  uint8_t best = 0;

  uint8_t cache_hash = (r ^ g ^ b) & (COLOR_CACHE_SIZE - 1);
  struct color_cache *cache_entry = &color_cache[cache_hash];
  if (r == cache_entry->r && g == cache_entry->g && b == cache_entry->b) {
    dbg_col("cache hit %d %d %d\n", r, g, b);
    return cache_entry->col;
  }

#ifdef DEBUG
  int best_h, best_s, best_v;
#endif
  int mindiff = INT32_MAX;
  int adj_sw = 0, adj_hw = 0, adj_vw = 0;

  rgb_to_hsv(r, g, b, &h, &s, &v);
  dbg_col("hsv %d %d %d\n", h, s, v);

  // Fix-ups that improve corner cases.
  // Most of these are required because there is a lack of low-saturation
  // dark colors.
  if (color_cache_state.fixup) {
    if (v < 15 || (s <= 65 && v < 40)) {
      // very dark -> grey
      s = 0;
      adj_hw = -color_cache_state.h_weight;
    }
    else if (s < 10) {
      // extremely pale colors -> grey
      s = 0;
      adj_hw = -color_cache_state.h_weight;
    }
    else if ((s+v < 190 || s < 60 || v < 60) &&
        h > 185 && h < 265) {
      // very pale bluish -> light grey
      s = 0;
      adj_hw = -color_cache_state.h_weight;
    }
  }

  for (int i=0; i<256; ++i) {
    int _r = pgm_read_byte(&color_cache_state.yuvpal[i].r);
    int _g = pgm_read_byte(&color_cache_state.yuvpal[i].g);
    int _b = pgm_read_byte(&color_cache_state.yuvpal[i].b);
    int _h,_s,_v;
    int diff;

    if (_r == r && _g == g && b == _b) {
      dbg_col("exact match rgb %d %d %d\n", r, g, b);
      return i;
    }

    rgb_to_hsv(_r, _g, _b, &_h, &_s, &_v);

    diff = ((color_cache_state.h_weight+adj_hw)*abs(h-_h)+
            (color_cache_state.s_weight+adj_sw)*abs(s-_s)+
            (color_cache_state.v_weight+adj_vw)*abs(v-_v));

    if (diff < mindiff) {
      mindiff = diff;
      best = i;
#ifdef DEBUG
      best_h = _h;
      best_s = _s;
      best_v = _v;
#endif
    }
  }

  dbg_col("best for (%d %d %d hsv %d %d %d) is %d (%d %d %d hsv %d %d %d) diff %d\n", r, g, b,
         h, s, v,
         best,
         pgm_read_byte(&color_cache_state.yuvpal[best].r),
         pgm_read_byte(&color_cache_state.yuvpal[best].g),
         pgm_read_byte(&color_cache_state.yuvpal[best].b),
         best_h, best_s, best_v,
         mindiff);

  cache_entry->r = r;
  cache_entry->g = g;
  cache_entry->b = b;
  cache_entry->col = best;
  return best;
}
