#version 3.7;
#include "graphics/common.inc"
#include "graphics/pallet.inc"

#declare scene_transform = transform {
  scale 1/22
  translate <0,-4,0>
}

object {
  pallet
  transform { scene_transform }
  #if ((Variant = VARIANT_BKG) | (Variant = VARIANT_SHADOW))
    no_image
  #end
}
