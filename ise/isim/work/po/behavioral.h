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

#ifndef H_Work_po_behavioral_H
#define H_Work_po_behavioral_H
#ifdef __MINGW32__
#include "xsimMinGW.h"
#else
#include "xsim.h"
#endif


class Work_po_behavioral: public HSim__s6 {
public:

    HSim__s1 SE[26];

  HSimArrayType Reg16array;
    HSim__s1 SA[17];
HSimConstraints *c6;
  char *t7;
  int t8;
    Work_po_behavioral(const char * name);
    ~Work_po_behavioral();
    void constructObject();
    void constructPorts();
    void reset();
    void architectureInstantiate(HSimConfigDecl* cfg);
    virtual void vhdlArchImplement();
};



HSim__s6 *createWork_po_behavioral(const char *name);

#endif
