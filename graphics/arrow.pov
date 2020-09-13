#version 3.7;
#include "graphics/common.inc"

#declare scene_transform = transform {
  scale 1
  rotate <0,0,0>
  translate <0,0,0>
}

object {
  pallet
  transform { scene_transform }
  #if ((Variant = VARIANT_BKG) | (Variant = VARIANT_SHADOW))
    no_image
  #end
}
