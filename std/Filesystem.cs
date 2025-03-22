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

        public static string ExpandUser(string path)
        {
            string homeDir = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
            string relativePath = path.Substring(1).TrimStart('/'); // Remove leading `/`
            string fullPath = Path.Combine(homeDir, relativePath);
            return fullPath;
        }

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
                
                if (pathStr.StartsWith("~"))
                {
                    pathStr = ExpandUser(pathStr);
                    Console.WriteLine("Expanded path: " + pathStr);
                }

                pathStr = Path.GetFullPath(pathStr);

                // Check if the directory exists
                string directory = Path.GetDirectoryName(pathStr);
                Console.WriteLine("Directory: " + directory);
                if (Directory.Exists(directory) || File.Exists(pathStr))
                {
                    // FileStream fs = new FileStream(pathStr, FileMode.Open, FileAccess.Read);
                    // fileHandle = Guid.NewGuid(); 
                    // openFileHandles[fileHandle] = fs;
                    isError = false;
                }
                else
                {
                    throw new FileNotFoundException("Given path does not exist: ", pathStr);
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
            string pathStr = path?.ToString();
             try
            {
                Console.WriteLine("Input path: " + pathStr);
                if (pathStr.StartsWith("~"))
                {
                    pathStr = ExpandUser(pathStr);
                }

                pathStr = Path.GetFullPath(pathStr);

                // Check if the directory exists
                string directory = Path.GetDirectoryName(pathStr);
                if (File.Exists(pathStr) || Directory.Exists(directory))
                {
                   bytesRead = Helpers.SeqFromArray(File.ReadAllBytes(pathStr));
                   isError = false;
                }
                else
                {
                    throw new FileNotFoundException("Given path does not exist: ", pathStr);
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
                Console.WriteLine("Input path: " + pathStr);
                
                if (pathStr.StartsWith("~"))
                {
                    pathStr = ExpandUser(pathStr);
                }

                pathStr = Path.GetFullPath(pathStr);

                // Check if the directory exists
                string directory = Path.GetDirectoryName(pathStr);
                if (File.Exists(pathStr) || Directory.Exists(directory))
                {
                    Console.WriteLine("Writing to file: " + pathStr);
                    Console.WriteLine("Bytes: " + bytes.ToString());
                    File.WriteAllBytes(pathStr, bytes.CloneAsArray());
                    isError = false;
                }
                else
                {
                    throw new FileNotFoundException("Given path does not exist: ", pathStr);
                }
            }
            catch (Exception e)
            {
                errorMsg = Helpers.SeqFromArray(e.ToString().ToCharArray());
            }
        }

        /// <summary>
        /// Attempts to return true if a give path is a reparse point or not, and outputs the following values:
        /// <list>
        ///  <item>
        ///      <term>isError</term>
        ///      <description>
        ///         true iff an exception was thrown during path string conversion or when checking if the path is a symbolic link
        ///     </description>
        ///  </item>
        ///  <item>
        ///     <term>isLink</term>
        ///     <description>
        ///         true iff the path is a symbolic link, false otherwise
        ///     </description>
        ///  </item>
        ///  <item>
        ///      <term>errorMsg</term>
        ///     <description>
        ///       the error message of the thrown exception if <c>isError</c> is true, or an empty sequence otherwise
        ///     </description>
        ///   </item>
        /// </list>
        /// </summary>
        public static void INTERNAL_IsLink(ISequence<char> path, out bool isError, out bool isLink, out ISequence<char> errorMsg)
        {
            isError = true;
            isLink = false;
            errorMsg = Sequence<char>.Empty;
            try
            {
                string pathStr = path?.ToString();
   
                if(!File.Exists(pathStr) || !Directory.Exists(pathStr))
                {
                    throw new FileNotFoundException("Neither a file nor a directory exists for ", pathStr);
                }
                else
                {
                     // Get the attributes of the file or directory
                    FileAttributes attributes = File.GetAttributes(pathStr);

                    // Check if the file is a reparse point (symbolic link)
                    isLink = attributes.HasFlag(FileAttributes.ReparsePoint);
                    isError = false;
                }
            
            }
            catch (Exception e)
            {
                errorMsg = Helpers.SeqFromArray(e.ToString().ToCharArray());
            }
        }

        /// <summary>
        /// Attempts to create a path from a list of paths and files and a separator, and outputs the following values:
        /// <list>
        /// <item>
        ///     <term>isError</term>
        ///     <description>
        ///         true iff an exception was thrown during path string conversion or when joining the paths
        ///     </description>
        /// </item>
        /// <item>
        /// <term>fullPath</term>
        ///     <description>
        ///         the full path created from the list of paths and files, or an empty sequence if <c>isError</c> is true
        ///     </description>
        /// </item>
        /// <item>
        /// <term>errorMsg</term>
        ///     <description>
        ///      error message of the thrown exception if <c>isError</c> is true, or an empty sequence otherwise
        ///     </description>
        /// </item>
        /// </list>
        /// </summary>
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
        /// <param name="fileHandle">The handle to the file to close.</param>
        /// <param name="isError">True if an error occurred while closing the file, false otherwise.</param>
        /// <param name="errorMsg">The error message if an error occurred, an empty sequence otherwise.</param>
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

                openFileHandles[fileHandle].Close();
                openFileHandles.Remove(fileHandle);  

                isError = false; 
            }
            catch (Exception e)
            {
                errorMsg = Helpers.SeqFromArray(e.ToString().ToCharArray());
            }
        }


        /// <summary>
        /// Ensures that the parent directories of a given file path exist by creating them if necessary
        /// </summary>
        /// <list>
        /// <item>
        ///     <term>path</term>
        ///     <description>
        ///         the path to the file whose parent directories should be created
        ///     </description>
        /// </item>
        /// </list>
        private static void CreateParentDirs(ISequence<char> path) {
            string pathStr = path?.ToString();
            string parentDir = Path.GetDirectoryName(Path.GetFullPath(pathStr));
            Directory.CreateDirectory(parentDir);
        }


        public static void INTERNAL_AppendBytesToFile(ISequence<char> path, ISequence<byte> bytes, out bool isError, out ISequence<char> errorMsg)
        {
            isError = true;
            errorMsg = Sequence<char>.Empty;
            string pathStr = path?.ToString();
            
            try
            {
                Console.WriteLine("Input path: " + pathStr);
                
                if (pathStr.StartsWith("~"))
                {
                    pathStr = ExpandUser(pathStr);
                }

                pathStr = Path.GetFullPath(pathStr);

                // Check if the directory exists
                string directory = Path.GetDirectoryName(pathStr);
                if (File.Exists(pathStr) || Directory.Exists(directory))
                {
                    Console.WriteLine("Appending to file: " + pathStr);
                    Console.WriteLine("Bytes: " + bytes.ToString());

                    // Open the file with FileMode.Append to append bytes to the end of the file
                    using (FileStream fs = new FileStream(pathStr, FileMode.Append, FileAccess.Write))
                    {
                        fs.Write(bytes.CloneAsArray(), 0, bytes.Count); // Write the bytes to the file
                    }

                    isError = false;
                }
                else
                {
                    throw new FileNotFoundException("Given path does not exist: ", pathStr);
                }
            }
            catch (Exception e)
            {
                errorMsg = Helpers.SeqFromArray(e.ToString().ToCharArray());
            }
        }
    }

    
}