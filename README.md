
# YUV和RGB详解

## 前言

YUV，是一种颜色编码方法。常使用在各个视频处理组件中。 YUV在对照片或视频编码时，考虑到人类的感知能力，允许降低色度的带宽。 

YUV是编码true-color时使用的颜色空间(color space)之一. 像Y'UV, YUV, YCbCr, YPbPr等都可以称为YUV， 彼此之间有重叠。

- Y: 明亮度(Luminace, Luma)
- U: 色度(chrominance)
- V: 浓度(chroma)

YUV和Y'UV: 通常用来编码电视的模拟信号 （Y'表示伽玛校正)
YCbCr: 用来描述数字的视频信号，适合视频与图片压缩以及传输，例如MPEG、JPEG

YUV Formats分成两个格式：

- 紧凑格式(packed format): 依次将每个pixel的Y,U,V值存储在一起，和RGB类似
- 平面格式(planar format): 将一帧画面的Y放到一起， 然后再放所有的U，然后再放所有的V

紧凑格式对于YUV4:4：4比较适合，而平面格式适用于采样，它有I420(4:2:0), YV12, IYUV等。

注： 因为github不支持数学公式，所以下面的公式显示有问题，大家可以拷贝到本地查看。

## 历史

Y'UV的发明是由于彩色电视与黑白电视的过渡时期[1]。黑白视频只有Y（Luma，Luminance）视频，也就是灰阶值。到了彩色电视规格的制定，是以YUV/YIQ的格式来处理彩色电视图像，把UV视作表示彩度的C（Chrominance或Chroma），如果忽略C信号，那么剩下的Y（Luma）信号就跟之前的黑白电视频号相同，这样一来便解决彩色电视机与黑白电视机的兼容问题。Y'UV最大的优点在于只需占用极少的带宽。

因为UV分别代表不同颜色信号，所以直接使用R与B信号表示色度的UV。 也就是说UV信号告诉了电视要偏移某象素的的颜色，而不改变其亮度。 或者UV信号告诉了显示器使得某个颜色亮度依某个基准偏移。 UV的值越高，代表该像素会有更饱和的颜色。

彩色图像记录的格式，常见的有RGB、YUV、CMYK等。彩色电视最早的构想是使用RGB三原色来同时传输。这种设计方式是原来黑白带宽的3倍，在当时并不是很好的设计。RGB诉求于人眼对色彩的感应，YUV则着重于视觉对于亮度的敏感程度，Y代表的是亮度，UV代表的是彩度（因此黑白电影可省略UV，相近于RGB），分别用Cr和Cb来表示，因此YUV的记录通常以Y:UV的格式呈现。 

## YUV格式种类

为节省带宽起见，大多数YUV格式平均使用的每像素位数都少于24位。主要的抽样（subsample）格式有YCbCr 4:2:0、YCbCr 4:2:2、YCbCr 4:1:1和YCbCr 4:4:4。YUV的表示法称为A:B:C表示法：

- 4:4:4表示完全取样。
- 4:2:2表示2:1的水平取样，垂直完全采样。
- 4:2:0表示2:1的水平取样，垂直2：1采样。
- 4:1:1表示4:1的水平取样，垂直完全采样。

最常用Y:UV记录的比重通常1:1或2:1，DVD-Video是以YUV 4:2:0的方式记录，也就是我们俗称的I420，YUV4:2:0并不是说只有U（即Cb）, V（即Cr）一定为0，而是指U：V互相援引，时见时隐，也就是说对于每一个行，只有一个U或者V分量，如果一行是4:2:0的话，下一行就是4:0:2，再下一行是4:2:0...以此类推。至于其他常见的YUV格式有YUY2、YUYV、YVYU、UYVY、AYUV、Y41P、Y411、Y211、IF09、IYUV、YV12、YVU9、YUV411、YUV420等。

### YUY2及常见表示方法

