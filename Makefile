all:
	mkdir -p out
	bsc -show-schedule -D RV32 -check-assert -p "%/Libraries:CSR:." -u -sim -bdir out -simdir out -info-dir out ExceptionController_tb.bsv
	bsc -show-schedule -sim -u -check-assert -e mkExceptionController_tb -simdir out -bdir out -o out/ExceptionController_tb
