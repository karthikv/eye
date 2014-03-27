clean:
	rm -rf files scripts

dev:
	make clean
	gulp dev
	fss dev

prod:
	make clean
	gulp prod
	fss prod
