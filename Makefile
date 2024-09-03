# [PUTAIN - makefile]
# juan diego pmz (Moi3Moi)
# Mon Sep 3 2024

objs = putain.o
exec = puta

all: $(exec)

$(exec): $(objs)
	ld	-o $(exec) $(objs)

%.o: %.s
	as	-o $@ $<

clean:
	rm	-rf $(objs) $(exec) && clear
