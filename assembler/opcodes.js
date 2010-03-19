/**********************************************************************************
**
** Copyright 2010 Hugues Bruant. All rights reserved.
**
** <hugues.bruant@ensimag.imag.fr>
**
** This file is part of a school project and licensed under the terms of FreeBSD
** license (2-clause BSD also refered to as Simplified BSD License)
**
**********************************************************************************/

/*
	Some explanations about the inner workings :
	
	* one-pass assembly
	* keep track of forward references and resolve them last
	* modularity : nothing hardcoded in assembler
		=> regexps and eval() rock
	* reduced redudancy : directly take advantage of instructions bit patterns
	* optimized for size and simplicity
	
	What's missing :
	* support for "modules"/includes (doable with pure JS ???)
	* support for data embedding (not really useful since our CPU is a "Harvard machine")
	* better label system (with advanced scoping and unnamed labels) 
	
	Thoughts about module assembling :
	* do separate assembly pass for each module and keep results around
	* iteratively resolve remaining references with as many passes as required (unless
	we run into an unsolvable deps-chain : one pass without any new resolution)
	* merge back the different fragments (check for address range overlaps)
*/

// register code fields
var regs = new Array();

for ( i = 0; i < 8; ++i )
	regs["r" + i] = i;

// alias...
regs["-"] = 0;

// UAL operation code fields
var ops = new Array();
ops[0] = {name : "nop", value : 0x00};
ops[1] = {name : "inc", value : 0x02};
ops[2] = {name : "dec", value : 0x03};
ops[3] = {name : "add", value : 0x04};
ops[4] = {name : "sub", value : 0x05};
ops[5] = {name : "adc", value : 0x06};
ops[6] = {name : "sbc", value : 0x07};
ops[7] = {name : "mova", value : 0x08};
ops[8] = {name : "movb", value : 0x09};
ops[9] = {name : "nega", value : 0x0A};
ops[10] = {name : "negb", value : 0x0B};
ops[11] = {name : "and", value : 0x10};
ops[12] = {name : "or", value : 0x11};
ops[13] = {name : "xor", value : 0x12};
ops[14] = {name : "not", value : 0x13};
ops[15] = {name : "shl", value : 0x20};
ops[16] = {name : "shr", value : 0x30};
// extra operations (spec extension)
ops[17] = {name : "mixhh", value : 0x0C};
ops[18] = {name : "mixhl", value : 0x0D};
ops[19] = {name : "mixlh", value : 0x0E};
ops[20] = {name : "mixll", value : 0x0F};

// condition code fields
var conds = new Array();
conds[0] = {name : "eq", value : 0};
conds[1] = {name : "ge", value : 1};
conds[2] = {name : "le", value : 2};
conds[3] = {name : "ic", value : 3};
conds[4] = {name : "ne", value : 4};
conds[5] = {name : "lt", value : 5};
conds[6] = {name : "gt", value : 6};
conds[7] = {name : "no", value : 7};
// alias for "always true" condition
conds[8] = {name : "", value : 3};

// instruction patterns
var instr = new Array();

// load (9bit, sign-extended) immediate
instr["li\\s+(r[0-7])\\s*,?\\s*(.+)"]		= ["0xC000 + reg(\"\\1\") + ((immediate(\"\\2\", 9, 0) << 3) & 0x0FF8)"];

// memory I/O
instr["lw\\s+(r[0-7])\\s*,?\\s*(r[0-7])"]	= ["0xD000 + reg(\"\\1\") + (reg(\"\\2\") << 3)"];
instr["sw\\s+(r[0-7])\\s*,?\\s*(r[0-7])"]	= ["0xD200 + reg(\"\\1\") + (reg(\"\\2\") << 3)"];
// spec extension : direct reg/mem swap
instr["exw\\s+(r[0-7])\\s*,?\\s*(r[0-7])"]	= ["0xE400 + reg(\"\\1\") + (reg(\"\\2\") << 3)"];

// port I/O
instr["in\\s+(r[0-7])"]						= ["0xD400 + reg(\"\\1\")"];
instr["out\\s+(r[0-7])"]					= ["0xD600 + (reg(\"\\1\") << 6)"];

