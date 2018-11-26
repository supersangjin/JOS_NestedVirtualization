

#include <inc/trap.h>
bool handle_interrupt_window(struct Trapframe *tf, struct VmxGuestInfo *ginfo, uint32_t host_vector);
bool handle_interrupts(struct Trapframe *tf, struct VmxGuestInfo *ginfo, uint32_t host_vector);
bool handle_eptviolation(uint64_t *eptrt, struct VmxGuestInfo *ginfo);
bool handle_rdmsr(struct Trapframe *tf, struct VmxGuestInfo *ginfo);
bool handle_wrmsr(struct Trapframe *tf, struct VmxGuestInfo *ginfo);
bool handle_ioinstr(struct Trapframe *tf, struct VmxGuestInfo *ginfo);
bool handle_cpuid(struct Trapframe *tf, struct VmxGuestInfo *ginfo);
bool handle_vmcall(struct Trapframe *tf, struct VmxGuestInfo *gInfo, uint64_t *eptrt );
bool handle_vmclear(struct Trapframe *tf, struct VmxGuestInfo *gInfo);
bool handle_vmptrld(struct Trapframe *tf, struct VmxGuestInfo *gInfo);
bool handle_vmwrite(struct Trapframe *tf, struct VmxGuestInfo *gInfo);
bool handle_vmlaunch(struct Trapframe *tf, struct VmxGuestInfo *gInfo);
extern struct Env *L1_env;
extern struct Env *L2_env;
