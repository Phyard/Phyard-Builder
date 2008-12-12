OUTPUT=MochiAd.swf
SOURCES=Test.as MochiAd.as Preloader.as

all: $(OUTPUT)

clean:
	rm -f $(OUTPUT)

MochiAd.swf: $(SOURCES)
	mxmlc \
		-default-frame-rate 31 \
		-default-size 550 400 \
		-use-network \
		-optimize=true \
		-output $@ \
		-frame=Test,Test \
		Preloader.as

.PHONY: all clean
