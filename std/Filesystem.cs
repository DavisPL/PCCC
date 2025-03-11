/*******************************************************************************
*  Copyright by the contributors to the Dafny Project
*  SPDX-License-Identifier: MIT
*******************************************************************************/

namespace Filesystem
{
    using System;
    using System.IO;
    using System.Diagnostics;

    using Dafny;

    public partial class Files
    {
        private static Dictionary<object, FileStream> openFileHandles = new Dictionary<object, FileStream>();  // To track open files

  

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
            string fullPath = "";
            try
            {
                string pathStr = path?.ToString();
                Console.WriteLine("User's path: " + pathStr);
                
                if (pathStr.StartsWith("~"))
                {
                    string homeDir = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
                    string relativePath = pathStr.Substring(1).TrimStart('/'); // Remove leading `/`
                    pathStr = Path.Combine(homeDir, relativePath);

                    Console.WriteLine("Expanded path: " + pathStr);
                }

                pathStr = Path.GetFullPath(pathStr);
                Console.WriteLine("Opening file at: " + pathStr);

                // Check if the directory exists
                string directory = Path.GetDirectoryName(pathStr);
                if (!Directory.Exists(directory))
                {
                    Console.WriteLine("Directory does not exist: " + directory);
                }
                else if (!File.Exists(pathStr))
                {
                    Console.WriteLine("File does not exist: " + pathStr);
                }
                else
                {
                    FileStream fs = new FileStream(pathStr, FileMode.Open, FileAccess.ReadWrite);
                    fileHandle = Guid.NewGuid(); 
                    openFileHandles[fileHandle] = fs;
                    isError = false;
                }
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
                string pathStr = path?.ToString();
                Console.WriteLine("User's path: " + pathStr);
                
                if (pathStr.StartsWith("~"))
                {
                    string homeDir = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
                    string relativePath = pathStr.Substring(1).TrimStart('/'); // Remove leading `/`
                    pathStr = Path.Combine(homeDir, relativePath);

                    Console.WriteLine("Expanded path: " + pathStr);
                }

                pathStr = Path.GetFullPath(pathStr);
                Console.WriteLine("Opening file at: " + pathStr);

                // Check if the directory exists
                string directory = Path.GetDirectoryName(pathStr);
                if (!Directory.Exists(directory))
                {
                    Console.WriteLine("Directory does not exist: " + directory);
                }
                else if (!File.Exists(pathStr))
                {
                    Console.WriteLine("File does not exist: " + pathStr);
                }
                else
                {
                    bytesRead = Helpers.SeqFromArray(File.ReadAllBytes(pathStr));
                    isError = false;
                }
                
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
            string pathStr = path?.ToString();
            try
            {
                
                if(File.Exists(pathStr))
                {
                    isError = false;
                    // This path is a file
                }
                else if(Directory.Exists(pathStr))
                {
                    isError = false;
                    // This path is a directory
                }
                else
                {
                    throw new FileNotFoundException("Neither a file nor a directory exists for ", pathStr);
                }

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
   
                if(File.Exists(pathStr))
                {
                    isError = false;
                    // This path is a file
                }
                else if(Directory.Exists(pathStr))
                {
                    isError = false;
                    // This path is a directory
                }
                else
                {
                    throw new FileNotFoundException("Neither a file nor a directory exists for ", pathStr);
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
        public static void INTERNAL_Join(ISequence<ISequence<char>> paths, ISequence<char> separator, out bool isError, out ISequence<char> fullPath, out ISequence<char> errorMsg)
        {
            isError = true;
            fullPath = Sequence<char>.Empty;
            errorMsg = Sequence<char>.Empty;

            try
            {
                if (paths == null || separator == null)
                {
                    errorMsg = Helpers.SeqFromArray("Paths or separator cannot be null.".ToCharArray());
                    return;
                }

                // Check if the sequence is empty
                if (!paths.Elements.Any())
                {
                    errorMsg = Helpers.SeqFromArray("No paths provided to join.".ToCharArray());
                    return;
                }

                string separatorStr = separator.ToString();
                List<string> pathStrs = new List<string>();

                // Iterate through each path in the sequence
                foreach (var currentPath in paths.Elements)
                {
                    if (currentPath == null)
                    {
                        errorMsg = Helpers.SeqFromArray("One of the paths is null.".ToCharArray());
                        return;
                    }

                    pathStrs.Add(currentPath.ToString());
                }

                // Use the separator explicitly to join paths
                string joinedPath = string.Join(separatorStr, pathStrs);
                // Convert to real (absolute) path
                string realPath = Path.GetFullPath(joinedPath);
                fullPath = Helpers.SeqFromArray(realPath.ToCharArray());
                isError = false;
            }
            catch (Exception e)
            {
                errorMsg = Helpers.SeqFromArray(e.ToString().ToCharArray());
            }
        }

        /// <summary>
        /// Resolves a given relative path to its absolute path.
        /// If the path is already absolute, it simply returns the same path.
        /// </summary>
        /// <param name="relativePath">The relative or absolute path to resolve.</param>
        /// <returns>The absolute path corresponding to the input.</returns>
        public static string Internal_GetAbsolutePath(string relativePath)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(relativePath))
                {
                    throw new ArgumentException("The path cannot be null or empty.");
                }

                // Resolve the absolute path using Path.GetFullPath
                string absolutePath = Path.GetFullPath(relativePath);

                return absolutePath;
            }
            catch (Exception e)
            {
                Console.WriteLine($"Error resolving path: {e.Message}");
                throw;
            }
        }

         /// <summary>
        /// Closes the file associated with the given file handle.
        /// </summary>
        public static void INTERNAL_Close(object fileHandle, out bool isError, out ISequence<char> errorMsg)
        {
            isError = true;
            errorMsg = Sequence<char>.Empty;

            try
            {
                if (fileHandle == null || !openFileHandles.ContainsKey(fileHandle))
                {
                    throw new ArgumentException("Invalid file handle or file already closed.");
                }

                // Close the file stream
                openFileHandles[fileHandle].Close();
                openFileHandles.Remove(fileHandle);  // Remove from dictionary

                isError = false;  // File closed successfully
            }
            catch (Exception e)
            {
                errorMsg = Helpers.SeqFromArray(e.ToString().ToCharArray());
            }
        }


        /// <summary>
        /// Creates the nonexistent parent directory(-ies) of the given path.
        /// </summary>
        private static void CreateParentDirs(ISequence<char> path) {
            string pathStr = path?.ToString();
            string parentDir = Path.GetDirectoryName(Path.GetFullPath(pathStr));
            Directory.CreateDirectory(parentDir);
        }

        public static void INTERNAL_ExpandUser(ISequence<char> path, out bool isError, out ISequence<char> homeDirectory, out ISequence<char> errorMsg) 
        {
            isError = true;
            errorMsg = Sequence<char>.Empty;
            homeDirectory = Sequence<char>.Empty;
            try
            {
                string pathStr = path?.ToString();
                string homeDirStr = homeDirectory?.ToString();
                homeDirStr = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
                // Console.WriteLine("User's home directory: " + homeDirStr);
                homeDirectory = Helpers.SeqFromArray(homeDirStr.ToCharArray());
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