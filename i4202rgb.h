//
// Created by         :  Harris Zhu
// Filename           :  rgb2I420.cpp
// Avthor             :  Harris Zhu
// Created On         :  2018-09-17 04:33:02
// Last Modified      :  2018-09-17 04:33:02
// Update Count       :  1
// Tags               :   
// Description        :  
// Conclusion         :  
//                      
//=======================================================================

#include <stdint.h>
#include <stddef.h>

void Yuv420p2Rgb888(uint8_t *destination, uint8_t *yuv, size_t width, size_t height)
{
    size_t image_size = width * height;
    size_t upos = image_size;
    size_t vpos = upos + upos / 4;
    size_t i = 0;

    for( size_t line = 0; line < height; ++line )
    {
		for( size_t col = 0; col < width; col += 1 )
		{
			uint8_t y = yuv[line*width+col];
			uint8_t u = yuv[(line/2)*(width/2)+(col/2)+image_size];
			uint8_t v = yuv[(line/2)*(width/2)+(col/2)+image_size+(image_size/4)];

			int16_t C = y-16;
			int16_t D = u-128;
			int16_t E = v-128;

			int16_t rt =  (int16_t)((298*C+408*E+128)>>8);
			int16_t gt =  (int16_t)((298*C-100*D-208*E+128)>>8);
			int16_t bt =  (int16_t)((298*C+516*D+128)>>8);

			destination[i++] = rt>255?255:rt<0?0:rt;
			destination[i++] = gt>255?255:gt<0?0:gt;
			destination[i++] = bt>255?255:bt<0?0:bt;

		}
    }
}
