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

#ifndef H_Work_cond_checker_behavioral_H
#define H_Work_cond_checker_behavioral_H
#ifdef __MINGW32__
#include "xsimMinGW.h"
#else
#include "xsim.h"
#endif


class Work_cond_checker_behavioral: public HSim__s6 {
public:

    HSim__s1 SE[3];

    HSim__s1 SA[2];
  char t73;
  char t74;
  char t75;
  char t76;
  char t77;
  char t78;
  char t79;
  char t80;
  char t81;
  char t82;
  char t83;
  char t84;
  char t85;
  char t86;
  char t87;
    Work_cond_checker_behavioral(const char * name);
    ~Work_cond_checker_behavioral();
    void constructObject();
    void constructPorts();
    void reset();
    void architectureInstantiate(HSimConfigDecl* cfg);
    virtual void vhdlArchImplement();
};



HSim__s6 *createWork_cond_checker_behavioral(const char *name);

#endif
