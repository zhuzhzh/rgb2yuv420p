GENFILE = yuv1.in

b build: torgb toyuv

torgb:
	g++ -o torgb torgb.cpp -I./ -g

toyuv:
	g++ -o toyuv toyuv.cpp -I./ -g

g1 gen1:
	./toyuv rgb0.in yuv0.out 60 40

g2 gen2:
	./torgb yuv1.in rgb1.out 720 480

p1 play1:
	cat yuv0.out| ffplay -i pipe:0 -f rawvideo -pix_fmt yuv420p -video_size 60x40

yuv:
	yes | ffmpeg -i h264.mp4 -f rawvideo -vcodec rawvideo -frames 100 yuv.in

testyuv:
	cat $(GENFILE) | ffplay -i pipe:0 -f rawvideo -pix_fmt yuv420p -video_size 720x480

p2 play2:
	cat rgb1.out | ffplay -i pipe:0 -f rawvideo -pix_fmt rgb24 -video_size 720x480

conv2vpx:
	./simple_encoder vp9 720 480 yuv.in vp9.webm 2 0 30

tovpx:
	gcc -I/trunk/branch/sdl/libvpx/third_party/libwebm \
	-I/trunk/branch/sdl/libvpx/vp8 \
	-I/trunk/branch/sdl/libvpx/vp9 \
	-I/trunk/branch/sdl/libvpx/third_party/libyuv/include \
	-m64 -DNDEBUG -O3 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0 \
	-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -Wall \
	-Wdeclaration-after-statement -Wdisabled-optimization \
	-Wpointer-arith -Wtype-limits -Wcast-qual -Wvla \
	-Wimplicit-function-declaration -Wuninitialized \
	-Wunused -Wextra -Wundef -Wframe-larger-than=52000 \
	-I. -I/trunk/branch/sdl/libvpx \
	-c -o tovpx.o \
	tovpx.c
	g++ -L/trunk/branch/sdl/libvpx -m64 -o tovpx ivfenc.c.o tools_common.c.o video_writer.c.o tovpx.o -lvpx -lm -lpthread

g3 gen3:
	time ./tovpx rgb1.out webm1.out 720 480


.PHONY: torgb toyuv tovpx
