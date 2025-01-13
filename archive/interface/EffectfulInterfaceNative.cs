using System;
using System.Numerics;
using System.Diagnostics;
using System.Threading;
using System.Collections.Concurrent;
using System.Collections.Generic;
using FStream = System.IO.FileStream;
using UClient = System.Net.Sockets.UdpClient;
using IEndPoint = System.Net.IPEndPoint;
using FInfo = System.IO.FileInfo;

namespace @__default {

public partial class FileStream
{
    internal FStream fstream;
    internal FileStream(FStream fstream) { this.fstream = fstream; }

    internal FInfo finfo;

    internal FileInfo(FInfo finfo) { this.finfo = finfo; }

    public static void Open(char[] name, out bool ok, out FileStream f)
    {
        try
        {
            f = new FileStream(new FStream(new string(name), System.IO.FileMode.OpenOrCreate, System.IO.FileAccess.ReadWrite));
            ok = true;
        }
        catch (Exception e)
        {
            System.Console.Error.WriteLine(e);
            f = null;
            ok = false;
        }
    }

    public void Close(out bool ok)
    {
        try
        {
            fstream.Close();
            ok = true;
        }
        catch (Exception e)
        {
            System.Console.Error.WriteLine(e);
            ok = false;
        }
    }

    public void Read(int fileOffset, byte[] buffer, int start, int end, out bool ok)
    {
        try
        {
            fstream.Seek(fileOffset, System.IO.SeekOrigin.Begin);
            fstream.Read(buffer, start, end - start);
            ok = true;
        }
        catch (Exception e)
        {
            System.Console.Error.WriteLine(e);
            ok = false;
        }
    }

    public void Write(int fileOffset, byte[] buffer, int start, int end, out bool ok)
    {
        try
        {
            fstream.Seek(fileOffset, System.IO.SeekOrigin.Begin);
            fstream.Write(buffer, start, end - start);
            ok = true;
        }
        catch (Exception e)
        {
            System.Console.Error.WriteLine(e);
            ok = false;
        }
    }

    public void Flush(out bool ok)
    {
        try
        {
            fstream.Flush();
            ok = true;
        }
        catch (Exception e)
        {
            System.Console.Error.WriteLine(e);
            ok = false;
        }
    }

    public long GetFileSize(out bool ok)
    {
        try
        {
            long size = fstream.Length;
            ok = true;
            return size;
        }
        catch (Exception e)
        {
            System.Console.Error.WriteLine(e);
            ok = false;
            return -1;
        }
    }

    public bool IsSymbolicLink (string path)
    { try{
            var fileInfo = new FInfo(path);
            ok = true;
            return fileInfo.LinkTarget != null;
        }
        catch (Exception e)
        {
            System.Console.Error.WriteLine(e);
            ok = false;
            return false;
        }
    }
}