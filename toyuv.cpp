//
// Created by         :  Harris Zhu
// Filename           :  test.cpp
// Author             :  Harris Zhu
// Created On         :  2018-09-17 04:40:06
// Last Modified      :  2018-09-17 04:40:06
// Update Count       :  1
// Tags               :   
// Description        :  
// Conclusion         :  
//                      
//=======================================================================

#include <stdio.h>
#include <stdlib.h>
#include "rgb2i420.h"
#include "i4202rgb.h"

int main(int argc, char**argv) {

	char * din = argv[1];
	char * dout = argv[2];
	int width = atoi(argv[3]);
	int height = atoi(argv[4]);
	
	size_t imagesize=width*height;


	uint8_t bufin[imagesize*3];
	uint8_t bufout[size_t(imagesize*1.5)];

	size_t nread;

	FILE * fin=fopen(din, "r");
	FILE * fout=fopen(dout, "w+");

	if(fin) {
		while((nread = fread(bufin, 1, sizeof(bufin), fin)) > 0) {
			Rgb2Yuv420p(bufout, bufin, width, height);
			fwrite(bufout, 1, sizeof(bufout), fout);
		}
	}


	fclose(fin);
	fclose(fout);
	return 0;


}
