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

#ifndef H_Work_processeurandco_behavioral_H
#define H_Work_processeurandco_behavioral_H
#ifdef __MINGW32__
#include "xsimMinGW.h"
#else
#include "xsim.h"
#endif


class Work_processeurandco_behavioral: public HSim__s6 {
public:

    HSim__s1 SE[9];

    HSim__s1 SA[10];
  char *t33;
  char *t34;
    Work_processeurandco_behavioral(const char * name);
    ~Work_processeurandco_behavioral();
    void constructObject();
    void constructPorts();
    void reset();
    void architectureInstantiate(HSimConfigDecl* cfg);
    virtual void vhdlArchImplement();
};



HSim__s6 *createWork_processeurandco_behavioral(const char *name);

#endif
