#include "Vtestbench.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

VerilatedContext* contextp = NULL; // 上下文变量
VerilatedVcdC* tfp = NULL;         // 波形变量
static Vtestbench* top;               // 声明模块变量
static int sim_time = 50000000;

void sim_init(int argc, char** argv ){
	contextp = new VerilatedContext;  
	contextp->commandArgs(argc, argv);
	top = new Vtestbench;                 
	#ifdef ENABLE_WAVEFORM
		Verilated::traceEverOn(true);
		tfp = new VerilatedVcdC;
		top->trace(tfp, 99);
		tfp->open("build/dump.vcd");
	#endif
}

void main_loop(){
	while(contextp->time() < sim_time && !contextp->gotFinish()){
		contextp->timeInc(1);
		top->eval();
	#ifdef ENABLE_WAVEFORM
		tfp->dump(contextp->time());
	#endif
	}
}

void sim_exit(){
#ifdef ENABLE_WAVEFORM
	if(tfp){
		tfp->close();
		delete tfp;
	}
#endif
	delete top;
	delete contextp;
}

int main(int argc, char** argv) {
	sim_init(argc, argv);
	main_loop();
	sim_exit();
	return 0;
}
