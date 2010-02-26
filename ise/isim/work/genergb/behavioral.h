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

#ifndef H_Work_genergb_behavioral_H
#define H_Work_genergb_behavioral_H
#ifdef __MINGW32__
#include "xsimMinGW.h"
#else
#include "xsim.h"
#endif


class Work_genergb_behavioral: public HSim__s6 {
public:

    HSim__s1 SE[9];

    HSim__s1 SA[2];
  int t172;
HSimConstraints *c173;
  char *t174;
HSimConstraints *c175;
HSimConstraints *c176;
  char *t177;
  char *t178;
  char t179;
    Work_genergb_behavioral(const char * name);
    ~Work_genergb_behavioral();
    void constructObject();
    void constructPorts();
    void reset();
    void architectureInstantiate(HSimConfigDecl* cfg);
    virtual void vhdlArchImplement();
};



HSim__s6 *createWork_genergb_behavioral(const char *name);

#endif
