.SUFFIXES:

# Pick the first available compiler: g++-13 > g++-12 > g++-11 > g++
CXX_CANDIDATES := g++-13 g++-12 g++-11 g++
CXX := $(firstword $(foreach c,$(CXX_CANDIDATES),$(if $(shell command -v $(c) 2>/dev/null),$(c))))

ifeq ($(CXX),)
$(error No g++ found (tried: $(CXX_CANDIDATES)))
endif

LD := $(CXX)
CXXFLAGS := -g -O0 -std=c++23

CPU ?= 1

RED   := "\\033[31m"
GREEN := "\\033[32m"
RESET := "\\033[0m"

TASKS = $(patsubst %/,%,$(wildcard */))
TASKS_OUT = $(patsubst %,%.out,$(TASKS))

.PHONY: all clean

default:
	@printf "Usage: make [task]\n"

.PHONY: $(TASKS_OUT)

$(filter-out task1,$(TASKS)): %: %.out
	@echo "taskset -c $(CPU) ./$*.out $(args)"
	@taskset -c $(CPU) ./$*.out $(args); printf "\nReturn Code: %d\n" $$?

# `make task1` also writes the output to task1/data.txt and draws task1/latency.png.
.PHONY: task1
task1: task1.out
	@echo "taskset -c $(CPU) ./task1.out > task1/data.txt"
	@taskset -c $(CPU) ./task1.out > task1/data.txt
	@python3 task1/plot.py task1/data.txt --caches $(CPU)

.SECONDEXPANSION:

get_all_o_files = $(addsuffix .o, $(basename $(wildcard $1/*.cpp)))
get_sol_o_files = $(filter %_solution.o, $(call get_all_o_files,$1))
get_oth_o_files = $(filter-out $(call get_sol_o_files,$1),$(call get_all_o_files,$1))

$(TASKS_OUT): %.out: $$(call get_oth_o_files,$$*)
	$(LD) -o $@ $^

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# --- Lab exam (labexam/) ---
# `make labexam` builds and runs poly. `make labexam-check` also checks that the fixed part of the
# source is unchanged and that poly_fast uses SSE (mulps), which level 2 requires.
FIXED_SHA = 70574b78530784e4ba563abd40b80ed5801f360ebfaa0cc7385b0cdd5e36f8c2

.PHONY: labexam-check
labexam-check: labexam.out
	@src=labexam/poly.cpp; \
	got=$$(sed '/YOUR CODE BELOW/,/YOUR CODE ABOVE/d' $$src | sha256sum | cut -d' ' -f1); \
	if [ "$$got" = "$(FIXED_SHA)" ]; then printf $(GREEN)"PASS"$(RESET)" -- code outside the markers is unchanged\n"; \
	else printf $(RED)"FAIL"$(RESET)" -- code outside the YOUR CODE markers was edited\n"; fi; \
	n=$$(objdump -d --no-show-raw-insn labexam.out | awk '/<_Z9poly_fastv>:/{f=1;next} /^$$/{f=0} f' | grep -c mulps); \
	if [ "$$n" -gt 0 ]; then printf $(GREEN)"PASS"$(RESET)" -- poly_fast uses SSE (%s mulps)\n" "$$n"; \
	else printf $(RED)"FAIL"$(RESET)" -- no mulps in poly_fast (level 2 needs SSE)\n"; fi; \
	taskset -c $(CPU) ./labexam.out

clean:
	@rm -fv $(TASKS_OUT) */*.o task1/data.txt task1/latency.png