YUY2（和YUYV）格式为像素保留Y，而UV在水平空间上相隔二个像素采样一次（Y0 U0 Y1 V0），（Y2 U2 Y3 V2）…其中，（Y0 U0 Y1 V0）就是一个macro-pixel（宏像素），它表示了2个像素，（Y2 U2 Y3 V2）是另外的2个像素。 以此类推，再如：Y41P（和Y411）格式为每个像素保留Y分量，而UV分量在水平方向上每4个像素采样一次。一个宏像素为12个字节，实际表示8个像素。图像数据中YUV分量排列顺序如下：（U0 Y0 V0 Y1 U4 Y2 V4 Y3 Y4 Y5 Y6 Y7）…

### YVYU UYVY

YVYU, UYVY格式跟YUY2类似，只是排列顺序有所不同。Y211格式是Y每2个像素采样一次，而UV每4个像素采样一次。AYUV格式则有一Alpha通道。

### YV12

YV12格式与IYUV类似，每个像素都提取Y，在UV提取时，将图像2 x 2的矩阵，每个矩阵提取一个U和一个V。YV12格式和I420格式的不同处在V平面和U平面的位置不同。在YV12格式中，V平面紧跟在Y平面之后，然后才是U平面（即：YVU）；但I420则是相反（即：YUV）。NV12与YV12类似，效果一样，YV12中U和V是连续排列的，而在NV12中，U和V就交错排列的。

排列举例： 2*2图像YYYYVU； 4＊4图像YYYYYYYYYYYYYYYYVVVVUUUU

## 转换

### YUV与RGB的转换公式

$$
Y = 0.299 \times R + 0.587 \times G + 0.114 \times B \\\
U = -0.169 \times R - 0.331 \times G + 0.5 \times B + 128 \\\
V = 0.5 \times R - 0.419 \times G - 0.081 \times B + 128 
$$

YUV的取值范围：

$$
Y \in [0,255] \\\
U \in [0,255] \\\
V \in [0,255]
$$

反过来，从YUV得到RGB，公式如下

$$
\begin{align}
&R = Y + 1.13983 \times (V-128) \\\
&G = Y - 0.39465 \times (U-128) - 0.58060 \times (V-128) \\\
&B = Y + 2.03211 \times (U-128)
\end{align}
$$

用矩阵表示法，表示如下：

$$
\begin{bmatrix}
Y \\
U \\
V
\end{bmatrix}=\begin{bmatrix}
0.299&0.587&0.114 \\
-0.169&-0.331&0.5 \\
0.5&-0.419&-0.081
\end{bmatrix}\begin{bmatrix}
R \\
G \\
B
\end{bmatrix}+\begin{bmatrix}
0 \\
128 \\
128
\end{bmatrix}
$$

$$
\begin{bmatrix}
R \\
G \\
B
\end{bmatrix}=\begin{bmatrix}
1&-0.00093&1.401687 \\
1&-0.3437&-0.71417 \\
1&1.77216&0.00099
\end{bmatrix}\begin{bmatrix}
Y \\
U-128 \\
V-128
\end{bmatrix}
$$

### Y'UV与RGB转换

SDTV(standard-definition television) with BT.601定义公式如下：

$$
\begin{bmatrix}
Y' \\
U \\
V
\end{bmatrix}=\begin{bmatrix}
0.299&0.587&0.114 \\
-0.14713&-0.28886&0.436 \\
0.615&-0.51499&-0.10001
\end{bmatrix}\begin{bmatrix}
R \\
G \\
B
\end{bmatrix}
$$

$$
\begin{bmatrix}
R \\
G \\
B
\end{bmatrix}=\begin{bmatrix}
1&0&1.13983 \\
1&-0.39465&-0.58060 \\
1&2.03211&0
\end{bmatrix}\begin{bmatrix}
Y' \\
U \\
V
\end{bmatrix}
$$

HDTV with BT.709定义公式如下：

