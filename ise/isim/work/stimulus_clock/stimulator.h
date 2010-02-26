////////////////////////////////////////////////////////////////////////////////
//   ____  ____   
//  /   /\/   /  
// /___/  \  /   
// \   \   \/  
//  \   \        Copyright (c) 2003-2004 Xilinx, Inc.
//  /   /        All Right Reserved. 
// /---/   /\     
// \   \  /  \  
//  \___\/\___\
////////////////////////////////////////////////////////////////////////////////

#ifndef H_Work_stimulus_clock_stimulator_H
#define H_Work_stimulus_clock_stimulator_H
#ifdef __MINGW32__
#include "xsimMinGW.h"
#else
#include "xsim.h"
#endif


class Work_stimulus_clock_stimulator: public HSim__s6 {
public:

    HSim__s1 SE[1];

HSim__s4 C8;
    Work_stimulus_clock_stimulator(const char * name);
    ~Work_stimulus_clock_stimulator();
    void constructObject();
    void constructPorts();
    void reset();
    void architectureInstantiate(HSimConfigDecl* cfg);
    virtual void vhdlArchImplement();
};



HSim__s6 *createWork_stimulus_clock_stimulator(const char *name);

#endif