// branching
instr["bri(|eq|ge|le|ic|ne|lt|gt)?\\s+(-|r[0-7])\\s*,?\\s*(.+)"] = ["0x8000 + condition(\"\\1\") + (reg(\"\\2\") << 3) + ((immediate(\"\\3\", 8, 1) << 6) & 0x3FC0)"];
instr["brl\\s+(r[0-7])\\s*,?\\s*(r[0-7])"]	= ["0xF000 + reg(\"\\1\") + (reg(\"\\2\") << 6)"];
instr["bal\\s+(r[0-7])\\s*,?\\s*(r[0-7])"]	= ["0xF200 + reg(\"\\1\") + (reg(\"\\2\") << 6)"];
instr["br(|eq|ge|le|ic|ne|lt|gt)\\s+(-|r[0-7])\\s*,?\\s*(r[0-7])"] = ["0xE000 + condition(\"\\1\") + (reg(\"\\2\") << 3) + (reg(\"\\3\") << 6)"];
instr["ba(|eq|ge|le|ic|ne|lt|gt)\\s+(-|r[0-7])\\s*,?\\s*(r[0-7])"] = ["0xE200 + condition(\"\\1\") + (reg(\"\\2\") << 3) + (reg(\"\\3\") << 6)"];
// spec extension : 16 bit immediate absolute conditionnal branch
instr["bai(|eq|ge|le|ic|ne|lt|gt)\\s+(-|r[0-7])\\s*,?\\s*(.+)"] = ["0xF800 + (condition(\"\\1\") << 6) + (reg(\"\\2\") << 3)", "immediate(\"\\3\", 16, 0)"];
// spec extension : 16 bit immediate absolute conditionnal branch with link
instr["bail(|eq|ge|le|ic|ne|lt|gt)\\s+(-|r[0-7])\\s*,?\\s*(r[0-7])\\s*,?\\s*(.+)"] = ["0xFA00 + (condition(\"\\1\") << 6) + (reg(\"\\2\") << 3) + reg(\"\\3\")", "immediate(\"\\4\", 16, 0)"];

// spec extension : 16 bit immediate load
instr["liw\\s+(r[0-7])\\s*,?\\s*(.+)"] = ["0xFFF0 + reg(\"\\1\")", "immediate(\"\\2\", 16, 0)"];

instr["reset"] = ["0xFFFF"];

// spec extension : interrupt exit
instr["reti"] = ["0xFFFE"];

// spec extension : alias for nop r0, r0, r0
instr["nop"] = ["0x0000"];

// spec extension : multiplication, outside ALU for performance reasons
instr["mul\\s+(r[0-7])\\s*,?\\s*(r[0-7])\\s*,?\\s*(r[0-7])"] = ["0xFC00 + reg(\"\\1\") + (reg(\"\\2\") << 3) + (reg(\"\\3\") << 6)"];

// 2 address ops
instr["(inc|dec|mova|nega|not)\\s+(r[0-7])\\s*,?\\s*(r[0-7])"]	= ["(operation(\"\\1\") << 9) + reg(\"\\2\") + (reg(\"\\3\") << 3)"];
instr["(movb|negb)\\s+(r[0-7])\\s*,?\\s*(r[0-7])"]	= ["(operation(\"\\1\") << 9) + reg(\"\\2\") + (reg(\"\\3\") << 6)"];
instr["(shl|shr)\\s+(r[0-7])\\s*,?\\s*(r[0-7])\\s*,?\\s*(.+)"]	= ["(operation(\"\\1\") << 9) + reg(\"\\2\") + (reg(\"\\3\") << 3) + ((immediate(\"\\4\", 4, 0) << 9) & 0x1F00)"];
// catch-all for 3 address ops
instr["(\\w+)\\s+(r[0-7])\\s*,?\\s*(r[0-7])\\s*,?\\s*(r[0-7])"]	= ["(operation(\"\\1\") << 9) + reg(\"\\2\") + (reg(\"\\3\") << 3) + (reg(\"\\4\") << 6)"];

// internal assembler variables
var pc = 0;
var filler = 0;
var labels = new Array();
var hex = new Array();
var fwd = new Array();

// Exceptions
ImmediateSizeError = new Error("Immediate too large");
UnknownLabelError = new Error("Unknown label");
UnknownInstructionError = new Error("Unknown instruction");
DuplicateLabelError = new Error("Duplicate label");
InvalidOrgAddress = new Error("Invalid org address");

function reg(name)
{
	return regs[name.toLowerCase()];
}

// exception-throwing proxy to access operations table
function operation(name)
{
	for ( i in ops )
	{
		var op = ops[i];
		
		if ( op.name == name.toLowerCase() )
			return op.value;
	}
	
	throw UnknownInstructionError;
}

// exception-throwing proxy to access conditions table
function condition(name)
{
	for ( i in conds )
	{
		var cond = conds[i];
		
		if ( cond.name == name.toLowerCase() )
			return cond.value;
	}
	
	throw UnknownInstructionError;
}

// exception-throwing proxy to access labels table
function label(name)
{
	for ( i in labels )
	{
		var lbl = labels[i];
		
		if ( lbl.name == name )
			return lbl.address;
	}
	
	throw UnknownLabelError;
}

