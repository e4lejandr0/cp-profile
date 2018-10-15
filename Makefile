CFLAGS  :=-g
LDFLAGS :=
BINDIR := bin

GPROF := gprof

# Test parameters
TESTSIZE := 1024  # in MB
TESTFILE := ${BINDIR}/testfile
TESTCPY  := ${BINDIR}/testcpy 

# Profiling results
STATSFILE := stats.xt

all: cp cp-prof

cp: dirs cp.c
	${CC} ${CFLAGS} ${LDFLAGS} cp.c -o ${BINDIR}/cp
cp-prof: dirs cp.c
	$(eval LDFLAGS +=-pg)
	${CC} ${CFLAGS} ${LDFLAGS} cp.c -o ${BINDIR}/cp-prof

dirs:
	@mkdir -p ${BINDIR}

.PHONY: clean
clean:
	@rm -rf ${BINDIR}

.PHONY: gendata
gendata: dirs
	@printf "Generating %04dMB of data...\n" ${TESTSIZE}
	dd if=/dev/zero bs=1M count=${TESTSIZE} of=${TESTFILE} status=progress

.PHONY: run
run: cp
	${BINDIR}/cp ${TESTFILE} ${TESTCPY}

.PHONY: run-profile
run-profile: cp-prof
	${BINDIR}/cp-prof ${TESTFILE} ${TESTCPY}
	${GPROF} ${BINDIR}/cp-prof > ${STATSFILE}
