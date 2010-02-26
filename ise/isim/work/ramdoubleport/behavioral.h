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

#ifndef H_Work_ramdoubleport_behavioral_H
#define H_Work_ramdoubleport_behavioral_H
#ifdef __MINGW32__
#include "xsimMinGW.h"
#else
#include "xsim.h"
#endif


class Work_ramdoubleport_behavioral: public HSim__s6 {
public:

    HSim__s1 SE[9];

HSim__s4 C8;
HSim__s4 Cb;
  HSimArrayType Octet;
  HSimArrayType Zone_memoirebase;
  HSimArrayType Zone_memoire;
    HSim__s1 SA[1];
    Work_ramdoubleport_behavioral(const char * name);
    ~Work_ramdoubleport_behavioral();
    void constructObject();
    void constructPorts();
    void reset();
    void architectureInstantiate(HSimConfigDecl* cfg);
    virtual void vhdlArchImplement();
};



HSim__s6 *createWork_ramdoubleport_behavioral(const char *name);

#endif
