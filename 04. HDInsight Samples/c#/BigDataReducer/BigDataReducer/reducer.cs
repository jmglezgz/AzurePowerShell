using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BigDataReducer
{
    class reducer
    {
        static void Main(string[] args)
        {
            if (args.Length > 0)
            {
                Console.SetIn(new StreamReader(args[0]));
            }

            string line;
            //counter for each key
            var uriCounters = new Dictionary<string, int>();
            //list of th euri ordered by the counter value
            var topUriList = new SortedList<int, string>();
            int count = 0;

            while ((line = Console.ReadLine()) != null)
            {
                //Parse the key and associated values
                var words = line.Split('\t');
                string key = words[0];
                int value = int.Parse(words[1]);

                //sum th evalues for each key in uriCounters
                if (!uriCounters.ContainsKey(key))
                {
                    count = value;
                    uriCounters.Add(key, value);
                }
                else
                {
                    count += value;
                    uriCounters[key] = count;
                }
            }
            //print the output
            foreach (var keyValue in uriCounters)
            {
                Console.WriteLine(string.Format("{0},{1}", keyValue.Key, keyValue.Value));
            }
        }
    }
}