$$
\begin{bmatrix}
Y' \\
U \\
V
\end{bmatrix}=\begin{bmatrix}
0.2126&0.7152&0.0722 \\
-0.09991&-0.33609&0.436 \\
0.615&-0.55861&-0.05639
\end{bmatrix}\begin{bmatrix}
R \\
G \\
B
\end{bmatrix}
$$

$$
\begin{bmatrix}
R \\
G \\
B
\end{bmatrix}=\begin{bmatrix}
1&0&1.28033 \\
1&-0.21482&-0.38059 \\
1&2.12798&0
\end{bmatrix}\begin{bmatrix}
Y' \\
U \\
V
\end{bmatrix}
$$


## 数值近似

### studio swing for BT.601

$ Y' \in [16,235]$
$ U/V \in [16,240]$

**step 1**
$$
\begin{bmatrix}
Y' \\
U \\
V
\end{bmatrix}=\begin{bmatrix}
66&129&25 \\
-38&-74&112 \\
112&-94&-18
\end{bmatrix}\begin{bmatrix}
R \\
G \\
B
\end{bmatrix}
$$

**step 2**
$$
Yt' = (Y' + 128) >> 8 \\\
Ut = (U + 128) >> 8 \\\
Vt = (V + 128) >> 8
$$

**step 3**
$$
Yu' = Yt' + 16 \\\
Uu = Ut + 128 \\\
Vu = Vt + 128
$$

### Full swing for BT.601
$Y'/U/V \in [0,255]$

**step 1**
$$
\begin{bmatrix}
Y' \\
U \\
V
\end{bmatrix}=\begin{bmatrix}
77&150&29 \\
-43&-84&127 \\
127&-106&-21
\end{bmatrix}\begin{bmatrix}
R \\
G \\
B
\end{bmatrix}
$$

**step 2**
$$
Yt' = (Y' + 128) >> 8 \\\
Ut = (U + 128) >> 8 \\\
Vt = (V + 128) >> 8
$$

**step 3**
$$
Yu' = Yt' + 16 \\\
Uu = Ut + 128 \\\
Vu = Vt + 128
$$

### Y'UV444 to RGB888

$$
Y' = 0.299 \times R + 0.587 \times G + 0.114 \times B \\\
U = -0.147 \times R - 0.289 \times G + 0.436 \times B \\\
V = 0.615 \times R - 0.515 \times G - 0.100 \times B
$$

转成定点：

$$
Y' = ((66 \times R + 129 \times G + 25 \times B +128) >> 8) + 16 \\\
U = ((-38 \times R - 74 \times G + 112 \times B +128) >> 8) + 128 \\\
V = ((112 \times R - 94 \times G - 18 \times B + 128) >> 8 ) +128
$$

### RGB888 to Y'UV

定点方法：
clmap 表示限定值在[0,255]之间

$$
C = Y' - 16 \\\
D = U - 128 \\\
E = V - 128 \\\
R = clamp( (298 \times C + 408 \times E + 128) >> 8 ) \\\
G = clamp( (298 \times C - 100 \times D - 208 \times E +128) >> 8 ) \\\
B = clamp( (298 \times C + 516 \times D +128) >> 8 ) \\\
$$

### Y'UV422 to RGB888

