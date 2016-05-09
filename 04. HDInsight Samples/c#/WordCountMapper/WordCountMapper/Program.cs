using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WordCountMapper
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length >0)
            {
                Console.SetIn(new StreamReader(args[0]));
            }

            string line;
            string[] words;

            while ((line = Console.ReadLine()) != null)
            {   "hola esta es una linea"
                words = line.Split(' ');
                foreach (string word in words)
                {
                    Console.WriteLine(word.ToLower());
                }
            }
        }
    }
}
