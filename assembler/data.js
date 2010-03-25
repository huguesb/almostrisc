
BaseError = new Error("Invalid literal");
ImmediateSizeError = new Error("Immediate too large");
UnknownDirectiveError = new Error("Unknown directive");
InvalidOrgAddress = new Error("Invalid org address");

var pc = 0;
var filler = 0;
var hex = new Array();

var fmts = new Array();

fmts["%([01]+)"] = 2;
fmts["\\$([0-9A-F]+)"] = 16;
fmts["([01]+)b"] = 2;
fmts["([0-7]+)o"] = 8;
fmts["([0-9A-F]+)h"] = 16;

function val(c, base)
{
	v = (c >= '0' && c <= '9') ? c - '0' : (c >= 'A' && c <= 'Z' ? c - 'A' + 10 : (c >= 'a' && c <= 'z' ? c - 'a' + 10 : -1));
	
	if ( v >= 0 && v < base )
		return v;
	
	print(v + " " + c + " " + base);
	
	throw BaseError;
}

function base_conv(str, base)
{
	var res = 0;
	
	for ( c in str )
	{
		res = base * res + val(str[c], base);
	}
	
	return res;
}

function pad_str(s, n, c)
{
	while ( s.length < n )
		s = c + s;
		
	return s;
}

function hex16(i)
{
	return pad_str(i.toString(16).toUpperCase(), 4, '0');
}

function bin16(i)
{
	return pad_str(i.toString(2), 16, '0');
}

function eval_num(str, bits)
{
	for ( pattern in fmts )
	{
		var rx = new RegExp(pattern, "i");
		
		m = rx.exec(str);
		
		if ( m != null )
		{
			str = str.replace(m[0], base_conv(m[1], fmts[pattern]));
		}
	}
	
	var n = eval(str);
	
	if ( n >= (1 << bits) )
		throw ImmediateSizeError;
	
	//print(n + ":" + pad_str(n.toString(2), 8, " "));
	
	return n;
}

function assemble(text)
{
	/*
		turns a list of .db / .dw statements into xxxx=>x"", statements for VHDL embedding
	*/
	var lines = String(text).split("\n");
	
	/*
		init array
	*/
	
	for ( i = 0; i < 16384; ++i )
		hex[i] = 0;
	
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
		
		var dir = /\.(org|db|dw)\s+(.+)/i.exec(line);
		
		if ( dir != null )
		{
			var args = dir[2].split(",");
			
			if ( dir[1] == "org" )
			{
				pc = eval_num(dir[2], 16) * 2;
				
			} else if ( dir[1] == "db" ) {
				for ( arg in args )
				{
					arg = /\s*(.+)\s*/.exec(args[arg])[1];
					
					if ( arg.charAt(0) == '\"' )
					{
						arg = arg.substr(1, arg.length - 2);
						
						for ( c in arg )
						{
							hex[pc] = arg.charCodeAt(c);
							++pc;
						}
					} else {
						hex[pc] = eval_num(arg, 8);
						++pc;
					}
				}
			} else if ( dir[1] == "dw" ) {
				for ( arg in args ) 
				{
					n =  eval_num(args[arg], 16);
					hex[pc] = n >> 8;
					++pc;
					hex[pc] = n & 0xff;
					++pc;
				}
			}
		} else {
		}
	}
	
	var out_str = "";
	
	for ( i = 0; i < 8192; ++i )
	{
		var n = (hex[i + i] << 8) + hex[i + i + 1];
		
		if ( n != 0 )
			out_str += " " + pad_str(i.toString(10), 5, ' ') + " => x\"" + hex16(n) + "\",\n";
		
// 		print(
// 			(n & 1 ? "        & " : " " + pad_str((i - n / 2).toString(10), 6, " ") + "=> ")
// 			+ "\"" + pad_str(hex[i].toString(2), 8, "0") + "\""
// 			+ (n & 1 ? "," : "")
// 			);
// 		
	}
	
	return out_str;
}