Y'UV422在内存中的存储方式如下：
![350px-Yuv422_yuy2.svg](http://ows8v7qop.bkt.clouddn.com/350px-Yuv422_yuy2.svg.png)

所以读取4bytes， 输出6bytes(2 pixels)

```c
y0 = yuv[0];
u =  yuv[1];
y1 = yuv[2];
v = yuv[3];
rgb0 = Y'UV444toRGB888(y0, u, v);
rgb1 = Y'UV444toRGB888(y1, u, v);
```

### Y'UV420p (I420) to RGB888

Y'UV420p的采样方式如下：
![800px-Yuv420.svg](http://ows8v7qop.bkt.clouddn.com/800px-Yuv420.svg.png)

获取坐标为(x,y)像素点的y,u,v方法如下：

```c
total_pixel = width * height;
y = yuv[y*width + x];
u = yuv[(y/2) * (width/2) + (x/2) + total_pixel]
v = yuv[(y/2) * (widith/2) + (x/2) + total_pixel + (total_pixel/4)]
rgb = Y'uv444toRGB(y,u,v)
```

Y'V12 和Y'UV420p相似，只是UV数据反转， Y'后是V，然后是U。


## 代码示例

### RGB to Y'UV420p

```c
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

void Rgb2Yuv420p(uint8_t *destination, uint8_t *rgb, size_t width, size_t height)
{
    size_t image_size = width * height;
    size_t upos = image_size;
    size_t vpos = upos + upos / 4;
    size_t i = 0;

    for( size_t line = 0; line < height; ++line )
    {
        if( !(line % 2) )
        {
            for( size_t x = 0; x < width; x += 2 )
            {
                uint8_t r = rgb[3 * i];
                uint8_t g = rgb[3 * i + 1];
                uint8_t b = rgb[3 * i + 2];
				uint8_t yt =  ((66*r + 129*g + 25*b + 128) >> 8) + 16;
				uint8_t ut =  (((-38*r) + (-74*g) + 112*b + 128) >> 8) + 128;
				uint8_t vt =  ((112*r + (-94*g) + (-18*b) + 128) >> 8) + 128;

                destination[i++] = yt;
                destination[upos++] = ut;
                destination[vpos++] = vt;

                r = rgb[3 * i];
                g = rgb[3 * i + 1];
                b = rgb[3 * i + 2];
				yt =  ((66*r + 129*g + 25*b + 128) >> 8) + 16;

                destination[i++] = yt;
            }
        }
        else
        {
            for( size_t x = 0; x < width; x += 1 )
            {
                uint8_t r = rgb[3 * i];
                uint8_t g = rgb[3 * i + 1];
                uint8_t b = rgb[3 * i + 2];
				uint8_t yt =  ((66*r + 129*g + 25*b + 128) >> 8) + 16;

                destination[i++] = yt;
            }
        }
    }
}
```

测试文件：
```c
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
```

makefile文件：

```makefile
GENFILE = yuv.in

b build: torgb toyuv

torgb:
	g++ -o torgb torgb.cpp -I./ -g

toyuv:
	g++ -o toyuv toyuv.cpp -I./ -g

g1 gen1:
	./toyuv rgb.in yuv.out 60 40

g2 gen2:
	./torgb yuv.in rgb.out 720 480

p1 play1:
	cat yuv.out| ffplay -i pipe:0 -f rawvideo -pix_fmt yuv420p -video_size 60x40

p2 play2:
	cat rgb.out | ffplay -i pipe:0 -f rawvideo -pix_fmt rgb24 -video_size 720x480

.PHONY: torgb toyuv
```

上面的makefile包含了下面yuv2rgb的部分

### Y'uv420p to RGB

```c
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
```

测试用例:

```c
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


	uint8_t bufin[(size_t)(imagesize*1.5)];
	uint8_t bufout[imagesize*3];

	size_t nread;

	FILE * fin=fopen("yuv.in", "r");
	FILE * fout=fopen(dout, "w+");

	if(fin) {
		while((nread = fread(bufin, 1, sizeof(bufin), fin)) > 0) {
			Yuv420p2Rgb888(bufout, bufin, width, height);
			fwrite(bufout, 1, sizeof(bufout), fout);
			fflush(fout);
		}
	}


	fclose(fin);
	fclose(fout);
	return 0;


}
```

## 总结

YUV相比RGB的优点是和黑白兼容，而且它的变种容易压缩带宽，它被广泛用于目前各种图像和视频编码中。掌握它是开始图像和视频编程的基础

注：本文大部分内容是来自YUV的[wiki](https://en.wikipedia.org/wiki/YUV#Y.E2.80.B2UV420p_.28and_Y.E2.80.B2V12_or_YV12.29_to_RGB888_conversion), 大家也可以自行查看原文。
