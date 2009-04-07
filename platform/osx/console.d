module platform.osx.console;

import core.main;

import console.window;

import core.thread;

import Unicode = core.unicode;

void ConsoleInit()
{
}

void ConsoleSetColors(uint fg, uint bg, int bright)
{
}

void ConsoleSetSize(uint width, uint height)
{
}

void ConsoleGetSize(out uint width, out uint height)
{
}

void ConsoleClear()
{
}



void _ConsoleGetPosition(ref uint x, ref uint y)
{
}

void ConsoleSavePosition()
{
}

void ConsoleRestorePosition()
{
}

void ConsoleSetPosition(uint x, uint y)
{
}

void ConsoleSetHome()
{
}

void ConsoleSetRelative(int x, int y)
{
}

void ConsoleHideCaret()
{
}

void ConsoleShowCaret()
{
}

void ConsolePutChar(dchar chr)
{
}

void ConsoleGetChar(out dchar chr, out uint code)
{
}