// exception-throwing proxy to compute immediate value
function immediate(value, bits, rel)
{
	var r;
	
	if ( String(value).match(/^-?(0x[0-9A-Fa-f]+|0[0-7]+|[0-9]+)$/) != null )
	{
		r = parseInt(value);
	} else {
		if ( /[-+/*()~&|^$]/.test(value) )
		{
			value = value.replace("$", " " + pc + " ");
			
			for ( i in labels )
				value = value.replace(labels[i].name, " " + labels[i].address + " ");
			
			try {
				r = eval(value);
			} catch ( e ) {
				throw UnknownLabelError;
			}
		} else {
			r = label(value);
		}
		
		if ( rel != 0 )
		{
			//print(value + " : " + r + " - " + pc);
			r -= pc;
		}
	}
	
	if ( Math.abs(r) >= (1 << bits) )
	{
		throw ImmediateSizeError;
	}
	
	return r;
}

var opcode_sz;

function opcode(line)
{
	for ( pattern in instr )
	{
		var rx = new RegExp("^" + pattern + "$", "i");
		
		match = rx.exec(line);
		
		if ( match != null )
		{
			var opc = instr[pattern];
			var hexcodes = new Array();
			
			opcode_sz = opc.length;
			
			for ( n in opc )
			{
				var op = opc[n];
				
				for ( i = 1; i < match.length; ++i )
				{
					op = op.replace("\\" + i, match[i]);
				}
				
				hexcodes[n] = eval(op);
			}
			
			return hexcodes;
		}
	}
	
	throw UnknownInstructionError;
}

function hex16(i)
{
	var s = i.toString(16).toUpperCase();
	
	while ( s.length < 4 )
		s = "0" + s;
	
	return s;
}

function bin16(i)
{
	var s = i.toString(2);
	
	while ( s.length < 16 )
		s = "0" + s;
	
	return s;
}

function assemble(text)
{
	var lines = String(text).split("\n");
	
	for ( l in lines )
	{
		var line = lines[l];
		var first = line.search(/\S/);
		
		// skip blank lines
		if ( first == -1 )
			continue;
		
		// remove comment if any, skip if whole line is a comment
		var comment = line.indexOf(";");
		if ( comment == first )
			continue;
		if ( comment != -1 )
			line = line.substr(0, comment);
		
		// remove trailing whitespaces
		var last = line.search(/\S\s*$/);
		line = line.substring(first, last + 1);
		
		var dir = /\.(org|equ|filler)\s+(.+)\s*/i.exec(line);
		
		if ( dir != null )
		{
			if ( dir[1] == "org" )
			{
				npc = immediate(dir[2], 16, 0);
				
				if ( npc < pc )
					throw InvalidOrgAddress;
				
				while ( pc < npc )
				{
					hex[pc] = { op : filler };
					++pc;
				}
			} else if ( dir[1] == "filler" ) {
				filler = immediate(dir[2], 16, 0);
			} else if ( dir[1] == "equ" ) {
				ws = dir[2].search(/\s/);
				
				lblname = ws != -1 ? dir[2].substring(0, ws) : dir[2];
				lblvalue = ws != -1 ? dir[2].substr(ws) : "";
				
				for ( l in labels )
					if ( labels[l].name == lblname )
						throw DuplicateLabelError;
				
				labels[labels.length] = {name : lblname, address : eval(lblvalue)};
			}
		} else if ( line[last] == ':' ) {
			lblname = line.substr(0, last);
			
			for ( l in labels )
				if ( labels[l].name == lblname )
					throw DuplicateLabelError;
			
			// add label to table if not present already
			labels[labels.length] = {name : lblname, address : pc};
			
			// listing file
			//print(hex16(pc) + "\t" + "    " + "\t" + line);
		} else {
			// instruction
			
			try {
				// parse instruction
				op = opcode(line);
			} catch ( e ) {
				// handle errors
				if ( e == UnknownLabelError )
				{
					fwd[fwd.length] = {line : l, pc : pc, instr : line};
					//op = new Array(opcode_sz);
					
					for ( i = 0; i < opcode_sz; ++i )
						op[i] = 0x0000;
				} else {
					print("error:" + l + ":" + e.message + "[" + line + "]");
					return;
				}
			}
			
			// bin file
			for ( i in op )
			{
				//print(hex16(pc) + "\t" + hex16(op[i]) + "\t\t[" + i + "]");
				
				hex[pc] = { op : op[i], instr : (i == 0) ? line : "" };
				++pc;
			}
		}
	}
	
	// resolve forward refs
	for ( r in fwd )
	{
		var ref = fwd[r];
		
		try {
			// adjust pc in case it is used by opcode computation
			pc = ref.pc;
			// retry to compute opcode
			op = opcode(ref.instr);
		} catch ( e ) {
			print("error:" + ref.line + ":" + e.message + "[" + ref.instr + "]");
			return;
		}
		
		//print("fwd : " + hex16(ref.pc) + "\t" + bin16(op) + "\t" + ref.instr);
		
		var n = 0;
		
		for ( i in op )
		{
			hex[ref.pc + n] = { op : op[i], instr : (i == 0) ? ref.instr : "" };
			++n;
		}
	}
	
	// print final result
	for ( h in hex )
	{
		// print(hex16(Number(h)) + "\t" + hex16(hex[h]));
		
		// vhdl-friendly representation (for copy/paste into ROMPROG)
		if ( hex[h].op != filler )
			print(h + "=>x\"" + hex16(hex[h].op) + "\",\t-- " + bin16(hex[h].op) + "  " + hex[h].instr);
	}
}
