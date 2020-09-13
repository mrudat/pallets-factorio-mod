#version 3.7;
#include "graphics/common.inc"
#include "graphics/pallet.inc"

#declare scene_transform = transform {
  scale 1/29
  rotate <0,0,-30>
  translate <0,-9,0>
}

object {
  pallet
  transform { scene_transform }
  #if ((Variant = VARIANT_BKG) | (Variant = VARIANT_SHADOW))
    no_image
  #end
}

object {
  pallet
  transform {
    rotate <0, 0, 5>
    translate <0, 0, pallet_height>
  }
  transform { scene_transform }
  #if ((Variant = VARIANT_BKG) | (Variant = VARIANT_SHADOW))
    no_image
  #end
}

object {
  pallet
  transform {
    rotate <0, 0, -3>
    translate <0, 0, pallet_height * 2>
  }
  transform { scene_transform }
  #if ((Variant = VARIANT_BKG) | (Variant = VARIANT_SHADOW))
    no_image
  #end
}
