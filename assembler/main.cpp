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

#include <QFile>
#include <QString>
#include <QScriptValue>
#include <QScriptEngine>
#include <QCoreApplication>

int main(int argc, char **argv)
{
	QCoreApplication app(argc, argv);
	
	if ( argc < 3 )
	{
		qDebug("not enough arguments");
		return 1;
	}
	
	QFile f(argv[1]);
	
	if ( !f.open(QFile::ReadOnly | QFile::Text) )
	{
		qDebug("Unable to open assembler script file.");
		return 1;
	}
	
	QScriptEngine engine;
	QScriptValue v = engine.evaluate(QString::fromLocal8Bit(f.readAll()), f.fileName(), 1);
	
	if ( engine.hasUncaughtException() )
	{
		qDebug("Uncaught exception while loading assembler script at line %i: %s",
				engine.uncaughtExceptionLineNumber(),
				qPrintable(engine.uncaughtException().toString())
			);
		
		return 2;
	}
	
	f.close();
	f.setFileName(argv[2]);
	
	if ( !f.open(QFile::ReadOnly | QFile::Text) )
	{
		qDebug("Unable to open source file.");
		return 1;
	}
	
	engine.globalObject().setProperty("source", engine.newVariant(QString::fromLocal8Bit(f.readAll())));
	
	engine.evaluate("assemble(source)");
	
	if ( engine.hasUncaughtException() )
	{
		qDebug("Uncaught exception while assembling file at line %i: %s",
				engine.uncaughtExceptionLineNumber(),
				qPrintable(engine.uncaughtException().toString())
			);
		
		return 3;
	}
	
	return 0;
}
