using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WordCountReducer
{
    class reducer
    {
        static void Main(string[] args)
        {
            string word, lastWord = null;
            int count = 0;
            if (args.Length > 0)
            {
                Console.SetIn(new StreamReader (args[0]));
            }

            while ((word = Console.ReadLine()) != null)
            {
                if (word != lastWord)
                {
                    if (lastWord != null)
                    {
                        Console.WriteLine("{0}[{1}]", lastWord, count);
                    }
                    count = 1;
                    lastWord = word;
                }
                else
                {
                    count += 1; 
                }

            }

        }
    }
}
