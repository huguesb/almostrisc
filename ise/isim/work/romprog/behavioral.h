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

#ifndef H_Work_romprog_behavioral_H
#define H_Work_romprog_behavioral_H
#ifdef __MINGW32__
#include "xsimMinGW.h"
#else
#include "xsim.h"
#endif


class Work_romprog_behavioral: public HSim__s6 {
public:

    HSim__s1 SE[3];

HSim__s4 C8;
HSim__s4 Cb;
  HSimArrayType Octet;
  HSimArrayType Zone_memoirebase;
  HSimArrayType Zone_memoire;
  char *t29;
HSim__s4 CN;
    Work_romprog_behavioral(const char * name);
    ~Work_romprog_behavioral();
    void constructObject();
    void constructPorts();
    void reset();
    void architectureInstantiate(HSimConfigDecl* cfg);
    virtual void vhdlArchImplement();
};



HSim__s6 *createWork_romprog_behavioral(const char *name);

#endif
