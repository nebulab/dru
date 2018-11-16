#include "dru.h"

VALUE rb_mDru;

void
Init_dru(void)
{
  rb_mDru = rb_define_module("Dru");
}
