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

yuv:
	yes | ffmpeg -i h264.mp4 -f rawvideo -vcodec rawvideo -frames 100 yuv.in

testyuv:
	cat $(GENFILE) | ffplay -i pipe:0 -f rawvideo -pix_fmt yuv420p -video_size 720x480

p2 play2:
	cat rgb.out | ffplay -i pipe:0 -f rawvideo -pix_fmt rgb24 -video_size 720x480

.PHONY: torgb toyuv
