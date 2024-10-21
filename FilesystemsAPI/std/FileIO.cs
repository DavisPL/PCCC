/*******************************************************************************
*  Copyright by the contributors to the Dafny Project
*  SPDX-License-Identifier: MIT
*******************************************************************************/

namespace DafnyLibraries
{
    using System;
    using System.IO;

    using Dafny;

    public class FileIO
    {
        /// <summary>
        /// Attempts to open the file at the given path, and outputs the following values:
        /// <list>
        ///  <item>
        ///  <term>isError</term>
        ///  <description>
        ///  true iff an exception was thrown during path string conversion or when opening the file
        ///  </description>
        ///  </item>
        ///  <item>
        ///  <term>fileHandle</term>
        ///  <description>
        ///  a handle to the opened file, or null if <c>isError</c> is true
        ///  </description>
        ///  </item>
        ///  <item>
        ///  <term>errorMsg</term>
        ///  <description>
        ///  
        public static void INTERNAL_Open(ISequence<char> path, out bool isError, out object fileHandle, out ISequence<char> errorMsg)
        {
            isError = true;
            fileHandle = null;
            errorMsg = Sequence<char>.Empty;
            try
            {
                string pathStr = path?.ToString();

                if (!File.Exists(pathStr))
                {
                    throw new FileNotFoundException("File does not exist.", pathStr);
                }

                string fullPath = Path.GetFullPath(pathStr);

                // Open the file in read/write mode (adjust FileAccess as needed)
                FileStream fs = new FileStream(fullPath, FileMode.Open, FileAccess.ReadWrite);

                // Store the FileStream in a Dafny-compatible wrapper
                fileHandle = new FileHandleWrapper(fs);

                isError = false;
            }
            catch (Exception e)
            {
                errorMsg = Helpers.SeqFromArray(e.ToString().ToCharArray());
            }
        }
        /// <summary>
        /// Attempts to read all bytes from the file at the given path, and outputs the following values:
        /// <list>
        ///   <item>
        ///     <term>isError</term>
        ///     <description>
        ///       true iff an exception was thrown during path string conversion or when reading the file
        ///     </description>
        ///   </item>
        ///   <item>
        ///     <term>bytesRead</term>
        ///     <description>
        ///       the sequence of bytes read from the file, or an empty sequence if <c>isError</c> is true
        ///     </description>
        ///   </item>
        ///   <item>
        ///     <term>errorMsg</term>
        ///     <description>
        ///       the error message of the thrown exception if <c>isError</c> is true, or an empty sequence otherwise
        ///     </description>
        ///   </item>
        /// </list>
        ///
        /// We output these values individually because Result is not defined in the runtime but instead in library code.
        /// It is the responsibility of library code to construct an equivalent Result value.
        /// </summary>
        public static void INTERNAL_ReadBytesFromFile(ISequence<char> path, out bool isError, out ISequence<byte> bytesRead,
          out ISequence<char> errorMsg)
        {
            isError = true;
            bytesRead = Sequence<byte>.Empty;
            errorMsg = Sequence<char>.Empty;
            try
            {
                bytesRead = Helpers.SeqFromArray(File.ReadAllBytes(path?.ToString()));
                isError = false;
            }
            catch (Exception e)
            {
                errorMsg = Helpers.SeqFromArray(e.ToString().ToCharArray());
            }
        }

        /// <summary>
        /// Attempts to write all given bytes to the file at the given path, creating nonexistent parent directories as necessary,
        /// and outputs the following values:
        /// <list>
        ///   <item>
        ///     <term>isError</term>
        ///     <description>
        ///       true iff an exception was thrown during path string conversion or when writing to the file
        ///     </description>
        ///   </item>
        ///   <item>
        ///     <term>errorMsg</term>
        ///     <description>
        ///       the error message of the thrown exception if <c>isError</c> is true, or an empty sequence otherwise
        ///     </description>
        ///   </item>
        /// </list>
        ///
        /// We output these values individually because Result is not defined in the runtime but instead in library code.
        /// It is the responsibility of library code to construct an equivalent Result value.
        /// </summary>
        public static void INTERNAL_WriteBytesToFile(ISequence<char> path, ISequence<byte> bytes, out bool isError, out ISequence<char> errorMsg)
        {
            isError = true;
            errorMsg = Sequence<char>.Empty;
            try
            {
                string pathStr = path?.ToString();
                CreateParentDirs(pathStr);
                File.WriteAllBytes(pathStr, bytes.CloneAsArray());
                isError = false;
            }
            catch (Exception e)
            {
                errorMsg = Helpers.SeqFromArray(e.ToString().ToCharArray());
            }
        }

        /// <summary>
        /// Creates the nonexistent parent directory(-ies) of the given path.
        /// </summary>
        private static void CreateParentDirs(string path)
        {
            string parentDir = Path.GetDirectoryName(Path.GetFullPath(path));
            Directory.CreateDirectory(parentDir);
        }

        public static void INTERNAL_IsLink(ISequence<char> path, out bool isError, out bool isLink, out ISequence<char> errorMsg)
        {
            isError = true;
            isLink = false;
            errorMsg = Sequence<char>.Empty;
            try
            {
                string pathStr = path?.ToString();

                // Check if the file exists
                if (!File.Exists(pathStr) && !Directory.Exists(pathStr))
                {
                    throw new FileNotFoundException("File or directory does not exist.", pathStr);
                }
               
                // Get the attributes of the file or directory
                FileAttributes attributes = File.GetAttributes(pathStr);

                // Check if the file is a reparse point (symbolic link)
                isLink = attributes.HasFlag(FileAttributes.ReparsePoint);
                isError = false;
            
            }
            catch (Exception e)
            {
                errorMsg = Helpers.SeqFromArray(e.ToString().ToCharArray());
            }
        }

        // private static bool FileExists(string path, out bool exists)
        // {
        //     exists = false;
        //     try {
        //         File.Exists(path);
        //         return exists = File.Exists(path) != null;
        //     }
        //     catch (Exception e) {
        //         errorMsg = Helpers.SeqFromArray(e.ToString().ToCharArray());
        //     }

        // }

        // private static bool DirExists(string path)
        // {
        //     try {   
        //         Directory.Exists(path);
        //     }
        //     catch (Exception e) {   
        //         errorMsg = Helpers.SeqFromArray(e.ToString().ToCharArray());
        //     }
        // }
        // public static void INTERNAL_JoinPaths(ISequence<string> paths, string separator, out bool isError, out string fullPath, out ISequence<char> errorMsg)
        // {
        //     isError = true;
        //     fullPath = "";
        //     errorMsg = Sequence<char>.Empty;
        //     try
        //     {
        //         // Convert ISequence<string> to IEnumerable<string> if necessary
        //         IEnumerable<string> pathList = paths.Elements;

        //         // Use string.Join to concatenate the paths with the separator
        //         fullPath = string.Join(separator, pathList);
        //         isError = false;
        //     }
        //     catch (Exception e)
        //     {
        //         errorMsg = Helpers.SeqFromArray(e.ToString().ToCharArray());
        //     }
        // }


    }

    
}