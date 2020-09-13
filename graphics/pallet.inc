#include "woods.inc"
#include "metals.inc"

// AS square pallet (or as near as I can get).

#declare pallet_size = 1165;
#declare block_width = 95;
#declare block_height = 95;
#declare block_end_length = 160; // 190?
#declare top_deckboard_height = 25;
#declare bottom_deckboard_height = 25;
#declare stringer_height = 25;
#declare deckboard_width = 95;
#declare deckboard_count = 6;

#declare pallet_height = top_deckboard_height + stringer_height + block_height + bottom_deckboard_height;

#declare block_z1 = bottom_deckboard_height;
#declare block_z2 = block_z1 + block_height;

#declare pallet_x1 = -pallet_size / 2;
#declare pallet_x2 =  pallet_size / 2;
#declare pallet_y1 = -pallet_size / 2;
#declare pallet_y2 =  pallet_size / 2;

#declare left_block_x1 = pallet_x2 - block_width;
#declare left_block_x2 = pallet_x2;
#declare middle_block_x1 = -block_width/2;
#declare middle_block_x2 =  block_width/2;
#declare right_block_x1 = pallet_x1;
#declare right_block_x2 = pallet_x1 + block_width;

#declare block_gap_1_y1 = pallet_y1 + block_end_length;
#declare block_gap_1_y2 = -block_width/2;
#declare block_gap_2_y1 =  block_width/2;
#declare block_gap_2_y2 = pallet_y2 - block_end_length;

#declare bottom_deckboard_z1 = 0;
#declare bottom_deckboard_z2 = bottom_deckboard_height;
#declare lead_bottom_deckboard_x1 = pallet_x1;
#declare lead_bottom_deckboard_x2 = pallet_x2;
#declare front_bottom_deckboard_y1 = pallet_y1;
#declare front_bottom_deckboard_y2 = pallet_y1 + block_width;
#declare rear_bottom_deckboard_y1 = pallet_y2 - block_width;
#declare rear_bottom_deckboard_y2 = pallet_y2;

#declare middle_bottom_deckboard_y1 = pallet_y1 + block_width;
#declare middle_bottom_deckboard_y2 = pallet_y2 - block_width;

#declare stringer_z1 = block_z2;
#declare stringer_z2 = stringer_z1 + stringer_height;

#declare top_deckboard_z1 = stringer_z2;
#declare top_deckboard_z2 = top_deckboard_z1 + top_deckboard_height;

#declare top_deckboard_ystep = (pallet_size - deckboard_width) / (deckboard_count - 1);
#declare top_deckboard_yoffset = pallet_y1;

#declare pallet = union {
  difference {
    union {
      box {
        <  left_block_x1, pallet_y1, block_z1>,
        <  left_block_x2, pallet_y2, block_z2>
      }
      box {
        <middle_block_x1, pallet_y1, block_z1>,
        <middle_block_x2, pallet_y2, block_z2>
      }
      box {
        < right_block_x1, pallet_y1, block_z1>,
        < right_block_x2, pallet_y2, block_z2>
      }
    }
    box {
      <pallet_x1 - 1, block_gap_1_y1, block_z1 - 1>,
      <pallet_x2 + 1, block_gap_1_y2, block_z2 + 1>
    }
    box {
      <pallet_x1 - 1, block_gap_2_y1, block_z1 - 1>,
      <pallet_x2 + 1, block_gap_2_y2, block_z2 + 1>
    }
    texture {
      T_Wood12
      rotate <90, 0, 0>
    }
  }
  union {
    box {
      <lead_bottom_deckboard_x1, front_bottom_deckboard_y1, bottom_deckboard_z1>,
      <lead_bottom_deckboard_x2, front_bottom_deckboard_y2, bottom_deckboard_z2>
    }
    box {
      <lead_bottom_deckboard_x1, rear_bottom_deckboard_y1, bottom_deckboard_z1>,
      <lead_bottom_deckboard_x2, rear_bottom_deckboard_y2, bottom_deckboard_z2>
    }
    texture {
      T_Wood13
      rotate <0, 90, 0>
    }
  }
  union {
    box {
      <  left_block_x1, middle_bottom_deckboard_y1, bottom_deckboard_z1>,
      <  left_block_x2, middle_bottom_deckboard_y2, bottom_deckboard_z2>
    }
    box {
      <middle_block_x1, middle_bottom_deckboard_y1, bottom_deckboard_z1>,
      <middle_block_x2, middle_bottom_deckboard_y2, bottom_deckboard_z2>
    }
    box {
      < right_block_x1, middle_bottom_deckboard_y1, bottom_deckboard_z1>,
      < right_block_x2, middle_bottom_deckboard_y2, bottom_deckboard_z2>
    }
    texture {
      T_Wood13
      rotate <90, 0, 0>
    }
  }
  union {
    box {
      <  left_block_x1, pallet_y1, stringer_z1>,
      <  left_block_x2, pallet_y2, stringer_z2>
    }
    box {
      <middle_block_x1, pallet_y1, stringer_z1>,
      <middle_block_x2, pallet_y2, stringer_z2>
    }
    box {
      < right_block_x1, pallet_y1, stringer_z1>,
      < right_block_x2, pallet_y2, stringer_z2>
    }
    texture {
      T_Wood13
      rotate <90, 0, 0>
    }
  }
  union {
    #for(i,1,deckboard_count)
      #declare top_deckboard_y1 = top_deckboard_yoffset + top_deckboard_ystep * (i-1);
      #declare top_deckboard_y2 = top_deckboard_y1 + deckboard_width;
      box {
        <pallet_x1, top_deckboard_y1, top_deckboard_z1>,
        <pallet_x2, top_deckboard_y2, top_deckboard_z2>
      }
    #end
    texture {
      T_Wood13
      rotate <0, 90, 0>
    }
  }
}